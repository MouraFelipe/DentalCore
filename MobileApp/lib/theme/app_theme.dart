import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final manrope = GoogleFonts.manropeTextTheme().apply(
      bodyColor:    AppColors.textPrimary,
      displayColor: AppColors.navy,
    );

    return ThemeData(
      useMaterial3:            true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor:            AppColors.navy,
      colorScheme: const ColorScheme.light(
        primary:    AppColors.navy,
        secondary:  AppColors.gold,
        surface:    AppColors.surface,
      ),
      textTheme: manrope,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navy,
        elevation:       0,
        centerTitle:     false,
        iconTheme:       const IconThemeData(color: Colors.white),
        titleTextStyle:  GoogleFonts.manrope(
          color:      Colors.white,
          fontSize:   18,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.manrope(
              fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }
}
