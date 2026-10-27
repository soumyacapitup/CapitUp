import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/data/account_repository.dart';
import '../security/app_lock.dart';
import 'push_service.dart';
import '../strings.dart';

/// Explains why notifications help before the OS permission dialog appears, once per install.
/// Users who tap "Not now" are not asked again here; they can turn reminders on in settings.
class PushPrompt extends ConsumerStatefulWidget {
  const PushPrompt({super.key, required this.child});
  final Widget child;

  static const prefKey = 'push_prompt_shown';

  @override
  ConsumerState<PushPrompt> createState() => _PushPromptState();
}

class _PushPromptState extends ConsumerState<PushPrompt> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAsk());
  }

  Future<void> _maybeAsk() async {
    final prefs = ref.read(sharedPrefsProvider);
    if (prefs.getBool(PushPrompt.prefKey) ?? false) return;
    if (!await PushService.needsPermission() || !mounted) return;
    await prefs.setBool(PushPrompt.prefKey, true);
    if (!mounted) return;
    final allow = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.neverMissRenewal),
        content: Text(strings.pushPromptBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(strings.notNow)),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(96, 44)),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(strings.allow),
          ),
        ],
      ),
    );
    if (allow == true && mounted) {
      await PushService.registerForUser(ref.read(accountRepositoryProvider), GoRouter.of(context), ask: true);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
