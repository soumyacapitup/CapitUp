import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/locale.dart';

/// Shown when content came from the offline MOCK AI provider (development/demo backends),
/// so nobody mistakes heuristic output for real AI analysis.
class DemoAiBadge extends StatelessWidget {
  const DemoAiBadge({super.key, required this.provider});
  final String? provider;

  @override
  Widget build(BuildContext context) {
    if (provider != 'mock') return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(6)),
      child: Text(
        context.l10n.demoMode,
        style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
      ),
    );
  }
}
