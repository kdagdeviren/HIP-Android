import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'theme_color.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    textTheme: appTextTheme,

    colorScheme: const ColorScheme.light(
      primary: AppColors.main,
      error: AppColors.error,
      surface: AppColors.textFieldBackground,
      onSurface: AppColors.text,
    ),
    useMaterial3: true,
  );
}
