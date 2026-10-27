import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_states.dart';
import '../../../core/widgets/policy_card.dart';
import '../../account/data/account_repository.dart';
import '../data/models.dart';
import '../data/policy_repository.dart';
import '../../../core/locale.dart';

const nomineeRelations = ['spouse', 'child', 'parent', 'sibling', 'other'];

/// What the family should do if the policyholder dies — per policy type.
/// TODO(before launch): have this content reviewed by an insurance claims expert.
Map<String, List<String>> _afterDeathSteps(AppLocalizations t) => {
  'life': [t.deathLife1, t.deathLife2, t.deathLife3, t.deathLife4],
  'health': [t.deathHealth1, t.deathHealth2, t.deathHealth3],
  'motor': [t.deathMotor1, t.deathMotor2, t.deathMotor3],
  'other': [t.deathOther1],
};

List<String> _afterDeathDocs(AppLocalizations t) => [
  t.deathDoc1,
  t.deathDoc2,
  t.deathDoc3,
  t.deathDoc4,
  t.deathDoc5,
  t.deathDoc6,
];

class NomineesScreen extends ConsumerWidget {
  const NomineesScreen({super.key, required this.policyId});
  final String policyId;

  Future<void> _share(Policy p, AppLocalizations t) async {
    final names = p.nominees.map((n) => '${n.fullName} (${humanise(n.relation)}, ${n.sharePercent}%)').join(', ');
    final all = _afterDeathSteps(t);
    final steps = (all[p.policyType] ?? all['other']!).map((s) => '• $s').join('\n');
    final type = policyTypeLabel(p.policyType);
    await SharePlus.instance.share(
      ShareParams(
        subject: t.shareSubject(type),
        text: t.shareBody(
          p.displayName,
          type,
          p.policyNumber ?? t.seePolicyDocument,
          formatInr(p.sumInsured),
          names.isEmpty ? t.notRecorded.toLowerCase() : names,
          steps,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policy = ref.watch(policyProvider(policyId));
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.nominees)),
      floatingActionButton: policy.value == null || policy.value!.nominees.fold(0, (a, n) => a + n.sharePercent) >= 100
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showNomineeSheet(context, policy.value!),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: Text(context.l10n.addNominee),
            ),
      body: AsyncValueView(
        value: policy,
        onRetry: () => ref.invalidate(policyProvider(policyId)),
        data: (p) {
          final total = p.nominees.fold(0, (a, n) => a + n.sharePercent);
          return ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 96),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.displayName, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: total / 100,
                          minHeight: 10,
                          backgroundColor: AppColors.border,
                          color: total == 100 ? AppColors.accent : AppColors.warning,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        total == 100
                            ? context.l10n.fullyAssigned
                            : total == 0
                            ? context.l10n.noNomineeYet
                            : context.l10n.assignedLeft(total, 100 - total),
                        style: TextStyle(color: total == 100 ? AppColors.accent : AppColors.warning),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(context.l10n.nomineeLegalNote, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              if (p.nominees.isNotEmpty) SectionHeader(context.l10n.nominees),
              for (final n in p.nominees)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.surfaceTint,
                        child: Text(
                          '${n.sharePercent}%',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary),
                        ),
                      ),
                      title: Text(n.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        [
                          humanise(n.relation),
                          if (n.isMinor) context.l10n.minorAppointee(n.appointeeName ?? context.l10n.notSet),
                          if (n.phone != null) n.phone!,
                        ].join(' · '),
                      ),
                      trailing: const Icon(Icons.edit_outlined, size: 20),
                      onTap: () => showNomineeSheet(context, p, nominee: n),
                    ),
                  ),
                ),
              SectionHeader(context.l10n.ifSomethingHappens),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final (i, step)
                          in (_afterDeathSteps(context.l10n)[p.policyType] ?? _afterDeathSteps(context.l10n)['other']!)
                              .indexed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(radius: 11, child: Text('${i + 1}', style: const TextStyle(fontSize: 11))),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(child: Text(step)),
                            ],
                          ),
                        ),
                      const Divider(),
                      Text(context.l10n.docsFamilyNeeds, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: AppSpacing.xs),
                      for (final d in _afterDeathDocs(context.l10n))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(Icons.check_rounded, size: 16, color: AppColors.accent),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(child: Text(d)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () => _share(p, context.l10n),
                icon: const Icon(Icons.ios_share_rounded),
                label: Text(context.l10n.shareWithFamily),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> showNomineeSheet(BuildContext context, Policy policy, {Nominee? nominee}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _NomineeForm(policy: policy, nominee: nominee),
);

class _NomineeForm extends ConsumerStatefulWidget {
  const _NomineeForm({required this.policy, this.nominee});
  final Policy policy;
  final Nominee? nominee;

  @override
  ConsumerState<_NomineeForm> createState() => _NomineeFormState();
}

class _NomineeFormState extends ConsumerState<_NomineeForm> {
  late final _name = TextEditingController(text: widget.nominee?.fullName);
  late final _phone = TextEditingController(text: widget.nominee?.phone);
  late final _appointee = TextEditingController(text: widget.nominee?.appointeeName);
  late String _relation = widget.nominee?.relation ?? 'spouse';
  late DateTime? _dob = widget.nominee?.dateOfBirth;
  late String? _memberId = widget.nominee?.familyMemberId;
  late final int _available =
      100 - widget.policy.nominees.where((n) => n.id != widget.nominee?.id).fold(0, (a, n) => a + n.sharePercent);
  late double _share = (widget.nominee?.sharePercent ?? _available).toDouble().clamp(1, 100);
  bool _saving = false;
  String? _error;

  bool get _isMinor {
    final dob = _dob;
    return dob != null && DateTime.now().difference(dob).inDays < 18 * 365;
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _appointee]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_isMinor && _appointee.text.trim().isEmpty) {
      setState(() => _error = context.l10n.needAppointee);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(policyRepositoryProvider).saveNominee(widget.policy.id, {
        'full_name': _name.text.trim(),
        'relation': _relation,
        'share_percent': _share.round(),
        'date_of_birth': _dob?.toIso8601String().substring(0, 10),
        'phone': _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        'appointee_name': _isMinor ? _appointee.text.trim() : null,
        'family_member_id': _memberId,
      }, id: widget.nominee?.id);
      invalidatePolicies(ref, widget.policy.id);
      if (mounted) Navigator.pop(context);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    try {
      await ref.read(policyRepositoryProvider).deleteNominee(widget.policy.id, widget.nominee!.id);
      invalidatePolicies(ref, widget.policy.id);
      if (mounted) Navigator.pop(context);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final family = ref.watch(familyProvider).value ?? [];
    final relationFor = {'spouse': 'spouse', 'child': 'child', 'parent': 'parent'};
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.nominee == null ? context.l10n.addNominee : context.l10n.editNominee,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (widget.nominee == null && family.any((m) => m.relation != 'self')) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(context.l10n.pickFromFamily, style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final m in family.where((m) => m.relation != 'self'))
                    ChoiceChip(
                      label: Text(m.fullName),
                      selected: _memberId == m.id,
                      onSelected: (_) => setState(() {
                        _memberId = m.id;
                        _name.text = m.fullName;
                        _relation = relationFor[m.relation] ?? 'other';
                        _dob = m.dateOfBirth;
                      }),
                    ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: context.l10n.fullNameAsPolicy),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _relation,
              decoration: InputDecoration(labelText: context.l10n.relationship),
              items: [for (final r in nomineeRelations) DropdownMenuItem(value: r, child: Text(humanise(r)))],
              onChanged: (v) => setState(() => _relation = v ?? _relation),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(context.l10n.shareOfClaim(_share.round()), style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: _share.clamp(1, _available.toDouble().clamp(1, 100)),
              min: 1,
              max: _available.toDouble().clamp(1, 100),
              divisions: (_available - 1).clamp(1, 99),
              label: '${_share.round()}%',
              onChanged: (v) => setState(() => _share = v),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.cake_outlined),
              label: Text(_dob == null ? context.l10n.dobOptional : formatDate(_dob)),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dob ?? DateTime(1990),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _dob = picked);
              },
            ),
            if (_isMinor) ...[
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _appointee,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: context.l10n.appointeeLabel),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: context.l10n.phoneOptional),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(_error!, style: TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _name.text.trim().isEmpty || _saving ? null : _save,
              child: Text(context.l10n.save),
            ),
            if (widget.nominee != null)
              TextButton(
                onPressed: _delete,
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: Text(context.l10n.removeNominee),
              ),
          ],
        ),
      ),
    );
  }
}
