import 'package:flutter/material.dart';
import 'kala_colors.dart';

class KalaTheme {
  static const String fontFamily = 'ZT_Nature';

  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: fontFamily,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: KalaColors.ivory,
      primaryColor: KalaColors.burntOrange,
      colorScheme: const ColorScheme.light(
        primary: KalaColors.burntOrange,
        secondary: KalaColors.mutedGold,
        surface: KalaColors.cardBg,
        onPrimary: Colors.white,
        onSecondary: KalaColors.charcoal,
        onSurface: KalaColors.charcoal,
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: KalaColors.charcoal,
          height: 1.1,
        ),
        displayMedium: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: KalaColors.charcoal,
          height: 1.1,
        ),
        displaySmall: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: KalaColors.charcoal,
          height: 1.2,
        ),
        headlineLarge: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: KalaColors.charcoal,
          height: 1.2,
        ),
        headlineMedium: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: KalaColors.charcoal,
          height: 1.2,
        ),
        headlineSmall: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: KalaColors.charcoal,
          height: 1.2,
        ),
        titleLarge: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: KalaColors.charcoal,
        ),
        titleMedium: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: KalaColors.charcoal,
        ),
        titleSmall: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: KalaColors.charcoal,
        ),
        bodyLarge: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: KalaColors.charcoal,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: KalaColors.charcoal,
          height: 1.4,
        ),
        bodySmall: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: KalaColors.mediumGrey,
          height: 1.3,
        ),
        labelLarge: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: KalaColors.mediumGrey,
          letterSpacing: 0.5,
        ),
        labelMedium: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: KalaColors.mediumGrey,
          letterSpacing: 0.5,
        ),
        labelSmall: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: KalaColors.mediumGrey,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: KalaColors.ivory,
        elevation: 0,
        iconTheme: IconThemeData(color: KalaColors.charcoal),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: KalaColors.charcoal,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: KalaColors.softBeige, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: KalaColors.softBeige, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: KalaColors.burntOrange,
            width: 1.5,
          ),
        ),
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          color: KalaColors.mediumGrey,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          color: KalaColors.burntOrange,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KalaColors.burntOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: KalaColors.charcoal,
          side: const BorderSide(color: KalaColors.charcoal, width: 1.2),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
