import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../storage/token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

/// Called when refresh fails; the auth controller registers itself here.
typedef SessionExpiredCallback = void Function();

class SessionEvents {
  SessionExpiredCallback? onExpired;
}

final sessionEventsProvider = Provider<SessionEvents>((ref) => SessionEvents());

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(minutes: 3),
    ),
  );
  dio.interceptors.add(AuthInterceptor(dio, ref.read(tokenStorageProvider), ref.read(sessionEventsProvider)));
  return dio;
});

/// Adds the bearer token and transparently refreshes it once on 401.
/// Errors are processed one at a time (QueuedInterceptor), so concurrent 401s refresh only once.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._dio, this._tokens, this._events);

  final Dio _dio;
  final TokenStorage _tokens;
  final SessionEvents _events;

  static const _noAuthPaths = ['/auth/otp/request', '/auth/otp/verify', '/auth/refresh'];

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_noAuthPaths.contains(options.path)) {
      final token = await _tokens.accessToken;
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final retried = options.extra['retried'] == true;
    if (err.response?.statusCode != 401 || _noAuthPaths.contains(options.path) || retried) {
      return handler.next(err);
    }
    // Requests are queued, so a request that failed with an old token may find a fresh one
    // already stored by an earlier refresh; only refresh when the token is unchanged.
    final current = await _tokens.accessToken;
    final usedToken = options.headers['Authorization'] == 'Bearer $current';
    final ok = current != null && !usedToken ? true : await _refresh();
    if (!ok) {
      _events.onExpired?.call();
      return handler.next(err);
    }
    try {
      options.extra['retried'] = true;
      options.headers['Authorization'] = 'Bearer ${await _tokens.accessToken}';
      // Retry on an interceptor-free client: re-entering this queued interceptor would deadlock.
      handler.resolve(await Dio(_dio.options).fetch(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<bool> _refresh() async {
    final refresh = await _tokens.refreshToken;
    if (refresh == null) return false;
    try {
      final res = await Dio(_dio.options).post<Map<String, dynamic>>('/auth/refresh', data: {'refresh_token': refresh});
      await _tokens.save(access: res.data!['access_token'] as String, refresh: res.data!['refresh_token'] as String);
      return true;
    } on DioException {
      await _tokens.clear();
      return false;
    }
  }
}
