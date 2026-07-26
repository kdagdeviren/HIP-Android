import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_all_list_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_connection_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/page_information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/patient_add_list.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/patient_list_view.dart';
import 'package:flutter_medical_data_app/core/services/deep_link_service.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientAllListPage extends StatefulWidget {
  const PatientAllListPage({super.key});

  @override
  State<PatientAllListPage> createState() => _PatientAllListPageState();
}

class _PatientAllListPageState extends State<PatientAllListPage> {
  late TextEditingController idController;
  bool _shouldAutoAdd = false;
  String? _autoAddPatientId;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();

    // Listen to deep link service for patient ID updates
    DeepLinkService().onPatientIdReceived = (patientId) async {
      if (mounted) {
        debugPrint('Callback received patient ID: $patientId');
        setState(() {
          idController.text = patientId;
          _shouldAutoAdd = true;
          _autoAddPatientId = patientId;
        });
      }
    };
  }

  @override
  void dispose() {
    idController.dispose();
    DeepLinkService().onPatientIdReceived = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Route arguments'i al
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final patientId = args?['patientId'] as String?;
    final autoAdd = args?['autoAdd'] as bool? ?? false;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientAllListViewModel()),
      ],
      child: Builder(
        builder: (builderContext) {
          final allListViewModel = builderContext
              .read<PatientAllListViewModel>();
          allListViewModel.initializePatientViewModel(
            builderContext.read<PatientViewModel>(),
          );
          allListViewModel.initializeConnectionViewModel(
            builderContext.read<PatientConnectionViewModel>(),
          );

          // Deep link'ten gelen hasta ID'sini handle et
          if (patientId != null && !_shouldAutoAdd) {
            debugPrint('Deep link patient ID detected: $patientId');
            idController.text = patientId;

            // Eğer autoAdd flag'i true ise otomatik olarak hasta ekle
            if (autoAdd) {
              _shouldAutoAdd = true;
              _autoAddPatientId = patientId;

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (mounted && _shouldAutoAdd) {
                  debugPrint(
                    'Auto-add flag is true, attempting to add patient...',
                  );
                  await Future.delayed(const Duration(milliseconds: 500));

                  if (mounted) {
                    debugPrint('Triggering automatic patient connection...');
                    _shouldAutoAdd = false; // Tekrar tetiklenmesini engelle
                    _handleAddPatient(builderContext);
                  }
                }
              });
            }
          }

          // Callback'ten gelen ID için otomatik ekleme
          if (_shouldAutoAdd && _autoAddPatientId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (mounted && _shouldAutoAdd) {
                debugPrint('Triggering automatic connection from callback...');
                await Future.delayed(const Duration(milliseconds: 500));

                if (mounted) {
                  _shouldAutoAdd = false; // Tekrar tetiklenmesini engelle
                  _handleAddPatient(builderContext);
                }
              }
            });
          }

          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            appBar: PatientAppBar(title: l10n.patient_add_appBarTitle),
            body: Padding(
              padding: mainPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 2.2.h),
                        Consumer<PatientAllListViewModel>(
                          builder: (context, viewModel, child) =>
                              PatientAddList(
                                idController: idController,
                                onAddPatient: () => _handleAddPatient(context),
                                isLoading: viewModel.isConnecting,
                              ),
                        ),
                        SizedBox(height: 2.h),
                        PageInformationBox(title: l10n.patient_allList_title),
                        SizedBox(height: 1.h),
                        Expanded(
                          child: Consumer<PatientAllListViewModel>(
                            builder: (context, viewModel, child) =>
                                PatientListView(
                                  addDataCallback: (patientId) => viewModel
                                      .addDataNavigation(patientId: patientId),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleAddPatient(BuildContext context) async {
    final patientId = idController.text.trim();

    // Validasyon kontrolleri
    if (patientId.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.patient_allList_idEmptyError),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    // Minimum uzunluk kontrolü
    if (patientId.length < 10) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.patient_allList_idInvalidError),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    final viewModel = context.read<PatientAllListViewModel>();

    try {
      final response = await viewModel.connectExistingPatient(
        context,
        patientId,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: response.status ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );

        if (response.status) {
          idController.clear();
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              )!.patient_allList_genericError(e.toString()),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
