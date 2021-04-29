import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontBuilder {
  static TextStyle buildCommonAppThemeFont(double fontSize, Color fontColor) =>
      GoogleFonts.lato(
          textStyle: TextStyle(fontSize: fontSize), color: fontColor);
}
