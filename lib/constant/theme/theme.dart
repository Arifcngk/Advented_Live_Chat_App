import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFF8FAFC),
      secondary: Color(0xFF29e680),
      surface: Color(0xFFBCCCDC),
      onPrimary: Color(0xFF9AA6B2),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF007665),
      centerTitle: true,
      elevation: 0,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
  );
}
