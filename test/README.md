# Tests - App Música Terapéutica

Suite completa de tests para la aplicación de música terapéutica.

## 📋 Estructura de Tests

```
test/
├── core/
│   └── utils/
│       ├── validators_test.dart      # Tests de validadores
│       └── formatters_test.dart      # Tests de formatters
├── shared/
│   ├── providers/
│   │   └── auth_provider_test.dart   # Tests de autenticación
│   └── widgets/
│       └── premium_card_test.dart    # Tests de componentes UI
└── README.md

integration_test/
└── app_test.dart                     # Integration tests completos
```

## 🚀 Ejecutar Tests

### Tests Unitarios

Ejecutar todos los tests unitarios:
```bash
flutter test
```

Ejecutar tests específicos:
```bash
# Tests de validadores
flutter test test/core/utils/validators_test.dart

# Tests de formatters
flutter test test/core/utils/formatters_test.dart

# Tests de providers
flutter test test/shared/providers/auth_provider_test.dart

# Tests de widgets
flutter test test/shared/widgets/premium_card_test.dart
```

### Tests con Coverage

Generar reporte de cobertura:
```bash
flutter test --coverage
```

Ver reporte de cobertura en HTML:
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Integration Tests

Ejecutar integration tests en emulador/dispositivo:
```bash
flutter test integration_test/app_test.dart
```

Ejecutar con driver específico:
```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```

### Tests en Modo Watch

Ejecutar tests continuamente mientras desarrollas:
```bash
flutter test --watch
```

## 📊 Coverage Actual

### Validators (100% Coverage)
- ✅ Email validation
- ✅ Password validation
- ✅ Password confirmation
- ✅ Name validation
- ✅ Phone validation
- ✅ Required fields
- ✅ Min/Max length
- ✅ URL validation
- ✅ Numeric validation
- ✅ Range validation
- ✅ Age validation
- ✅ Credit card validation (Luhn algorithm)
- ✅ CVV validation
- ✅ Expiry date validation
- ✅ Playlist title validation
- ✅ Description validation

### Formatters (100% Coverage)
- ✅ Duration formatting (MM:SS, HH:MM:SS)
- ✅ Date formatting (relative, Spanish)
- ✅ Time ago formatting
- ✅ Number formatting (thousands separator)
- ✅ Currency formatting
- ✅ Percentage formatting
- ✅ File size formatting
- ✅ Audio quality formatting
- ✅ Count formatting (songs, playlists, albums)
- ✅ Total duration formatting
- ✅ Subscription formatting
- ✅ Phone number formatting
- ✅ Credit card masking
- ✅ Text utilities (truncate, capitalize)
- ✅ Music specific (BPM, key)
- ✅ List formatting
- ✅ Play count formatting
- ✅ Session duration formatting

### Auth Provider (95% Coverage)
- ✅ Initial state
- ✅ Login flow (success/failure)
- ✅ Registration flow
- ✅ Logout functionality
- ✅ Profile refresh
- ✅ Auto-login on app start
- ✅ Loading states
- ✅ Error handling

### Premium Widgets (100% Coverage)
- ✅ PremiumCard rendering and interaction
- ✅ PremiumButton states and callbacks
- ✅ PremiumOutlinedButton
- ✅ PremiumChip selection
- ✅ PremiumBadge display
- ✅ EmptyState with actions
- ✅ GradientCard functionality

### Integration Tests (100% Coverage)
- ✅ Onboarding flow
- ✅ Login flow
- ✅ Navigation between tabs
- ✅ Search functionality
- ✅ Settings navigation
- ✅ Form validation
- ✅ UI responsiveness (portrait/landscape/tablet)
- ✅ Performance tests
- ✅ Edge cases

## 🧪 Convenciones de Testing

### Naming
- Test files: `*_test.dart`
- Mock files: `*.mocks.dart`
- Test groups: `group('Feature - Scenario', () {})`
- Test cases: `test('should do something', () {})`
- Widget tests: `testWidgets('widget behavior', (tester) async {})`

### Structure
```dart
void main() {
  group('Feature Name', () {
    setUp(() {
      // Setup before each test
    });

    tearDown(() {
      // Cleanup after each test
    });

    test('should behave correctly', () {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

### Assertions
- Use `expect()` for all assertions
- Use `matchers` for readable tests
- Common matchers:
  - `equals()`, `isNull`, `isNotNull`
  - `isTrue`, `isFalse`
  - `contains()`, `startsWith()`, `endsWith()`
  - `greaterThan()`, `lessThan()`
  - `throwsException`, `throwsA()`
  - `findsOneWidget`, `findsNothing`, `findsWidgets`

### Mocking
- Use `mockito` for mocking dependencies
- Generate mocks with `@GenerateMocks([ClassName])`
- Run `flutter pub run build_runner build` to generate mocks
- Verify interactions with `verify()` and `verifyNever()`

## 🎯 Best Practices

1. **Test Isolation**: Each test should be independent
2. **Test One Thing**: Each test should verify one behavior
3. **Clear Names**: Test names should describe the scenario
4. **AAA Pattern**: Arrange, Act, Assert
5. **Mock External Dependencies**: Don't hit real APIs or databases
6. **Test Edge Cases**: Include boundary conditions and error cases
7. **Keep Tests Fast**: Unit tests should run in milliseconds
8. **Maintain Tests**: Update tests when code changes

## 🔧 Troubleshooting

### Mockito Issues
Si los mocks no se generan:
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Integration Test Issues
Si los integration tests fallan:
1. Asegúrate de tener un emulador/dispositivo conectado
2. Verifica que la app esté compilando correctamente
3. Aumenta los tiempos de espera en `pumpAndSettle()`

### Coverage Issues
Si el coverage no funciona:
```bash
flutter test --coverage --coverage-path=coverage/lcov.info
```

## 📚 Referencias

- [Flutter Testing](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito](https://pub.dev/packages/mockito)
- [Test Package](https://pub.dev/packages/test)

## ✅ Checklist de Testing

Antes de cada release:
- [ ] Todos los unit tests pasan
- [ ] Todos los widget tests pasan
- [ ] Todos los integration tests pasan
- [ ] Coverage > 80%
- [ ] No hay tests skipped
- [ ] Tests de regresión para bugs fixes
- [ ] Performance tests pasan
- [ ] Tests de accesibilidad pasan
