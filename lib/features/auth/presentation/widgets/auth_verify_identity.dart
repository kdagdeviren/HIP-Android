import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AuthVerifyIdentity extends StatelessWidget {
  const AuthVerifyIdentity({
    super.key,
    required this.iconNameLeft,
    required this.iconNameRight,
    required this.hintText,
    required this.onTap,
    this.iconHeight,
  });

  final String iconNameLeft;
  final String iconNameRight;
  final String hintText;
  final Function onTap;
  final double? iconHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 5.h,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.text.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/icons/$iconNameLeft",
                    height: iconHeight ?? 2.h,
                    width: iconHeight ?? 2.h,
                    color: AppColors.text,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    AppLocalizations.of(context)!.auth_register_identityVerifyHint,
                    style: AppTextStyles.nunitoRegular20.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              Image.asset(
                "assets/images/icons/$iconNameRight",
                height: iconHeight ?? 2.h,
                width: iconHeight ?? 2.h,
                color: AppColors.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
