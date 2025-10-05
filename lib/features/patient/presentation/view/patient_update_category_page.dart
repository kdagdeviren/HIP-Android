import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/core/utils/enum_display_util.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_all_list_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_update_category_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientUpdateCategoryPage extends StatelessWidget {
  final String? patientId;
  final String categoryKey;
  final String? patientJson;

  const PatientUpdateCategoryPage({
    super.key,
    this.patientId,
    required this.categoryKey,
    this.patientJson,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientAllListViewModel()),
        ChangeNotifierProvider(
          create: (_) => PatientUpdateCategoryViewmodel(
            context.read<PatientViewModel>(),
            categoryKey,
            patientId,
            patientJson,
          ),
        ),
      ],
      child: Consumer<PatientUpdateCategoryViewmodel>(
        builder: (context, viewModel, child) {
          // setInitialValues artık burada çağrılmıyor!
          return Scaffold(
            appBar: PatientAppBar(title: viewModel.categoryCardData.name),
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding: mainPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                          child: Column(children: _buildDropdowns(viewModel)),
                        ),
                      ),
                    ),
                    SecondButton(
                      height: 5.h,
                      buttonText: "KAYDI TAMAMLA",
                      onPressed: () {
                        viewModel.save(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildDropdowns(PatientUpdateCategoryViewmodel viewModel) {
    final configs = viewModel.dropdownConfigs;
    if (configs != null) {
      return configs.map((config) {
        return Column(
          children: [
            _buildDropdown(
              config['key'] as String,
              config['label'] as String,
              config['values'] as List<Enum>,
              viewModel,
            ),
            SizedBox(height: 2.h),
          ],
        );
      }).toList();
    }
    return [const Text('Bu kategori için dropdown henüz tanımlanmadı.')];
  }

  Widget _buildDropdown(
    String key,
    String label,
    List<Enum> values,
    PatientUpdateCategoryViewmodel viewModel,
  ) {
    // Güvenli cast: eğer Enum değilse null döndür
    Enum? initialValue;
    final storedValue = viewModel.selectedValues[key];
    if (storedValue is Enum) {
      initialValue = storedValue;
    } else if (storedValue is String) {
      // String ise Enum'a dönüştürmeyi dene
      try {
        initialValue = values.firstWhere(
          (e) => e.name == storedValue,
          orElse: () => values.first,
        );
      } catch (e) {
        initialValue = null;
      }
    }

    return DropdownButtonFormField<Enum>(
      value: initialValue,
      hint: const Text('Seçin'),
      style: AppTextStyles.nunitoBold20.copyWith(fontSize: 17.sp),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.nunitoBold20.copyWith(fontSize: 17.sp),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.text, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.text, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.text, width: 1.5),
        ),
      ),
      dropdownColor: Colors.white,
      items: values.map((e) {
        return DropdownMenuItem<Enum>(
          value: e,
          child: Text(
            EnumDisplayUtil.getDisplayText(e),
            style: AppTextStyles.nunitoBold20.copyWith(
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: (value) => viewModel.updateValue(key, value),
    );
  }
}
