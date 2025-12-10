import 'package:flutter_medical_data_app/features/admin/data/admin_service.dart';
import 'package:flutter_medical_data_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:flutter_medical_data_app/features/auth/data/models/user_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminService _adminService;

  AdminRepositoryImpl(this._adminService);

  @override
  Future<List<UserModel>> getUnverifiedUsers() async {
    return await _adminService.getUnverifiedUsers();
  }

  @override
  Future<void> verifyUser(String userId) async {
    return await _adminService.verifyUser(userId);
  }

  @override
  Future<void> rejectUser(String userId) async {
    return await _adminService.rejectUser(userId);
  }
}
