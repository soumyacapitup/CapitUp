import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../features/policy/data/models.dart';
import '../ui/pressable.dart';
import '../utils/formatters.dart';
import '../../core/locale.dart';

IconData policyIcon(String type) => switch (type) {
  'health' => Icons.favorite_rounded,
  'life' => Icons.shield_rounded,
  'motor' => Icons.directions_car_rounded,
  _ => Icons.description_rounded,
};

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.policy});
  final Policy policy;

  @override
  Widget build(BuildContext context) {
    final (label, text, tint) = !policy.verified
        ? (context.l10n.reviewNeeded, AppColors.warningText, AppColors.warningTint)
        : switch (policy.status) {
            'active' => (context.l10n.statusActive, AppColors.successText, AppColors.successTint),
            'expiring_soon' => (
              context.l10n.endsInDays(policy.daysToExpiry ?? 0),
              AppColors.warningText,
              AppColors.warningTint,
            ),
            'expired' => (context.l10n.statusExpired, AppColors.errorText, AppColors.errorTint),
            _ => (context.l10n.datesMissing, AppColors.unknownText, AppColors.surfaceTint),
          };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class PolicyCard extends StatelessWidget {
  const PolicyCard({super.key, required this.policy, this.onTap});
  final Policy policy;
  final VoidCallback? onTap;

  /// Fraction of the policy term still left (1 = just started, 0 = ended); null when dates are missing.
  double? get _remaining {
    final s = policy.startDate, e = policy.endDate;
    if (s == null || e == null) return null;
    final total = e.difference(s).inHours;
    if (total <= 0) return null;
    return (e.difference(DateTime.now()).inHours / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forPolicyType(policy.policyType);
    final remaining = _remaining;
    final urgent = (policy.daysToExpiry ?? 999) <= 30;
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          boxShadow: AppShadows.card,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.tintForPolicyType(policy.policyType),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(policyIcon(policy.policyType), color: color, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    policy.displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.typeCover(policyTypeLabel(policy.policyType), formatInrCompact(policy.sumInsured)),
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  StatusChip(policy: policy),
                ],
              ),
            ),
            if (remaining != null && policy.verified)
              _ValidityRing(fraction: remaining, days: policy.daysToExpiry, urgent: urgent)
            else
              Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// Ring showing how much of the policy term is left, with the days in the middle.
class _ValidityRing extends StatelessWidget {
  const _ValidityRing({required this.fraction, required this.days, required this.urgent});
  final double fraction;
  final int? days;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    final color = urgent ? AppColors.warning : AppColors.primary;
    final d = days ?? 0;
    return Semantics(
      label: d > 0 ? context.l10n.daysLeft(d) : context.l10n.statusExpired,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: fraction,
              strokeWidth: 4.5,
              strokeCap: StrokeCap.round,
              backgroundColor: AppColors.border,
              color: color,
            ),
            ExcludeSemantics(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    d > 99 ? '99+' : '$d',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: urgent ? AppColors.warningText : AppColors.textPrimary,
                    ),
                  ),
                  Text('days', style: TextStyle(fontSize: 9, height: 1.1, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action});
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
    child: Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18))),
        ?action,
      ],
    ),
  );
}
