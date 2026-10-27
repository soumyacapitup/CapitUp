import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/async_states.dart';
import '../../core/widgets/policy_card.dart';
import '../policy/data/models.dart';
import '../policy/data/policy_repository.dart';
import '../../core/locale.dart';

/// Pick 2–3 of your own policies of the same type.
class CompareSelectScreen extends ConsumerStatefulWidget {
  const CompareSelectScreen({super.key});

  @override
  ConsumerState<CompareSelectScreen> createState() => _CompareSelectScreenState();
}

class _CompareSelectScreenState extends ConsumerState<CompareSelectScreen> {
  final _selected = <String>[];

  @override
  Widget build(BuildContext context) {
    final policies = ref.watch(policiesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.comparePolicies)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FilledButton(
            onPressed: _selected.length >= 2 ? () => context.push('/compare/view?ids=${_selected.join(',')}') : null,
            child: Text(_selected.length >= 2 ? context.l10n.compareN(_selected.length) : context.l10n.choose2or3),
          ),
        ),
      ),
      body: AsyncValueView(
        value: policies,
        onRetry: () => invalidatePolicies(ref),
        data: (all) {
          final verified = all.where((p) => p.verified).toList();
          final type = _selected.isEmpty ? null : verified.firstWhere((p) => p.id == _selected.first).policyType;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(context.l10n.compareIntro, style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.md),
              for (final p in verified)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Card(
                    child: CheckboxListTile(
                      value: _selected.contains(p.id),
                      enabled:
                          _selected.contains(p.id) || (_selected.length < 3 && (type == null || type == p.policyType)),
                      onChanged: (on) => setState(() => on == true ? _selected.add(p.id) : _selected.remove(p.id)),
                      secondary: Icon(policyIcon(p.policyType), color: AppColors.forPolicyType(p.policyType)),
                      title: Text(p.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        context.l10n.typeCover(policyTypeLabel(p.policyType), formatInrCompact(p.sumInsured)),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

final _comparisonProvider = FutureProvider.autoDispose.family<Comparison, String>(
  (ref, ids) => ref.watch(policyRepositoryProvider).compare(ids.split(',')),
);

class CompareScreen extends ConsumerWidget {
  const CompareScreen({super.key, required this.ids});
  final String ids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comparison = ref.watch(_comparisonProvider(ids));
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sideBySide)),
      body: AsyncValueView(
        value: comparison,
        onRetry: () => ref.invalidate(_comparisonProvider(ids)),
        data: (c) {
          final sections = <String, List<CompareRow>>{};
          for (final r in c.rows) {
            sections.putIfAbsent(r.section, () => []).add(r);
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _HeaderRow(names: c.policyNames),
              for (final entry in sections.entries) ...[
                SectionHeader(entry.key),
                Card(
                  child: Column(
                    children: [
                      for (final (i, row) in entry.value.indexed) ...[
                        if (i > 0) const Divider(height: 1),
                        _Row(row: row),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(c.disclaimer, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.names});
  final List<String> names;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final n in names)
        Expanded(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: AppColors.primaryFill,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                n,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
    ],
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.row});
  final CompareRow row;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          row.label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (i, v) in row.values.indexed)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _Cell(value: v, best: row.bestIndex == i, grade: i < row.grades.length ? row.grades[i] : null),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

class _Cell extends StatelessWidget {
  const _Cell({required this.value, required this.best, this.grade});
  final String? value;
  final bool best;
  final String? grade;

  @override
  Widget build(BuildContext context) {
    final (IconData? icon, Color? color) = switch (grade) {
      'strong' => (Icons.check_circle_rounded, AppColors.accent),
      'attention' => (Icons.warning_amber_rounded, AppColors.warning),
      'not_covered' => (Icons.cancel_rounded, AppColors.error),
      _ => best ? (Icons.star_rounded, AppColors.accent) : (null, null),
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            value ?? '—',
            style: TextStyle(
              fontWeight: best ? FontWeight.w700 : FontWeight.w400,
              color: value == null ? AppColors.textSecondary : (grade == 'not_covered' ? AppColors.error : null),
            ),
          ),
        ),
      ],
    );
  }
}
