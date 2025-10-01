import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';

class PatientAllListViewModel extends ChangeNotifier {
  late ScrollController _scrollController;
  PatientViewModel? _patientViewModel;

  ScrollController get scrollController => _scrollController;

  PatientAllListViewModel() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void initializePatientViewModel(PatientViewModel patientViewModel) {
    if (_patientViewModel != patientViewModel) {
      _patientViewModel = patientViewModel;
      LoggerUtil.d('PatientViewModel initialized successfully');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_patientViewModel != null) {
        LoggerUtil.d('Triggering fetchPatients from scroll');
        _patientViewModel!.fetchPatients();
      } else {
        LoggerUtil.e('_patientViewModel is null during scroll');
      }
    }
  }

  void addDataNavigation({String? patientId}) {
    if (patientId != null) {
      NavigationService.instance.navigateTo(
        '/patient-enter-data',
        arguments: {'patientId': patientId},
      );
    } else {
      NavigationService.instance.navigateTo('/patient-enter-data');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
