import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/auth/data/auth_service.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/viewmodel/login_viewmodel.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/bottom_text_navigator.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/widgets/logo_with_round_bg.dart';
import 'package:flutter_medical_data_app/shared/widgets/inner_shadow.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ChangeNotifierProvider(
      create: (_) => LoginViewmodel(AuthService()),
      child: Scaffold(
        body: SafeArea(
          child: Selector<LoginViewmodel, bool>(
            selector: (context, viewModel) => viewModel.isLoading,
            builder: (context, isLoading, _) {
              final viewModel = Provider.of<LoginViewmodel>(
                context,
                listen: false,
              );
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
                            child: Column(
                              children: [
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
                                  iconHeight: 2.h,
                                ),
                                SizedBox(height: 2.h),
                                MainButton(
                                  onPressed: () async {
                                    if (isLoading) return;

                                    await viewModel.loginWithEmail(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      context: context,
                                    );

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
                                  buttonText: isLoading
                                      ? l10n.auth_login_submittingButton
                                      : l10n.auth_login_submitButton,
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
                      firstText: l10n.auth_login_noAccountPrompt,
                      secondText: l10n.auth_login_registerLink,
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
