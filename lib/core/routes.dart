import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/view/patient_add_page.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/view/patient_all_list_page.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/view/patient_enter_data.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/view/patient_update_category_page.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_medical_data_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter_medical_data_app/core/services/auth_guard.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/view/patient_view_data.dart';

final Map<String, WidgetBuilder> appRoutes = {
  //Home Page
  '/home': (context) => const MainPage(),
  //Auth Pages
  '/auth-guard': (context) => const AuthGuard(),
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
  //Patient Pages
  '/patient-add': (context) => const PatientAddPage(),
  '/patient-all-list': (context) => const PatientAllListPage(),
  '/patient-view-data': (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return PatientViewData(
      patientId: args?['patientId'],
      categoryKey: args?['categoryKey'] ?? "Kategori",
    );
  },
  '/patient-update-data': (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return PatientUpdateCategoryPage(
      patientId: args?['patientId'],
      categoryKey: args?['categoryKey'] ?? "Kategori",
    );
  },
  '/patient-enter-data': (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return PatientEnterData(patientId: args?['patientId']);
  },
};
