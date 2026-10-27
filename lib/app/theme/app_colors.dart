import 'package:flutter/material.dart';

/// CapitUp v2 design tokens (mirrors replica/design/tokens.json; contrast-checked there).
/// Keep all colours here; widgets never hard-code hex values.
///
/// Status and category base colours are for icons and fills. Text in those colours uses the `*Text` versions.
class AppColors {
  /// True while the dark theme is showing. Set by [AppThemeScope]; every colour below follows it.
  static bool dark = false;

  static Color _c(Color light, Color darkValue) => dark ? darkValue : light;

  // Brand: deep teal + warm gold (from the CapitUp logo). [ink] is the brand's near-black, used as a
  // background (hero, gold-button text) in both themes.
  static const ink = Color(0xFF0B2B2E);

  /// Teal for text, icons, outlines and Material buttons (lighter in dark mode, where buttons carry [ink] text).
  static Color get primary => _c(const Color(0xFF0B7A75), const Color(0xFF4FC3B9));

  /// Teal for filled areas that carry white text (meets AA with white in both themes).
  static Color get primaryFill => const Color(0xFF0B7A75);
  static Color get primaryDark => const Color(0xFF07524F);
  static const gold = Color(0xFFF5A81C);
  static Color get goldText => _c(const Color(0xFF7A4E00), const Color(0xFFF4C163));
  static Color get goldTint => _c(const Color(0xFFFFF3D6), const Color(0xFF33290F));
  static Color get goldWash => _c(const Color(0xFFFFFBF0), const Color(0xFF15130C));
  static Color get goldWashStrong => _c(const Color(0xFFFFF3D1), const Color(0xFF2A2210));
  static Color get goldGlow => _c(const Color(0xFFFFE9B0), const Color(0xFF3D3013));

  /// Kept for existing call sites: the interactive accent is the brand teal.
  static Color get secondary => primary;

  // Status.
  static Color get accent => _c(const Color(0xFF17A06A), const Color(0xFF2DBE83)); // success
  static const warning = Color(0xFFE59E0B);
  static Color get error => _c(const Color(0xFFE5484D), const Color(0xFFFF6B6B));
  static Color get successText => _c(const Color(0xFF0F7A4E), const Color(0xFF5CCF9B));
  static Color get warningText => _c(const Color(0xFF8A5300), const Color(0xFFF2BE5C));
  static Color get errorText => _c(const Color(0xFFB42318), const Color(0xFFFF8A80));
  static Color get unknownText => _c(const Color(0xFF66706D), const Color(0xFF9BA7A4));
  static Color get successTint => _c(const Color(0xFFE4F6EE), const Color(0xFF15302A));
  static Color get warningTint => _c(const Color(0xFFFFF1D6), const Color(0xFF33280F));
  static Color get errorTint => _c(const Color(0xFFFDECEC), const Color(0xFF3A1B1C));
  static Color get infoTint => _c(const Color(0xFFF0F5FF), const Color(0xFF172234));
  static Color get lavenderTint => _c(const Color(0xFFEDEAFB), const Color(0xFF23203A));

  // Surfaces and text.
  static Color get background => _c(const Color(0xFFF6F8F7), const Color(0xFF0E1514));
  static Color get surface => _c(Colors.white, const Color(0xFF172221));
  static Color get surfaceTint => _c(const Color(0xFFEAF5F3), const Color(0xFF1E302D));
  static Color get textPrimary => _c(const Color(0xFF0F1F1D), const Color(0xFFE6EEEC));
  static Color get textSecondary => _c(const Color(0xFF55635F), const Color(0xFFA3B3AF));
  static Color get border => _c(const Color(0xFFE1E8E6), const Color(0xFF2B3B39));
  static Color get skeletonBase => _c(const Color(0xFFE6ECEA), const Color(0xFF1E2A28));
  static Color get skeletonHighlight => _c(const Color(0xFFF4F7F6), const Color(0xFF283633));

  // Policy types.
  static Color get health => _c(const Color(0xFFE5484D), const Color(0xFFFF6B6B));
  static Color get life => _c(const Color(0xFF6D5BD0), const Color(0xFF9D8FF0));
  static Color get motor => _c(const Color(0xFF2F7DE1), const Color(0xFF6AA6F5));
  static Color get other => _c(const Color(0xFF55635F), const Color(0xFFA3B3AF));

  static Color forPolicyType(String type) => switch (type) {
    'health' => health,
    'life' => life,
    'motor' => motor,
    _ => other,
  };

  /// Pale fill behind a policy-type icon.
  static Color tintForPolicyType(String type) => forPolicyType(type).withValues(alpha: dark ? 0.2 : 0.12);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const radius = 20.0;
  static const radiusLg = 28.0;
  static const radiusSm = 14.0;
}

class AppShadows {
  static const card = [BoxShadow(color: Color(0x140B2B2E), blurRadius: 18, offset: Offset(0, 6))];
  static const lift = [BoxShadow(color: Color(0x290B2B2E), blurRadius: 28, offset: Offset(0, 12))];
}
