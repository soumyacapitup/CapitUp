import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/demo_badge.dart';
import '../../auth/data/auth_controller.dart';
import '../../../core/widgets/async_states.dart';
import '../../../core/widgets/policy_card.dart';
import '../data/models.dart';
import '../data/policy_repository.dart';
import 'claim_guide.dart';
import 'policy_health_screen.dart';
import '../../../core/locale.dart';

class PolicyDetailScreen extends ConsumerWidget {
  const PolicyDetailScreen({super.key, required this.policyId});
  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policy = ref.watch(policyProvider(policyId));
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.policy),
        actions: [if (policy.value != null) _Menu(policy: policy.value!)],
      ),
      body: AsyncValueView(
        value: policy,
        onRetry: () => ref.invalidate(policyProvider(policyId)),
        data: (p) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(policyProvider(policyId)),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _Header(policy: p),
              if (!p.verified) ...[
                const SizedBox(height: AppSpacing.md),
                Card(
                  color: AppColors.warningTint,
                  child: ListTile(
                    leading: const Icon(Icons.fact_check_rounded, color: AppColors.warning),
                    title: Text(context.l10n.reviewExtracted),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/policy/${p.id}/verify'),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              _Actions(policy: p),
              if (p.policyType != 'other') ...[
                const SizedBox(height: AppSpacing.md),
                Card(
                  color: AppColors.surfaceTint,
                  child: ListTile(
                    leading: Icon(Icons.fact_check_rounded, color: AppColors.secondary),
                    title: Text(context.l10n.coverageReport, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(context.l10n.coverageReportHelp),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/policy/${p.id}/report'),
                  ),
                ),
              ],
              if (p.policyType == 'health' || p.policyType == 'motor') _HealthCard(policyId: p.id),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.groups_rounded, color: AppColors.secondary),
                      title: Text(context.l10n.nominees, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        p.nominees.isEmpty
                            ? (p.policyType == 'life' ? context.l10n.noNomineeAddOne : context.l10n.notRecorded)
                            : p.nominees.map((n) => '${n.fullName} ${n.sharePercent}%').join(', '),
                        style: TextStyle(
                          color: p.nominees.isEmpty && p.policyType == 'life' ? AppColors.warning : null,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push('/policy/${p.id}/nominees'),
                    ),
                    if (p.documentId != null) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.article_outlined, color: AppColors.secondary),
                        title: Text(context.l10n.policyClauses, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(context.l10n.policyClausesHelp),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.push('/policy/${p.id}/clauses'),
                      ),
                    ],
                  ],
                ),
              ),
              if (p.members.isNotEmpty) ...[
                SectionHeader(context.l10n.whoIsCovered),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final m in p.members)
                      Chip(
                        avatar: const Icon(Icons.person_rounded, size: 18),
                        label: Text('${m.fullName} · ${humanise(m.relation)}'),
                      ),
                  ],
                ),
              ],
              SectionHeader(context.l10n.understandPolicy),
              _SummaryCard(policyId: p.id),
              SectionHeader(context.l10n.keyDetails),
              _KeyDetails(policy: p),
              if (p.details.isNotEmpty) ...[
                SectionHeader(context.l10n.coverageDetails),
                _CoverageDetails(details: p.details),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.policy});
  final Policy policy;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forPolicyType(policy.policyType);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(policyIcon(policy.policyType), color: color),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(policy.displayName, style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        '${context.l10n.typeInsurance(policyTypeLabel(policy.policyType))}${policy.planName != null ? ' · ${policy.planName}' : ''}',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(formatInr(policy.sumInsured), style: Theme.of(context).textTheme.headlineMedium),
            Text(
              policy.policyType == 'motor' ? context.l10n.idv : context.l10n.cover,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            StatusChip(policy: policy),
            const SizedBox(height: AppSpacing.sm),
            Text(context.l10n.validRange(formatDate(policy.startDate), formatDate(policy.endDate))),
            Text(
              '${context.l10n.premiumValue(formatInr(policy.premium))}${policy.paymentFrequency != null ? ' (${humanise(policy.paymentFrequency!)})' : ''}',
            ),
          ],
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.policy});
  final Policy policy;

  @override
  Widget build(BuildContext context) {
    Widget action(IconData icon, String label, VoidCallback onTap) => Expanded(
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              children: [
                Icon(icon, color: AppColors.secondary),
                const SizedBox(height: AppSpacing.xs),
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
    return Row(
      children: [
        action(Icons.chat_bubble_rounded, context.l10n.askAi, () => context.push('/policy/${policy.id}/ask')),
        const SizedBox(width: AppSpacing.sm),
        action(Icons.event_repeat_rounded, context.l10n.renewal, () => _showRenewal(context, policy)),
        const SizedBox(width: AppSpacing.sm),
        action(Icons.support_agent_rounded, context.l10n.claimHelp, () => _showClaimGuide(context, policy.policyType)),
      ],
    );
  }

  void _showRenewal(BuildContext context, Policy p) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => _RenewalSheet(policyId: p.id),
    );
  }

  void _showClaimGuide(BuildContext context, String type) {
    final guides = claimGuidesFor(context.l10n);
    final guide = guides[type] ?? guides['other']!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
          children: [
            Text(guide.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            for (final (i, step) in guide.steps.indexed)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(radius: 14, child: Text('${i + 1}', style: const TextStyle(fontSize: 12))),
                title: Text(step),
              ),
            SectionHeader(context.l10n.documentsRequired),
            for (final d in guide.documents)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: Icon(Icons.check_circle_outline_rounded, color: AppColors.accent),
                title: Text(d),
              ),
            const SizedBox(height: AppSpacing.md),
            Text(context.l10n.followInsurerProcess, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  const _SummaryCard({required this.policyId});
  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(summaryProvider(policyId));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: summary.when(
          loading: () => Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: LoadingView(message: context.l10n.readingPolicy),
          ),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(summaryProvider(policyId))),
          data: (s) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DemoAiBadge(provider: s.provider),
              Text(s.headline, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              for (final point in s.keyPoints) _Bullet(point, Icons.check_circle_rounded, AppColors.accent),
              if (s.watchOuts.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(context.l10n.watchOutFor, style: const TextStyle(fontWeight: FontWeight.w600)),
                for (final w in s.watchOuts) _Bullet(w, Icons.warning_amber_rounded, AppColors.warning),
              ],
              const SizedBox(height: AppSpacing.sm),
              Text(s.disclaimer, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text, this.icon, this.color);
  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _KeyDetails extends StatelessWidget {
  const _KeyDetails({required this.policy});
  final Policy policy;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      (context.l10n.policyNumber, policy.policyNumber ?? '—'),
      (context.l10n.insurer, policy.insurer ?? '—'),
      (context.l10n.plan, policy.planName ?? '—'),
      (context.l10n.startDate, formatDate(policy.startDate)),
      (context.l10n.endDate, formatDate(policy.endDate)),
      (context.l10n.premium, formatInr(policy.premium)),
      (context.l10n.cover, formatInr(policy.sumInsured)),
    ];
    return Card(
      child: Column(
        children: [
          for (final (label, value) in rows)
            ListTile(
              dense: true,
              title: Text(label, style: TextStyle(color: AppColors.textSecondary)),
              trailing: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CoverageDetails extends StatelessWidget {
  const _CoverageDetails({required this.details});
  final Map<String, dynamic> details;

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: [
        for (final e in details.entries)
          ListTile(
            title: Text(humanise(e.key), style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(e.value is List ? (e.value as List).join(', ') : e.value.toString()),
          ),
      ],
    ),
  );
}

class _Menu extends ConsumerWidget {
  const _Menu({required this.policy});
  final Policy policy;

  Future<void> _openDocument(BuildContext context, WidgetRef ref) async {
    try {
      final url = await ref.read(policyRepositoryProvider).documentUrl(policy.documentId!);
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } on ApiException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(context.l10n.deletePolicyQ),
        content: Text(context.l10n.deletePolicyBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(context.l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(policyRepositoryProvider).delete(policy.id);
      invalidatePolicies(ref);
      if (context.mounted) context.go('/portfolio');
    } on ApiException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => PopupMenuButton<String>(
    onSelected: (v) => switch (v) {
      'edit' => context.push('/policy/${policy.id}/edit'),
      'doc' => _openDocument(context, ref),
      'delete' => _delete(context, ref),
      _ => null,
    },
    itemBuilder: (_) => [
      PopupMenuItem(value: 'edit', child: Text(context.l10n.editDetails)),
      if (policy.documentId != null) PopupMenuItem(value: 'doc', child: Text(context.l10n.viewDocument)),
      PopupMenuItem(value: 'delete', child: Text(context.l10n.deletePolicy)),
    ],
  );
}

class _HealthCard extends ConsumerWidget {
  const _HealthCard({required this.policyId});
  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(healthProvider(policyId)).value;
    if (health == null || !health.available) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(AppSpacing.md),
          leading: ScoreRing(score: health.score!, size: 52),
          title: Text(context.l10n.policyHealth, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            health.attention.isEmpty && health.notCovered.isEmpty
                ? context.l10n.noIssuesFound
                : context.l10n.thingsToKnow(health.attention.length + health.notCovered.length),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => context.push('/policy/$policyId/health'),
        ),
      ),
    );
  }
}

class _RenewalSheet extends ConsumerWidget {
  const _RenewalSheet({required this.policyId});
  final String policyId;

  Future<void> _set(BuildContext context, WidgetRef ref, String status) async {
    try {
      await ref.read(policyRepositoryProvider).setRenewal(policyId, status);
      invalidatePolicies(ref, policyId);
      if (!context.mounted) return;
      Navigator.pop(context);
      if (status == 'renewed') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.markedRenewed),
            action: SnackBarAction(label: context.l10n.add, onPressed: () => context.push('/add')),
          ),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(policyProvider(policyId)).value;
    final remindersOn = ref.watch(authControllerProvider).user?.notifyRenewals ?? true;
    if (p == null) return const SizedBox(height: 200, child: LoadingView());
    final days = p.daysToExpiry;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.renewal, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Text(
              days == null
                  ? context.l10n.addEndDate
                  : days < 0
                  ? context.l10n.expiredOn(formatDate(p.endDate))
                  : context.l10n.renewsOn(formatDate(p.endDate), days),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(context.l10n.lastPremium(formatInr(p.premium))),
            const SizedBox(height: AppSpacing.md),
            if (p.renewalStatus == 'pending')
              Row(
                children: [
                  Icon(
                    remindersOn ? Icons.notifications_active_rounded : Icons.notifications_off_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      remindersOn ? context.l10n.remindSchedule : context.l10n.remindersOff,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              )
            else
              Text(
                p.renewalStatus == 'renewed' ? context.l10n.markedAsRenewed : context.l10n.markedNotRenewing,
                style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: AppSpacing.lg),
            if (p.renewalStatus == 'pending') ...[
              FilledButton(onPressed: () => _set(context, ref, 'renewed'), child: Text(context.l10n.iRenewed)),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () => _set(context, ref, 'not_renewing'),
                child: Text(context.l10n.notRenewing),
              ),
            ] else
              OutlinedButton(onPressed: () => _set(context, ref, 'pending'), child: Text(context.l10n.undo)),
          ],
        ),
      ),
    );
  }
}
