import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/features/home/presentation/widgets/main_app_bar.dart';
import 'package:flutter_medical_data_app/shared/widgets/custom_card_with_image.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

String getCurrentUserName() {
  return FirebaseAuth.instance.currentUser?.displayName ?? "Ana Sayfa";
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    String name = getCurrentUserName();
    return Scaffold(
      appBar: MainAppBar(title: name),
      body: Padding(
        padding: mainPadding,
        child: Column(
          children: [
            CustomCardWithImage(
              title: "Yeni bir hasta kaydı oluşturun",
              buttonName: "KAYIT AÇ",
              image: "assets/images/new_patient.png",
              buttonPressed: () {
                NavigationService.instance.navigateTo('/patient-add');
              },
            ),
            SizedBox(height: 1.h),
            CustomCardWithImage(
              title: "Mevcut bir hastanın verilerini girin",
              buttonName: "HASTALARI GÖR",
              image: "assets/images/existing_patinet.png",
              buttonPressed: () {
                NavigationService.instance.navigateTo('/patient-all-list');
              },
            ),
            SizedBox(height: 1.h),
            CustomCardWithImage(
              title: "Çıkış yapmak için test alanı",
              buttonName: "ÇIKIŞ YAP",
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
