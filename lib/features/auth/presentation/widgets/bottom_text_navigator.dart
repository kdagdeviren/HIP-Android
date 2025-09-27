import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';

class BottomTextNavigator extends StatelessWidget {
  const BottomTextNavigator({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.routeName,
  });

  final String firstText;
  final String secondText;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        try {
          NavigationService.instance.navigateTo(routeName);
        } catch (e) {
          LoggerUtil.e("Navigation error: $e");
        }
      },
      child: RichText(
        text: TextSpan(
          text: firstText,
          style: AppTextStyles.nunitoBold20.copyWith(color: AppColors.text),
          children: [
            TextSpan(
              text: secondText,
              style: AppTextStyles.nunitoBold20.copyWith(
                color: AppColors.mainDark,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
