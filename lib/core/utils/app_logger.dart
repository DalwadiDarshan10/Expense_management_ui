import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// Log error
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log info
  static void info(String message) {
    _logger.i(message);
  }

  /// Log debug
  static void debug(String message) {
    _logger.d(message);
  }

  /// Log warning
  static void warning(String message) {
    _logger.w(message);
  }
}
