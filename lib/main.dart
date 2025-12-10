import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_medical_data_app/core/constants/providers.dart';
import 'package:flutter_medical_data_app/core/routes.dart';
import 'package:flutter_medical_data_app/firebase_options.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_medical_data_app/core/services/auth_guard.dart';
import 'package:flutter_medical_data_app/core/services/deep_link_service.dart';
import 'package:flutter_medical_data_app/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize deep link service
  await DeepLinkService().initialize();

  // Initialize notification service
  await NotificationService().initialize();

  runApp(MultiProvider(providers: providers, child: const MyApp()));
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
            routes: appRoutes,
            home: const AuthGuard(),
          ),
        );
      },
    );
  }
}
