import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/box_decorations.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/added_categories.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/page_list_tile/patient_list_tile_top.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/page_list_tile/medical_data_tile/patient_medical_data.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/page_list_tile/protocol_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientListTile extends StatelessWidget {
  const PatientListTile({
    super.key,
    required this.patient,
    required this.addDataCallback,
  });

  final Patient patient;
  final Function(String?) addDataCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: borderDecoration,
          child: Column(
            children: [
              InformationBox(
                showCopy: true,
                customWidget: Padding(
                  padding: EdgeInsets.only(
                    top: 1.5.h,
                    bottom: 1.h,
                    left: 2.w,
                    right: 2.w,
                  ),
                  child: Column(
                    children: [
                      //Patient information for name, surname and ID
                      PatientListTileTop(
                        patientName: "${patient.firstName} ${patient.lastName}",
                        patientDocID: patient.docId ?? 'N/A',
                      ),
                      Container(height: 1.5, color: AppColors.text),
                      SizedBox(height: 1.h),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Information for protocol number
                            Expanded(
                              flex: 35,
                              child: ProtocolWidget(
                                protocolNo: patient.protocolNo,
                              ),
                            ),
                            //Divider
                            VerticalDivider(
                              thickness: 1.5,
                              color: AppColors.text,
                            ),
                            //Information for medical data, pathology, radiology, etc.
                            Expanded(
                              flex: 65,
                              child: PatientMedicalData(
                                onPressed: () => addDataCallback(patient.docId),
                                addedCategories:
                                    patient.addedCategories ??
                                    AddedCategories().getEmpty(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
      ],
    );
  }
}
