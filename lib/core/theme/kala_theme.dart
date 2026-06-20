import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kala_colors.dart';

class KalaTheme {
  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light();

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
        // Serif headlines representing "Reyes"
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: KalaColors.charcoal,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: KalaColors.charcoal,
          height: 1.1,
        ),
        displaySmall: GoogleFonts.cormorantGaramond(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: KalaColors.charcoal,
          height: 1.2,
        ),
        headlineLarge: GoogleFonts.cormorantGaramond(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: KalaColors.charcoal,
          height: 1.2,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: KalaColors.charcoal,
          height: 1.2,
        ),
        headlineSmall: GoogleFonts.cormorantGaramond(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: KalaColors.charcoal,
          height: 1.2,
        ),
        titleLarge: GoogleFonts.cormorantGaramond(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: KalaColors.charcoal,
        ),

        // Sans-serif body elements using "Inter"
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: KalaColors.charcoal,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: KalaColors.charcoal,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: KalaColors.charcoal,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: KalaColors.charcoal,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: KalaColors.mediumGrey,
          height: 1.3,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: KalaColors.mediumGrey,
          letterSpacing: 0.5,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: KalaColors.mediumGrey,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: KalaColors.mediumGrey,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: KalaColors.ivory,
        elevation: 0,
        iconTheme: const IconThemeData(color: KalaColors.charcoal),
        titleTextStyle: GoogleFonts.cormorantGaramond(
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
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: KalaColors.mediumGrey,
        ),
        floatingLabelStyle: GoogleFonts.inter(
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
          textStyle: GoogleFonts.inter(
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
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
