import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import 'security/app_lock.dart';
import '../core/locale.dart';

export '../l10n/app_localizations.dart';

/// The app's screen language (English or Hindi). Stored on the phone, so it works before sign-in.
/// AI answers have their own language, set per user on the server (Profile > AI answer language).
final appLocaleProvider = NotifierProvider<AppLocaleController, Locale>(AppLocaleController.new);

class AppLocaleController extends Notifier<Locale> {
  static const _key = 'app_locale';
  static const supported = [Locale('en'), Locale('hi')];

  @override
  Locale build() {
    final saved = ref.read(sharedPrefsProvider).getString(_key);
    return supported.firstWhere((l) => l.languageCode == saved, orElse: () => supported.first);
  }

  Future<void> set(Locale locale) async {
    await ref.read(sharedPrefsProvider).setString(_key, locale.languageCode);
    state = locale;
  }
}

/// Shorthand: `context.l10n.getOtp`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Compact English / हिन्दी switch, used on the welcome and login screens.
class LanguageSwitch extends ConsumerWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(appLocaleProvider);
    final other = current.languageCode == 'hi' ? const Locale('en') : const Locale('hi');
    return TextButton.icon(
      onPressed: () => ref.read(appLocaleProvider.notifier).set(other),
      icon: const Icon(Icons.translate_rounded, size: 18),
      label: Text(lookupAppLocalizations(other).languageName),
    );
  }
}
