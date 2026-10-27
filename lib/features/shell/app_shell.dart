import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../core/locale.dart';
import '../../core/ui/pressable.dart';

/// Floating pill navigation with a centre "Add policy" button.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  static const _icons = [
    (Icons.home_outlined, Icons.home_rounded),
    (Icons.folder_outlined, Icons.folder_rounded),
    (Icons.explore_outlined, Icons.explore_rounded),
    (Icons.person_outline_rounded, Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final labels = [t.navHome, t.navPortfolio, t.navExplore, t.navProfile];
    final tabs = [for (var i = 0; i < _icons.length; i++) (_icons[i].$1, _icons[i].$2, labels[i])];
    Widget tab(int i) {
      final (icon, selectedIcon, label) = tabs[i];
      final selected = shell.currentIndex == i;
      return Expanded(
        child: Semantics(
          selected: selected,
          button: true,
          label: label,
          excludeSemantics: true,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => shell.goBranch(i, initialLocation: selected),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.surfaceTint : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      selected ? selectedIcon : icon,
                      size: 24,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(32),
              boxShadow: AppShadows.lift,
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                tab(0),
                tab(1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Pressable(
                    semanticLabel: t.addPolicy,
                    onTap: () => context.push('/add'),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.primaryFill, AppColors.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [BoxShadow(color: Color(0x550B7A75), blurRadius: 14, offset: Offset(0, 6))],
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
                    ),
                  ),
                ),
                tab(2),
                tab(3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
