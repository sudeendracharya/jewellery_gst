import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectStyles {
  static TextStyle drawerStyle() {
    return GoogleFonts.lato(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle headingStyle() {
    return GoogleFonts.merriweather(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle invoiceheadingStyle() {
    return GoogleFonts.merriweather(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle invoiceContentStyle() {
    return GoogleFonts.roboto(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle cancelStyle() {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
  }
}
