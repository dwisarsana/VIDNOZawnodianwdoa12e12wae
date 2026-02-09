import 'package:flutter/material.dart';

class AppShadows {
  static final List<BoxShadow> glass = [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static final List<BoxShadow> primaryGlow = [
    const BoxShadow(
      color: Color(0x4D7C8CFF), // 0.3 opacity
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}
