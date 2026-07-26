import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/pages/waiting_verify_page.dart';
import 'package:flutter_medical_data_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter_medical_data_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_medical_data_app/features/auth/data/auth_service.dart';
import 'package:flutter_medical_data_app/features/auth/data/models/user_model.dart';
import 'package:flutter_medical_data_app/features/admin/presentation/pages/admin_home_page.dart';

//AuthModelden alınacak

class AuthGuard extends StatefulWidget {
  const AuthGuard({super.key});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  final AuthService _authService = AuthService();

  UserModel? _userModel;
  bool _isLoadingUserData = false;
  bool _isAdmin = false;
  String? _errorMessage;

  /// The uid whose profile load has finished, successfully or not.
  ///
  /// Without this the build method reschedules the load on every rebuild as
  /// long as [_userModel] is null, so a failed or missing profile turns into an
  /// endless retry loop behind a spinner.
  String? _loadedUid;

  Future<void> _loadUserData(User user, {bool forceTokenRefresh = false}) async {
    if (_isLoadingUserData) return;

    setState(() {
      _isLoadingUserData = true;
      _errorMessage = null;
    });

    try {
      // The admin flag comes from the auth token, so it cannot be forged by the
      // client. A freshly granted claim only appears after the token refreshes,
      // which is what the retry path forces.
      final token = await user.getIdTokenResult(forceTokenRefresh);
      final isAdmin = token.claims?['admin'] == true;

      // Admins manage accounts and are not required to have a profile document.
      final profile = isAdmin ? null : await _authService.getUser(user.uid);

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _isAdmin = isAdmin;
        _userModel = profile;
        _loadedUid = user.uid;
        _isLoadingUserData = false;
        _errorMessage = (!isAdmin && profile == null)
            ? l10n.auth_guard_profileNotFound
            : null;
      });
    } catch (e) {
      LoggerUtil.e('AuthGuard could not load user ${user.uid}: $e');
      if (!mounted) return;
      setState(() {
        _isAdmin = false;
        _userModel = null;
        _loadedUid = user.uid;
        _isLoadingUserData = false;
        _errorMessage = ErrorHandler.handleError(e, 'Load User');
      });
    }
  }

  void _retry() {
    setState(() {
      _loadedUid = null;
      _errorMessage = null;
      _forceTokenRefresh = true;
    });
  }

  /// Set by [_retry] so a just-granted admin claim is picked up without waiting
  /// for the token's own refresh cycle.
  bool _forceTokenRefresh = false;

  Future<void> _signOut() async {
    await _authService.logout();
    if (!mounted) return;
    setState(() {
      _userModel = null;
      _isAdmin = false;
      _loadedUid = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _AuthGuardLoading();
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginPage();
        }

        if (_isLoadingUserData) {
          return const _AuthGuardLoading();
        }

        // Kullanıcı verisi bu uid için henüz yüklenmemişse yükle (build sonrası)
        if (_loadedUid != user.uid) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final force = _forceTokenRefresh;
            _forceTokenRefresh = false;
            _loadUserData(user, forceTokenRefresh: force);
          });
          return const _AuthGuardLoading();
        }

        // Admin kontrolü - yetki token'daki custom claim'den gelir
        if (_isAdmin) {
          return const AdminHomePage();
        }

        if (_errorMessage != null || _userModel == null) {
          return _AuthGuardError(
            message:
                _errorMessage ??
                AppLocalizations.of(context)!.auth_guard_userDataUnreadable,
            onRetry: _retry,
            onSignOut: _signOut,
          );
        }

        // Kullanıcı verisi yüklendi, doğrulama durumuna göre yönlendir
        if (_userModel!.isVerified) {
          return const MainPage();
        }
        return const WaitingVeirfyPage();
      },
    );
  }
}

/// Wrapped in a [Scaffold] so it renders on the theme background instead of the
/// bare black canvas an unparented widget gets.
class _AuthGuardLoading extends StatelessWidget {
  const _AuthGuardLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _AuthGuardError extends StatelessWidget {
  const _AuthGuardError({
    required this.message,
    required this.onRetry,
    required this.onSignOut,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: onRetry, child: Text(l10n.common_retry)),
              TextButton(
                onPressed: onSignOut,
                child: Text(l10n.auth_guard_signOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
