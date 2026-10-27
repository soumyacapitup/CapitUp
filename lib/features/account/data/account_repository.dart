import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../policy/data/models.dart';

class AccountRepository {
  AccountRepository(this._dio);
  final Dio _dio;

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // Family
  Future<List<FamilyMember>> family() => _call(() async {
    final res = await _dio.get<List<dynamic>>('/me/family');
    return res.data!.map((m) => FamilyMember.fromJson(m as Map<String, dynamic>)).toList();
  });

  Future<FamilyMember> saveMember({String? id, required Map<String, dynamic> fields}) => _call(() async {
    final res = id == null
        ? await _dio.post<Map<String, dynamic>>('/me/family', data: fields)
        : await _dio.patch<Map<String, dynamic>>('/me/family/$id', data: fields);
    return FamilyMember.fromJson(res.data!);
  });

  Future<void> deleteMember(String id) => _call(() => _dio.delete<void>('/me/family/$id'));

  // Notifications
  Future<List<AppNotification>> notifications() => _call(() async {
    final res = await _dio.get<List<dynamic>>('/notifications');
    return res.data!.map((n) => AppNotification.fromJson(n as Map<String, dynamic>)).toList();
  });

  Future<int> unreadCount() => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/notifications/unread-count');
    return res.data!['count'] as int;
  });

  Future<void> markRead(String id) => _call(() => _dio.post<void>('/notifications/$id/read'));
  Future<void> markAllRead() => _call(() => _dio.post<void>('/notifications/read-all'));

  Future<void> registerDevice(String token, String platform) =>
      _call(() => _dio.post<void>('/me/devices', data: {'token': token, 'platform': platform}));

  // Support & privacy
  Future<void> contactSupport(String category, String message) =>
      _call(() => _dio.post<void>('/support', data: {'category': category, 'message': message}));

  Future<String> exportData() => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/me/export');
    return const JsonEncoder.withIndent('  ').convert(res.data);
  });
}

final accountRepositoryProvider = Provider<AccountRepository>((ref) => AccountRepository(ref.watch(dioProvider)));

final familyProvider = FutureProvider<List<FamilyMember>>((ref) => ref.watch(accountRepositoryProvider).family());

final notificationsProvider = FutureProvider.autoDispose<List<AppNotification>>(
  (ref) => ref.watch(accountRepositoryProvider).notifications(),
);

final unreadCountProvider = FutureProvider<int>((ref) => ref.watch(accountRepositoryProvider).unreadCount());
