import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';

/// Handles FCM registration and inbound message routing.
///
/// Outbound delivery is intentionally not implemented on the client: sending an
/// FCM v1 message requires service account credentials, and anything shipped in
/// the app bundle is readable by anyone who unpacks it. Delivery belongs on the
/// server side.
///
/// TODO: Move outbound delivery to a Cloud Function. See
/// docs/plans/2026-07-26-guvenlik-ve-yayin-hazirligi.md, "Kapsam Dışı".
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    LoggerUtil.d('User granted permission: ${settings.authorizationStatus}');

    // Warm up the token so the registration flow can persist it
    await _firebaseMessaging.getToken();

    // Set up handlers
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _onMessage(RemoteMessage message) {
    LoggerUtil.d('Got a message whilst in the foreground!');
    LoggerUtil.d('Message data: ${message.data}');

    if (message.notification != null) {
      LoggerUtil.d(
        'Message also contained a notification: ${message.notification}',
      );
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    LoggerUtil.d('A new onMessageOpenedApp event was published!');
    LoggerUtil.d('Message data: ${message.data}');
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    LoggerUtil.d('Handling a background message: ${message.messageId}');
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// No-op until outbound delivery moves to a Cloud Function.
  ///
  /// Kept as a stable seam so call sites do not need to change when the server
  /// side lands: only the body below is replaced with a callable invocation.
  Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    LoggerUtil.d(
      'sendNotification skipped - no server-side delivery configured '
      '(title: $title)',
    );
  }
}
