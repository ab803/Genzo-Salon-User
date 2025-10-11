import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle heading(Color color) => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: color,
  );

  static TextStyle subheading(Color color) => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle body(Color color) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: color,
  );

  static TextStyle caption(Color color) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: color,
  );

  static TextStyle button(Color color) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
  );
}
