import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/network/api_exception.dart';
import '../../core/widgets/async_states.dart';
import '../../core/widgets/demo_badge.dart';
import '../policy/data/models.dart';
import '../policy/data/policy_repository.dart';
import '../policy/presentation/clauses_screen.dart';
import '../../core/locale.dart';

Map<String, List<String>> _suggestions(AppLocalizations t) => {
  'health': [t.sugMaternity, t.sugRoomRent, t.sugPed, t.sugExcluded],
  'motor': [t.sugZeroDep, t.sugIdv, t.sugRoadside],
  'life': [t.sugDeathBenefit, t.sugNominee, t.sugSurrender],
  'other': [t.sugCover, t.sugExcluded],
};

final _historyProvider = FutureProvider.autoDispose.family<List<Answer>, String>(
  (ref, id) => ref.watch(policyRepositoryProvider).messages(id),
);

class AskScreen extends ConsumerStatefulWidget {
  const AskScreen({super.key, required this.policyId, this.initialQuestion});
  final String policyId;

  /// Pre-filled (not sent) question, e.g. from "Ask about this" on the coverage report.
  final String? initialQuestion;

  @override
  ConsumerState<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends ConsumerState<AskScreen> {
  late final _input = TextEditingController(text: widget.initialQuestion);
  final _scroll = ScrollController();
  final List<Answer> _session = [];
  String? _pending;
  String? _error;
  bool _scrolledToHistory = false;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _ask(String question) async {
    question = question.trim();
    if (question.length < 3 || _pending != null) return;
    _input.clear();
    setState(() {
      _pending = question;
      _error = null;
    });
    _scrollToEnd();
    try {
      final answer = await ref.read(policyRepositoryProvider).ask(widget.policyId, question);
      setState(() => _session.add(answer));
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _pending = null);
      _scrollToEnd();
    }
  }

  void _scrollToEnd({bool animate = true}) => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!_scroll.hasClients) return;
    final end = _scroll.position.maxScrollExtent;
    animate
        ? _scroll.animateTo(end, duration: const Duration(milliseconds: 250), curve: Curves.easeOut)
        : _scroll.jumpTo(end);
  });

  @override
  Widget build(BuildContext context) {
    final policy = ref.watch(policyProvider(widget.policyId));
    final history = ref.watch(_historyProvider(widget.policyId));
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.askAboutYourPolicy),
            if (policy.value != null)
              Text(policy.value!.displayName, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AsyncValueView(
              value: history,
              onRetry: () => ref.invalidate(_historyProvider(widget.policyId)),
              data: (past) {
                final all = [...past, ..._session];
                if (!_scrolledToHistory && past.isNotEmpty) {
                  _scrolledToHistory = true;
                  _scrollToEnd(animate: false);
                }
                if (all.isEmpty && _pending == null) {
                  return _Suggestions(
                    questions:
                        _suggestions(context.l10n)[policy.value?.policyType ?? 'other'] ??
                        _suggestions(context.l10n)['other']!,
                    onTap: _ask,
                  );
                }
                return ListView(
                  controller: _scroll,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    for (final a in all) ...[_QuestionBubble(a.question), _AnswerBubble(a)],
                    if (_pending != null) ...[
                      _QuestionBubble(_pending!),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                            const SizedBox(width: AppSpacing.sm),
                            Text(context.l10n.checkingDocument, style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Text(_error!, style: TextStyle(color: AppColors.error)),
                      ),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      maxLength: 500,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _ask,
                      decoration: InputDecoration(hintText: context.l10n.askAQuestion, counterText: ''),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: _pending == null ? () => _ask(_input.text) : null,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.questions, required this.onTap});
  final List<String> questions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    children: [
      Icon(Icons.auto_awesome_rounded, size: 40, color: AppColors.secondary),
      const SizedBox(height: AppSpacing.md),
      Text(context.l10n.askAnythingPolicy, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: AppSpacing.sm),
      Text(context.l10n.answersFromDocument, style: TextStyle(color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.lg),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [for (final q in questions) ActionChip(label: Text(q), onPressed: () => onTap(q))],
      ),
    ],
  );
}

class _QuestionBubble extends StatelessWidget {
  const _QuestionBubble(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.only(top: AppSpacing.md, left: 48),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.primaryFill, borderRadius: BorderRadius.circular(16)),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    ),
  );
}

class _AnswerBubble extends StatelessWidget {
  const _AnswerBubble(this.answer);
  final Answer answer;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm, right: 32),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DemoAiBadge(provider: answer.provider),
          if (!answer.answerable)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.help_outline_rounded, size: 16, color: AppColors.warning),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.statusUnknown,
                    style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ],
              ),
            ),
          Text(answer.answer),
          if (answer.relatedClauses.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            for (final c in answer.relatedClauses)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: AppSpacing.xs),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClauseTypeBadge(c.type),
                        const SizedBox(width: AppSpacing.sm),
                        if (c.page != null)
                          Text(
                            context.l10n.pageLabel('${c.page}'),
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(c.text, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
          ],
          if (answer.citations.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            for (final c in answer.citations)
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  dense: true,
                  leading: Icon(Icons.bookmark_outline_rounded, size: 18, color: AppColors.secondary),
                  title: Text(
                    context.l10n.sourceLabel(c.label.isEmpty ? context.l10n.policyDocument : c.label),
                    style: TextStyle(color: AppColors.secondary, fontSize: 13),
                  ),
                  children: [Text('“${c.excerpt}”', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13))],
                ),
              ),
            if (answer.confidence != 'high')
              Text(
                context.l10n.confidenceLabel(answer.confidence),
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
          ],
          const SizedBox(height: 6),
          Text(answer.disclaimer, style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    ),
  );
}
