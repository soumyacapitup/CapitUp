import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/core/strings.dart';
import 'package:insureiq/core/appearance.dart';
import 'package:insureiq/app/theme/app_colors.dart';
import 'package:insureiq/l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:insureiq/app/theme/app_theme.dart';
import 'package:insureiq/core/security/app_lock.dart';
import 'package:insureiq/features/account/data/account_repository.dart';
import 'package:insureiq/features/auth/data/auth_controller.dart';
import 'package:insureiq/features/auth/data/auth_repository.dart';
import 'package:insureiq/features/coverage/coverage_data.dart';
import 'package:insureiq/features/auth/presentation/login_screen.dart';
import 'package:insureiq/features/auth/presentation/onboarding_screen.dart';
import 'package:insureiq/features/coverage/coverage_report_screen.dart';
import 'package:insureiq/features/explore/explore_screen.dart';
import 'package:insureiq/features/rewards/rewards_screen.dart';
import 'package:insureiq/features/emergency/emergency_screen.dart';
import 'package:insureiq/features/home/home_screen.dart';
import 'package:insureiq/features/policy/data/models.dart';
import 'package:insureiq/features/policy/data/policy_repository.dart';
import 'package:insureiq/features/portfolio/portfolio_screen.dart';
import 'package:insureiq/features/profile/profile_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'coverage_test.dart' show FakeCoverageRepo;

/// Layout sweep with data loaded: long names, big sums, expiring and expired policies, several insights.
/// (alignment_test.dart covers the screens that can be built without data.)
class _SignedIn extends AuthController {
  @override
  AuthState build() => AuthState(
    AuthStatus.signedIn,
    AppUser(
      id: 'u1',
      fullName: 'Ashish Babu Nannepaga Venkata Subrahmanyam',
      phone: '+919876543210',
      city: 'Hyderabad',
    ),
  );
}

String _d(int days) => DateTime.now().add(Duration(days: days)).toIso8601String().substring(0, 10);

Policy _p(String id, String type, String insurer, String plan, int days, {bool verified = true}) => Policy.fromJson({
  'id': id,
  'policy_type': type,
  'insurer': insurer,
  'plan_name': plan,
  'policy_number': 'POL/2025/00012345678901234',
  'verified': verified,
  'source': 'upload',
  'status': days < 0 ? 'expired' : (days < 30 ? 'expiring_soon' : 'active'),
  'field_confidence': <String, dynamic>{},
  'details': <String, dynamic>{},
  'sum_insured': 25000000,
  'premium': 148750,
  'start_date': _d(days - 365),
  'end_date': _d(days),
  'days_to_expiry': days,
});

final _policies = [
  _p('1', 'health', 'Niva Bupa Health Insurance Company Limited', 'ReAssure 2.0 Platinum Plus Family Floater', 9),
  _p('2', 'motor', 'HDFC ERGO General Insurance', 'Private Car Package Policy Comprehensive', 120),
  _p('3', 'life', 'Life Insurance Corporation of India', 'Jeevan Utsav Single Premium', 400),
  _p('4', 'health', 'Star Health', 'Old plan', -20),
  _p('5', 'health', 'Care', 'Unverified upload', 200, verified: false),
];

PortfolioSummary _portfolio() => PortfolioSummary.fromJson({
  'total_policies': 5,
  'active_policies': 3,
  'expiring_soon': 1,
  'pending_verification': 1,
  'total_annual_premium': 1487500.0,
  'health_cover': 250000000.0,
  'life_cover': 500000000.0,
  'by_type': {'health': 3, 'motor': 1, 'life': 1},
  'upcoming_renewals': [
    for (final p in _policies.take(2))
      {
        'policy_id': p.id,
        'policy_type': p.policyType,
        'insurer': p.insurer,
        'end_date': p.endDate!.toIso8601String().substring(0, 10),
        'days_to_expiry': p.daysToExpiry,
      },
  ],
});

Insights _insights() => Insights.fromJson({
  'insights': [
    {
      'id': 'i1',
      'severity': 'high',
      'category': 'renewal',
      'title': 'Your Niva Bupa ReAssure policy ends in 9 days — renew before it lapses',
      'detail': 'A gap in cover can restart waiting periods for pre-existing conditions.',
      'action_label': 'See policy',
      'action_link': '/policy/1',
    },
    {
      'id': 'i2',
      'severity': 'info',
      'category': 'gap',
      'title': 'No critical illness cover found',
      'detail': 'Consider a top-up.',
      'action_label': null,
      'action_link': null,
    },
  ],
  'disclaimer': 'General information, not advice.',
});

void main() {
  setUpAll(() => initializeDateFormatting('en_IN'));
  late SharedPreferences prefs;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  final screens = <String, Widget Function()>{
    'home': () => const HomeScreen(),
    'portfolio': () => const PortfolioScreen(),
    'emergency': () => const EmergencyScreen(),
    'profile': () => const ProfileScreen(),
    'rewards': () => const RewardsScreen(),
    'sample report': () => const CoverageReportScreen(),
    'explore': () => const ExploreScreen(),
    'login': () => const LoginScreen(),
    'onboarding': () => const OnboardingScreen(),
  };

  for (final entry in screens.entries) {
    for (final (locale, dark) in const [(Locale('en'), false), (Locale('hi'), false), (Locale('en'), true)]) {
      testWidgets(
        '${entry.key} [${locale.languageCode}${dark ? ', dark' : ''}]: tap targets >= 48 dp and every tappable is labelled',
        (tester) async {
          final handle = tester.ensureSemantics();
          tester.view.physicalSize = const Size(360, 800);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                sharedPrefsProvider.overrideWithValue(prefs),
                authControllerProvider.overrideWith(_SignedIn.new),
                policiesProvider.overrideWith((ref) async => _policies),
                portfolioProvider.overrideWith((ref) async => _portfolio()),
                insightsProvider.overrideWith((ref) async => _insights()),
                unreadCountProvider.overrideWith((ref) async => 3),
                coverageRepositoryProvider.overrideWithValue(FakeCoverageRepo()),
              ],
              child: MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: locale,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: dark ? ThemeMode.dark : ThemeMode.light,
                builder: (context, child) => AppThemeScope(
                  child: AppStringsScope(
                    child: MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child!),
                  ),
                ),
                home: entry.value(),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          handle.dispose();
        },
      );
    }
  }
  tearDown(() {
    strings = lookupAppLocalizations(const Locale('en'));
    AppColors.dark = false;
  });
}
