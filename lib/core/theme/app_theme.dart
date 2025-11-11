import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Premium Minimalist Therapeutic Theme
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  static const Color secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color secondaryDark = Color(0xFF7C3AED);

  static const Color accentColor = Color(0xFF10B981); // Green
  static const Color accentLight = Color(0xFF34D399);

  // Neutral Colors - More refined
  static const Color backgroundColor = Color(0xFF0A0E1A); // Deeper dark
  static const Color surfaceColor = Color(0xFF141824); // Premium surface
  static const Color cardColor = Color(0xFF1E2330); // Elevated card
  static const Color borderColor = Color(0xFF2A3142); // Subtle borders

  // Text Colors - Better hierarchy
  static const Color textPrimaryColor = Color(0xFFF8FAFC);
  static const Color textSecondaryColor = Color(0xFFCBD5E1);
  static const Color textTertiaryColor = Color(0xFF8B93A8);
  static const Color textDisabledColor = Color(0xFF4B5563);

  // Semantic Colors
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  // Glassmorphism Colors
  static const Color glassLight = Color(0x1AFFFFFF);
  static const Color glassMedium = Color(0x33FFFFFF);
  static const Color glassDark = Color(0x0DFFFFFF);

  // Gradients - More sophisticated
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundColor, Color(0xFF0F1419)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [cardColor, surfaceColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0x1AFFFFFF),
      Color(0x33FFFFFF),
      Color(0x1AFFFFFF),
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Shadows - Refined for depth
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  // Glow effects for premium feel
  static List<BoxShadow> glowPrimary({double opacity = 0.3}) => [
        BoxShadow(
          color: primaryColor.withOpacity(opacity),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> glowAccent({double opacity = 0.3}) => [
        BoxShadow(
          color: accentColor.withOpacity(opacity),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        error: errorColor,
      ),
      textTheme: _textTheme(textPrimaryColor: Colors.black87),
      appBarTheme: _appBarTheme(isDark: false),
      cardTheme: _cardTheme(isDark: false),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(isDark: false),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(isDark: false),
      floatingActionButtonTheme: _fabTheme(),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      textTheme: _textTheme(textPrimaryColor: textPrimaryColor),
      appBarTheme: _appBarTheme(isDark: true),
      cardTheme: _cardTheme(isDark: true),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(isDark: true),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(isDark: true),
      floatingActionButtonTheme: _fabTheme(),
    );
  }

  static TextTheme _textTheme({required Color textPrimaryColor}) {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
        letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
        letterSpacing: 0,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textPrimaryColor,
        letterSpacing: 0.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
        letterSpacing: 0,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
        letterSpacing: 0,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimaryColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimaryColor,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondaryColor,
        letterSpacing: 0.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
        letterSpacing: 0.5,
      ),
    );
  }

  static AppBarTheme _appBarTheme({required bool isDark}) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: isDark ? backgroundColor : Colors.white,
      foregroundColor: isDark ? textPrimaryColor : Colors.black87,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        color: isDark ? textPrimaryColor : Colors.black87,
      ),
    );
  }

  static CardTheme _cardTheme({required bool isDark}) {
    return CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      color: isDark ? cardColor : Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        side: const BorderSide(
          color: borderColor,
          width: 1.5,
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({required bool isDark}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? surfaceColor : const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: BorderSide(
          color: isDark ? borderColor : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: BorderSide(
          color: isDark ? borderColor : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: isDark ? textSecondaryColor : const Color(0xFF64748B),
        letterSpacing: 0.15,
      ),
      hintStyle: GoogleFonts.inter(
        color: isDark ? textTertiaryColor : const Color(0xFF94A3B8),
        letterSpacing: 0.15,
      ),
    );
  }

  static BottomNavigationBarThemeData _bottomNavigationBarTheme({
    required bool isDark,
  }) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? surfaceColor : Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: isDark ? textTertiaryColor : const Color(0xFF94A3B8),
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    );
  }

  static FloatingActionButtonThemeData _fabTheme() {
    return FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
    );
  }
}

// Spacing Constants - Refined scale
class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

// Border Radius Constants - More variety
class AppBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double circular = 999.0;
}

// Opacity Constants - For glassmorphism
class AppOpacity {
  static const double subtle = 0.05;
  static const double light = 0.1;
  static const double medium = 0.2;
  static const double strong = 0.3;
  static const double heavy = 0.5;
}

// Duration Constants - Animation timing
class AppDuration {
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 700);
}
