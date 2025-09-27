import 'package:flutter/material.dart';
import 'package:smart_popup/smart_popup.dart';

class PopupService extends ChangeNotifier {
  // Normal popup (X ile kapatma)
  void showNormal(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => SmartPopup(
        title: title,
        subTitle: message,
        primaryButtonText: "Tamam",
        showCloseButton: true,
      ),
    );
  }

  // Success popup
  void showSuccess(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => SmartPopup(
        title: title,
        subTitle: message,
        primaryButtonText: "Tamam",
        popType: PopType.success,
      ),
    );
  }

  // Error popup
  void showError(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => SmartPopup(
        title: title,
        subTitle: message,
        primaryButtonText: "Tamam",
        popType: PopType.error,
      ),
    );
  }

  // Confirmation popup
  void showConfirmation(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => SmartPopup(
        title: title,
        subTitle: message,
        primaryButtonText: "Evet",
        secondaryButtonText: "Hayır",
        popType: PopType.warning,
        primaryButtonTap: () {
          Navigator.pop(context);
          if (onConfirm != null) onConfirm();
        },
        secondaryButtonTap: () => Navigator.pop(context),
      ),
    );
  }
}
