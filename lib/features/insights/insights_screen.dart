import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/async_states.dart';
import '../policy/data/models.dart';
import '../policy/data/policy_repository.dart';
import '../../core/locale.dart';

(IconData, Color) insightStyle(Insight i) => switch (i.severity) {
  'high' => (Icons.priority_high_rounded, AppColors.error),
  'medium' => (Icons.warning_amber_rounded, AppColors.warning),
  _ => (Icons.lightbulb_outline_rounded, AppColors.secondary),
};

class InsightTile extends StatelessWidget {
  const InsightTile(this.insight, {super.key});
  final Insight insight;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = insightStyle(insight);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          onTap: insight.actionLink == null ? null : () => context.push(insight.actionLink!),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(insight.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(insight.detail, style: TextStyle(color: AppColors.textSecondary)),
                      if (insight.actionLabel != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${insight.actionLabel} →',
                          style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(insightsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.checkupTitle)),
      body: AsyncValueView(
        value: insights,
        onRetry: () => ref.invalidate(insightsProvider),
        data: (data) => data.items.isEmpty
            ? EmptyView(
                icon: Icons.verified_rounded,
                title: context.l10n.lookingGood,
                message: context.l10n.noGapsFound,
              )
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(insightsProvider),
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    for (final i in data.items) InsightTile(i),
                    const SizedBox(height: AppSpacing.sm),
                    Text(data.disclaimer, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
      ),
    );
  }
}
