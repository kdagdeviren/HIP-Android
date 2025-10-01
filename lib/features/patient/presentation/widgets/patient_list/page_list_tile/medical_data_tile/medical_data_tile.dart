import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/page_list_tile/medical_data_tile/Icons/circular_icon_enum.dart';

class MedicalDataTile extends StatelessWidget {
  const MedicalDataTile({
    super.key,
    required this.title,
    required this.isActive,
  });

  final String title;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: AppTextStyles.nunitoRegular20,
        ),
        isActive
            ? CircularIconEnum.success.widget
            : CircularIconEnum.error.widget,
      ],
    );
  }
}
