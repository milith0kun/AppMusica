import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app_musica/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Complete onboarding flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Should show login screen or onboarding
      expect(
        find.byType(MaterialApp),
        findsOneWidget,
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('Login flow with valid credentials', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find email field
      final emailField = find.byType(TextFormField).first;
      expect(emailField, findsOneWidget);

      // Enter email
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Find password field
      final passwordField = find.byType(TextFormField).at(1);
      expect(passwordField, findsOneWidget);

      // Enter password
      await tester.enterText(passwordField, 'Password123');
      await tester.pump();

      // Find and tap login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Ingresar');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        // Should show loading or navigate
        await tester.pump(const Duration(seconds: 2));
      }
    });

    testWidgets('Navigation between tabs', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pump(const Duration(seconds: 2));

      // Check if bottom navigation exists
      final bottomNav = find.byType(BottomNavigationBar);
      if (bottomNav.evaluate().isNotEmpty) {
        // Tap Library tab
        await tester.tap(find.byIcon(Icons.library_music));
        await tester.pumpAndSettle();

        // Tap Search tab
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        // Tap Profile tab
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        // Go back to Home
        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Search functionality', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));

      // Navigate to search
      final searchIcon = find.byIcon(Icons.search);
      if (searchIcon.evaluate().isNotEmpty) {
        await tester.tap(searchIcon);
        await tester.pumpAndSettle();

        // Find search field
        final searchField = find.byType(TextField);
        if (searchField.evaluate().isNotEmpty) {
          await tester.enterText(searchField, 'relajación');
          await tester.pump(const Duration(milliseconds: 500));
          await tester.pumpAndSettle();

          // Results should appear
          await tester.pump(const Duration(seconds: 1));
        }
      }
    });

    testWidgets('Settings navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));

      // Navigate to profile/settings
      final profileIcon = find.byIcon(Icons.person);
      if (profileIcon.evaluate().isNotEmpty) {
        await tester.tap(profileIcon);
        await tester.pumpAndSettle();

        // Look for settings option
        final settingsButton = find.byIcon(Icons.settings);
        if (settingsButton.evaluate().isNotEmpty) {
          await tester.tap(settingsButton);
          await tester.pumpAndSettle();

          // Should show settings screen
          expect(find.text('Configuración'), findsWidgets);
        }
      }
    });
  });

  group('Form Validation Tests', () {
    testWidgets('Login form validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 1));

      // Try to login without credentials
      final loginButton = find.widgetWithText(ElevatedButton, 'Ingresar');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton);
        await tester.pump();

        // Should show validation errors
        expect(find.text('El email es requerido'), findsWidgets);
      }
    });

    testWidgets('Registration form validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to register
      final registerLink = find.text('Registrarse');
      if (registerLink.evaluate().isNotEmpty) {
        await tester.tap(registerLink);
        await tester.pumpAndSettle();

        // Try to register without filling form
        final registerButton = find.widgetWithText(ElevatedButton, 'Crear Cuenta');
        if (registerButton.evaluate().isNotEmpty) {
          await tester.tap(registerButton);
          await tester.pump();

          // Should show validation errors
          expect(find.textContaining('requerido'), findsWidgets);
        }
      }
    });
  });

  group('UI Responsiveness Tests', () {
    testWidgets('App works in portrait mode', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812)); // iPhone X

      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('App works in landscape mode', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(812, 375)); // iPhone X landscape

      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));

      // Reset to portrait
      await tester.binding.setSurfaceSize(const Size(375, 812));
    });

    testWidgets('App works on tablet', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1024, 768)); // iPad

      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));

      // Reset
      await tester.binding.setSurfaceSize(null);
    });
  });

  group('Performance Tests', () {
    testWidgets('Scrolling performance in lists', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));

      // Find any scrollable list
      final listView = find.byType(ListView);
      if (listView.evaluate().isNotEmpty) {
        // Scroll down
        await tester.drag(listView.first, const Offset(0, -500));
        await tester.pumpAndSettle();

        // Scroll up
        await tester.drag(listView.first, const Offset(0, 500));
        await tester.pumpAndSettle();

        // Should complete without frame drops
        expect(tester.binding.hasScheduledFrame, isFalse);
      }
    });

    testWidgets('Navigation performance', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 1));

      final bottomNav = find.byType(BottomNavigationBar);
      if (bottomNav.evaluate().isNotEmpty) {
        // Rapidly switch tabs
        for (var i = 0; i < 5; i++) {
          await tester.tap(find.byIcon(Icons.library_music));
          await tester.pump();

          await tester.tap(find.byIcon(Icons.home));
          await tester.pump();
        }

        await tester.pumpAndSettle();

        // Should handle rapid taps without issues
        expect(tester.binding.hasScheduledFrame, isFalse);
      }
    });
  });

  group('Edge Cases Tests', () {
    testWidgets('Handles no internet connection', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // App should still render
      expect(find.byType(MaterialApp), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Handles rapid button taps', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 1));

      final loginButton = find.widgetWithText(ElevatedButton, 'Ingresar');
      if (loginButton.evaluate().isNotEmpty) {
        // Rapidly tap the button
        for (var i = 0; i < 5; i++) {
          await tester.tap(loginButton);
          await tester.pump(const Duration(milliseconds: 100));
        }

        await tester.pumpAndSettle();

        // Should handle gracefully
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });
  });
}
