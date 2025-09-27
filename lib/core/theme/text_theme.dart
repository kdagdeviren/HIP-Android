import 'package:flutter/material.dart';

const TextTheme appTextTheme = TextTheme(
  // SemiBold - 20sp
  displayLarge: TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w600,
    fontSize: 16,
  ),

  // Bold - 20, 25, 30
  displayMedium: TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 16,
  ),
  displaySmall: TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 20,
  ),
  headlineLarge: TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 25,
  ),

  // Medium - 20
  headlineMedium: TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w500,
    fontSize: 16,
  ),

  // Regular - 20, 25, 20
  headlineSmall: TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    fontSize: 16,
  ),
  titleLarge: TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    fontSize: 20,
  ),

  // Light - 19, 17, 15
  titleSmall: TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w300,
    fontSize: 16,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w300,
    fontSize: 15,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w300,
    fontSize: 12,
  ),
);

class AppTextStyles {
  // SemiBold
  static const TextStyle nunitoSemiBold20 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  // Bold
  static const TextStyle nunitoBold20 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );
  static const TextStyle nunitoBold25 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );
  static const TextStyle nunitoBold30 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 30,
  );

  static const TextStyle nunitoBold40 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 40,
  );

  // Medium
  static const TextStyle nunitoMedium20 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  // Regular
  static const TextStyle nunitoRegular20 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );
  static const TextStyle nunitoRegular25 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  // Light
  static const TextStyle nunitoLight19 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w300,
    fontSize: 15,
  );
  static const TextStyle nunitoLight17 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w300,
    fontSize: 14,
  );
  static const TextStyle nunitoLight15 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w300,
    fontSize: 12,
  );
}
