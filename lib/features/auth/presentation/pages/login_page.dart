import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/bottom_text_navigator.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/logo_with_round_bg.dart';
import 'package:flutter_medical_data_app/shared/widgets/inner_shadow.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                          AuthTextField(
                            controller: TextEditingController(),
                            iconName: "email.png",
                            hintText: "Email",
                          ),
                          SizedBox(height: 1.h),
                          AuthTextField(
                            controller: TextEditingController(),
                            iconName: "pass.png",
                            hintText: "Şifre",
                            iconHeight: 2.h,
                          ),
                          SizedBox(height: 2.h),
                          MainButton(
                            onPressed: () {
                              LoggerUtil.i("message");
                            },
                            height: 5.h,
                            buttonText: "GİRİŞ YAP",
                          ),
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
                firstText: "Hesabınız yok mu? ",
                secondText: "Kayıt Ol",
                routeName: "/register",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
