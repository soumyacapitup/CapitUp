import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:insureiq/app/theme/app_theme.dart';
import 'package:insureiq/core/security/app_lock.dart';
import 'package:insureiq/core/widgets/policy_card.dart';
import 'package:insureiq/features/auth/presentation/onboarding_screen.dart';
import 'package:insureiq/features/coverage/coverage_data.dart';
import 'package:insureiq/features/coverage/coverage_report_screen.dart';
import 'package:insureiq/features/auth/presentation/login_screen.dart';
import 'package:insureiq/features/emergency/emergency_screen.dart';
import 'package:insureiq/features/explore/explore_screen.dart';
import 'package:insureiq/features/home/home_hero.dart';
import 'package:insureiq/features/home/home_screen.dart';
import 'package:insureiq/features/portfolio/portfolio_screen.dart';
import 'package:insureiq/features/profile/profile_screen.dart';
import 'package:insureiq/features/policy/data/models.dart';
import 'package:insureiq/features/rewards/rewards_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coverage_test.dart' show FakeCoverageRepo;

/// Layout sweep: every screen that can be built from fixtures is pumped at common phone widths and at
/// larger system text sizes. Flutter throws on overflow, so a clipped or misaligned layout fails here.
const _widths = [320.0, 360.0, 390.0, 412.0];
const _textScales = [1.0, 1.3, 1.6];
// Hindi words run longer than English, so every screen is also checked in Hindi.
const _locales = [Locale('en'), Locale('hi')];

Policy _policy() => Policy.fromJson({
  'id': 'p1',
  'policy_type': 'health',
  'insurer': 'Niva Bupa Health Insurance Company',
  'plan_name': 'ReAssure 2.0 Platinum Plus Family Floater with a very long name',
  'verified': true,
  'source': 'upload',
  'status': 'expiring_soon',
  'field_confidence': <String, dynamic>{},
  'details': <String, dynamic>{},
  'sum_insured': 10000000,
  'start_date': '2025-10-01',
  'end_date': DateTime.now().add(const Duration(days: 9)).toIso8601String().substring(0, 10),
  'days_to_expiry': 9,
});

void main() {
  setUpAll(() => initializeDateFormatting('en_IN'));

  late SharedPreferences prefs;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  final screens = <String, Widget Function()>{
    'onboarding': () => const OnboardingScreen(),
    'coverage report': () => const CoverageReportScreen(),
    'rewards': () => const RewardsScreen(),
    'login': () => const LoginScreen(),
    'explore': () => const ExploreScreen(),
    'profile': () => const ProfileScreen(),
    'emergency': () => const EmergencyScreen(),
    'portfolio': () => const PortfolioScreen(),
    'home': () => const HomeScreen(),
    'home hero': () => const Scaffold(body: SingleChildScrollView(child: HomeHero(hasPolicies: false))),
    'policy card': () => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PolicyCard(policy: _policy()),
      ),
    ),
  };

  for (final entry in screens.entries) {
    for (final locale in _locales) {
      for (final w in _widths) {
        for (final scale in _textScales) {
          testWidgets('${entry.key} [${locale.languageCode}] @ ${w.toInt()}px, text x$scale', (tester) async {
            final view = tester.view;
            view.physicalSize = Size(w, 780);
            view.devicePixelRatio = 1;
            addTearDown(view.reset);
            await tester.pumpWidget(
              ProviderScope(
                overrides: [
                  coverageRepositoryProvider.overrideWithValue(FakeCoverageRepo()),
                  sharedPrefsProvider.overrideWithValue(prefs),
                ],
                child: MaterialApp(
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: locale,
                  theme: AppTheme.light(),
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(disableAnimations: true, textScaler: TextScaler.linear(scale)),
                    child: child!,
                  ),
                  home: entry.value(),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          });
        }
      }
    }
  }
}
