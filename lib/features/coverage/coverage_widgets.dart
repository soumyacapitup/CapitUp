import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/locale.dart';

/// Colour, icon and words for each row status, shared by the report, the cards and the home hero.
class StatusStyle {
  const StatusStyle(this.icon, this.color, this.textColor, this.label);
  final IconData icon;

  /// Icon colour.
  final Color color;

  /// Text colour (darker, meets WCAG AA).
  final Color textColor;
  final String label;

  static StatusStyle of(String status, AppLocalizations t) => switch (status) {
    'good' => StatusStyle(Icons.check_circle_rounded, AppColors.accent, AppColors.successText, t.statusCovered),
    'limited' => StatusStyle(Icons.error_rounded, AppColors.warning, AppColors.warningText, t.statusLimited),
    'missing' => StatusStyle(Icons.cancel_rounded, AppColors.error, AppColors.errorText, t.statusMissing),
    'info' => StatusStyle(Icons.info_rounded, AppColors.secondary, AppColors.secondary, t.statusInfo),
    _ => StatusStyle(Icons.help_rounded, const Color(0xFF9AA3B2), AppColors.unknownText, t.statusUnknown),
  };
}

class RatingBadge extends StatelessWidget {
  const RatingBadge(this.rating, {super.key});
  final String rating;

  @override
  Widget build(BuildContext context) {
    final (color, label, icon) = switch (rating) {
      'strong' => (AppColors.accent, context.l10n.ratingStrong, Icons.speed_rounded),
      'fair' => (AppColors.warning, context.l10n.ratingFair, Icons.speed_rounded),
      _ => (const Color(0xFFFF7A7A), context.l10n.ratingWeak, Icons.speed_rounded),
    };
    return Semantics(
      label: context.l10n.ratingLabel(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: AppColors.textPrimary, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small illustration for a scenario card: a large tinted disc with an icon, a smaller overlapping
/// disc and a few soft dots. Drawn from icons, so it needs no image assets.
class ScenarioArt extends StatelessWidget {
  const ScenarioArt(this.art, {super.key, this.size = 120});
  final String art;
  final double size;

  static (IconData, IconData, Color) _spec(String art) => switch (art) {
    'maternity' => (Icons.pregnant_woman_rounded, Icons.receipt_long_rounded, const Color(0xFFE8579A)),
    'room' => (Icons.king_bed_rounded, Icons.currency_rupee_rounded, AppColors.secondary),
    'clock' => (Icons.medical_information_rounded, Icons.schedule_rounded, const Color(0xFF7C4DFF)),
    'refresh' => (Icons.currency_rupee_rounded, Icons.autorenew_rounded, AppColors.secondary),
    'wallet' => (Icons.account_balance_wallet_rounded, Icons.percent_rounded, const Color(0xFF0E9F9A)),
    'family' => (Icons.family_restroom_rounded, Icons.currency_rupee_rounded, AppColors.life),
    'nominee' => (Icons.person_rounded, Icons.how_to_reg_rounded, AppColors.life),
    'exit' => (Icons.savings_rounded, Icons.logout_rounded, const Color(0xFFE59E0B)),
    'growth' => (Icons.trending_up_rounded, Icons.flag_rounded, AppColors.accent),
    'engine' => (Icons.settings_rounded, Icons.water_drop_rounded, AppColors.secondary),
    'parts' => (Icons.build_rounded, Icons.trending_down_rounded, const Color(0xFFE59E0B)),
    'theft' => (Icons.directions_car_rounded, Icons.receipt_rounded, AppColors.error),
    'tow' => (Icons.car_crash_rounded, Icons.support_agent_rounded, AppColors.warning),
    'car' => (Icons.directions_car_filled_rounded, Icons.verified_user_rounded, AppColors.motor),
    _ => (Icons.shield_rounded, Icons.help_rounded, AppColors.secondary),
  };

  @override
  Widget build(BuildContext context) {
    final (main, badge, color) = _spec(art);
    final s = size;
    return ExcludeSemantics(
      child: SizedBox(
        width: s * 1.6,
        height: s,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (final (dx, dy, r) in [(0.05, 0.15, 0.06), (1.45, 0.1, 0.05), (1.5, 0.75, 0.08), (0.1, 0.8, 0.04)])
              Positioned(
                left: s * dx,
                top: s * dy,
                child: CircleAvatar(radius: s * r, backgroundColor: color.withValues(alpha: 0.12)),
              ),
            Positioned(
              left: s * 0.3,
              top: 0,
              child: Container(
                width: s,
                height: s,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [color.withValues(alpha: 0.75), color],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8)),
                  ],
                ),
                child: Icon(main, color: Colors.white, size: s * 0.5),
              ),
            ),
            Positioned(
              left: s * 1.0,
              top: s * 0.5,
              child: Container(
                width: s * 0.46,
                height: s * 0.46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: AppColors.border, width: 2),
                  boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Icon(badge, color: color, size: s * 0.24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gold coin used for rewards.
class CoinIcon extends StatelessWidget {
  const CoinIcon({super.key, this.size = 18});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(
        colors: [Color(0xFFFFE08A), Color(0xFFE0A526)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: const Color(0xFFC98A12), width: size * 0.06),
    ),
    child: Icon(Icons.trending_up_rounded, size: size * 0.6, color: const Color(0xFF9A6408)),
  );
}

/// "+50" coin chip shown next to actions that earn coins.
class CoinChip extends StatelessWidget {
  const CoinChip(this.text, {super.key, this.dark = false});
  final String text;
  final bool dark;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(4, 3, 10, 3),
    decoration: BoxDecoration(
      color: dark ? Colors.white.withValues(alpha: 0.18) : AppColors.goldTint,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CoinIcon(size: 18),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: dark ? Colors.white : AppColors.goldText),
        ),
      ],
    ),
  );
}
