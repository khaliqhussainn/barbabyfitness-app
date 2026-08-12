import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static TextTheme get textTheme => GoogleFonts.outfitTextTheme();

  static TextTheme get darkTextTheme =>
      GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme);
}
