import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:insureiq/app/theme/app_theme.dart';
import 'package:insureiq/features/coverage/coverage_data.dart';
import 'package:insureiq/features/coverage/coverage_report_screen.dart';
import 'package:insureiq/features/home/home_hero.dart';
import 'package:insureiq/features/rewards/rewards_screen.dart';

/// Fixtures are real backend output (app.services.coverage_report.demo_report), so these tests also
/// catch API contract drift.
Map<String, dynamic> _fixture(String name) =>
    jsonDecode(File('test/fixtures/$name.json').readAsStringSync()) as Map<String, dynamic>;

class FakeCoverageRepo extends CoverageRepository {
  FakeCoverageRepo() : super(Dio());

  @override
  Future<CoverageReport> demo(String policyType) async => CoverageReport.fromJson(_fixture('demo_$policyType'));

  @override
  Future<Rewards> rewards() async => Rewards.fromJson({
    'balance': 90,
    'tasks': [
      {'kind': 'profile', 'title': 'Complete your profile', 'coins': 20, 'route': '/x', 'done': true, 'progress': null},
      {
        'kind': 'policy_added',
        'title': 'Add a policy',
        'coins': 50,
        'route': '/add',
        'done': false,
        'progress': '1/10',
      },
    ],
    'history': [
      {'title': 'Complete your profile', 'coins': 20, 'created_at': '2026-10-06T10:00:00Z'},
    ],
    'perks': [
      {'key': 'vouchers', 'title': 'Shopping vouchers', 'icon': 'gift'},
    ],
    'note': 'Coins have no cash value.',
  });
}

Widget _app(Widget child) => ProviderScope(
  overrides: [coverageRepositoryProvider.overrideWithValue(FakeCoverageRepo())],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
    builder: (context, child) =>
        MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child!),
    home: child,
  ),
);

void main() {
  setUpAll(() => initializeDateFormatting('en_IN'));

  setUp(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(400, 860);
    view.devicePixelRatio = 1;
  });

  test('coverage report parses backend output', () {
    final r = CoverageReport.fromJson(_fixture('demo_health'));
    expect(r.demo, isTrue);
    expect(r.scenarios, hasLength(5));
    final rows = {
      for (final s in r.sections) ...{for (final i in s.items) i.key: i},
    };
    expect(rows['maternity']!.status, 'missing');
    expect(rows['sum_insured']!.value, '₹10 lakh');
    expect(r.counts['good'], greaterThan(0));
  });

  testWidgets('sample report: scenarios, sections, row details and type switch', (tester) async {
    await tester.pumpWidget(_app(const CoverageReportScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Will a delivery bill be paid?'), findsOneWidget);
    expect(find.text('Essentials'), findsWidgets);
    expect(find.text('Room rent'), findsOneWidget);
    expect(find.text('1% of sum insured per day'), findsNWidgets(2)); // scenario answer + row

    await tester.ensureVisible(find.text('Room rent'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Room rent'));
    await tester.pumpAndSettle();
    expect(find.text('Why it matters'), findsOneWidget);
    expect(find.textContaining('cut the payout'), findsOneWidget);
    Navigator.of(tester.element(find.text('Why it matters'))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Motor'));
    await tester.pumpAndSettle();
    expect(find.text('Flood-damaged engine — are you covered?'), findsOneWidget);
    expect(find.text('See this for your own policy'), findsOneWidget);
  });

  testWidgets('rewards: earn tasks and coming-soon perks', (tester) async {
    await tester.pumpWidget(_app(const RewardsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('90'), findsOneWidget);
    expect(find.text('1/10 done'), findsOneWidget);
    expect(find.text('+50'), findsOneWidget);
    await tester.tap(find.text('USE COINS'));
    await tester.pumpAndSettle();
    expect(find.text('Shopping vouchers'), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('home hero greets by name and offers add + sample report', (tester) async {
    await tester.pumpWidget(_app(const Scaffold(body: HomeHero(hasPolicies: false))));
    await tester.pump();
    expect(find.text('Will your policy cover'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text(heroScenarios(lookupAppLocalizations(const Locale('en'))).first), findsOneWidget);
    expect(find.text('+50'), findsOneWidget);
    expect(find.text('See a sample report'), findsOneWidget);
  });
}
