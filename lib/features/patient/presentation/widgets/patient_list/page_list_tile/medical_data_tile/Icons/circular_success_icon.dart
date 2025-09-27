import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CircularSuccessIcon extends StatelessWidget {
  const CircularSuccessIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.5.h,
      width: 2.5.h,
      decoration: BoxDecoration(
        color: AppColors.success.withAlpha(50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.check_rounded, size: 2.h, color: AppColors.success),
    );
  }
}
