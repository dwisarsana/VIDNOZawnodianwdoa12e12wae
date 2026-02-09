import 'package:flutter/foundation.dart';

class AppLogger {
  static void i(String message) {
    if (kDebugMode) {
      print('ℹ️ [INFO] $message');
    }
  }

  static void w(String message) {
    if (kDebugMode) {
      print('⚠️ [WARN] $message');
    }
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('❌ [ERROR] $message');
      if (error != null) print(error);
      if (stackTrace != null) print(stackTrace);
    }
  }

  static void d(String message) {
    if (kDebugMode) {
      print('🐛 [DEBUG] $message');
    }
  }
}
