import 'package:flutter/material.dart';

class ColorssA {
  const ColorssA._();

  static Color primaryColor = const Color(0xFF4676B8);
  static Color dialpgColor = const Color(0xff80A4BD);
  static Color errorColor = const Color(0xffF02C44);
  static Color bookConfirmColor = const Color(0xffFF4A4A);
  static Color loginColor = const Color(0xff0696FF);
  static Color purpleColor = const Color(0xffA495FF);
  static Color greenColor = const Color(0xff33EA9D);
  static Color whiteColor = const Color(0xffffffff);
  static Color blackColor = const Color(0xff000000);

  static LinearGradient AppLinears = LinearGradient(
      colors: [
        Color(0xff4675B8),
        Color(0xff57B8D6)

      ],
      // stops: [0,0.8],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
  );
}