import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTextTheme = Typography.englishLike2021;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      // Montserrat for Headlines, Inter for Body as per design system
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.montserrat(textStyle: baseTextTheme.displayLarge?.copyWith(color: AppColors.onBackground)),
        headlineLarge: GoogleFonts.montserrat(textStyle: baseTextTheme.headlineLarge?.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w600)),
        headlineMedium: GoogleFonts.montserrat(textStyle: baseTextTheme.headlineMedium?.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w600)),
        
        bodyLarge: GoogleFonts.inter(textStyle: baseTextTheme.bodyLarge?.copyWith(color: AppColors.onBackground)),
        bodyMedium: GoogleFonts.inter(textStyle: baseTextTheme.bodyMedium?.copyWith(color: AppColors.onBackground)),
        labelLarge: GoogleFonts.inter(textStyle: baseTextTheme.labelLarge?.copyWith(color: AppColors.onBackground)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
