import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/core/utils/category_display_util.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories_card_data.dart';
import 'package:flutter_medical_data_app/shared/widgets/custom_card_with_image.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DataList extends StatelessWidget {
  const DataList({
    super.key,
    required this.isFin,
    required this.categoryCardData,
    required this.patientID,
  });

  final List<CategoryCardData> categoryCardData;
  final bool isFin;
  final String patientID;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView.builder(
      itemCount: categoryCardData.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (index != 0) SizedBox(height: 0.7.h),
            CustomCardWithImage(
              title: l10n.data_list_categoryDataEntryTitle(
                CategoryDisplayUtil.getName(categoryCardData[index].id),
              ),
              buttonName: !isFin
                  ? l10n.data_list_viewButton
                  : l10n.data_list_enterButton,
              buttonColor: !isFin
                  ? AppColors.thirdButtonColor
                  : AppColors.buttonColor,
              image: categoryCardData[index].imagePath,
              buttonPressed: () {
                if (!isFin) {
                  NavigationService.instance.navigateTo(
                    '/patient-view-data',
                    arguments: {
                      'patientId': patientID,
                      'categoryKey': categoryCardData[index].id,
                    },
                  );
                } else {
                  NavigationService.instance.navigateTo(
                    '/patient-update-data',
                    arguments: {
                      'patientId': patientID,
                      'categoryKey': categoryCardData[index].id,
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
