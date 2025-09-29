import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
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
    _patientViewModel = patientViewModel;
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _patientViewModel?.fetchPatients();
    }
  }

  void addDataNavigation() {
    NavigationService.instance.navigateTo('/patient-enter-data');
    notifyListeners();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
