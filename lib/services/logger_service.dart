// lib/src/services/logger_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Provider for LoggerService.
final loggerServiceProvider = Provider<LoggerService>((ref) {
  return LoggerService();
});


/// Service for handling logging operations.
class LoggerService {
  final Logger _logger;

  /// Initializes the LoggerService with a predefined Logger configuration.
  LoggerService({Level level = Level.debug})
      : _logger = Logger(
          level: level,
          printer: PrettyPrinter(
            methodCount: 0, // No method calls
            // printTime: true,
            dateTimeFormat: (time) => DateTimeFormat.onlyTimeAndSinceStart(time),

          ),
        );

  /// Logs an informational [message].
  void logInfo(String message) {
    _logger.i(message);
  }

  /// Logs a warning [message].
  void logWarning(String message) {
    _logger.w(message);
  }

  /// Logs an error [message] with optional [exception] and [stackTrace].
  void logError(String message, [Exception? exception, StackTrace? stackTrace]) {
    _logger.e(message, error: exception, stackTrace: stackTrace);
  }

  /// Logs a debug [message].
  void logDebug(String message) {
    _logger.d(message);
  }

  /// Logs a verbose [message] for detailed debugging.
  void logVerbose(String message) {
    _logger.v(message);
  }
}
