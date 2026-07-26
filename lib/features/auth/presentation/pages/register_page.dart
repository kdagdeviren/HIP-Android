import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/auth/data/auth_service.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/viewmodel/register_viewmodel.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/auth_verify_identity.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/bottom_text_navigator.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/logo_with_round_bg.dart';
import 'package:flutter_medical_data_app/shared/widgets/inner_shadow.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController nameController;
  late final TextEditingController surnameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordRepeatController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordRepeatController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                                    hintText: l10n.auth_register_nameHint,
                                  ),
                                  SizedBox(height: 1.h),
                                  AuthTextField(
                                    controller: surnameController,
                                    iconName: "name.png",
                                    hintText: l10n.auth_register_surnameHint,
                                  ),
                                  SizedBox(height: 1.h),
                                  AuthTextField(
                                    controller: emailController,
                                    iconName: "email.png",
                                    hintText: l10n.auth_login_emailHint,
                                  ),
                                  SizedBox(height: 1.h),
                                  AuthTextField(
                                    controller: passwordController,
                                    iconName: "pass.png",
                                    hintText: l10n.auth_login_passwordHint,
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 1.h),
                                  AuthTextField(
                                    controller: passwordRepeatController,
                                    iconName: "pass.png",
                                    hintText:
                                        l10n.auth_register_passwordRepeatHint,
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AuthVerifyIdentity(
                                          onTap: () async {
                                            await viewModel.changeImage(
                                              context,
                                            );
                                          },
                                          iconNameLeft: "select_image.png",
                                          iconNameRight: "arrow_right.png",
                                          hintText: l10n
                                              .auth_register_identityVerifyHint,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Container(
                                        padding: EdgeInsets.all(0.2),

                                        decoration: BoxDecoration(
                                          color: AppColors.text,
                                          borderRadius: BorderRadius.circular(
                                            360,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: viewModel.isIdentityVerified
                                              ? AppColors.success
                                              : Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ],
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
                                    onPressed: () async {
                                      if (viewModel.isLoading) return;

                                      loading.show(context);
                                      await viewModel.registerWithEmail(
                                        email: emailController.text.trim(),
                                        name: nameController.text.trim(),
                                        surname: surnameController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                        passwordRepeat: passwordRepeatController
                                            .text
                                            .trim(),
                                      );
                                      loading.close();

                                      if (!mounted ||
                                          viewModel.responseMessage == null) {
                                        return;
                                      }

                                      if (viewModel.responseMessage!.status) {
                                        NavigationService.instance.navigateTo(
                                          '/auth-guard',
                                        );
                                      } else {
                                        ErrorHandler.showErrorSnackBar(
                                          context,
                                          viewModel.responseMessage!.message,
                                        );
                                      }
                                    },
                                    height: 5.h,
                                    buttonText: viewModel.isLoading
                                        ? l10n.auth_register_submittingButton
                                        : l10n.auth_register_submitButton,
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
                      firstText: l10n.auth_register_haveAccountPrompt,
                      secondText: l10n.auth_common_loginLink,
                      routeName: "/login",
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
