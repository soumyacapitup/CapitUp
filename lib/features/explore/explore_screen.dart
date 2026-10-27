import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/policy_card.dart';
import '../policy/presentation/claim_guide.dart';
import '../../core/locale.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.explore)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 128),
        children: [
          SectionHeader(context.l10n.claimGuides),
          for (final entry in claimGuidesFor(context.l10n).entries)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Card(
                child: ExpansionTile(
                  shape: const Border(),
                  leading: Icon(policyIcon(entry.key), color: AppColors.forPolicyType(entry.key)),
                  title: Text(entry.value.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                  children: [
                    for (final (i, s) in entry.value.steps.indexed)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${i + 1}. ', style: const TextStyle(fontWeight: FontWeight.w600)),
                            Expanded(child: Text(s)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          SectionHeader(context.l10n.comingSoon),
          // Future modules (P2/P3) shown as labelled tiles only — no placeholder flows.
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _SoonTile(Icons.mail_outline_rounded, context.l10n.gmailImport),
              _SoonTile(Icons.account_balance_wallet_outlined, context.l10n.digiLocker),
              _SoonTile(Icons.track_changes_rounded, context.l10n.claimTracking),
              _SoonTile(Icons.spa_outlined, context.l10n.wellness),
            ],
          ),
        ],
      ),
    );
  }
}

class _SoonTile extends StatelessWidget {
  const _SoonTile(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: (MediaQuery.sizeOf(context).width - AppSpacing.md * 2 - AppSpacing.sm) / 2,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.sm),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(context.l10n.comingSoon, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    ),
  );
}
