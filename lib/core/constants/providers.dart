import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/features/patient/data/datasources/patient_remote_data_source.dart';
import 'package:flutter_medical_data_app/features/patient/data/datasources/patient_connection_remote_data_source.dart';
import 'package:flutter_medical_data_app/features/patient/data/repositories/patient_repository.dart';
import 'package:flutter_medical_data_app/features/patient/data/repositories/patient_connection_repository.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_add_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_connection_viewmodel.dart';
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

  // ViewModels
  ChangeNotifierProvider<PatientViewModel>(
    create: (context) => PatientViewModel(
      context.read<PatientRepository>(),
      context.read<PatientConnectionRepository>(),
    ),
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
