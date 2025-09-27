import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/box_decorations.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/fixed_list_tile.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/text_field_list_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InformationBox extends StatelessWidget {
  const InformationBox({
    super.key,
    required this.title,
    required this.buttons,
    this.fixedListTiles,
    this.textFieldListTiles,
    this.buttonWidget,
  });

  final String title;
  final bool buttons;
  final List<FixedListTile>? fixedListTiles;
  final List<TextFieldListTile>? textFieldListTiles;
  final Widget? buttonWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
          decoration: borderDecoration,
          child: Column(
            children: [
              SizedBox(height: 1.h),
              fixedListTiles != null
                  ? Column(
                      children: fixedListTiles!
                          .map(
                            (e) => Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: e,
                            ),
                          )
                          .toList(),
                    )
                  : SizedBox.shrink(),
              textFieldListTiles != null
                  ? Column(
                      children: textFieldListTiles!
                          .map(
                            (e) => Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: e,
                            ),
                          )
                          .toList(),
                    )
                  : SizedBox.shrink(),
              if (buttonWidget != null) SizedBox(height: 1.5.h),
              buttonWidget ?? SizedBox.shrink(),
            ],
          ),
        ),
        Positioned(
          top: -1.8.h,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 3.6.h,
                  color: AppColors.background,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: FittedBox(
                    child: Text(
                      title,
                      style: AppTextStyles.nunitoBold25.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                if (buttons)
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
                              onTap: () {},
                              child: Icon(
                                Icons.copy,
                                size: 2.5.h,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          color: AppColors.background,
                          height: 3.6.h,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(3),
                              onTap: () {},
                              child: Icon(
                                Icons.share,
                                size: 2.5.h,
                                color: AppColors.text,
                              ),
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
      ],
    );
  }
}
