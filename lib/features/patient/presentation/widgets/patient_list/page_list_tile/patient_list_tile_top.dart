import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientListTileTop extends StatelessWidget {
  const PatientListTileTop({
    super.key,
    required this.patientName,
    required this.patientDocID,
  });

  final String patientName;
  final String patientDocID;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          patientName,
          style: AppTextStyles.nunitoBold25.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              textAlign: TextAlign.end,
              "ID",
              style: AppTextStyles.nunitoBold20,
            ),
            Text(
              textAlign: TextAlign.right,
              patientDocID,
              style: AppTextStyles.nunitoMedium20.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
      ],
    );
  }
}
