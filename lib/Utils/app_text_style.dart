import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {

  static final heading = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xff2C3444),
  );

  static final title = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: Color(0xff2C3444),
  );

  static final body = GoogleFonts.poppins(
    fontSize: 14,
    color: Color(0xff6B7280),
    height: 1.6,
  );

  static final small = GoogleFonts.poppins(
    fontSize: 13,
    color: Color(0xff6B7280),
  );
}