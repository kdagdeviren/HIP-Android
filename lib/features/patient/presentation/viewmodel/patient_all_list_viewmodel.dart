import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_connection_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_connection_viewmodel.dart';

class PatientAllListViewModel extends ChangeNotifier {
  late ScrollController _scrollController;
  PatientViewModel? _patientViewModel;
  PatientConnectionViewModel? _connectionViewModel;

  ScrollController get scrollController => _scrollController;

  bool _isConnecting = false;
  bool get isConnecting => _isConnecting;

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

  void initializeConnectionViewModel(
    PatientConnectionViewModel connectionViewModel,
  ) {
    if (_connectionViewModel != connectionViewModel) {
      _connectionViewModel = connectionViewModel;
      LoggerUtil.d('PatientConnectionViewModel initialized successfully');
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

  /// Mevcut bir hastayı ID ile bağlar
  Future<ResponseMessage> connectExistingPatient(
    BuildContext context,
    String patientId,
  ) async {
    // Validasyon kontrolleri
    if (patientId.trim().isEmpty) {
      return ResponseMessage(status: false, message: 'Hasta ID boş olamaz');
    }

    // ID format kontrolü (minimum uzunluk)
    if (patientId.trim().length < 10) {
      return ResponseMessage(
        status: false,
        message: 'Geçersiz hasta ID formatı',
      );
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return ResponseMessage(
        status: false,
        message: 'Kullanıcı oturumu bulunamadı. Lütfen giriş yapın.',
      );
    }

    if (_connectionViewModel == null) {
      LoggerUtil.e('ConnectionViewModel is not initialized');
      return ResponseMessage(
        status: false,
        message: 'Bağlantı servisi hazır değil',
      );
    }

    // Loading göster
    loading.show(context);
    _isConnecting = true;
    notifyListeners();

    try {
      // Zaten bağlı mı kontrol et
      if (_connectionViewModel!.isConnectedToPatient(patientId)) {
        return ResponseMessage(status: false, message: 'Bu hasta zaten mevcut');
      }

      // Bağlantı oluştur
      final response = await _connectionViewModel!.connectPatient(
        patientId: patientId,
        userId: currentUser.uid,
        role: ConnectionRole.editor, // Mevcut hastalar için editor
      );

      if (response.status && _patientViewModel != null) {
        // Hasta listesini yenile
        await _patientViewModel!.refresh();
        LoggerUtil.i('Patient connected successfully and list refreshed');
      }

      return response;
    } catch (e) {
      LoggerUtil.e('Error connecting patient: $e');
      return ResponseMessage(
        status: false,
        message: ErrorHandler.handleError(e, 'Connect Patient'),
      );
    } finally {
      // Loading kapat
      loading.close();
      _isConnecting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
