import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TextFieldListTile extends StatelessWidget {
  const TextFieldListTile({
    super.key,
    required this.title,
    required this.controller,
  });

  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 30,
          child: Text(
            title,

            style: AppTextStyles.nunitoSemiBold20.copyWith(
              fontSize: 16.sp,
              height: 1,
            ),
          ),
        ),
        Expanded(
          flex: 70,
          child: DottedBorder(
            options: CustomPathDottedBorderOptions(
              padding: EdgeInsets.only(bottom: 0.2.h),
              color: AppColors.text,
              strokeWidth: 1,
              dashPattern: [2, 3],
              customPath: (size) => Path()
                ..moveTo(0, size.height)
                ..relativeLineTo(size.width, 0),
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              style: AppTextStyles.nunitoMedium20.copyWith(fontSize: 16.sp),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
