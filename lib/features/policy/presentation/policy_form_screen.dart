import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_states.dart';
import '../../account/data/account_repository.dart';
import '../data/models.dart';
import '../data/policy_repository.dart';
import '../../../core/locale.dart';

enum PolicyFormMode { verify, manual, edit }

/// One form for: verifying AI-extracted details, manual entry, and editing.
class PolicyFormScreen extends ConsumerWidget {
  const PolicyFormScreen({super.key, required this.mode, this.policyId});
  final PolicyFormMode mode;
  final String? policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (policyId == null) return _PolicyForm(mode: mode);
    final policy = ref.watch(policyProvider(policyId!));
    return AsyncValueView(
      value: policy,
      onRetry: () => ref.invalidate(policyProvider(policyId!)),
      data: (p) => _PolicyForm(mode: mode, policy: p),
    );
  }
}

class _PolicyForm extends ConsumerStatefulWidget {
  const _PolicyForm({required this.mode, this.policy});
  final PolicyFormMode mode;
  final Policy? policy;

  @override
  ConsumerState<_PolicyForm> createState() => _PolicyFormState();
}

class _PolicyFormState extends ConsumerState<_PolicyForm> {
  static const _lowConfidence = 0.7;
  final _formKey = GlobalKey<FormState>();
  late String _type = widget.policy?.policyType ?? 'health';
  late String? _frequency = widget.policy?.paymentFrequency;
  late DateTime? _start = widget.policy?.startDate;
  late DateTime? _end = widget.policy?.endDate;
  late final _insurer = TextEditingController(text: widget.policy?.insurer);
  late final _plan = TextEditingController(text: widget.policy?.planName);
  late final _number = TextEditingController(text: widget.policy?.policyNumber);
  late final _premium = TextEditingController(text: _amount(widget.policy?.premium));
  late final _cover = TextEditingController(text: _amount(widget.policy?.sumInsured));
  late final Set<String> _members = {...?widget.policy?.members.map((m) => m.id)};
  bool _saving = false;
  String? _error;

  static String? _amount(double? v) => v?.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);

  @override
  void dispose() {
    for (final c in [_insurer, _plan, _number, _premium, _cover]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Highlight fields the AI was unsure about (only when verifying an extraction).
  String? _hint(String field, bool hasValue) {
    if (widget.mode != PolicyFormMode.verify) return null;
    if (!hasValue) return context.l10n.notFoundFillIn;
    final c = widget.policy?.fieldConfidence[field] ?? 1;
    return c < _lowConfidence ? context.l10n.doubleCheck : null;
  }

  InputDecoration _decoration(String label, String field, bool hasValue) {
    final hint = _hint(field, hasValue);
    return InputDecoration(
      labelText: label,
      helperText: hint,
      helperStyle: const TextStyle(color: AppColors.warning),
      enabledBorder: hint == null
          ? null
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.warning, width: 1.5),
            ),
    );
  }

  Map<String, dynamic> _fields() {
    String? text(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
    String? day(DateTime? d) => d?.toIso8601String().substring(0, 10);
    return {
      'policy_type': _type,
      'insurer': text(_insurer),
      'plan_name': text(_plan),
      'policy_number': text(_number),
      'start_date': day(_start),
      'end_date': day(_end),
      'premium': text(_premium),
      'sum_insured': text(_cover),
      'payment_frequency': _frequency,
      'member_ids': _members.toList(),
    };
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_start != null && _end != null && !_start!.isBefore(_end!)) {
      setState(() => _error = context.l10n.startBeforeEnd);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final repo = ref.read(policyRepositoryProvider);
    try {
      final saved = switch (widget.mode) {
        PolicyFormMode.verify => await repo.confirm(widget.policy!.id, _fields()),
        PolicyFormMode.edit => await repo.update(widget.policy!.id, _fields()),
        PolicyFormMode.manual => await repo.createManual(_fields()),
      };
      invalidatePolicies(ref, saved.id);
      if (!mounted) return;
      if (widget.mode == PolicyFormMode.edit) {
        context.pop();
      } else {
        context.go('/policy/${saved.id}');
      }
    } on ApiException catch (e) {
      setState(() => _error = e.fields.isNotEmpty ? e.fields.values.first : e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _start : _end) ?? now,
      firstDate: DateTime(now.year - 40),
      lastDate: DateTime(now.year + 60),
    );
    if (picked != null) setState(() => isStart ? _start = picked : _end = picked);
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (widget.mode) {
      PolicyFormMode.verify => context.l10n.checkPolicyDetails,
      PolicyFormMode.manual => context.l10n.enterPolicyDetails,
      PolicyFormMode.edit => context.l10n.editPolicyDetails,
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (widget.mode == PolicyFormMode.verify)
              Card(
                color: AppColors.warningTint,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(context.l10n.weReadDetails, style: TextStyle(color: AppColors.warningText)),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _type,
              decoration: InputDecoration(labelText: context.l10n.insuranceType),
              items: const [
                'health',
                'life',
                'motor',
                'other',
              ].map((t) => DropdownMenuItem(value: t, child: Text(policyTypeLabel(t)))).toList(),
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _insurer,
              textCapitalization: TextCapitalization.words,
              decoration: _decoration(context.l10n.insurer, 'insurer', _insurer.text.isNotEmpty),
              validator: (v) => (v ?? '').trim().isEmpty ? context.l10n.insurerRequired : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _plan,
              decoration: _decoration(context.l10n.planName, 'plan_name', _plan.text.isNotEmpty),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _number,
              decoration: _decoration(context.l10n.policyNumber, 'policy_number', _number.text.isNotEmpty),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    context.l10n.startDate,
                    _start,
                    () => _pickDate(true),
                    _hint('start_date', _start != null),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _DateField(
                    context.l10n.endDate,
                    _end,
                    () => _pickDate(false),
                    _hint('end_date', _end != null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _cover,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: _decoration(
                _type == 'motor'
                    ? context.l10n.idvRupees
                    : _type == 'life'
                    ? context.l10n.sumAssuredRupees
                    : context.l10n.sumInsuredRupees,
                'sum_insured',
                _cover.text.isNotEmpty,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _premium,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: _decoration(context.l10n.premiumRupees, 'premium', _premium.text.isNotEmpty),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String?>(
              isExpanded: true,
              initialValue: _frequency,
              decoration: InputDecoration(labelText: context.l10n.premiumFrequency),
              items: const [null, 'annual', 'half_yearly', 'quarterly', 'monthly', 'single']
                  .map((f) => DropdownMenuItem(value: f, child: Text(f == null ? context.l10n.notSure : humanise(f))))
                  .toList(),
              onChanged: (v) => setState(() => _frequency = v),
            ),
            if (_type != 'motor') _MembersPicker(selected: _members, onChanged: () => setState(() {})),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_error!, style: TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(widget.mode == PolicyFormMode.verify ? context.l10n.confirmAddPolicy : context.l10n.save),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField(this.label, this.value, this.onTap, this.hint);
  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final String? hint;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        helperText: hint,
        helperMaxLines: 2,
        helperStyle: const TextStyle(color: AppColors.warning),
        suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
      ),
      child: Text(value == null ? context.l10n.select : formatDate(value)),
    ),
  );
}

class _MembersPicker extends ConsumerWidget {
  const _MembersPicker({required this.selected, required this.onChanged});
  final Set<String> selected;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final family = ref.watch(familyProvider).value ?? [];
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.whoIsCoveredQ, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.sm),
          if (family.isEmpty)
            TextButton.icon(
              onPressed: () => context.push('/family'),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: Text(context.l10n.addFamilyMembers),
            )
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                for (final m in family)
                  FilterChip(
                    label: Text(m.fullName),
                    selected: selected.contains(m.id),
                    onSelected: (on) {
                      on ? selected.add(m.id) : selected.remove(m.id);
                      onChanged();
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
