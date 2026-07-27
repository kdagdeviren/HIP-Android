import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerUtil {
  static final LoggerUtil _instance = LoggerUtil._internal();
  late final Logger _logger;

  factory LoggerUtil() {
    return _instance;
  }

  LoggerUtil._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
      ),
      // Release derlemede loglar tamamen kapalı: hasta adı, protokol no,
      // doküman ID'si gibi kişisel veri release APK'da adb logcat ile
      // okunabilir olmasın diye.
      level: kReleaseMode ? Level.off : Level.trace,
    );
  }

  static Logger get logger => _instance._logger;

  static void d(dynamic message) => _instance._logger.d(message);
  static void i(dynamic message) => _instance._logger.i(message);
  static void w(dynamic message) => _instance._logger.w(message);
  static void e(dynamic message) => _instance._logger.e(message);
  static void t(dynamic message) => _instance._logger.t(message);
  static void f(dynamic message) => _instance._logger.f(message);
}
