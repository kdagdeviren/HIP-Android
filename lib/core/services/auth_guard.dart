import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/pages/waiting_verify_page.dart';
import 'package:flutter_medical_data_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/pages/login_page.dart';

bool verificaionDone = false;

class AuthGuard extends StatelessWidget {
  const AuthGuard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          if (!verificaionDone) {
            return const MainPage();
          } else {
            return const WaitingVeirfyPage();
          }
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
