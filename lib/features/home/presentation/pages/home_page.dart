import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/features/home/presentation/widgets/main_app_bar.dart';
import 'package:flutter_medical_data_app/shared/widgets/custom_card_with_image.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

String getCurrentUserName(AppLocalizations l10n) {
  return FirebaseAuth.instance.currentUser?.displayName ??
      l10n.home_defaultTitle;
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String name = getCurrentUserName(l10n);
    return Scaffold(
      appBar: MainAppBar(title: name),
      body: Padding(
        padding: mainPadding,
        child: Column(
          children: [
            CustomCardWithImage(
              title: l10n.home_newPatientTitle,
              buttonName: l10n.home_newPatientButton,
              image: "assets/images/new_patient.png",
              buttonPressed: () {
                NavigationService.instance.navigateTo('/patient-add');
              },
            ),
            SizedBox(height: 1.h),
            CustomCardWithImage(
              title: l10n.home_existingPatientTitle,
              buttonName: l10n.home_existingPatientButton,
              image: "assets/images/existing_patinet.png",
              buttonPressed: () {
                NavigationService.instance.navigateTo('/patient-all-list');
              },
            ),
            SizedBox(height: 1.h),
            CustomCardWithImage(
              title: l10n.admin_home_signOutTitle,
              buttonName: l10n.admin_home_signOutButton,
              image: "assets/images/existing_patinet.png",
              buttonPressed: () async {
                await FirebaseAuth.instance.signOut();
                NavigationService.instance.navigateToReplacement('/auth-guard');
              },
            ),
          ],
        ),
      ),
    );
  }
}
