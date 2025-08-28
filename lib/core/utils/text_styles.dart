import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle headingTextStyle = GoogleFonts.lato(
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 57 / 40, // lineHeight / fontSize
    letterSpacing: 0,
  );
  static TextStyle headingTextStyleInter = GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 50,
    height: 22 / 40,
    letterSpacing: 0,
  );

  static TextStyle bodyTextStyleInter = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 22 / 18,
    letterSpacing: 0,
  );

  static TextStyle bodyTextStyle = GoogleFonts.lato(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 22 / 18,
    letterSpacing: 0,
  );

  static TextStyle buttonTextStyle = GoogleFonts.lato(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 24 / 18,
    letterSpacing: 0,
  );
}
