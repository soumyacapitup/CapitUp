import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Build-time configuration via `--dart-define`. The app holds NO secrets:
/// only the public API base URL, environment name and public Firebase client identifiers.
class Env {
  static const String name = String.fromEnvironment('ENV', defaultValue: 'development');
  static const String _apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static bool get isProduction => name == 'production';

  /// Set by [discoverDevBackend] when no API_BASE_URL was given.
  static String? _discovered;

  /// Defaults point at a backend on the developer machine
  /// (Android emulator reaches the host via 10.0.2.2).
  static String get apiBaseUrl {
    if (_apiBaseUrl.isNotEmpty) return _apiBaseUrl;
    if (_discovered != null) return _discovered!;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:8000/api/v1';
    return 'http://localhost:8000/api/v1';
  }

  /// Backend addresses a development build tries, in order. 127.0.0.1 works on a real phone or an emulator
  /// once `adb reverse tcp:8000 tcp:8000` is active; 10.0.2.2 is the emulator's address for the PC. Extra
  /// addresses (e.g. the PC's Wi-Fi IP) can be added with `--dart-define=DEV_BACKENDS=http://192.168.1.20:8000`.
  static List<String> get devCandidates => [
    for (final host in const String.fromEnvironment('DEV_BACKENDS').split(','))
      if (host.trim().isNotEmpty) '${host.trim()}/api/v1',
    'http://127.0.0.1:8000/api/v1',
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) 'http://10.0.2.2:8000/api/v1',
    'http://localhost:8000/api/v1',
  ];

  /// Development builds only, and only when API_BASE_URL was not given: checks each candidate's /health at the
  /// same time and uses the first that answers, so a plain `flutter run` works on a phone and on an emulator.
  /// Production builds never probe; they use API_BASE_URL (enforced by [releaseProblems]).
  static Future<void> discoverDevBackend({Dio? dio}) async {
    if (_apiBaseUrl.isNotEmpty || isProduction) return;
    final client =
        dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 2), receiveTimeout: const Duration(seconds: 2)));
    final candidates = devCandidates;
    final results = await Future.wait(
      candidates.map((base) async {
        try {
          final r = await client.get<Object>('${Uri.parse(base).origin}/health');
          return r.statusCode == 200;
        } catch (_) {
          return false;
        }
      }),
    );
    final index = results.indexOf(true);
    _discovered = index >= 0 ? candidates[index] : null;
    debugPrint(
      index >= 0
          ? 'CapitUp: backend found at ${candidates[index]}'
          : 'CapitUp: no backend answered at ${candidates.join(', ')}. Is uvicorn running, and did you run adb reverse?',
    );
  }

  @visibleForTesting
  static void resetDiscovery() => _discovered = null;

  /// Origin of the API, used to resolve relative URLs returned by the server.
  static Uri get apiOrigin {
    final uri = Uri.parse(apiBaseUrl);
    return Uri(scheme: uri.scheme, host: uri.host, port: uri.port);
  }

  /// Shown in crash reports so a fix can be matched to a release. Set with `--dart-define=APP_VERSION=1.0.0+1`.
  static const appVersion = String.fromEnvironment('APP_VERSION', defaultValue: 'dev');

  // Firebase (push). Public client config, not secrets. Push is disabled when unset.
  static const firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const firebaseSenderId = String.fromEnvironment('FIREBASE_SENDER_ID');
  static const firebaseAndroidAppId = String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
  static const firebaseIosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');

  // Legal pages are served by the backend (/privacy, /terms), so they work as soon as the API is live.
  static const String _privacyUrl = String.fromEnvironment('PRIVACY_URL');
  static const String _termsUrl = String.fromEnvironment('TERMS_URL');
  static String get privacyPolicyUrl => _privacyUrl.isNotEmpty ? _privacyUrl : '${apiOrigin.toString()}/privacy';
  static String get termsUrl => _termsUrl.isNotEmpty ? _termsUrl : '${apiOrigin.toString()}/terms';

  static const String supportEmail = String.fromEnvironment('SUPPORT_EMAIL', defaultValue: 'support@example.com');
  static const String grievanceOfficer = String.fromEnvironment(
    'GRIEVANCE_OFFICER',
    defaultValue: 'Grievance Officer, grievance@example.com',
  );

  /// Settings a store build must not ship with. Empty in a correct production build.
  static List<String> releaseProblems() => [
    if (!apiBaseUrl.startsWith('https://')) 'API_BASE_URL must be https:// (got $apiBaseUrl)',
    if (supportEmail.endsWith('@example.com')) 'SUPPORT_EMAIL is a placeholder',
    if (grievanceOfficer.contains('example.com')) 'GRIEVANCE_OFFICER is a placeholder',
  ];
}
