import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/core/services/notification_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/patient/data/datasources/patient_connection_remote_data_source.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_connection_model.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories_card_data.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';

class PatientUpdateCategoryViewmodel extends ChangeNotifier {
  final PatientViewModel patientViewModel;
  final String categoryKey;
  final String? patientId;
  final String? patientJson;
  Map<String, dynamic> selectedValues = {};
  bool _isInitialized = false;
  Patient? _patient;

  PatientUpdateCategoryViewmodel(
    this.patientViewModel,
    this.categoryKey,
    this.patientId,
    this.patientJson,
  ) {
    // Constructor'da initialize et
    setInitialValues();
  }

  CategoryCardData get categoryCardData =>
      CategoryCardData.getCategoryById(categoryKey);

  List<Map<String, dynamic>>? get dropdownConfigs {
    switch (categoryKey) {
      case 'pathology':
        return Pathology.getDropdownConfigs();
      case 'oncology':
        return Oncology.getDropdownConfigs();
      case 'demography':
        return Demography.getDropdownConfigs();
      case 'comorbidity':
        return Comorbidity.getDropdownConfigs();
      case 'biochemistry':
        return Biochemistry.getDropdownConfigs();
      case 'radiology':
        return Radiology.getDropdownConfigs();
      default:
        return null;
    }
  }

  void setInitialValues() {
    // Sadece bir kez çalışsın
    if (_isInitialized) return;

    Patient? patient;
    if (patientJson != null) {
      try {
        final Map<String, dynamic> patientMap = Patient.fromJsonString(
          patientJson!,
        );
        patient = Patient.fromMap(patientMap);
        _patient = patient; // Hasta bilgisini sakla
        LoggerUtil.d('Patient deserialized from JSON successfully');
      } catch (e) {
        LoggerUtil.e('Error deserializing patient JSON: $e');
      }
    }
    if (patient == null) {
      _isInitialized = true;
      return;
    }

    Map<String, dynamic>? raw;

    switch (categoryKey) {
      case 'pathology':
        raw = patient.pathology?.toMap();
        break;
      case 'oncology':
        raw = patient.oncology?.toMap();
        break;
      case 'demography':
        raw = patient.demography?.toMap();
        break;
      case 'comorbidity':
        raw = patient.comorbidity?.toMap();
        break;
      case 'biochemistry':
        raw = patient.biochemistry?.toMap();
        break;
      case 'radiology':
        raw = patient.radiology?.toMap();
        break;
      default:
        raw = {};
    }

    if (raw != null) {
      try {
        selectedValues = {};
        final configs = dropdownConfigs;

        if (configs != null) {
          raw.forEach((key, value) {
            if (value == null) {
              selectedValues[key] = null;
              return;
            }

            // Bu field için enum listesini bul
            final config = configs.firstWhere(
              (c) => c['key'] == key,
              orElse: () => <String, dynamic>{},
            );

            if (config.isNotEmpty && value is String) {
              final enumValues = config['values'] as List<Enum>;
              // String değeri Enum'a dönüştür
              try {
                final enumValue = enumValues.firstWhere((e) => e.name == value);
                selectedValues[key] = enumValue;
                LoggerUtil.d('Converted $key: $value -> ${enumValue.name}');
              } catch (e) {
                LoggerUtil.e('Could not find enum value for $key: $value');
                // İlk enum değerini varsayılan olarak kullan
                selectedValues[key] = enumValues.first;
              }
            } else {
              selectedValues[key] = value;
            }
          });
        } else {
          selectedValues = Map<String, dynamic>.from(raw);
        }

        LoggerUtil.d('Initial values set for $categoryKey: $selectedValues');
      } catch (e) {
        LoggerUtil.e('Error converting raw data to Map<String, dynamic>: $e');
      }
    } else {
      LoggerUtil.d('No initial values found for $categoryKey');
    }

    _isInitialized = true;
    notifyListeners();
  }

  void updateValue(String key, dynamic value) {
    selectedValues[key] = value;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    if (patientId == null) {
      LoggerUtil.e('Patient ID is null, cannot save category data');
      return;
    }

    try {
      loading.show(context);

      // Convert selectedValues to Map<String, String>
      Map<String, String> categoryData = {};
      selectedValues.forEach((key, value) {
        if (value is Enum) {
          categoryData[key] = value.name;
        } else {
          categoryData[key] = value.toString();
        }
      });

      // Check if this is an update or new entry
      bool isUpdate = _isUpdate();

      // Update only this category in Firestore
      final response = await patientViewModel.updatePatientCategory(
        patientId!,
        categoryKey,
        categoryData,
      );

      if (response.status) {
        loading.close();
        LoggerUtil.i(
          'Category $categoryKey updated successfully for patient $patientId',
        );

        // Send notification to owners after successful save
        await _sendNotificationToOwners(context, isUpdate);

        String? navigationFrom = NavigationService.instance
            .getPreviousRouteName();
        if (navigationFrom == '/patient-view-data') {
          NavigationService.instance.goBack();
          NavigationService.instance.goBack();
        } else {
          NavigationService.instance.goBack();
        }
        PopupService().showSuccess(context, "Başarılı", "Güncelleme başarılı");
      } else {
        loading.close();
        LoggerUtil.e('Failed to update category: ${response.message}');
        PopupService().showError(context, "HATA", response.message);
      }
    } catch (e) {
      loading.close();
      LoggerUtil.e('Error saving category data: $e');
      PopupService().showError(context, "HATA", e.toString());
    }
  }

  bool _isUpdate() {
    // Check if any values are already set (indicating this is an update)
    return selectedValues.values.any((value) => value != null);
  }

  Future<void> _sendNotificationToOwners(
    BuildContext context,
    bool isUpdate,
  ) async {
    try {
      final connectionDataSource = PatientConnectionRemoteDataSource();

      // Get all connections for this patient
      final connections = await connectionDataSource.getConnectionsByPatientId(
        patientId!,
      );

      // Filter connections with owner role
      final ownerConnections = connections
          .where((connection) => connection.role == ConnectionRole.owner)
          .toList();

      if (ownerConnections.isEmpty) {
        LoggerUtil.i('No owner connections found for patient $patientId');
        return;
      }

      // Get current user name
      final currentUserName = await _getCurrentUserName();
      final userInfo = currentUserName != null
          ? '$currentUserName tarafından'
          : '';

      // Get patient name for notification
      String patientName = 'Hasta';
      if (_patient?.firstName != null && _patient?.lastName != null) {
        patientName = '${_patient!.firstName} ${_patient!.lastName}';
      }

      // Get category display name
      final categoryName = categoryCardData.name;

      // Create notification message
      final message = isUpdate
          ? '$userInfo\n$patientName - $categoryName verileri güncellendi'
          : '$userInfo\n$patientName - $categoryName verilerinin girişi tamamlandı';

      // Send notification to each owner
      final notificationService = NotificationService();
      for (final connection in ownerConnections) {
        try {
          // Get FCM token for the owner user
          // Note: You might need to store FCM tokens in user documents
          // For now, we'll assume you have a way to get user FCM tokens
          final ownerToken = await _getUserFCMToken(connection.userId);
          if (ownerToken != null) {
            await notificationService.sendNotification(
              token: ownerToken,
              title: 'Hasta Güncellemesi',
              body: message,
            );
            LoggerUtil.i('Notification sent to owner ${connection.userId}');
          } else {
            LoggerUtil.w('No FCM token found for owner ${connection.userId}');
          }
        } catch (e) {
          LoggerUtil.e(
            'Error sending notification to owner ${connection.userId}: $e',
          );
        }
      }
    } catch (e) {
      LoggerUtil.e('Error sending notifications to owners: $e');
    }
  }

  Future<String?> _getCurrentUserName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return null;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final ad = data?['ad'] as String?;
        final soyad = data?['soyad'] as String?;
        if (ad != null && soyad != null) {
          return '$ad $soyad';
        }
      }
      return null;
    } catch (e) {
      LoggerUtil.e('Error getting current user name: $e');
      return null;
    }
  }

  Future<String?> _getUserFCMToken(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return userDoc.data()?['fcmToken'] as String?;
    } catch (e) {
      LoggerUtil.e('Error getting FCM token for user $userId: $e');
      return null;
    }
  }
}
