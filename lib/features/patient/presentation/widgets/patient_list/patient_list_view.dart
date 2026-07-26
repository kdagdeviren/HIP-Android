import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_all_list_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/page_list_tile/patient_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientListView extends StatelessWidget {
  const PatientListView({super.key, required this.addDataCallback});

  final Function(String?) addDataCallback;

  @override
  Widget build(BuildContext context) {
    final listViewModel = Provider.of<PatientAllListViewModel>(
      context,
      listen: false,
    );
    return Consumer<PatientViewModel>(
      builder: (context, patientViewModel, _) {
        // Initialize the PatientViewModel in PatientAllListViewModel
        listViewModel.initializePatientViewModel(patientViewModel);

        final patients = patientViewModel.patients;
        final hasMore = patientViewModel.hasMore;
        final errorMessage = patientViewModel.errorMessage;

        if (patients.isEmpty && errorMessage != null) {
          return _EmptyState(
            message: errorMessage,
            onRetry: patientViewModel.refresh,
          );
        }

        if (patients.isEmpty && !hasMore && !patientViewModel.isLoading) {
          return const _EmptyState(message: 'Kayıtlı hasta bulunamadı.');
        }

        return ListView.builder(
          controller: listViewModel.scrollController,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            if (index == patients.length) {
              // Loading indicator
              return hasMore
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }

            final patient = patients[index];
            return Column(
              children: [
                if (index == 0) SizedBox(height: 2.h),
                PatientListTile(
                  patient: patient,
                  addDataCallback: addDataCallback,
                ),
              ],
            );
          },
          itemCount: patients.length + (hasMore ? 1 : 0),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, this.onRetry});

  final String message;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 2.h),
              TextButton(onPressed: onRetry, child: const Text('Tekrar dene')),
            ],
          ],
        ),
      ),
    );
  }
}
