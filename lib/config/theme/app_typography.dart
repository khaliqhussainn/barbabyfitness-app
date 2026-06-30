import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Font family is a placeholder pending Figma design handoff.
abstract final class AppTypography {
  static TextTheme get textTheme => GoogleFonts.interTextTheme();

  static TextTheme get darkTextTheme =>
      GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
}
