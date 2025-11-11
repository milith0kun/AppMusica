import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/main/main_screen.dart';
import 'features/player/screens/player_screen.dart';
import 'features/subscription/screens/subscription_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'shared/providers/auth_provider.dart';

class MusicaTerapeuticaApp extends ConsumerWidget {
  const MusicaTerapeuticaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: authState.isAuthenticated ? const MainScreen() : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
        '/player': (context) => const PlayerScreen(),
        '/subscription': (context) => const SubscriptionScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
