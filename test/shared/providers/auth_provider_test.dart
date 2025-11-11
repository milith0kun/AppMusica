import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:app_musica/shared/providers/auth_provider.dart';
import 'package:app_musica/data/repositories/auth_repository.dart';
import 'package:app_musica/data/repositories/user_repository.dart';
import 'package:app_musica/data/models/user_model.dart';

@GenerateMocks([AuthRepository, UserRepository])
import 'auth_provider_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockUserRepository mockUserRepo;
  late ProviderContainer container;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockUserRepo = MockUserRepository();

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        userRepositoryProvider.overrideWithValue(mockUserRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthProvider - Initial State', () {
    test('initial state is not authenticated', () {
      when(mockAuthRepo.isLoggedIn()).thenAnswer((_) async => false);

      final authState = container.read(authProvider);

      expect(authState.isAuthenticated, isFalse);
      expect(authState.user, isNull);
      expect(authState.isLoading, isFalse);
      expect(authState.error, isNull);
    });
  });

  group('AuthProvider - Login', () {
    final testUser = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      profession: 'Psicólogo',
      country: 'México',
      registeredAt: DateTime.now(),
    );

    test('successful login updates state', () async {
      when(mockAuthRepo.login('test@example.com', 'password123'))
          .thenAnswer((_) async => testUser);

      final notifier = container.read(authProvider.notifier);

      await notifier.login('test@example.com', 'password123');

      final authState = container.read(authProvider);

      expect(authState.isAuthenticated, isTrue);
      expect(authState.user, equals(testUser));
      expect(authState.isLoading, isFalse);
      expect(authState.error, isNull);

      verify(mockAuthRepo.login('test@example.com', 'password123')).called(1);
    });

    test('failed login sets error', () async {
      when(mockAuthRepo.login('test@example.com', 'wrong'))
          .thenThrow(Exception('Invalid credentials'));

      final notifier = container.read(authProvider.notifier);

      expect(
        () => notifier.login('test@example.com', 'wrong'),
        throwsException,
      );

      final authState = container.read(authProvider);

      expect(authState.isAuthenticated, isFalse);
      expect(authState.user, isNull);
      expect(authState.isLoading, isFalse);
      expect(authState.error, isNotNull);

      verify(mockAuthRepo.login('test@example.com', 'wrong')).called(1);
    });

    test('sets loading state during login', () async {
      when(mockAuthRepo.login(any, any))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return testUser;
      });

      final notifier = container.read(authProvider.notifier);

      final loginFuture = notifier.login('test@example.com', 'password123');

      // Check loading state immediately
      await Future.delayed(const Duration(milliseconds: 10));
      final loadingState = container.read(authProvider);
      expect(loadingState.isLoading, isTrue);

      await loginFuture;

      final finalState = container.read(authProvider);
      expect(finalState.isLoading, isFalse);
    });
  });

  group('AuthProvider - Register', () {
    final testUser = UserModel(
      id: '1',
      email: 'new@example.com',
      name: 'New User',
      profession: 'Terapeuta',
      country: 'España',
      registeredAt: DateTime.now(),
    );

    test('successful registration updates state', () async {
      when(mockAuthRepo.register(
        email: 'new@example.com',
        password: 'password123',
        fullName: 'New User',
        profession: 'Terapeuta',
        country: 'España',
      )).thenAnswer((_) async => testUser);

      final notifier = container.read(authProvider.notifier);

      await notifier.register(
        email: 'new@example.com',
        password: 'password123',
        fullName: 'New User',
        profession: 'Terapeuta',
        country: 'España',
      );

      final authState = container.read(authProvider);

      expect(authState.isAuthenticated, isTrue);
      expect(authState.user, equals(testUser));
      expect(authState.error, isNull);

      verify(mockAuthRepo.register(
        email: 'new@example.com',
        password: 'password123',
        fullName: 'New User',
        profession: 'Terapeuta',
        country: 'España',
      )).called(1);
    });

    test('failed registration sets error', () async {
      when(mockAuthRepo.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        fullName: anyNamed('fullName'),
        profession: anyNamed('profession'),
      )).thenThrow(Exception('Email already exists'));

      final notifier = container.read(authProvider.notifier);

      expect(
        () => notifier.register(
          email: 'existing@example.com',
          password: 'password123',
          fullName: 'User',
          profession: 'Terapeuta',
        ),
        throwsException,
      );

      final authState = container.read(authProvider);

      expect(authState.isAuthenticated, isFalse);
      expect(authState.error, isNotNull);
    });
  });

  group('AuthProvider - Logout', () {
    test('logout clears state', () async {
      when(mockAuthRepo.logout()).thenAnswer((_) async => {});

      final notifier = container.read(authProvider.notifier);

      await notifier.logout();

      final authState = container.read(authProvider);

      expect(authState.isAuthenticated, isFalse);
      expect(authState.user, isNull);
      expect(authState.error, isNull);

      verify(mockAuthRepo.logout()).called(1);
    });
  });

  group('AuthProvider - Refresh Profile', () {
    final updatedUser = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Updated Name',
      profession: 'Psicólogo',
      country: 'México',
      registeredAt: DateTime.now(),
    );

    test('refreshes user profile', () async {
      when(mockUserRepo.getProfile()).thenAnswer((_) async => updatedUser);

      final notifier = container.read(authProvider.notifier);

      await notifier.refreshProfile();

      final authState = container.read(authProvider);

      expect(authState.user, equals(updatedUser));

      verify(mockUserRepo.getProfile()).called(1);
    });

    test('handles refresh error silently', () async {
      when(mockUserRepo.getProfile()).thenThrow(Exception('Network error'));

      final notifier = container.read(authProvider.notifier);

      // Should not throw
      await notifier.refreshProfile();

      verify(mockUserRepo.getProfile()).called(1);
    });
  });

  group('AuthProvider - Check Auth Status on Init', () {
    final testUser = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      profession: 'Psicólogo',
      country: 'México',
      registeredAt: DateTime.now(),
    );

    test('loads user if logged in', () async {
      when(mockAuthRepo.isLoggedIn()).thenAnswer((_) async => true);
      when(mockUserRepo.getProfile()).thenAnswer((_) async => testUser);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          userRepositoryProvider.overrideWithValue(mockUserRepo),
        ],
      );

      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 100));

      final authState = container.read(authProvider);

      expect(authState.isAuthenticated, isTrue);
      expect(authState.user, equals(testUser));

      verify(mockAuthRepo.isLoggedIn()).called(1);
      verify(mockUserRepo.getProfile()).called(1);

      container.dispose();
    });

    test('logs out if profile fetch fails', () async {
      when(mockAuthRepo.isLoggedIn()).thenAnswer((_) async => true);
      when(mockUserRepo.getProfile()).thenThrow(Exception('Unauthorized'));
      when(mockAuthRepo.logout()).thenAnswer((_) async => {});

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          userRepositoryProvider.overrideWithValue(mockUserRepo),
        ],
      );

      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 100));

      final authState = container.read(authProvider);

      expect(authState.isAuthenticated, isFalse);
      expect(authState.user, isNull);

      verify(mockAuthRepo.logout()).called(1);

      container.dispose();
    });
  });

  group('AuthState - copyWith', () {
    test('copyWith creates new instance with updated fields', () {
      const initialState = AuthState(
        isLoading: false,
        isAuthenticated: false,
      );

      final updatedState = initialState.copyWith(
        isLoading: true,
        isAuthenticated: true,
      );

      expect(updatedState.isLoading, isTrue);
      expect(updatedState.isAuthenticated, isTrue);
      expect(initialState.isLoading, isFalse); // Original unchanged
    });

    test('copyWith preserves unspecified fields', () {
      const initialState = AuthState(
        isLoading: false,
        isAuthenticated: true,
        error: 'Some error',
      );

      final updatedState = initialState.copyWith(isLoading: true);

      expect(updatedState.isLoading, isTrue);
      expect(updatedState.isAuthenticated, isTrue); // Preserved
      expect(updatedState.error, equals('Some error')); // Preserved
    });
  });
}
