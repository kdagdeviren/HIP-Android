import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LogoWithRoundBg extends StatelessWidget {
  const LogoWithRoundBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.h,
      height: 8.h,
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Image.asset("assets/images/logo/logo_fg.png"),
    );
  }
}
