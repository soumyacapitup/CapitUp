import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/core/config/env.dart';

/// Answers /health only for the given host; everything else fails like an unreachable address.
class _OnlyHost implements HttpClientAdapter {
  _OnlyHost(this.host);
  final String? host;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.uri.host == host && options.uri.path == '/health') {
      return ResponseBody.fromString(
        '{"status":"ok"}',
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    }
    throw DioException.connectionError(requestOptions: options, reason: 'unreachable');
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  tearDown(Env.resetDiscovery);

  test('a plain `flutter run` finds the backend through adb reverse (127.0.0.1)', () async {
    await Env.discoverDevBackend(dio: Dio()..httpClientAdapter = _OnlyHost('127.0.0.1'));
    expect(Env.apiBaseUrl, 'http://127.0.0.1:8000/api/v1');
  });

  test('localhost is used when it is the only one answering', () async {
    await Env.discoverDevBackend(dio: Dio()..httpClientAdapter = _OnlyHost('localhost'));
    expect(Env.apiBaseUrl, 'http://localhost:8000/api/v1');
  });

  test('when nothing answers, the default stays (and the error shows which address was tried)', () async {
    final before = Env.apiBaseUrl;
    await Env.discoverDevBackend(dio: Dio()..httpClientAdapter = _OnlyHost(null));
    expect(Env.apiBaseUrl, before);
  });
}
