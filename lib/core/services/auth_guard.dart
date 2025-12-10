import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/pages/waiting_verify_page.dart';
import 'package:flutter_medical_data_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_medical_data_app/features/auth/data/auth_service.dart';
import 'package:flutter_medical_data_app/features/auth/data/models/user_model.dart';
import 'package:flutter_medical_data_app/shared/admin_settings.dart';
import 'package:flutter_medical_data_app/features/admin/presentation/pages/admin_home_page.dart';

//AuthModelden alınacak

class AuthGuard extends StatefulWidget {
  const AuthGuard({super.key});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  bool _isLoadingUserData = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadUserData(String userId) async {
    if (_isLoadingUserData) return; // Zaten yükleniyor

    setState(() {
      _isLoadingUserData = true;
    });

    try {
      _userModel = await _authService.getUser(userId);
    } catch (e) {
      // Handle error if needed
      _userModel = null;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUserData = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;

          // Admin kontrolü
          if (user.email == adminEmail) {
            return const AdminHomePage();
          }

          // Kullanıcı verisi yükleniyor ise loading göster
          if (_isLoadingUserData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Kullanıcı verisi henüz yüklenmemişse yükle (build sonrası)
          if (_userModel == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadUserData(user.uid);
            });
            return const Center(child: CircularProgressIndicator());
          }

          // Kullanıcı verisi yüklendi, doğrulama durumuna göre yönlendir
          if (_userModel!.isVerified) {
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
