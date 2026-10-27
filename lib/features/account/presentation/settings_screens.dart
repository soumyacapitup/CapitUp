import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/appearance.dart';
import '../../../core/locale.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/brand.dart';
import '../../../core/config/env.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/security/app_lock.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/policy_card.dart';
import '../../auth/data/auth_controller.dart';
import '../../policy/data/policy_repository.dart';
import '../data/account_repository.dart';

void _snack(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final _user = ref.read(authControllerProvider).user!;
  late final _name = TextEditingController(text: _user.fullName);
  late final _city = TextEditingController(text: _user.city);
  late final _state = TextEditingController(text: _user.state);
  late DateTime? _dob = _user.dateOfBirth;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _city, _state]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(authControllerProvider.notifier).updateProfile({
        'full_name': _name.text.trim(),
        'city': _city.text.trim().isEmpty ? null : _city.text.trim(),
        'state': _state.text.trim().isEmpty ? null : _state.text.trim(),
        'date_of_birth': _dob?.toIso8601String().substring(0, 10),
      });
      if (mounted) Navigator.pop(context);
    } on ApiException catch (e) {
      if (mounted) _snack(context, e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.personalDetails)),
    body: ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: context.l10n.fullName),
        ),
        const SizedBox(height: AppSpacing.md),
        InputDecorator(
          decoration: InputDecoration(labelText: context.l10n.mobileNumber, enabled: false),
          child: Text(_user.phone ?? _user.email ?? ''),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          icon: const Icon(Icons.cake_outlined),
          label: Text(_dob == null ? context.l10n.dateOfBirth : formatDate(_dob)),
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
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _city,
                decoration: InputDecoration(labelText: context.l10n.city),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextField(
                controller: _state,
                decoration: InputDecoration(labelText: context.l10n.state),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(onPressed: _saving ? null : _save, child: Text(context.l10n.save)),
      ],
    ),
  );
}

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    Future<void> update(String field, bool value) async {
      try {
        await ref.read(authControllerProvider.notifier).updateProfile({field: value});
      } on ApiException catch (e) {
        if (context.mounted) _snack(context, e.message);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.notifications)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: user?.notifyRenewals ?? true,
                  onChanged: (v) => update('notify_renewals', v),
                  title: Text(context.l10n.renewalReminders),
                  subtitle: Text(context.l10n.renewalRemindersHelp),
                ),
                SwitchListTile(
                  value: user?.notifyProcessing ?? true,
                  onChanged: (v) => update('notify_processing', v),
                  title: Text(context.l10n.policyUpdates),
                  subtitle: Text(context.l10n.policyUpdatesHelp),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(context.l10n.notificationsPromise, style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

List<(String, String)> _faqs(AppLocalizations t) => [
  (t.faqSafeQ, t.faqSafeA),
  (t.faqAiQ, t.faqAiA),
  (t.faqWrongQ, t.faqWrongA),
  (t.faqUploadQ, t.faqUploadA),
  (t.faqSellQ, t.faqSellA(Brand.name)),
  (t.faqDeleteQ, t.faqDeleteA),
];

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  final _message = TextEditingController();
  String _category = 'question';
  bool _sending = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    try {
      await ref.read(accountRepositoryProvider).contactSupport(_category, _message.text.trim());
      _message.clear();
      if (mounted) _snack(context, context.l10n.supportThanks);
    } on ApiException catch (e) {
      if (mounted) _snack(context, e.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.helpSupport)),
    body: ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        SectionHeader(context.l10n.faqTitle),
        Card(
          child: Column(
            children: [
              for (final (q, a) in _faqs(context.l10n))
                ExpansionTile(
                  shape: const Border(),
                  title: Text(q, style: const TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                  expandedAlignment: Alignment.centerLeft,
                  children: [Text(a)],
                ),
            ],
          ),
        ),
        SectionHeader(context.l10n.contactUs),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: _category,
          decoration: InputDecoration(labelText: context.l10n.topic),
          items: [
            DropdownMenuItem(value: 'question', child: Text(context.l10n.topicQuestion)),
            DropdownMenuItem(value: 'problem', child: Text(context.l10n.topicProblem)),
            DropdownMenuItem(value: 'feedback', child: Text(context.l10n.topicFeedback)),
            DropdownMenuItem(value: 'privacy', child: Text(context.l10n.topicPrivacy)),
            DropdownMenuItem(value: 'grievance', child: Text(context.l10n.topicGrievance)),
          ],
          onChanged: (v) => setState(() => _category = v ?? _category),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _message,
          minLines: 4,
          maxLines: 8,
          maxLength: 4000,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(hintText: context.l10n.howCanWeHelp),
        ),
        FilledButton(
          onPressed: _message.text.trim().length < 5 || _sending ? null : _send,
          child: Text(context.l10n.send),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton.icon(
          onPressed: () => launchUrl(Uri(scheme: 'mailto', path: Env.supportEmail)),
          icon: const Icon(Icons.mail_outline_rounded),
          label: Text(context.l10n.emailUsInstead),
        ),
      ],
    ),
  );
}

class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    try {
      final json = await ref.read(accountRepositoryProvider).exportData();
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(Uint8List.fromList(json.codeUnits), mimeType: 'application/json', name: 'my-data.json'),
          ],
          fileNameOverrides: const ['insureiq-my-data.json'],
          subject: 'My ${Brand.name} data',
        ),
      );
    } on ApiException catch (e) {
      if (context.mounted) _snack(context, e.message);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(context.l10n.deleteAccountQ),
        content: Text(context.l10n.deleteAccountBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(context.l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.deleteAccount),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(authControllerProvider.notifier).deleteAccount();
    } on ApiException catch (e) {
      if (context.mounted) _snack(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.privacyData)),
    body: ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Card(
          child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Text(context.l10n.privacyPromise)),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.download_rounded),
                title: Text(context.l10n.downloadMyData),
                subtitle: Text(context.l10n.downloadMyDataHelp),
                onTap: () => _export(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(context.l10n.privacyPolicyItem),
                onTap: () => launchUrl(Uri.parse(Env.privacyPolicyUrl)),
              ),
              ListTile(
                leading: const Icon(Icons.gavel_rounded),
                title: Text(context.l10n.grievanceOfficer),
                subtitle: const Text(Env.grievanceOfficer),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: AppColors.error),
            title: Text(context.l10n.deleteAccount, style: TextStyle(color: AppColors.error)),
            subtitle: Text(context.l10n.deleteAccountHelp),
            onTap: () => _delete(context, ref),
          ),
        ),
      ],
    ),
  );
}

/// App lock toggle row for the profile screen (hidden where biometrics aren't available).
class AppLockTile extends ConsumerWidget {
  const AppLockTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) return const SizedBox.shrink();
    final lock = ref.watch(appLockProvider);
    return SwitchListTile(
      secondary: Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary),
      title: Text(context.l10n.appLock),
      subtitle: Text(context.l10n.appLockHelp),
      value: lock.enabled,
      onChanged: (v) async {
        final ok = await ref.read(appLockProvider.notifier).setEnabled(v);
        if (!ok && context.mounted) _snack(context, context.l10n.setUpScreenLock);
      },
    );
  }
}

const answerLanguages = {
  'en': 'English',
  'hi': 'हिन्दी (Hindi)',
  'mr': 'मराठी (Marathi)',
  'ta': 'தமிழ் (Tamil)',
  'te': 'తెలుగు (Telugu)',
  'kn': 'ಕನ್ನಡ (Kannada)',
  'bn': 'বাংলা (Bengali)',
  'gu': 'ગુજરાતી (Gujarati)',
  'ml': 'മലയാളം (Malayalam)',
};

/// Language for AI summaries and answers (server-side, per user). The screens' language is [AppLanguageTile].
class LanguageTile extends ConsumerWidget {
  const LanguageTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(authControllerProvider).user?.preferredLanguage ?? 'en';
    return ListTile(
      leading: Icon(Icons.translate_rounded, color: AppColors.textSecondary),
      title: Text(context.l10n.aiAnswerLanguage),
      subtitle: Text(answerLanguages[current] ?? 'English'),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: context,
          showDragHandle: true,
          builder: (c) => SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
                  child: Text(context.l10n.aiAnswerLanguageHelp, style: TextStyle(color: AppColors.textSecondary)),
                ),
                for (final e in answerLanguages.entries)
                  ListTile(
                    title: Text(e.value),
                    trailing: e.key == current ? Icon(Icons.check_rounded, color: AppColors.accent) : null,
                    onTap: () => Navigator.pop(c, e.key),
                  ),
              ],
            ),
          ),
        );
        if (picked == null || picked == current) return;
        try {
          await ref.read(authControllerProvider.notifier).updateProfile({'preferred_language': picked});
          ref.invalidate(summaryProvider);
        } on ApiException catch (e) {
          if (context.mounted) _snack(context, e.message);
        }
      },
    );
  }
}

/// The language of the app's own screens (stored on the phone).
class AppLanguageTile extends ConsumerWidget {
  const AppLanguageTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.l10n;
    final current = ref.watch(appLocaleProvider);
    return ListTile(
      leading: Icon(Icons.language_rounded, color: AppColors.textSecondary),
      title: Text(t.appLanguage),
      subtitle: Text(t.languageName),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () async {
        final picked = await showModalBottomSheet<Locale>(
          context: context,
          showDragHandle: true,
          builder: (c) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
                  child: Text(t.appLanguageHelp, style: TextStyle(color: AppColors.textSecondary)),
                ),
                for (final l in AppLocaleController.supported)
                  ListTile(
                    title: Text(lookupAppLocalizations(l).languageName),
                    trailing: l == current ? Icon(Icons.check_rounded, color: AppColors.accent) : null,
                    onTap: () => Navigator.pop(c, l),
                  ),
              ],
            ),
          ),
        );
        if (picked != null) await ref.read(appLocaleProvider.notifier).set(picked);
      },
    );
  }
}

/// Light, dark or follow the phone (stored on the phone).
class AppearanceTile extends ConsumerWidget {
  const AppearanceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.l10n;
    final current = ref.watch(themeModeProvider);
    String label(ThemeMode m) => switch (m) {
      ThemeMode.light => t.themeLight,
      ThemeMode.dark => t.themeDark,
      ThemeMode.system => t.themeSystem,
    };
    return ListTile(
      leading: Icon(Icons.dark_mode_outlined, color: AppColors.textSecondary),
      title: Text(t.appearance),
      subtitle: Text(label(current)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () async {
        final picked = await showModalBottomSheet<ThemeMode>(
          context: context,
          showDragHandle: true,
          builder: (c) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final m in const [ThemeMode.system, ThemeMode.light, ThemeMode.dark])
                  ListTile(
                    title: Text(label(m)),
                    trailing: m == current ? Icon(Icons.check_rounded, color: AppColors.accent) : null,
                    onTap: () => Navigator.pop(c, m),
                  ),
              ],
            ),
          ),
        );
        if (picked != null) await ref.read(themeModeProvider.notifier).set(picked);
      },
    );
  }
}
