import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/l10n/l10n.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/features/admin/domain/usecases/get_unverified_users_usecase.dart';
import 'package:flutter_medical_data_app/features/admin/domain/usecases/verify_user_usecase.dart';
import 'package:flutter_medical_data_app/features/admin/domain/usecases/reject_user_usecase.dart';
import 'package:flutter_medical_data_app/features/auth/data/models/user_model.dart';
import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/core/services/notification_service.dart';

class AdminViewModel extends ChangeNotifier {
  final GetUnverifiedUsersUsecase _getUnverifiedUsersUsecase;
  final VerifyUserUsecase _verifyUserUsecase;
  final RejectUserUsecase _rejectUserUsecase;
  final NotificationService _notificationService = NotificationService();

  AdminViewModel(
    this._getUnverifiedUsersUsecase,
    this._verifyUserUsecase,
    this._rejectUserUsecase,
  );

  List<UserModel> _unverifiedUsers = [];
  bool _isLoading = false;

  List<UserModel> get unverifiedUsers => _unverifiedUsers;
  bool get isLoading => _isLoading;

  Future<void> loadUnverifiedUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _unverifiedUsers = await _getUnverifiedUsersUsecase();
    } catch (e) {
      // Handle error
      debugPrint('Error loading unverified users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyUser(BuildContext context, String userId) async {
    try {
      await _verifyUserUsecase(userId);
      // Find user and send notification
      final user = _unverifiedUsers.firstWhere((u) => u.docID == userId);
      await _notificationService.sendNotification(
        token: user.fcmToken,
        title: L10n.current.admin_approvedNotifTitle,
        body: L10n.current.admin_approvedNotifBody,
      );
      // Remove from list
      _unverifiedUsers.removeWhere((u) => u.docID == userId);
      notifyListeners();
      final l10n = AppLocalizations.of(context)!;
      PopupService().showSuccess(
        context,
        l10n.common_success,
        l10n.admin_userApproved,
      );
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      PopupService().showError(
        context,
        l10n.common_error,
        l10n.admin_userApproveFailed,
      );
    }
  }

  Future<void> rejectUser(BuildContext context, String userId) async {
    try {
      await _rejectUserUsecase(userId);
      // Find user and send notification
      final user = _unverifiedUsers.firstWhere((u) => u.docID == userId);
      await _notificationService.sendNotification(
        token: user.fcmToken,
        title: L10n.current.admin_rejectedNotifTitle,
        body: L10n.current.admin_rejectedNotifBody,
      );
      // Remove from list
      _unverifiedUsers.removeWhere((u) => u.docID == userId);
      notifyListeners();
      final l10n = AppLocalizations.of(context)!;
      PopupService().showSuccess(
        context,
        l10n.common_success,
        l10n.admin_userRejected,
      );
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      PopupService().showError(
        context,
        l10n.common_error,
        l10n.admin_userRejectFailed,
      );
    }
  }
}
