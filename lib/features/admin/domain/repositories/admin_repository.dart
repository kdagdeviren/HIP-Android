import 'package:flutter_medical_data_app/features/auth/data/models/user_model.dart';

abstract class AdminRepository {
  Future<List<UserModel>> getUnverifiedUsers();
  Future<void> verifyUser(String userId);
  Future<void> rejectUser(String userId);
}
