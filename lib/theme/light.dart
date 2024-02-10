

import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Metropolis',
  primaryColor: Color(0xFF05365B),
  secondaryHeaderColor: Color(0xFF171717).withOpacity(0.7),
  disabledColor: Color(0xff8b8b8b),
  backgroundColor: Color(0xFFffffff),
  errorColor: Color(0xFFFF3D00),
  hintColor: Color(0xFF000000),
  // cardColor: Color(0x80ffc700),
  cardColor: Color(0xff80A4BD),


  canvasColor: Colors.transparent,
  colorScheme: const ColorScheme.light(
      primary: Color(0xFF05365B), secondary: Color(0xFF05365B)),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Color(0xFF05365B))),
);
