import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:insureiq/app/theme/app_theme.dart';
import 'package:insureiq/core/security/app_lock.dart';
import 'package:insureiq/features/account/data/account_repository.dart';
import 'package:insureiq/features/auth/data/auth_controller.dart';
import 'package:insureiq/features/auth/data/auth_repository.dart';
import 'package:insureiq/features/coverage/coverage_data.dart';
import 'package:insureiq/features/emergency/emergency_screen.dart';
import 'package:insureiq/features/home/home_screen.dart';
import 'package:insureiq/features/policy/data/models.dart';
import 'package:insureiq/features/policy/data/policy_repository.dart';
import 'package:insureiq/features/portfolio/portfolio_screen.dart';
import 'package:insureiq/features/profile/profile_screen.dart';
import 'package:insureiq/core/strings.dart';
import 'package:insureiq/core/appearance.dart';
import 'package:insureiq/app/theme/app_colors.dart';
import 'package:insureiq/features/account/presentation/settings_screens.dart';
import 'package:insureiq/features/policy/presentation/add_policy_screen.dart';
import 'package:insureiq/features/policy/presentation/nominees_screen.dart';
import 'package:insureiq/features/policy/presentation/policy_detail_screen.dart';

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

/// A health policy with family members and nominees, for the detail and nominee screens.
final _detailed = Policy.fromJson({
  'id': 'd1',
  'policy_type': 'health',
  'insurer': 'Niva Bupa Health Insurance Company Limited',
  'plan_name': 'ReAssure 2.0 Platinum Plus Family Floater',
  'policy_number': 'POL/2025/00012345678901234',
  'verified': true,
  'source': 'upload',
  'status': 'expiring_soon',
  'field_confidence': <String, dynamic>{},
  'details': <String, dynamic>{'room_rent_limit': 'Single private AC room', 'co_payment': '20% above age 60'},
  'sum_insured': 25000000,
  'premium': 148750,
  'payment_frequency': 'half_yearly',
  'start_date': _d(-356),
  'end_date': _d(9),
  'days_to_expiry': 9,
  'document_id': 'doc1',
  'members': [
    {'id': 'm1', 'relation': 'spouse', 'full_name': 'Lakshmi Venkata Durga Prasanna'},
    {'id': 'm2', 'relation': 'child', 'full_name': 'Aarav'},
  ],
  'nominees': [
    {'id': 'n1', 'full_name': 'Lakshmi Venkata Durga Prasanna', 'relation': 'spouse', 'share_percent': 60},
    {'id': 'n2', 'full_name': 'Aarav', 'relation': 'child', 'share_percent': 40, 'appointee_name': 'Lakshmi'},
  ],
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
    'policy detail': () => const PolicyDetailScreen(policyId: 'd1'),
    'nominees': () => const NomineesScreen(policyId: 'd1'),
    'add policy': () => const AddPolicyScreen(),
    'support': () => const SupportScreen(),
    'privacy': () => const PrivacyScreen(),
    'notification settings': () => const NotificationSettingsScreen(),
  };

  for (final entry in screens.entries) {
    for (final (locale, dark) in const [(Locale('en'), false), (Locale('hi'), false), (Locale('en'), true)]) {
      for (final w in [320.0, 360.0, 412.0]) {
        for (final scale in [1.0, 1.3, 1.6]) {
          testWidgets(
            '${entry.key} [${locale.languageCode}${dark ? ', dark' : ''}] with data @ ${w.toInt()}px, text x$scale',
            (tester) async {
              tester.view.physicalSize = Size(w, 2600);
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
                    policyProvider.overrideWith((ref, id) async => _detailed),
                    summaryProvider.overrideWith((ref, id) => Future<PolicySummary>.error(StateError('offline'))),
                    healthProvider.overrideWith((ref, id) => Future<HealthCheck>.error(StateError('offline'))),
                    familyProvider.overrideWith((ref) async => const <FamilyMember>[]),
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
                        child: MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(disableAnimations: true, textScaler: TextScaler.linear(scale)),
                          child: child!,
                        ),
                      ),
                    ),
                    home: entry.value(),
                  ),
                ),
              );
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull);
              // Scroll to the bottom as well, so lower sections are laid out and checked.
              final scrollable = find.byType(Scrollable);
              if (scrollable.evaluate().isNotEmpty) {
                await tester.drag(scrollable.first, const Offset(0, -3000));
                await tester.pumpAndSettle();
                expect(tester.takeException(), isNull);
              }
            },
          );
        }
      }
    }
  }
  tearDown(() {
    strings = lookupAppLocalizations(const Locale('en'));
    AppColors.dark = false;
  });

  testWidgets('switching to dark repaints screens that read AppColors directly, keeping their state', (tester) async {
    final mode = ValueNotifier(ThemeMode.light);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          authControllerProvider.overrideWith(_SignedIn.new),
          policyProvider.overrideWith((ref, id) async => _detailed),
          summaryProvider.overrideWith((ref, id) => Future<PolicySummary>.error(StateError('offline'))),
          healthProvider.overrideWith((ref, id) => Future<HealthCheck>.error(StateError('offline'))),
          familyProvider.overrideWith((ref) async => const <FamilyMember>[]),
        ],
        child: ValueListenableBuilder(
          valueListenable: mode,
          builder: (context, m, _) => MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: m,
            builder: (context, child) => AppThemeScope(child: child!),
            home: const NomineesScreen(policyId: 'd1'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // The legal note is styled with AppColors.textSecondary directly, not through the Theme.
    final note = lookupAppLocalizations(const Locale('en')).nomineeLegalNote;
    Color textColour() => tester.widget<Text>(find.text(note)).style!.color!;
    final lightColour = textColour();
    mode.value = ThemeMode.dark;
    await tester.pumpAndSettle();
    expect(AppColors.dark, isTrue);
    expect(textColour(), isNot(lightColour));
    expect(find.text('Lakshmi Venkata Durga Prasanna'), findsWidgets); // same screen, not reset
  });

  testWidgets('home tiles add no blank gap on a phone with system insets', (tester) async {
    tester.view.physicalSize = const Size(360, 2400); // tall, so the lazy list builds the tiles
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 32, bottom: 120); // status bar + floating nav area
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
          theme: AppTheme.light(),
          builder: (context, child) =>
              MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child!),
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final lastTile = tester.getRect(find.text('Emergency card'));
    final nextSection = tester.getRect(find.text('Coming up'));
    expect(
      nextSection.top - lastTile.bottom,
      lessThan(80),
      reason: 'blank space between the tiles and the next section',
    );
  });
}
