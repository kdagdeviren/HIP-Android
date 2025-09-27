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
    );
  }

  static Logger get logger => _instance._logger;

  static void d(dynamic message) => _instance._logger.d(message);
  static void i(dynamic message) => _instance._logger.i(message);
  static void w(dynamic message) => _instance._logger.w(message);
  static void e(dynamic message) => _instance._logger.e(message);
  static void v(dynamic message) => _instance._logger.v(message);
  static void wtf(dynamic message) => _instance._logger.wtf(message);
}
