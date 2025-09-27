import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/features/patient/data/datasources/patient_remote_data_source.dart';
import 'package:flutter_medical_data_app/features/patient/data/repositories/patient_repository.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_add_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:provider/provider.dart';

var providers = [
  Provider<PatientRemoteDataSource>(create: (_) => PatientRemoteDataSource()),
  Provider<PatientRepository>(
    create: (context) =>
        PatientRepository(context.read<PatientRemoteDataSource>()),
  ),
  ChangeNotifierProvider<PatientViewModel>(
    create: (context) => PatientViewModel(context.read<PatientRepository>()),
  ),
  ChangeNotifierProvider(
    create: (context) => PatientAddViewmodel(context.read<PatientViewModel>()),
  ),
  Provider(create: (_) => PopupService()),
];
