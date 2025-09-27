import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:flutter_medical_data_app/firebase_options.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/core/theme/app_theme.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_medical_data_app/features/home/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_medical_data_app/core/services/auth_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PopupService()),
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return Center(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            navigatorKey: NavigationService.instance.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Medical App',
            routes: {
              '/auth-guard': (context) => const AuthGuard(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/home': (context) => const MainPage(),
            },
            home: const AuthGuard(),
          ),
        );
      },
    );
  }
}
