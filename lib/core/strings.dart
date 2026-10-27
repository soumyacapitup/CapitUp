import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// The app's strings for code that has no BuildContext (labels in models and formatters).
/// [AppStringsScope] keeps it in step with the chosen language; it is English until then.
AppLocalizations strings = lookupAppLocalizations(const Locale('en'));

/// Sits under the app's Localizations and updates [strings] whenever the language changes.
/// It is an ancestor of every screen, so it rebuilds (and updates [strings]) before they do.
class AppStringsScope extends StatelessWidget {
  const AppStringsScope({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    strings = AppLocalizations.of(context);
    return child;
  }
}
