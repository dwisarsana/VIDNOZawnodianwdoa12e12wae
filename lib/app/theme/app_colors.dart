import 'package:flutter/material.dart';

class AppColors {
  static const Color bgBase = Color(0xFF07090F);
  static const Color bgElevated = Color(0xFF0E1420);

  static const Color primary = Color(0xFF7C8CFF);
  static const Color secondary = Color(0xFF63E6BE);
  static const Color accent = Color(0xFF9B8CFF);

  static const Color success = Color(0xFF42D392);
  static const Color warning = Color(0xFFFFBD73);
  static const Color danger = Color(0xFFFF7B8B);

  static const Color textPrimary = Color(0xFFF5F8FF);
  static const Color textSecondary = Color(0xFFB8C1D9);
  static const Color textMuted = Color(0xFF8C94AB);

  // Glass Tints (Opacity handled by using withOpacity or alpha if needed, but here defined as per prompt)
  static const Color glassTintHigh = Color(0x29FFFFFF); // rgba(255,255,255,0.16)
  static const Color glassTintMed = Color(0x1CFFFFFF);  // rgba(255,255,255,0.11)
  static const Color glassTintLow = Color(0x12FFFFFF);  // rgba(255,255,255,0.07)
  static const Color glassBorder = Color(0x38FFFFFF);   // rgba(255,255,255,0.22)
  static const Color bgOverlay = Color(0xA6080A10);     // rgba(8,10,16,0.65)
}
