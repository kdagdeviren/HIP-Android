import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_data_app/core/constants/box_decorations.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/fixed_list_tile.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/text_field_list_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

class InformationBox extends StatelessWidget {
  const InformationBox({
    super.key,
    this.title,
    this.showPaste = false,
    this.divider,
    this.copyText,
    required this.showCopy,
    this.padding,
    this.innerPadding,
    this.fixedListTiles,
    this.textFieldListTiles,
    this.buttonWidget,
    this.customWidget,
  });

  final String? title;
  final bool showCopy;
  final bool showPaste;
  final bool? divider;
  final String? copyText;
  final EdgeInsets? padding;
  final EdgeInsets? innerPadding;
  final List<FixedListTile>? fixedListTiles;
  final List<TextFieldListTile>? textFieldListTiles;
  final Widget? buttonWidget;
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (customWidget != null)
          customWidget!
        else
          Container(
            width: double.infinity,
            padding:
                padding ??
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: borderDecoration,
            child: Column(
              children: [
                if (fixedListTiles != null)
                  Column(
                    children: fixedListTiles!.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final e = entry.value;
                      final isLast = idx == fixedListTiles!.length - 1;
                      if (fixedListTiles!.length == 1 || isLast) {}
                      if (divider == true && !isLast) {
                        return Column(
                          children: [
                            e,
                            Divider(color: AppColors.text),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: innerPadding ?? EdgeInsets.only(bottom: 2.h),
                          child: e,
                        );
                      }
                    }).toList(),
                  ),
                if (textFieldListTiles != null)
                  Column(
                    children: textFieldListTiles!.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final e = entry.value;
                      final isLast = idx == textFieldListTiles!.length - 1;
                      if (textFieldListTiles!.length == 1 || isLast) {
                        return e;
                      }

                      return Padding(
                        padding: innerPadding ?? EdgeInsets.only(bottom: 2.h),
                        child: e,
                      );
                    }).toList(),
                  ),
                if (buttonWidget != null) SizedBox(height: 1.5.h),
                buttonWidget ?? SizedBox.shrink(),
              ],
            ),
          ),
        Positioned(
          top: title != null ? -1.8.h : -1.8.h,
          left: 0,
          right: 0,
          child: Container(
            height: 3.6.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title != null
                    ? Container(
                        height: 3.6.h,
                        color: AppColors.background,
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: FittedBox(
                          child: Text(
                            title!,
                            style: AppTextStyles.nunitoBold25.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                if (showCopy)
                  SizedBox(
                    height: 3.6.h,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          color: AppColors.background,
                          height: 3.6.h,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(3),
                              onTap: () {
                                if (copyText != null) {
                                  Clipboard.setData(
                                    ClipboardData(text: copyText.toString()),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Kopyalandı")),
                                  );
                                }
                              },
                              child: Icon(
                                !showPaste ? Icons.copy : Icons.paste,
                                size: 4.h,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                        ),
                        if (!showPaste) SizedBox(width: 3.w),
                        !showPaste
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                                color: AppColors.background,
                                height: 3.6.h,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(3),
                                    onTap: () {
                                      final patientId = copyText;
                                      final patientLink =
                                          'https://medical-app-2c545.web.app/addPatient?id=$patientId';
                                      final message =
                                          'Hasta ID: $patientId\n\n'
                                          'Yeni hasta bilgilerini eklemek için aşağıdaki linki kullanabilirsiniz:\n'
                                          '$patientLink\n\n'
                                          'Lütfen bilgilerin doğruluğunu kontrol edin ve linki güvenli bir şekilde paylaşın.';
                                      SharePlus.instance.share(
                                        ShareParams(text: message),
                                      );
                                    },
                                    child: Icon(
                                      Icons.share,
                                      size: 4.h,
                                      color: AppColors.text,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
