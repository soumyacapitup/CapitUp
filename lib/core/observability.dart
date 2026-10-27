import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'config/env.dart';

/// Crash reporting without a native SDK.
///
/// Uncaught Dart errors (framework and async) are sent to the backend's `/client-errors`, which forwards them
/// to error tracking. A native crash SDK was tried and removed: it pulled in a JNI/CMake plugin that needed
/// Android 8+ and the Android 35 platform and broke the Gradle build. Native crashes and ANRs are reported by
/// Google Play's Android vitals instead.
///
/// Privacy: only the error type, a short message with numbers and emails masked, and the stack trace are sent.
/// No user, no request data, no screen content.
class CrashReporter {
  CrashReporter({Dio? dio, this.maxPerSession = 10})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 5),
              sendTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
            ),
          );

  final Dio _dio;
  final int maxPerSession;
  final _seen = <String>{};
  int _sent = 0;

  static final _digits = RegExp(r'\d[\d\s/\-]{4,}\d');
  static final _email = RegExp(r'[\w.+-]+@[\w-]+\.[\w.]+');

  static String scrub(String text) => text.replaceAll(_digits, '[number]').replaceAll(_email, '[email]');

  /// The report body, or null when this error was already sent or the session budget is used up.
  Map<String, Object?>? buildReport(Object error, StackTrace? stack, {required bool fatal}) {
    final stackText = (stack ?? StackTrace.empty).toString();
    final firstFrame = stackText.split('\n').firstWhere((l) => l.trim().isNotEmpty, orElse: () => '');
    final key = '${error.runtimeType}|$firstFrame';
    if (_sent >= maxPerSession || !_seen.add(key)) return null;
    _sent++;
    final message = scrub(error.toString());
    return {
      'error_type': error.runtimeType.toString(),
      'message': message.length > 300 ? message.substring(0, 300) : message,
      'stack': stackText.length > 8000 ? stackText.substring(0, 8000) : stackText,
      'app_version': Env.appVersion,
      'platform': defaultTargetPlatform.name,
      'fatal': fatal,
    };
  }

  Future<void> report(Object error, StackTrace? stack, {bool fatal = false}) async {
    final body = buildReport(error, stack, fatal: fatal);
    if (body == null) return;
    try {
      await _dio.post<void>('${Env.apiBaseUrl}/client-errors', data: body); // read now: discovery may change it
    } catch (_) {
      // Reporting must never crash the app or loop on its own failure.
    }
  }

  /// Installs the global handlers. In debug builds errors are only printed, never sent.
  void install() {
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      previous?.call(details);
      if (!kDebugMode) unawaited(report(details.exception, details.stack, fatal: false));
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      if (!kDebugMode) unawaited(report(error, stack, fatal: true));
      return false; // keep the default handling (logging)
    };
  }
}
