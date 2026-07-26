import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/bottom_text_navigator.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/logo_with_round_bg.dart';
import 'package:flutter_medical_data_app/shared/widgets/inner_shadow.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WaitingVeirfyPage extends StatelessWidget {
  const WaitingVeirfyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(2.h),
          decoration: BoxDecoration(gradient: AppColors.bgGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GlassBox(
                    blur: 5,
                    borderRadius: 2.h,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 0.h,
                        top: 4.h,
                        left: 1.2.w,
                        right: 1.2.w,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.h,
                            child: Lottie.asset("assets/lottie/identity.json"),
                          ),
                          Text(
                            l10n.auth_waitingVerify_message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: -4.h,
                    left: 0,
                    right: 0,
                    child: Center(child: LogoWithRoundBg()),
                  ),
                ],
              ),

              BottomTextNavigator(
                firstText: l10n.auth_waitingVerify_changeAccountPrompt,
                secondText: l10n.auth_common_loginLink,
                routeName: "/login",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
