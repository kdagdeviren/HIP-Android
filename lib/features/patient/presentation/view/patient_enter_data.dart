import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/fixed_list_tile.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/page_information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/shared/widgets/custom_card_with_image.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientEnterData extends StatelessWidget {
  const PatientEnterData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(title: "Hasta Bilgileri"),
      body: Padding(
        padding: mainPadding,
        child: Column(
          children: [
            SizedBox(height: 2.h),
            InformationBox(
              showCopy: true,
              title: "HASTA",
              fixedListTiles: [
                FixedListTile(title: "ID", field: "ID"),
                FixedListTile(title: "Adı", field: "Ad"),
                FixedListTile(title: "Soyadı", field: "Soyad"),
                FixedListTile(title: "Protokol\nNo", field: "Protokol No"),
              ],
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PageInformationBox(title: "Bekleyen"),
                    SizedBox(height: 1.h),
                    DataList(),
                    SizedBox(height: 1.5.h),
                    PageInformationBox(title: "Tamamlanmamış"),
                    SizedBox(height: 1.h),
                    SecondButton(
                      buttonText: "TÜMÜNÜ GÖRÜNTÜLE",
                      onPressed: () {},
                      height: 5.h,
                      buttonColor: AppColors.thirdButtonColor,
                    ),
                    SizedBox(height: 1.h),
                    DataList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataList extends StatelessWidget {
  const DataList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCardWithImage(
          title: "Radyoloji verilerinin girişini yapın",
          buttonName: "GÖRÜNTÜLE",
          buttonColor: AppColors.thirdButtonColor,
          image: "assets/images/new_patient.png",
          buttonPressed: () {},
        ),
        SizedBox(height: 0.7.h),
        CustomCardWithImage(
          title: "Radyoloji verilerinin girişini yapın",
          buttonName: "GÖRÜNTÜLE",
          buttonColor: AppColors.thirdButtonColor,
          image: "assets/images/new_patient.png",
          buttonPressed: () {},
        ),
        SizedBox(height: 0.7.h),
        CustomCardWithImage(
          title: "Radyoloji verilerinin girişini yapın",
          buttonName: "GÖRÜNTÜLE",
          buttonColor: AppColors.thirdButtonColor,
          image: "assets/images/new_patient.png",
          buttonPressed: () {},
        ),
      ],
    );
  }
}
