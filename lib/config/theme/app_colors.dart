import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFF97316);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Background & Surface
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color onSurface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);

  // Input fields
  static const Color inputBorder = Color(0xFF3A3A3C);
  static const Color inputFill = Color(0xFF1C1C1E);
  static const Color inputHint = Color(0xFF636366);

  // Utility
  static const Color divider = Color(0xFF2D2D2D);
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
}
