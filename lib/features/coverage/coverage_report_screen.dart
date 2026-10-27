import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/async_states.dart';
import '../../core/utils/formatters.dart';
import 'coverage_data.dart';
import 'coverage_widgets.dart';
import '../../core/locale.dart';

/// Coverage report for one of the user's policies, or a sample report when [policyId] is null.
class CoverageReportScreen extends ConsumerStatefulWidget {
  const CoverageReportScreen({super.key, this.policyId, this.initialType = 'health'});
  final String? policyId;
  final String initialType;

  bool get demo => policyId == null;

  @override
  ConsumerState<CoverageReportScreen> createState() => _CoverageReportScreenState();
}

class _CoverageReportScreenState extends ConsumerState<CoverageReportScreen> {
  late String _type = widget.initialType;

  @override
  void didUpdateWidget(CoverageReportScreen old) {
    super.didUpdateWidget(old);
    // Same route, new ?type= (e.g. a deep link): follow it.
    if (old.initialType != widget.initialType) _type = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.demo
        ? ref.watch(demoReportProvider(_type))
        : ref.watch(coverageReportProvider(widget.policyId!));
    return Scaffold(
      appBar: AppBar(title: Text(widget.demo ? context.l10n.sampleReport : context.l10n.coverageReport)),
      bottomNavigationBar: _BottomBar(policyId: widget.policyId),
      body: Column(
        children: [
          if (widget.demo)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: 0,
                  children: [
                    for (final t in const ['health', 'life', 'motor'])
                      _TypePill(
                        label: policyTypeLabel(t),
                        selected: t == _type,
                        onTap: () => setState(() => _type = t),
                      ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: AsyncValueView(
              value: report,
              onRetry: () => widget.demo
                  ? ref.invalidate(demoReportProvider(_type))
                  : ref.invalidate(coverageReportProvider(widget.policyId!)),
              data: (r) => r.available
                  ? _ReportBody(key: ValueKey(r.policyType), report: r, policyId: widget.policyId)
                  : EmptyView(
                      icon: Icons.fact_check_rounded,
                      title: context.l10n.reportNotAvailable,
                      message: r.note ?? context.l10n.reportTypesNote,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      // 4.5 dp of transparent padding inside the InkWell lifts the tap target to 48 dp without a taller pill.
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.textPrimary : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? AppColors.textPrimary : AppColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.surface : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    ),
  );
}

class _ReportBody extends StatefulWidget {
  const _ReportBody({super.key, required this.report, this.policyId});
  final CoverageReport report;
  final String? policyId;

  @override
  State<_ReportBody> createState() => _ReportBodyState();
}

class _ReportBodyState extends State<_ReportBody> {
  late final _sectionKeys = {for (final s in widget.report.sections) s.key: GlobalKey()};
  late final _rowKeys = {
    for (final s in widget.report.sections)
      for (final r in s.items) r.key: GlobalKey(),
  };
  late String _activeTab = widget.report.sections.first.key;

  void _jumpTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 350), curve: Curves.easeOut, alignment: 0.1);
    }
  }

  void _openRow(CoverageRow row) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _RowSheet(row: row, policyId: widget.policyId),
  );

  @override
  Widget build(BuildContext context) {
    final r = widget.report;
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: [
        if (r.scenarios.isNotEmpty)
          _ScenarioCarousel(
            scenarios: r.scenarios,
            onOpen: (s) {
              final key = _rowKeys[s.itemKey];
              if (key != null) _jumpTo(key);
            },
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
          child: _Summary(report: r),
        ),
        const SizedBox(height: AppSpacing.sm),
        _SectionTabs(
          sections: r.sections,
          active: _activeTab,
          onTap: (key) {
            setState(() => _activeTab = key);
            _jumpTo(_sectionKeys[key]!);
          },
        ),
        for (final s in r.sections)
          _SectionView(key: _sectionKeys[s.key], section: s, rowKeys: _rowKeys, onOpen: _openRow),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            [if (r.note != null) r.note!, r.disclaimer].join('\n\n'),
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

class _ScenarioCarousel extends StatefulWidget {
  const _ScenarioCarousel({required this.scenarios, required this.onOpen});
  final List<Scenario> scenarios;
  final ValueChanged<Scenario> onOpen;

  @override
  State<_ScenarioCarousel> createState() => _ScenarioCarouselState();
}

class _ScenarioCarouselState extends State<_ScenarioCarousel> {
  final _controller = PageController(viewportFraction: 0.86);
  int _page = 0;
  Timer? _timer;
  DateTime _lastTouch = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    if (!(MediaQuery.maybeOf(context)?.disableAnimations ?? false)) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        // Pause for a while after the user swipes or taps.
        if (!mounted || DateTime.now().difference(_lastTouch) < const Duration(seconds: 10)) return;
        final next = (_page + 1) % widget.scenarios.length;
        _controller.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.scenarios.length;
    return Container(
      color: AppColors.surfaceTint,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          SizedBox(
            height: 268,
            child: Listener(
              onPointerDown: (_) => _lastTouch = DateTime.now(),
              child: PageView.builder(
                controller: _controller,
                itemCount: n,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _ScenarioCard(scenario: widget.scenarios[i], onTap: () => widget.onOpen(widget.scenarios[i])),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '${_page + 1}/$n',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
              for (var i = 0; i < n; i++)
                if (i != _page)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(left: 5),
                    decoration: const BoxDecoration(color: Color(0xFFB8C0CE), shape: BoxShape.circle),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario, required this.onTap});
  final Scenario scenario;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = StatusStyle.of(scenario.status, context.l10n);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                scenario.question,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, height: 1.25),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Center(child: ScenarioArt(scenario.art, size: 92)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(style.icon, color: style.color, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        scenario.answer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: style.textColor, fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: style.textColor, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.report});
  final CoverageReport report;

  @override
  Widget build(BuildContext context) {
    Widget stat(String status, String label) {
      final s = StatusStyle.of(status, context.l10n);
      return Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(s.icon, color: s.color, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${report.counts[status] ?? 0}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ],
            ),
            Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    report.title ?? context.l10n.coverAtGlance,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (report.rating != null) ...[const SizedBox(width: AppSpacing.sm), RatingBadge(report.rating!)],
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                stat('good', 'Covered'),
                stat('limited', 'With limits'),
                stat('missing', 'Not covered'),
                stat('unknown', 'Not found'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({required this.sections, required this.active, required this.onTap});
  final List<CoverageSection> sections;
  final String active;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.border)),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          for (final s in sections)
            InkWell(
              onTap: () => onTap(s.key),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: s.key == active ? AppColors.textPrimary : Colors.transparent, width: 2),
                  ),
                ),
                child: Text(
                  s.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: s.key == active ? FontWeight.w700 : FontWeight.w500,
                    color: s.key == active ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

IconData _sectionIcon(String key) => switch (key) {
  'essentials' || 'protection' || 'own_damage' => Icons.thumb_up_alt_outlined,
  'important' || 'flexibility' => Icons.volunteer_activism_outlined,
  'extras' || 'add_ons' => Icons.add_circle_outline_rounded,
  'personal' => Icons.family_restroom_rounded,
  'costs' => Icons.receipt_long_outlined,
  'third_party' => Icons.groups_outlined,
  'exclusions' => Icons.block_rounded,
  _ => Icons.checklist_rounded,
};

class _SectionView extends StatelessWidget {
  const _SectionView({super.key, required this.section, required this.rowKeys, required this.onOpen});
  final CoverageSection section;
  final Map<String, GlobalKey> rowKeys;
  final ValueChanged<CoverageRow> onOpen;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(_sectionIcon(section.key), size: 22),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Semantics(
                header: true,
                child: Text(section.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              ),
            ),
            if (section.rating != null) ...[const SizedBox(width: AppSpacing.sm), RatingBadge(section.rating!)],
          ],
        ),
        const SizedBox(height: 2),
        Text(section.subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: AppSpacing.sm),
        if (section.key == 'add_ons')
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              initiallyExpanded: true,
              title: Text(
                context.l10n.addOnsCount(section.items.length),
                style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
              children: [
                for (final row in section.items)
                  Padding(
                    key: rowKeys[row.key],
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _RowTile(row: row, onTap: () => onOpen(row)),
                  ),
              ],
            ),
          )
        else
          for (final row in section.items)
            Padding(
              key: rowKeys[row.key],
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _RowTile(row: row, onTap: () => onOpen(row)),
            ),
      ],
    ),
  );
}

class _RowTile extends StatelessWidget {
  const _RowTile({required this.row, required this.onTap});
  final CoverageRow row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = StatusStyle.of(row.status, context.l10n);
    final valueColor = switch (row.status) {
      'missing' => AppColors.errorText,
      'unknown' => AppColors.unknownText,
      _ => AppColors.textSecondary,
    };
    return Semantics(
      button: true,
      label: '${row.label}: ${row.value}. ${style.label}',
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Icon(style.icon, color: style.color, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: Text(row.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 5,
                  child: Text(
                    row.value,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: valueColor, fontSize: 13, fontWeight: FontWeight.w500),
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

class _RowSheet extends StatelessWidget {
  const _RowSheet({required this.row, this.policyId});
  final CoverageRow row;
  final String? policyId;

  @override
  Widget build(BuildContext context) {
    final style = StatusStyle.of(row.status, context.l10n);
    final source = switch (row.source) {
      'document' => row.page != null ? context.l10n.fromPolicyPage(row.page!) : context.l10n.fromPolicyDetails,
      'clause' => '${context.l10n.fromPolicyWording}${row.page != null ? ' · ${context.l10n.pageN(row.page!)}' : ''}',
      _ => context.l10n.notMentioned,
    };
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(row.label, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(style.icon, color: style.color, size: 18),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    row.status == 'info' ? row.value : '${style.label} · ${row.value}',
                    style: TextStyle(color: style.textColor, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(context.l10n.whyItMatters, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(row.why),
            if (row.detail != null && row.detail != row.value) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: AppColors.secondary, width: 3)),
                ),
                child: Text('"${row.detail}"', style: const TextStyle(fontStyle: FontStyle.italic)),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(source, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            if (policyId != null) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  final q = Uri.encodeQueryComponent(context.l10n.askAboutThisQ(row.label.toLowerCase()));
                  context.push('/policy/$policyId/ask?q=$q');
                },
                icon: const Icon(Icons.auto_awesome_rounded),
                label: Text(context.l10n.askAboutThis),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({this.policyId});
  final String? policyId;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
    decoration: BoxDecoration(
      color: AppColors.surface,
      boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -2))],
    ),
    child: SafeArea(
      top: false,
      child: Row(
        children: [
          Expanded(
            child: Text(
              policyId == null ? context.l10n.seeForOwnPolicy : context.l10n.questionsAboutCover,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
          SizedBox(
            width: 150,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                minimumSize: const Size.fromHeight(46),
              ),
              onPressed: () => policyId == null ? context.push('/add') : context.push('/policy/$policyId/ask'),
              child: Text(policyId == null ? context.l10n.addPolicyShort : context.l10n.askAi),
            ),
          ),
        ],
      ),
    ),
  );
}
