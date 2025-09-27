import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/box_decorations.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PageInformationBox extends StatelessWidget {
  const PageInformationBox({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      decoration: borderDecoration,
      child: Center(
        child: Text(
          title,
          style: AppTextStyles.nunitoBold25.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
