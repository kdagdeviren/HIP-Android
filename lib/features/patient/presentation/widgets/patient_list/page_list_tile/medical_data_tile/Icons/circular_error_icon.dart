import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CircularErrorIcon extends StatelessWidget {
  const CircularErrorIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.5.h,
      width: 2.5.h,
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.close_rounded, size: 2.h, color: AppColors.error),
    );
  }
}
