import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.height,
  });

  final String buttonText;
  final Function onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          minimumSize: Size(double.infinity, 6.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.h),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(
          buttonText,
          style: AppTextStyles.nunitoBold25.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class SecondButton extends StatelessWidget {
  const SecondButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.height,
  });

  final String buttonText;
  final Function onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondButtonColor,
          minimumSize: Size(double.infinity, 6.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(
          buttonText,
          style: AppTextStyles.nunitoBold25.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
