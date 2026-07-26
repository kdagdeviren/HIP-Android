import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/features/patient/data/datasources/patient_remote_data_source.dart';
import 'package:flutter_medical_data_app/features/patient/data/datasources/patient_connection_remote_data_source.dart';
import 'package:flutter_medical_data_app/features/patient/data/repositories/patient_repository.dart';
import 'package:flutter_medical_data_app/features/patient/data/repositories/patient_connection_repository.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_add_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_connection_viewmodel.dart';
import 'package:flutter_medical_data_app/features/admin/data/admin_service.dart';
import 'package:flutter_medical_data_app/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:flutter_medical_data_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:flutter_medical_data_app/features/admin/domain/usecases/get_unverified_users_usecase.dart';
import 'package:flutter_medical_data_app/features/admin/domain/usecases/verify_user_usecase.dart';
import 'package:flutter_medical_data_app/features/admin/domain/usecases/reject_user_usecase.dart';
import 'package:flutter_medical_data_app/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:provider/provider.dart';

var providers = [
  // Data Sources
  Provider<PatientRemoteDataSource>(create: (_) => PatientRemoteDataSource()),
  Provider<PatientConnectionRemoteDataSource>(
    create: (_) => PatientConnectionRemoteDataSource(),
  ),

  // Repositories
  Provider<PatientRepository>(
    create: (context) =>
        PatientRepository(context.read<PatientRemoteDataSource>()),
  ),
  Provider<PatientConnectionRepository>(
    create: (context) => PatientConnectionRepository(
      context.read<PatientConnectionRemoteDataSource>(),
    ),
  ),

  // Admin
  Provider<AdminService>(create: (_) => AdminService()),
  Provider<AdminRepository>(
    create: (context) => AdminRepositoryImpl(context.read<AdminService>()),
  ),
  Provider<GetUnverifiedUsersUsecase>(
    create: (context) =>
        GetUnverifiedUsersUsecase(context.read<AdminRepository>()),
  ),
  Provider<VerifyUserUsecase>(
    create: (context) => VerifyUserUsecase(context.read<AdminRepository>()),
  ),
  Provider<RejectUserUsecase>(
    create: (context) => RejectUserUsecase(context.read<AdminRepository>()),
  ),
  ChangeNotifierProvider<AdminViewModel>(
    create: (context) => AdminViewModel(
      context.read<GetUnverifiedUsersUsecase>(),
      context.read<VerifyUserUsecase>(),
      context.read<RejectUserUsecase>(),
    ),
  ),

  // ViewModels
  ChangeNotifierProvider<PatientViewModel>(
    create: (context) => PatientViewModel(context.read<PatientRepository>()),
  ),
  ChangeNotifierProvider<PatientConnectionViewModel>(
    create: (context) =>
        PatientConnectionViewModel(context.read<PatientConnectionRepository>()),
  ),
  ChangeNotifierProvider(
    create: (context) => PatientAddViewmodel(
      context.read<PatientViewModel>(),
      context.read<PatientConnectionViewModel>(),
    ),
  ),

  // Services
  Provider(create: (_) => PopupService()),
];
