import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/async_states.dart';
import '../coverage/coverage_data.dart';
import '../coverage/coverage_widgets.dart';
import '../../core/locale.dart';

class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen> {
  bool _earn = true;

  @override
  Widget build(BuildContext context) {
    final rewards = ref.watch(rewardsProvider);
    return Scaffold(
      backgroundColor: AppColors.goldWash,
      appBar: AppBar(backgroundColor: AppColors.goldWashStrong, title: Text(context.l10n.rewards)),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(rewardsProvider),
        child: AsyncValueView(
          value: rewards,
          onRetry: () => ref.invalidate(rewardsProvider),
          data: (r) => ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            children: [
              _Header(balance: r.balance),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: _Toggle(earn: _earn, onChanged: (v) => setState(() => _earn = v)),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _earn ? _EarnTab(rewards: r) : _UseTab(rewards: r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.earn, required this.onChanged});
  final bool earn;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget seg(String label, bool value) => Semantics(
      selected: earn == value,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(value),
        // 48 dp tap target around a 40 dp visual segment.
        child: SizedBox(
          height: 48,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: earn == value ? AppColors.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.4,
                  color: earn == value ? AppColors.primary : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: AppColors.primaryFill, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Expanded(child: seg(context.l10n.earnCoins, true)),
          Expanded(child: seg(context.l10n.useCoins, false)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.balance});
  final int balance;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.lg),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.goldWashStrong, AppColors.goldWash],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Column(
      children: [
        ExcludeSemantics(
          child: SizedBox(
            height: 96,
            width: 170,
            child: Stack(
              children: [
                for (final (dx, dy, s) in [(0.0, 30.0, 52.0), (40.0, 6.0, 72.0), (108.0, 34.0, 52.0)])
                  Positioned(
                    left: dx,
                    top: dy,
                    child: CoinIcon(size: s),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(context.l10n.yourCoins, style: TextStyle(color: AppColors.textSecondary)),
        Semantics(
          label: context.l10n.coinsCount(balance),
          excludeSemantics: true,
          child: Text(
            formatIndianNumber(balance),
            style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
        ),
        Text(context.l10n.earnedForOrganising, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    ),
  );
}

class _EarnTab extends StatelessWidget {
  const _EarnTab({required this.rewards});
  final Rewards rewards;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(context.l10n.waysToEarn, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      const SizedBox(height: AppSpacing.sm),
      for (final t in rewards.tasks)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Card(
            child: ListTile(
              leading: t.done
                  ? Icon(Icons.check_circle_rounded, color: AppColors.accent)
                  : Icon(Icons.radio_button_unchecked_rounded, color: AppColors.textSecondary),
              title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: t.progress != null ? Text(context.l10n.progressDone('${t.progress}')) : null,
              trailing: CoinChip('+${t.coins}'),
              onTap: t.done ? null : () => context.push(t.route),
            ),
          ),
        ),
      if (rewards.history.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.md),
        Text(context.l10n.history, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Column(
            children: [
              for (final h in rewards.history)
                ListTile(
                  dense: true,
                  title: Text(h.title),
                  subtitle: Text(formatDate(h.createdAt)),
                  trailing: Text(
                    '+${h.coins}',
                    style: TextStyle(color: AppColors.successText, fontWeight: FontWeight.w800),
                  ),
                ),
            ],
          ),
        ),
      ],
      const SizedBox(height: AppSpacing.md),
      Text(rewards.note, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
    ],
  );
}

IconData _perkIcon(String icon) => switch (icon) {
  'lab' => Icons.biotech_rounded,
  'expert' => Icons.support_agent_rounded,
  'gift' => Icons.card_giftcard_rounded,
  _ => Icons.star_rounded,
};

class _UseTab extends StatelessWidget {
  const _UseTab({required this.rewards});
  final Rewards rewards;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        context.l10n.useYourCoins,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: AppSpacing.md),
      Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: AppColors.errorTint, borderRadius: BorderRadius.circular(12)),
        child: Text(
          context.l10n.perksOnTheWay,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.errorText),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      for (final p in rewards.perks)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.successTint, AppColors.infoTint]),
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.surface,
                      child: Icon(_perkIcon(p.icon), color: AppColors.secondary),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(p.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(onPressed: null, child: Text(context.l10n.comingSoon)),
              ],
            ),
          ),
        ),
    ],
  );
}
