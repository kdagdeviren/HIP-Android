import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/fixed_list_tile.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientInfoBox extends StatelessWidget {
  const PatientInfoBox({super.key, required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return InformationBox(
      padding: EdgeInsets.only(top: 3.h, left: 2.w, right: 2.w, bottom: 0.h),
      innerPadding: EdgeInsets.only(bottom: 0.5.h),
      showCopy: true,
      copyText: patient.docId,
      title: "HASTA BİLGİLERİ",
      fixedListTiles: [
        FixedListTile(title: "ID", field: patient.docId ?? "Yükleniyor..."),
        FixedListTile(title: "Adı", field: patient.firstName),
        FixedListTile(title: "Soyadı", field: patient.lastName),
        FixedListTile(title: "Protokol\nNo", field: patient.protocolNo),
      ],
    );
  }
}
