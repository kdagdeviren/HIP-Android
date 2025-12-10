import 'package:flutter_medical_data_app/features/admin/domain/repositories/admin_repository.dart';

class RejectUserUsecase {
  final AdminRepository _adminRepository;

  RejectUserUsecase(this._adminRepository);

  Future<void> call(String userId) async {
    return await _adminRepository.rejectUser(userId);
  }
}
