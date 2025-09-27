import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                title,
                style: AppTextStyles.nunitoMedium20.copyWith(fontSize: 18.sp),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/images/icons/settings_profile.png",
                height: 3.h,
                width: 3.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
