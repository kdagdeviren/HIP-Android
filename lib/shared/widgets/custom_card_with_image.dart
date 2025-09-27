import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomCardWithImage extends StatelessWidget {
  const CustomCardWithImage({
    super.key,
    required this.title,
    required this.buttonName,
    required this.image,
    required this.buttonPressed,
  });

  final String title;
  final String buttonName;
  final String image;
  final Function buttonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.text, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.nunitoBold25.copyWith(
                    height: 1,
                    color: AppColors.text,
                    fontSize: 19.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                SecondButton(
                  buttonText: buttonName,
                  onPressed: () {
                    buttonPressed();
                  },
                  height: 4.h,
                ),
              ],
            ),
          ),
          Spacer(flex: 10),
          Expanded(
            flex: 30,
            child: Image.asset(image, height: 10.h, width: 30.w),
          ),
        ],
      ),
    );
  }
}
