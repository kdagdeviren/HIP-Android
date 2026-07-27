import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/text_field_list_tile.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientAddList extends StatelessWidget {
  const PatientAddList({
    super.key,
    required this.idController,
    required this.onAddPatient,
    this.isLoading = false,
  });

  final TextEditingController idController;
  final VoidCallback onAddPatient;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InformationBox(
      showCopy: true,
      showPaste: true,
      title: l10n.patient_addList_title,
      padding: EdgeInsets.only(top: 2.3.h, bottom: 1.h, left: 4.w, right: 4.w),

      textFieldListTiles: [
        TextFieldListTile(
          title: l10n.patient_infoBox_idLabel,
          controller: idController,
        ),
      ],
      buttonWidget: SecondButton(
        buttonText: isLoading
            ? l10n.patient_addList_addingButton
            : l10n.patient_addList_addButton,
        onPressed: isLoading ? () {} : onAddPatient,
        height: 4.h,
      ),
    );
  }
}
