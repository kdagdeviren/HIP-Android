import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/text_field_list_tile.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientAddList extends StatelessWidget {
  const PatientAddList({super.key, required this.idController});

  final TextEditingController idController;

  @override
  Widget build(BuildContext context) {
    return InformationBox(
      showCopy: true,
      showPaste: true,
      title: "HASTA EKLE",
      padding: EdgeInsets.only(top: 1.h, bottom: 1.h, left: 4.w, right: 4.w),
      textFieldListTiles: [
        TextFieldListTile(title: "ID", controller: idController),
      ],
      buttonWidget: SecondButton(
        buttonText: "Mevcut Hasta Ekle",
        onPressed: () {},
        height: 4.h,
      ),
    );
  }
}
