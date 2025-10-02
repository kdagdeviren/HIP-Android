import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_all_list_viewmodel.dart';
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

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();

    // Check if there's a patient ID from route arguments (from deep link)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final patientId = args?['patientId'] as String?;

      if (patientId != null) {
        idController.text = patientId;
      }
    });

    // Listen to deep link service for patient ID updates
    DeepLinkService().onPatientIdReceived = (patientId) {
      if (mounted) {
        setState(() {
          idController.text = patientId;
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientAllListViewModel()),
      ],
      child: Scaffold(
        appBar: PatientAppBar(title: "Hasta Kaydı"),
        body: Padding(
          padding: mainPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 4.h),
                    PatientAddList(idController: idController),
                    SizedBox(height: 3.h),
                    Expanded(
                      child: Consumer<PatientAllListViewModel>(
                        builder: (context, viewModel, child) => PatientListView(
                          addDataCallback: (patientId) =>
                              viewModel.addDataNavigation(patientId: patientId),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
