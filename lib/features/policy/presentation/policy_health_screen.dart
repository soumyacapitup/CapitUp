import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/async_states.dart';
import '../../../core/widgets/policy_card.dart';
import '../data/models.dart';
import '../data/policy_repository.dart';
import '../../../core/locale.dart';

Color scoreColor(int score) => score >= 75
    ? AppColors.accent
    : score >= 50
    ? AppColors.warning
    : AppColors.error;

class PolicyHealthScreen extends ConsumerWidget {
  const PolicyHealthScreen({super.key, required this.policyId});
  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(healthProvider(policyId));
    final policy = ref.watch(policyProvider(policyId)).value;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.policyHealth)),
      body: AsyncValueView(
        value: health,
        onRetry: () => ref.invalidate(healthProvider(policyId)),
        data: (h) => !h.available
            ? EmptyView(
                icon: Icons.health_and_safety_outlined,
                title: context.l10n.notEnoughDetails,
                message: h.disclaimer,
              )
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          ScoreRing(score: h.score!),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(policy?.displayName ?? '', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  context.l10n.healthCounts(h.strong.length, h.attention.length, h.notCovered.length),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (h.strong.isNotEmpty)
                    _Section(context.l10n.ratingStrong, Icons.check_circle_rounded, AppColors.accent, h.strong),
                  if (h.attention.isNotEmpty)
                    _Section(context.l10n.needsAttention, Icons.warning_amber_rounded, AppColors.warning, h.attention),
                  if (h.notCovered.isNotEmpty)
                    _Section(context.l10n.statusMissing, Icons.cancel_rounded, AppColors.error, h.notCovered),
                  if (h.notMentioned.isNotEmpty) ...[
                    SectionHeader(context.l10n.notMentionedInDoc),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [for (final label in h.notMentioned) Chip(label: Text(label))],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Text(h.disclaimer, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
      ),
    );
  }
}

class ScoreRing extends StatelessWidget {
  const ScoreRing({super.key, required this.score, this.size = 88});
  final int score;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 9,
            strokeCap: StrokeCap.round,
            backgroundColor: AppColors.border,
            color: scoreColor(score),
          ),
        ),
        Text(
          '$score%',
          style: TextStyle(fontSize: size / 4.4, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.icon, this.color, this.items);
  final String title;
  final IconData icon;
  final Color color;
  final List<HealthFinding> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionHeader(title),
      Card(
        child: Column(
          children: [
            for (final f in items)
              ListTile(
                leading: Icon(icon, color: color),
                title: Text(f.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(f.detail),
              ),
          ],
        ),
      ),
    ],
  );
}
