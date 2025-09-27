import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.iconName,
    required this.hintText,
    this.iconHeight,
  });

  final TextEditingController controller;
  final String iconName;
  final String hintText;
  final double? iconHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.text.withOpacity(0.5), width: 2),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/icons/$iconName",
            height: iconHeight ?? 2.h,
            width: iconHeight ?? 2.h,
            color: AppColors.text,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: TextField(
              style: AppTextStyles.nunitoRegular20.copyWith(
                color: AppColors.text,
              ),

              decoration: InputDecoration(
                hintStyle: AppTextStyles.nunitoRegular20.copyWith(
                  color: AppColors.text,
                ),
                border: InputBorder.none,
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
