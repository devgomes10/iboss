import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
    datePickerTheme: const DatePickerThemeData(
      dayForegroundColor: MaterialStatePropertyAll(Colors.white),
      todayForegroundColor: MaterialStatePropertyAll(Colors.white),
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.raleway(
        color: Colors.grey[300],
        // fontSize: 18,
      ),
    ),
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      centerTitle: true,
      titleTextStyle:
          GoogleFonts.raleway(fontSize: 30, fontWeight: FontWeight.w600),
    ),
    colorScheme: const ColorScheme.dark(
      background: Colors.black,
      primary: Colors.black,
      secondary: Color(0xFF5CE1E6),
      tertiary: Colors.white,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black,
    ));
