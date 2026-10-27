import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/token_storage.dart';

class AppUser {
  AppUser({
    required this.id,
    this.phone,
    this.email,
    this.fullName,
    this.dateOfBirth,
    this.city,
    this.state,
    this.notifyRenewals = true,
    this.notifyProcessing = true,
    this.preferredLanguage = 'en',
  });

  final String id;
  final String? phone;
  final String? email;
  final String? fullName;
  final DateTime? dateOfBirth;
  final String? city;
  final String? state;
  final bool notifyRenewals;
  final bool notifyProcessing;

  /// Language for AI summaries and answers (en, hi, mr, ta, te, kn, bn, gu, ml).
  final String preferredLanguage;

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    id: j['id'] as String,
    phone: j['phone'] as String?,
    email: j['email'] as String?,
    fullName: j['full_name'] as String?,
    dateOfBirth: j['date_of_birth'] == null ? null : DateTime.parse(j['date_of_birth'] as String),
    city: j['city'] as String?,
    state: j['state'] as String?,
    notifyRenewals: j['notify_renewals'] as bool? ?? true,
    notifyProcessing: j['notify_processing'] as bool? ?? true,
    preferredLanguage: j['preferred_language'] as String? ?? 'en',
  );

  String get firstName => (fullName ?? '').split(' ').first;
}

class OtpChallenge {
  OtpChallenge(this.identifier, this.resendAfter);
  final String identifier;
  final int resendAfter;
}

class AuthRepository {
  AuthRepository(this._dio, this._tokens);

  final Dio _dio;
  final TokenStorage _tokens;

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<OtpChallenge> requestOtp(String identifier) => _call(() async {
    final res = await _dio.post<Map<String, dynamic>>('/auth/otp/request', data: {'identifier': identifier});
    return OtpChallenge(res.data!['identifier'] as String, res.data!['resend_after'] as int);
  });

  Future<AppUser> verifyOtp(String identifier, String code, {required bool consent}) => _call(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/otp/verify',
      data: {'identifier': identifier, 'code': code, 'consent': consent},
    );
    await _tokens.save(access: res.data!['access_token'] as String, refresh: res.data!['refresh_token'] as String);
    return AppUser.fromJson(res.data!['user'] as Map<String, dynamic>);
  });

  Future<AppUser?> currentUser() async {
    if (await _tokens.refreshToken == null) return null;
    return _call(() async {
      final res = await _dio.get<Map<String, dynamic>>('/me');
      return AppUser.fromJson(res.data!);
    });
  }

  Future<AppUser> updateProfile(Map<String, dynamic> changes) => _call(() async {
    final res = await _dio.patch<Map<String, dynamic>>('/me', data: changes);
    return AppUser.fromJson(res.data!);
  });

  Future<void> logout() async {
    final refresh = await _tokens.refreshToken;
    if (refresh != null) {
      try {
        await _dio.post<void>('/auth/logout', data: {'refresh_token': refresh});
      } on DioException {
        // Best effort: local tokens are cleared regardless.
      }
    }
    await _tokens.clear();
  }

  Future<void> deleteAccount() => _call(() async {
    await _dio.delete<void>('/me');
    await _tokens.clear();
  });
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(dioProvider), ref.watch(tokenStorageProvider)),
);
