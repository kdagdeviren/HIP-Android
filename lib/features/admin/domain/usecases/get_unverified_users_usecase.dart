import 'package:flutter_medical_data_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:flutter_medical_data_app/features/auth/data/models/user_model.dart';

class GetUnverifiedUsersUsecase {
  final AdminRepository _adminRepository;

  GetUnverifiedUsersUsecase(this._adminRepository);

  Future<List<UserModel>> call() async {
    return await _adminRepository.getUnverifiedUsers();
  }
}
