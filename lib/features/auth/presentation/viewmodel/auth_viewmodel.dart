import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';

class AuthViewmodel extends ChangeNotifier {
  Future<void> logOut() async {
    FirebaseAuth.instance.signOut();
    NavigationService.instance.navigateTo('/auth-guard');
    notifyListeners();
  }
}
