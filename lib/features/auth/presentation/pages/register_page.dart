import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/auth/data/auth_service.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/viewmodel/register_viewmodel.dart';

import 'package:flutter_medical_data_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/auth_verify_identity.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/bottom_text_navigator.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/logo_with_round_bg.dart';
import 'package:flutter_medical_data_app/shared/widgets/inner_shadow.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final passwordRepeatController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(AuthService()),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<RegisterViewModel>(
            builder: (context, viewModel, _) {
              return Container(
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
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AuthTextField(
                                    controller: nameController,
                                    iconName: "name.png",
                                    hintText: "Ad",
                                  ),
                                  SizedBox(height: 1.h),
                                  AuthTextField(
                                    controller: surnameController,
                                    iconName: "name.png",
                                    hintText: "Soyad",
                                  ),
                                  SizedBox(height: 1.h),
                                  AuthTextField(
                                    controller: emailController,
                                    iconName: "email.png",
                                    hintText: "Email",
                                  ),
                                  SizedBox(height: 1.h),
                                  AuthTextField(
                                    controller: passwordController,
                                    iconName: "pass.png",
                                    hintText: "Şifre",
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 1.h),
                                  AuthTextField(
                                    controller: passwordRepeatController,
                                    iconName: "pass.png",
                                    hintText: "Şifre Tekrar",
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 1.h),
                                  AuthVerifyIdentity(
                                    onTap: () {},
                                    iconNameLeft: "select_image.png",
                                    iconNameRight: "arrow_right.png",
                                    hintText: "Kimlik Doğrulaması",
                                  ),
                                  SizedBox(height: 2.h),
                                  if (viewModel.responseMessage != null)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 1.h),
                                      child: Text(
                                        viewModel.responseMessage!.message,
                                        style: TextStyle(
                                          color:
                                              viewModel.responseMessage!.status
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  MainButton(
                                    onPressed: () {
                                      if (viewModel.isLoading) return;
                                      viewModel.registerWithEmail(
                                        context: context,
                                        email: emailController.text.trim(),
                                        name: nameController.text.trim(),
                                        surname: surnameController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                        passwordRepeat: passwordRepeatController
                                            .text
                                            .trim(),
                                      );
                                    },
                                    height: 5.h,
                                    buttonText: viewModel.isLoading
                                        ? "Kayıt Olunuyor..."
                                        : "KAYIT OL",
                                  ),
                                ],
                              ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
