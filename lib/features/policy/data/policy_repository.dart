import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import 'models.dart';

class PolicyRepository {
  PolicyRepository(this._dio);
  final Dio _dio;

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<Policy>> list({String? type}) => _call(() async {
    final res = await _dio.get<List<dynamic>>('/policies', queryParameters: {'type': ?type});
    return res.data!.map((p) => Policy.fromJson(p as Map<String, dynamic>)).toList();
  });

  Future<Policy> get(String id) => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/policies/$id');
    return Policy.fromJson(res.data!);
  });

  Future<Policy> createManual(Map<String, dynamic> fields) => _call(() async {
    final res = await _dio.post<Map<String, dynamic>>('/policies', data: fields);
    return Policy.fromJson(res.data!);
  });

  Future<Policy> update(String id, Map<String, dynamic> fields) => _call(() async {
    final res = await _dio.patch<Map<String, dynamic>>('/policies/$id', data: fields);
    return Policy.fromJson(res.data!);
  });

  Future<Policy> confirm(String id, Map<String, dynamic> corrections) => _call(() async {
    final res = await _dio.post<Map<String, dynamic>>('/policies/$id/confirm', data: corrections);
    return Policy.fromJson(res.data!);
  });

  Future<void> delete(String id) => _call(() => _dio.delete<void>('/policies/$id'));

  Future<PolicyDocument> upload(Uint8List bytes, String filename, {void Function(double)? onProgress}) =>
      _call(() async {
        final form = FormData.fromMap({'file': MultipartFile.fromBytes(bytes, filename: filename)});
        final res = await _dio.post<Map<String, dynamic>>(
          '/documents',
          data: form,
          onSendProgress: (sent, total) => total > 0 ? onProgress?.call(sent / total) : null,
        );
        return PolicyDocument.fromJson(res.data!);
      });

  Future<PolicyDocument> document(String id) => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/documents/$id');
    return PolicyDocument.fromJson(res.data!);
  });

  Future<PolicyDocument> retry(String documentId) => _call(() async {
    final res = await _dio.post<Map<String, dynamic>>('/documents/$documentId/retry');
    return PolicyDocument.fromJson(res.data!);
  });

  Future<Uri> documentUrl(String documentId) => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/documents/$documentId/url');
    final url = Uri.parse(res.data!['url'] as String);
    return url.hasScheme ? url : Env.apiOrigin.resolveUri(url);
  });

  Future<PolicySummary> summary(String id) => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/policies/$id/summary');
    return PolicySummary.fromJson(res.data!);
  });

  Future<Answer> ask(String id, String question) => _call(() async {
    final res = await _dio.post<Map<String, dynamic>>('/policies/$id/ask', data: {'question': question});
    return Answer.fromJson(res.data!);
  });

  Future<List<Answer>> messages(String id) => _call(() async {
    final res = await _dio.get<List<dynamic>>('/policies/$id/messages');
    return res.data!.map((m) => Answer.fromJson(m as Map<String, dynamic>)).toList();
  });

  Future<HealthCheck> health(String id) => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/policies/$id/health');
    return HealthCheck.fromJson(res.data!);
  });

  Future<Policy> setRenewal(String id, String status) => _call(() async {
    final res = await _dio.put<Map<String, dynamic>>('/policies/$id/renewal', data: {'renewal_status': status});
    return Policy.fromJson(res.data!);
  });

  Future<List<Nominee>> nominees(String policyId) => _call(() async {
    final res = await _dio.get<List<dynamic>>('/policies/$policyId/nominees');
    return res.data!.map((n) => Nominee.fromJson(n as Map<String, dynamic>)).toList();
  });

  Future<Nominee> saveNominee(String policyId, Map<String, dynamic> fields, {String? id}) => _call(() async {
    final res = id == null
        ? await _dio.post<Map<String, dynamic>>('/policies/$policyId/nominees', data: fields)
        : await _dio.put<Map<String, dynamic>>('/policies/$policyId/nominees/$id', data: fields);
    return Nominee.fromJson(res.data!);
  });

  Future<void> deleteNominee(String policyId, String id) =>
      _call(() => _dio.delete<void>('/policies/$policyId/nominees/$id'));

  Future<List<Clause>> clauses(String policyId) => _call(() async {
    final res = await _dio.get<List<dynamic>>('/policies/$policyId/clauses');
    return res.data!.map((c) => Clause.fromJson(c as Map<String, dynamic>)).toList();
  });

  Future<Insights> insights() => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/portfolio/insights');
    return Insights.fromJson(res.data!);
  });

  Future<Comparison> compare(List<String> ids) => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/policies/compare',
      queryParameters: {'ids': ids},
      options: Options(listFormat: ListFormat.multi),
    );
    return Comparison.fromJson(res.data!);
  });

  Future<PortfolioSummary> portfolio() => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/portfolio/summary');
    return PortfolioSummary.fromJson(res.data!);
  });
}

final policyRepositoryProvider = Provider<PolicyRepository>((ref) => PolicyRepository(ref.watch(dioProvider)));

final policiesProvider = FutureProvider<List<Policy>>((ref) => ref.watch(policyRepositoryProvider).list());

final portfolioProvider = FutureProvider<PortfolioSummary>((ref) => ref.watch(policyRepositoryProvider).portfolio());

final policyProvider = FutureProvider.autoDispose.family<Policy, String>(
  (ref, id) => ref.watch(policyRepositoryProvider).get(id),
);

final summaryProvider = FutureProvider.autoDispose.family<PolicySummary, String>(
  (ref, id) => ref.watch(policyRepositoryProvider).summary(id),
);

final healthProvider = FutureProvider.autoDispose.family<HealthCheck, String>(
  (ref, id) => ref.watch(policyRepositoryProvider).health(id),
);

final clausesProvider = FutureProvider.autoDispose.family<List<Clause>, String>(
  (ref, id) => ref.watch(policyRepositoryProvider).clauses(id),
);

final insightsProvider = FutureProvider<Insights>((ref) => ref.watch(policyRepositoryProvider).insights());

/// Call after any change to policies so every list/summary refreshes.
void invalidatePolicies(WidgetRef ref, [String? policyId]) {
  ref.invalidate(policiesProvider);
  ref.invalidate(portfolioProvider);
  ref.invalidate(insightsProvider);
  if (policyId != null) {
    ref.invalidate(policyProvider(policyId));
    ref.invalidate(summaryProvider(policyId));
    ref.invalidate(healthProvider(policyId));
  }
}
