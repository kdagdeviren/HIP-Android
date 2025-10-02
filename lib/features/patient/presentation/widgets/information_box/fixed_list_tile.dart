import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/utils/text_format_util.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FixedListTile extends StatelessWidget {
  const FixedListTile({super.key, required this.title, required this.field});

  final String title;
  final String field;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          TextFormatUtil.formatFieldValue(title),
          style: AppTextStyles.nunitoSemiBold20.copyWith(fontSize: 16.sp),
        ),
        Text(
          field,
          style: AppTextStyles.nunitoMedium20.copyWith(fontSize: 16.sp),
        ),
      ],
    );
  }
}
