import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/locale.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_exception.dart';
import '../data/auth_controller.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _name = TextEditingController();
  DateTime? _dob;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).updateProfile({
        'full_name': _name.text.trim(),
        if (_dob != null) 'date_of_birth': _dob!.toIso8601String().substring(0, 10),
      });
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const SizedBox(height: AppSpacing.xl),
            Text(context.l10n.nameTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: context.l10n.fullName, errorText: _error),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              icon: const Icon(Icons.cake_outlined),
              label: Text(_dob == null ? context.l10n.dobOptional : '${_dob!.day}/${_dob!.month}/${_dob!.year}'),
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(now.year - 30),
                  firstDate: DateTime(1920),
                  lastDate: now,
                );
                if (picked != null) setState(() => _dob = picked);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _name.text.trim().isEmpty || _loading ? null : _save,
              child: Text(context.l10n.continueAction),
            ),
          ],
        ),
      ),
    );
  }
}
