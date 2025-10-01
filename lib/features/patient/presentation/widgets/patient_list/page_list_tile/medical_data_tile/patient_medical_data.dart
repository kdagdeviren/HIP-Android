import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories_card_data.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/added_categories.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/page_list_tile/medical_data_tile/medical_data_tile.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientMedicalData extends StatelessWidget {
  const PatientMedicalData({
    super.key,
    required this.addedCategories,
    required this.onPressed,
  });
  final AddedCategories addedCategories;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> addedCategoriesMap = addedCategories.toMap();
    double spaceHeight = 0.5.h;
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
          Column(
            children: CategoryCardData.getAllCardCategories().map((category) {
              bool isActive = addedCategoriesMap[category.id] ?? false;
              return Padding(
                padding: EdgeInsets.only(bottom: spaceHeight),
                child: MedicalDataTile(
                  title: category.name,
                  isActive: isActive,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: spaceHeight),
          SecondButton(
            buttonText: "VERİ GİRİŞİ",
            onPressed: onPressed,
            height: 4.h,
          ),
        ],
      ),
    );
  }
}
