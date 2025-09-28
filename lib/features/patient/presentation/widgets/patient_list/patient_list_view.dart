import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patitent_all_list_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/page_list_tile/patient_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientListView extends StatelessWidget {
  const PatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PatientViewModel, PatientAllListViewModel>(
      builder: (context, patientViewModel, listViewModel, _) {
        final patients = patientViewModel.patients;
        final hasMore = patientViewModel.hasMore;
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
                PatientListTile(patient: patient),
              ],
            );
          },
          itemCount: patients.length + (hasMore ? 1 : 0),
        );
      },
    );
  }
}
