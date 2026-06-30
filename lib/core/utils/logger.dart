import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static void info(String message, {String? tag}) {
    if (kDebugMode) dev.log(message, name: tag ?? 'INFO');
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) dev.log(message, name: tag ?? 'WARNING');
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (kDebugMode) {
      dev.log(
        message,
        name: tag ?? 'ERROR',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
