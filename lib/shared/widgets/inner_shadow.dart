import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GlassBox extends StatelessWidget {
  const GlassBox({
    super.key,
    this.blur = 10,
    this.innerShadowColor = Colors.white,
    this.outerShadowColor = const Color.fromARGB(255, 13, 71, 161),
    this.offset = const Offset(0, 4),
    this.borderRadius = 8.0,
    this.child,
  });

  final double blur;
  final Color innerShadowColor;
  final Color outerShadowColor;
  final Offset offset;
  final double borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.02, 0.1, 1.0],
          colors: [
            innerShadowColor.withAlpha(70),
            innerShadowColor.withAlpha(10),
            Colors.transparent,
            Colors.transparent,
          ],
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              blurStyle: BlurStyle.outer,
              color: outerShadowColor.withOpacity(0.28),
              blurRadius: blur,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.all(1.h),
        child: child,
      ),
    );
  }
}
