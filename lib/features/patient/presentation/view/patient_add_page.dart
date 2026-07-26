import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_add_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_connection_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/page_information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/text_field_list_tile.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientAddPage extends StatefulWidget {
  const PatientAddPage({super.key});

  @override
  State<PatientAddPage> createState() => _PatientAddPageState();
}

class _PatientAddPageState extends State<PatientAddPage> {
  late final TextEditingController nameController;
  late final TextEditingController surnameController;
  late final TextEditingController protocolNumber;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    protocolNumber = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    protocolNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ChangeNotifierProvider(
      create: (_) => PatientAddViewmodel(
        context.read<PatientViewModel>(),
        context.read<PatientConnectionViewModel>(),
      ),
      child: Scaffold(
        appBar: PatientAppBar(title: l10n.patient_add_appBarTitle),
        body: Padding(
          padding: mainPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              PageInformationBox(title: l10n.patient_add_pageTitle),
              SizedBox(height: 0.5.h),
              Text(
                l10n.patient_add_shareHint,
                textAlign: TextAlign.center,
                style: AppTextStyles.nunitoLight15.copyWith(
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 2.h),
              Consumer<PatientAddViewmodel>(
                builder: (context, viewModel, _) {
                  return Column(
                    children: [
                      InformationBox(
                        title: l10n.patient_add_sectionTitle,
                        showCopy: false,
                        textFieldListTiles: [
                          TextFieldListTile(
                            title: l10n.patient_add_nameLabel,
                            controller: nameController,
                          ),
                          TextFieldListTile(
                            title: l10n.patient_add_surnameLabel,
                            controller: surnameController,
                          ),
                          TextFieldListTile(
                            title: l10n.patient_add_protocolLabel,
                            controller: protocolNumber,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      SecondButton(
                        buttonText: l10n.patient_add_submitButton,
                        onPressed: () async {
                          await viewModel.handleAddPatient(
                            context,
                            name: nameController.text.trim(),
                            surname: surnameController.text.trim(),
                            protocolNo: protocolNumber.text.trim(),
                          );
                        },
                        height: 5.5.h,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
