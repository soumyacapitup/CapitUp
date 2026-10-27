import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_states.dart';
import '../../policy/data/models.dart';
import '../../policy/data/policy_repository.dart';
import '../data/account_repository.dart';
import '../../../core/locale.dart';

const relations = ['self', 'spouse', 'child', 'parent', 'other'];

IconData relationIcon(String r) => switch (r) {
  'self' => Icons.person_rounded,
  'spouse' => Icons.favorite_rounded,
  'child' => Icons.child_care_rounded,
  'parent' => Icons.elderly_rounded,
  _ => Icons.people_alt_rounded,
};

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final family = ref.watch(familyProvider);
    final policies = ref.watch(policiesProvider).value ?? [];
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.family)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showMemberSheet(context, ref),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: Text(context.l10n.addMember),
      ),
      body: AsyncValueView(
        value: family,
        onRetry: () => ref.invalidate(familyProvider),
        data: (members) => members.isEmpty
            ? EmptyView(
                icon: Icons.family_restroom_rounded,
                title: context.l10n.addYourFamily,
                message: context.l10n.addFamilyMessage,
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 96),
                children: [
                  for (final m in members)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _MemberCard(
                        member: m,
                        policies: policies.where((p) => p.members.any((x) => x.id == m.id)).toList(),
                        onTap: () => showMemberSheet(context, ref, member: m),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member, required this.policies, required this.onTap});
  final FamilyMember member;
  final List<Policy> policies;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final types = policies.map((p) => policyTypeLabel(p.policyType)).toSet();
    final uncovered = policies.isEmpty;
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceTint,
          child: Icon(relationIcon(member.relation), color: AppColors.secondary),
        ),
        title: Text(member.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          uncovered
              ? '${humanise(member.relation)} · ${context.l10n.notLinked}'
              : '${humanise(member.relation)} · ${types.join(', ')}',
          style: TextStyle(color: uncovered ? AppColors.warning : AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.edit_outlined, size: 20),
      ),
    );
  }
}

Future<void> showMemberSheet(BuildContext context, WidgetRef ref, {FamilyMember? member}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _MemberForm(member: member),
  );
}

class _MemberForm extends ConsumerStatefulWidget {
  const _MemberForm({this.member});
  final FamilyMember? member;

  @override
  ConsumerState<_MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends ConsumerState<_MemberForm> {
  late final _name = TextEditingController(text: widget.member?.fullName);
  late String _relation = widget.member?.relation ?? 'spouse';
  late DateTime? _dob = widget.member?.dateOfBirth;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(accountRepositoryProvider)
          .saveMember(
            id: widget.member?.id,
            fields: {
              'relation': _relation,
              'full_name': _name.text.trim(),
              'date_of_birth': _dob?.toIso8601String().substring(0, 10),
            },
          );
      ref.invalidate(familyProvider);
      invalidatePolicies(ref);
      if (mounted) Navigator.pop(context);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    try {
      await ref.read(accountRepositoryProvider).deleteMember(widget.member!.id);
      ref.invalidate(familyProvider);
      invalidatePolicies(ref);
      if (mounted) Navigator.pop(context);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.member == null ? context.l10n.addFamilyMember : context.l10n.editFamilyMember,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final r in relations)
                ChoiceChip(
                  avatar: Icon(relationIcon(r), size: 18),
                  label: Text(humanise(r)),
                  selected: _relation == r,
                  onSelected: (_) => setState(() => _relation = r),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(labelText: context.l10n.fullName, errorText: _error),
          ),
          const SizedBox(height: AppSpacing.md),
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
          const SizedBox(height: AppSpacing.lg),
          FilledButton(onPressed: _name.text.trim().isEmpty || _saving ? null : _save, child: Text(context.l10n.save)),
          if (widget.member != null)
            TextButton(
              onPressed: _delete,
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(context.l10n.removeMember),
            ),
        ],
      ),
    );
  }
}
