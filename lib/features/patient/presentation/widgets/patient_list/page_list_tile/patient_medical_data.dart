import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/page_list_tile/medical_data_tile/Icons/circular_icon_enum.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/page_list_tile/medical_data_tile/medical_data_tile.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientMedicalData extends StatelessWidget {
  const PatientMedicalData({super.key});

  @override
  Widget build(BuildContext context) {
    double spaceHeight = 1.h;
    return Padding(
      padding: EdgeInsets.all(1.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Mevcut Veriler",
            textAlign: TextAlign.left,
            style: AppTextStyles.nunitoBold25.copyWith(
              fontSize: 16.sp,
              height: 1,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 1.3.h),
          MedicalDataTile(
            title: "Patoloji",
            icon: CircularIconEnum.error.widget,
          ),
          SizedBox(height: spaceHeight),
          MedicalDataTile(
            title: "Onkoloji",
            icon: CircularIconEnum.error.widget,
          ),
          SizedBox(height: spaceHeight),
          MedicalDataTile(
            title: "Demografi",
            icon: CircularIconEnum.error.widget,
          ),
          SizedBox(height: spaceHeight),
          MedicalDataTile(
            title: "Komorbite",
            icon: CircularIconEnum.error.widget,
          ),
          SizedBox(height: spaceHeight),
          MedicalDataTile(
            title: "Biyokimya",
            icon: CircularIconEnum.error.widget,
          ),
          SizedBox(height: spaceHeight),
          MedicalDataTile(
            title: "Radyoloji",
            icon: CircularIconEnum.error.widget,
          ),
          SizedBox(height: spaceHeight),
          MedicalDataTile(title: "PET", icon: CircularIconEnum.error.widget),
          SizedBox(height: spaceHeight),
          SecondButton(
            buttonText: "VERİ GİRİŞİ",
            onPressed: () {},
            height: 4.h,
          ),
        ],
      ),
    );
  }
}
