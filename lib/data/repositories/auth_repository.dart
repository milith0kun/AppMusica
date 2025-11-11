import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../../core/utils/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(AuthService());
});

class AuthRepository {
  final AuthService _authService;
  final _storage = const FlutterSecureStorage();

  AuthRepository(this._authService);

  Future<UserModel> login(String email, String password) async {
    final response = await _authService.login(email: email, password: password);

    // Save tokens
    await _storage.write(
      key: AppConstants.keyAccessToken,
      value: response.accessToken,
    );
    await _storage.write(
      key: AppConstants.keyRefreshToken,
      value: response.refreshToken,
    );
    await _storage.write(
      key: AppConstants.keyUserId,
      value: response.user.id,
    );

    return response.user;
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required String profession,
    String? country,
    String? city,
  }) async {
    final response = await _authService.register(
      email: email,
      password: password,
      fullName: fullName,
      profession: profession,
      country: country,
      city: city,
    );

    // Save tokens
    await _storage.write(
      key: AppConstants.keyAccessToken,
      value: response.accessToken,
    );
    await _storage.write(
      key: AppConstants.keyRefreshToken,
      value: response.refreshToken,
    );
    await _storage.write(
      key: AppConstants.keyUserId,
      value: response.user.id,
    );

    return response.user;
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } finally {
      await _storage.deleteAll();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.keyAccessToken);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.keyAccessToken);
  }

  Future<void> forgotPassword(String email) async {
    await _authService.forgotPassword(email: email);
  }

  Future<void> resetPassword(String token, String newPassword) async {
    await _authService.resetPassword(token: token, newPassword: newPassword);
  }
}
