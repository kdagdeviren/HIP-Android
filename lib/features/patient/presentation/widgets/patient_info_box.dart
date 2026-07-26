import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/fixed_list_tile.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientInfoBox extends StatelessWidget {
  const PatientInfoBox({super.key, required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InformationBox(
      padding: EdgeInsets.only(top: 3.h, left: 2.w, right: 2.w, bottom: 0.h),
      innerPadding: EdgeInsets.only(bottom: 0.5.h),
      showCopy: true,
      copyText: patient.docId,
      title: l10n.patient_infoBox_title,
      fixedListTiles: [
        FixedListTile(
          title: l10n.patient_infoBox_idLabel,
          field: patient.docId ?? l10n.patient_infoBox_loading,
        ),
        FixedListTile(title: l10n.patient_add_nameLabel, field: patient.firstName),
        FixedListTile(
          title: l10n.patient_add_surnameLabel,
          field: patient.lastName,
        ),
        FixedListTile(
          title: l10n.patient_add_protocolLabel,
          field: patient.protocolNo,
        ),
      ],
    );
  }
}
