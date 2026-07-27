import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/core/services/locale_provider.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      appBar: PatientAppBar(title: l10n.settings_appBarTitle),
      body: Padding(
        padding: mainPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Text(
              l10n.settings_languageSectionTitle,
              style: AppTextStyles.nunitoBold25.copyWith(
                fontSize: 16.sp,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 1.h),
            _LanguageOption(
              label: l10n.settings_language_turkish,
              selected: currentLocale.languageCode == 'tr',
              onTap: () =>
                  context.read<LocaleProvider>().setLocale(const Locale('tr')),
            ),
            SizedBox(height: 1.h),
            _LanguageOption(
              label: l10n.settings_language_english,
              selected: currentLocale.languageCode == 'en',
              onTap: () =>
                  context.read<LocaleProvider>().setLocale(const Locale('en')),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.success : AppColors.text,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.nunitoBold20.copyWith(
                  fontSize: 15.sp,
                  color: AppColors.text,
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: AppColors.success, size: 20.sp),
            ],
          ),
        ),
      ),
    );
  }
}
