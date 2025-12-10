import 'package:flutter_medical_data_app/features/admin/domain/repositories/admin_repository.dart';

class VerifyUserUsecase {
  final AdminRepository _adminRepository;

  VerifyUserUsecase(this._adminRepository);

  Future<void> call(String userId) async {
    return await _adminRepository.verifyUser(userId);
  }
}
