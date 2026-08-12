import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFE0691A);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Background & Surface
  static const Color background = Color(0xFF0B0B0B);
  static const Color surface = Color(0xFF262626);
  static const Color onSurface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF64646C);

  // Input fields
  static const Color inputBorder = Color(0xFF64646C);
  static const Color inputFill = Color(0x00000000); // transparent — card shows through
  static const Color inputHint = Color(0xFF64646C);

  // Utility
  static const Color divider = Color(0xFF64646C);
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
}
