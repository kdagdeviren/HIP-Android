import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:smart_popup/smart_popup.dart';

class PopupService {
  // Normal popup (X ile kapatma)
  void showNormal(BuildContext context, String title, String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => SmartPopup(
        title: title,
        subTitle: message,
        primaryButtonText: l10n.common_ok,
        showCloseButton: true,
        lottiePath: '',
      ),
    );
  }

  // Success popup
  void showSuccess(BuildContext context, String title, String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => SmartPopup(
        title: title,
        subTitle: message,
        primaryButtonText: l10n.common_ok,
        popType: PopType.success,
        lottiePath: '',
      ),
    );
  }

  // Error popup
  void showError(BuildContext context, String title, String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => SmartPopup(
        title: title,
        subTitle: message,
        primaryButtonText: l10n.common_ok,
        popType: PopType.error,
        lottiePath: '',
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => SmartPopup(
        title: title,
        subTitle: message,
        primaryButtonText: l10n.common_yes,
        secondaryButtonText: l10n.common_no,
        popType: PopType.warning,
        lottiePath: '',
        primaryButtonTap: () {
          Navigator.pop(context);
          if (onConfirm != null) onConfirm();
        },
        secondaryButtonTap: () => Navigator.pop(context),
      ),
    );
  }
}
