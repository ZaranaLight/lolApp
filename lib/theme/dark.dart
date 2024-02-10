import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Metropolis',
  primaryColor: Color(0xFF05365B),

  secondaryHeaderColor: Color(0xFFffffff),
  disabledColor: Color(0xff8b8b8b),
  backgroundColor: Color(0xFF000000),
  errorColor: Color(0xFFFF3D00),
  hintColor: Color(0xFFffffff),
  cardColor: Color(0xff80A4BD),
  canvasColor: Colors.transparent,
// cardColor: Color(0x80ffc700),
  colorScheme: ColorScheme.light(
      primary: Color(0xFF05365B), secondary: Color(0xff80A4BD)),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Color(0xFF05365B))),
);