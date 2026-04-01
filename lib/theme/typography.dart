import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  /// Generates the base text theme from Google Fonts (Manrope)
  static TextTheme get textTheme => GoogleFonts.manropeTextTheme();

  /// Headline 1: Used for main screen titles etc.
  static TextStyle get h1 => GoogleFonts.manrope(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  /// Headline 2: Sub-headers or Card titles
  static TextStyle get h2 => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  /// Body Text 1: Standard read text
  static TextStyle get body1 => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  /// Body Text 2: Slightly smaller body (Cards, descriptions, inputs)
  static TextStyle get body2 => GoogleFonts.manrope(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  /// Caption / Labels
  static TextStyle get caption => GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
      );

  /// Hint Text
  static TextStyle get hint => GoogleFonts.manrope(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: AppColors.textHint,
      );
}
