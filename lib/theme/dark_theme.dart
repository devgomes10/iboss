import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  textTheme: TextTheme(
    bodySmall: GoogleFonts.montserrat(
      fontSize: 15,
    ),
    bodyMedium: GoogleFonts.montserrat(
      color: Colors.grey[300],
      fontSize: 18,
    ),
    bodyLarge: GoogleFonts.montserrat(fontSize: 23, fontWeight: FontWeight.bold),
  ),
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    centerTitle: true,
    titleTextStyle: GoogleFonts.concertOne(
      fontSize: 34,
    ),
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[400]!,
    tertiary: const Color(0xFF92E3A9),
  ),
);