import 'package:flutter/material.dart';

class AppColors {
  /// Defines primary brand color (taken from existing blue tones)
  static const Color primary = Color(0xFF2D5BE3);
  static const Color primaryDark = Color(0xFF1E3F9D);
  static const Color secondary = Color(0xFF82B1FF); // Lighter accent

  /// Background & Surfaces
  static const Color background = Color(0xFFEEF0F3);
  static const Color surface = Colors.white;

  /// Typography colors
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.black87;
  static const Color textTertiary = Colors.black54;
  static const Color textHint = Colors.black38;
  static const Color textInverse = Colors.white;

  /// Status & State colors
  static const Color error = Color(0xFFB71C1C);
  static const Color errorLight = Color(0xFFEB5757); // Seen in urgent category
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFF9800);
  static const Color placeholder = Color(0xFFE0E3E8); // e.g. Add category button bubble

  /// Category colors
  static const Color workColor = primary;
  static const Color personalColor = Color(0xFFF2F2F2);
  static const Color peaceColor = Color(0xFFE6F7EC);
  static const Color urgentColor = Color(0xFFFFE5E5);
  
  /// Category background colors
  static const Color workBg = Color(0xFFE3EDFF);
  static const Color personalBg = Color(0xFFF2F2F2);
  static const Color peaceBg = Color(0xFFE6F7EC);
  static const Color urgentBg = Color(0xFFFFE5E5);
  
  /// Category text colors
  static const Color workText = primary;
  static const Color personalText = Colors.grey;
  static const Color peaceText = Colors.green;
  static const Color urgentText = Colors.red;
  
  /// UI Element colors
  static const Color borderDefault = Color(0xFFE0E3E8);
  static const Color borderSelected = primary;
  static const Color borderUnselected = Color(0xFFE0E3E8);

  /// Misc colors for categories
  static const Color moodColor = Color(0xFFBDBDBD);
}
