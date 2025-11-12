import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0F1729);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceSecondary = Color(0xFF1F2937);
  static const Color border = Color(0xFF233044);

  static const Color primary = Color(0xFF5B61FF);
  static const Color primaryHover = Color(0xFF6C73FF);
  static const Color primaryForeground = Color(0xFFF8FAFC);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF38BDF8);

  static const Color muted = Color(0xFF64748B);
  static const Color mutedForeground = Color(0xFF94A3B8);

  static const Color chartPurple = Color(0xFF7C3AED);
  static const Color chartBlue = Color(0xFF2563EB);
  static const Color chartGreen = Color(0xFF16A34A);
  static const Color chartOrange = Color(0xFFF97316);
  static const Color chartPink = Color(0xFFEC4899);

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFF4C51BF),
      Color(0xFF312E81),
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}

