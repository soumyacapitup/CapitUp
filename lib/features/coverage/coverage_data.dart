import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';

/// good · limited · missing · info · unknown
class CoverageRow {
  CoverageRow({
    required this.key,
    required this.label,
    required this.status,
    required this.value,
    required this.why,
    this.detail,
    this.page,
    required this.source,
  });

  final String key;
  final String label;
  final String status;
  final String value;
  final String why;
  final String? detail;
  final int? page;
  final String source;

  factory CoverageRow.fromJson(Map<String, dynamic> j) => CoverageRow(
    key: j['key'] as String,
    label: j['label'] as String,
    status: j['status'] as String,
    value: j['value'] as String,
    why: j['why'] as String,
    detail: j['detail'] as String?,
    page: j['page'] as int?,
    source: j['source'] as String,
  );
}

class CoverageSection {
  CoverageSection({required this.key, required this.title, required this.subtitle, this.rating, required this.items});

  final String key;
  final String title;
  final String subtitle;

  /// strong · fair · weak · null when the section isn't graded
  final String? rating;
  final List<CoverageRow> items;

  factory CoverageSection.fromJson(Map<String, dynamic> j) => CoverageSection(
    key: j['key'] as String,
    title: j['title'] as String,
    subtitle: j['subtitle'] as String,
    rating: j['rating'] as String?,
    items: (j['items'] as List).map((i) => CoverageRow.fromJson(i as Map<String, dynamic>)).toList(),
  );
}

class Scenario {
  Scenario({
    required this.question,
    required this.itemKey,
    required this.art,
    required this.status,
    required this.answer,
  });

  final String question;
  final String itemKey;
  final String art;
  final String status;
  final String answer;

  factory Scenario.fromJson(Map<String, dynamic> j) => Scenario(
    question: j['question'] as String,
    itemKey: j['item_key'] as String,
    art: j['art'] as String,
    status: j['status'] as String,
    answer: j['answer'] as String,
  );
}

class CoverageReport {
  CoverageReport({
    required this.available,
    required this.policyType,
    required this.demo,
    this.title,
    this.rating,
    required this.scenarios,
    required this.sections,
    required this.counts,
    this.note,
    required this.disclaimer,
  });

  final bool available;
  final String policyType;
  final bool demo;
  final String? title;
  final String? rating;
  final List<Scenario> scenarios;
  final List<CoverageSection> sections;
  final Map<String, int> counts;
  final String? note;
  final String disclaimer;

  factory CoverageReport.fromJson(Map<String, dynamic> j) => CoverageReport(
    available: j['available'] as bool,
    policyType: j['policy_type'] as String,
    demo: j['demo'] as bool,
    title: j['title'] as String?,
    rating: j['rating'] as String?,
    scenarios: (j['scenarios'] as List).map((s) => Scenario.fromJson(s as Map<String, dynamic>)).toList(),
    sections: (j['sections'] as List).map((s) => CoverageSection.fromJson(s as Map<String, dynamic>)).toList(),
    counts: (j['counts'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v as int)),
    note: j['note'] as String?,
    disclaimer: j['disclaimer'] as String,
  );
}

class RewardTask {
  RewardTask({
    required this.kind,
    required this.title,
    required this.coins,
    required this.route,
    required this.done,
    this.progress,
  });

  final String kind;
  final String title;
  final int coins;
  final String route;
  final bool done;
  final String? progress;

  factory RewardTask.fromJson(Map<String, dynamic> j) => RewardTask(
    kind: j['kind'] as String,
    title: j['title'] as String,
    coins: j['coins'] as int,
    route: j['route'] as String,
    done: j['done'] as bool,
    progress: j['progress'] as String?,
  );
}

class Rewards {
  Rewards({required this.balance, required this.tasks, required this.history, required this.perks, required this.note});

  final int balance;
  final List<RewardTask> tasks;
  final List<({String title, int coins, DateTime createdAt})> history;
  final List<({String key, String title, String icon})> perks;
  final String note;

  factory Rewards.fromJson(Map<String, dynamic> j) => Rewards(
    balance: j['balance'] as int,
    tasks: (j['tasks'] as List).map((t) => RewardTask.fromJson(t as Map<String, dynamic>)).toList(),
    history: [
      for (final h in (j['history'] as List).cast<Map<String, dynamic>>())
        (
          title: h['title'] as String,
          coins: h['coins'] as int,
          createdAt: DateTime.parse(h['created_at'] as String).toLocal(),
        ),
    ],
    perks: [
      for (final p in (j['perks'] as List).cast<Map<String, dynamic>>())
        (key: p['key'] as String, title: p['title'] as String, icon: p['icon'] as String),
    ],
    note: j['note'] as String,
  );
}

class CoverageRepository {
  CoverageRepository(this._dio);
  final Dio _dio;

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<CoverageReport> report(String policyId) => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/policies/$policyId/coverage-report');
    return CoverageReport.fromJson(res.data!);
  });

  Future<CoverageReport> demo(String policyType) => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/coverage/demo/$policyType');
    return CoverageReport.fromJson(res.data!);
  });

  Future<Rewards> rewards() => _call(() async {
    final res = await _dio.get<Map<String, dynamic>>('/rewards');
    return Rewards.fromJson(res.data!);
  });
}

final coverageRepositoryProvider = Provider<CoverageRepository>((ref) => CoverageRepository(ref.watch(dioProvider)));

final coverageReportProvider = FutureProvider.autoDispose.family<CoverageReport, String>(
  (ref, policyId) => ref.watch(coverageRepositoryProvider).report(policyId),
);

final demoReportProvider = FutureProvider.autoDispose.family<CoverageReport, String>(
  (ref, type) => ref.watch(coverageRepositoryProvider).demo(type),
);

final rewardsProvider = FutureProvider<Rewards>((ref) => ref.watch(coverageRepositoryProvider).rewards());
