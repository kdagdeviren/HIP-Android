import 'package:flutter/material.dart';
import 'circular_error_icon.dart';
import 'circular_success_icon.dart';

enum CircularIconEnum { error, success }

extension CircularIconEnumExtension on CircularIconEnum {
  Widget get widget {
    switch (this) {
      case CircularIconEnum.error:
        return const CircularErrorIcon();
      case CircularIconEnum.success:
        return const CircularSuccessIcon();
    }
  }
}
