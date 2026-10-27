import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/theme/app_colors.dart';
import 'security/app_lock.dart';

/// Light, dark or follow the phone. Stored on the phone, so it works before sign-in.
final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    final saved = ref.read(sharedPrefsProvider).getString(_key);
    return ThemeMode.values.firstWhere((m) => m.name == saved, orElse: () => ThemeMode.system);
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPrefsProvider).setString(_key, mode.name);
  }
}

/// Sits under the app's Theme and keeps [AppColors.dark] in step with it. Screens read [AppColors] directly,
/// so when the brightness flips every widget is rebuilt once (state, scroll positions and the page stack are kept).
class AppThemeScope extends StatefulWidget {
  const AppThemeScope({super.key, required this.child});
  final Widget child;

  @override
  State<AppThemeScope> createState() => _AppThemeScopeState();
}

class _AppThemeScopeState extends State<AppThemeScope> {
  bool? _shown;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    AppColors.dark = dark;
    if (_shown != null && _shown != dark) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _rebuildAll(context as Element);
      });
    }
    _shown = dark;
    return widget.child;
  }

  static void _rebuildAll(Element element) {
    element.markNeedsBuild();
    element.visitChildren(_rebuildAll);
  }
}
