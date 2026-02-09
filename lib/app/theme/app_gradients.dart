import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient bgGradientMain = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0B1020),
      Color(0xFF090B14),
    ],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x29FFFFFF), // 0.16
      Color(0x0FFFFFFF), // 0.06
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF7C8CFF),
      Color(0xFF9B8CFF),
    ],
  );

  static const LinearGradient textGradient = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFD0D6E5),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
