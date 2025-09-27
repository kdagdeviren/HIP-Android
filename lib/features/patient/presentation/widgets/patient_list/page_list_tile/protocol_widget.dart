import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProtocolWidget extends StatelessWidget {
  const ProtocolWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Protokol No\n",
        style: AppTextStyles.nunitoBold25.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.text,
        ),
        children: [
          TextSpan(
            text: "157126154",
            style: AppTextStyles.nunitoBold20.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
