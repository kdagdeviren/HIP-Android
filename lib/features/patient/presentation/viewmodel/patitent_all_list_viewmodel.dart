import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:provider/provider.dart';

class PatientAllListViewModel extends ChangeNotifier {
  late ScrollController _scrollController;

  ScrollController get scrollController => _scrollController;

  PatientAllListViewModel(BuildContext context) {
    _scrollController = ScrollController();
    _scrollController.addListener(() => _onScroll(context));
  }

  void _onScroll(BuildContext context) {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final viewModel = context.read<PatientViewModel>();
      viewModel.fetchPatients();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
