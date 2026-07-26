import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/auth/data/models/user_model.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const UserCard({
    super.key,
    required this.user,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.text, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.admin_userCard_infoTitle('${user.ad} ${user.soyad}'),
                  textAlign: TextAlign.start,
                  style: AppTextStyles.nunitoBold25.copyWith(
                    height: 1,
                    color: AppColors.text,
                    fontSize: 19.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  l10n.admin_userCard_idLabel(user.docID),
                  textAlign: TextAlign.start,
                  style: AppTextStyles.nunitoBold25.copyWith(
                    height: 1,
                    color: AppColors.text,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: SecondButton(
                        buttonText: l10n.admin_userCard_reject,
                        buttonColor: AppColors.error,
                        onPressed: onReject,
                        height: 4.h,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: SecondButton(
                        buttonText: l10n.admin_userCard_approve,
                        buttonColor: AppColors.success,
                        onPressed: onApprove,
                        height: 4.h,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Stack(
                    children: [
                      // Yarı şeffaf arka plan
                      Container(color: Colors.black.withValues(alpha: 0.7)),
                      Center(
                        child: SizedBox(
                          height: 90.h,
                          width: 90.w,
                          child: InteractiveViewer(
                            child: Image(
                              image: MemoryImage(
                                base64Decode(user.uploadedImage),
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 1.h,
                        right: 1.h,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),

                      // Resim
                    ],
                  );
                },
              );
            },
            child: SizedBox(
              height: 15.h,
              width: 15.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: MemoryImage(base64Decode(user.uploadedImage)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
