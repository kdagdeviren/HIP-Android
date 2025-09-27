import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFE9EFFF);
  static const Color main = Color(0xFF457ADB);
  static const Color mainDark = Color(0xFF00266D);
  static const Color buttonColor = Color(0xFF2773FF);
  static const Color secondButtonColor = Color(0xFF474AF1);
  static const Color second = Color(0xFFACC3FF);
  static const Color textFieldBackground = Color(0xFFE9EFFF);
  static const Color text = Color(0xFF242424);
  static const Color textPlaceholder = Color(0x80242424);
  static const Color error = Color(0xFFF24D4D);
  static const Color errorBackground = Color(0xFFF9CFCF);
  static const Color success = Color(0xFF55C762);
  static const Color successBackground = Color(0xFFE6FFC7);

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [main, second],
  );
}
