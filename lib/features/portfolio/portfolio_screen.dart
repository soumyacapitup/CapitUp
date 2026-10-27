import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/async_states.dart';
import '../../core/widgets/policy_card.dart';
import '../policy/data/policy_repository.dart';
import '../../core/locale.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  String? _filter;

  @override
  Widget build(BuildContext context) {
    final policies = ref.watch(policiesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myInsurance),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/compare'),
            icon: const Icon(Icons.compare_arrows_rounded),
            label: Text(context.l10n.compare),
          ),
        ],
      ),
      body: AsyncValueView(
        value: policies,
        onRetry: () => invalidatePolicies(ref),
        data: (all) {
          if (all.isEmpty) {
            return EmptyView(
              icon: Icons.folder_open_rounded,
              title: context.l10n.nothingHereYet,
              message: context.l10n.addPoliciesHere,
              action: FilledButton.icon(
                onPressed: () => context.push('/add'),
                icon: const Icon(Icons.add_rounded),
                label: Text(context.l10n.addAPolicyTitle),
              ),
            );
          }
          final shown = _filter == null ? all : all.where((p) => p.policyType == _filter).toList();
          return RefreshIndicator(
            onRefresh: () async => invalidatePolicies(ref),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 128),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final t in [null, 'health', 'life', 'motor', 'other'])
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: ChoiceChip(
                            label: Text(
                              t == null
                                  ? context.l10n.allWithCount(all.length)
                                  : '${policyTypeLabel(t)} (${all.where((p) => p.policyType == t).length})',
                            ),
                            selected: _filter == t,
                            onSelected: (_) => setState(() => _filter = t),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (shown.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      context.l10n.noPoliciesOfType,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                for (final p in shown)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: PolicyCard(
                      policy: p,
                      onTap: () => context.push(p.verified ? '/policy/${p.id}' : '/policy/${p.id}/verify'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
