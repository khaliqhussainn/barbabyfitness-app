import 'package:flutter/material.dart';

// All values are temporary placeholders pending Figma design handoff.
// Do not derive brand identity from these values.
abstract final class AppColors {
  // Light theme
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF000000);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF000000);
  static const Color error = Color(0xFFB00020);
  static const Color onError = Color(0xFFFFFFFF);

  // Dark theme
  static const Color primaryDark = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFF000000);
  static const Color secondaryDark = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color onErrorDark = Color(0xFF000000);
}
