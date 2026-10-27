import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/l10n/app_localizations.dart';
import 'package:insureiq/app/theme/app_theme.dart';
import 'package:insureiq/features/auth/data/auth_repository.dart';
import 'package:insureiq/features/insights/insights_screen.dart';
import 'package:insureiq/features/policy/data/models.dart';
import 'package:insureiq/features/policy/data/policy_repository.dart';
import 'package:insureiq/features/policy/presentation/clauses_screen.dart';
import 'package:insureiq/features/portfolio/compare_screen.dart';

class FakeRepo extends PolicyRepository {
  FakeRepo() : super(Dio());

  @override
  Future<List<Clause>> clauses(String policyId) async => [
    Clause(
      type: 'exclusion',
      tags: ['exclusion'],
      title: 'Cosmetic surgery',
      text: 'Cosmetic surgery is not covered.',
      page: 3,
    ),
    Clause(
      type: 'waiting_period',
      tags: ['waiting_period', 'benefit'],
      title: 'Maternity',
      text: 'Maternity is covered after 24 months.',
      page: 2,
    ),
  ];

  @override
  Future<Comparison> compare(List<String> ids) async => Comparison.fromJson({
    'policy_type': 'health',
    'policies': [
      {'id': 'a', 'insurer': 'Star Health'},
      {'id': 'b', 'insurer': 'HDFC ERGO'},
    ],
    'rows': [
      {
        'section': 'Overview',
        'label': 'Sum insured',
        'values': ['₹10,00,000', '₹5,00,000'],
        'best_index': 0,
      },
      {
        'section': 'Features',
        'label': 'Co-payment',
        'values': ['No co-payment.', 'You pay 20% of every claim yourself.'],
        'best_index': null,
        'grades': ['strong', 'attention'],
      },
    ],
    'disclaimer': 'Compares only what we read.',
  });
}

Widget _app(Widget child) => ProviderScope(
  overrides: [policyRepositoryProvider.overrideWithValue(FakeRepo())],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
    home: child,
  ),
);

void main() {
  test('user preferences are parsed (regression: toggles always showed on)', () {
    final u = AppUser.fromJson({
      'id': 'u',
      'notify_renewals': false,
      'notify_processing': false,
      'preferred_language': 'hi',
    });
    expect(u.notifyRenewals, isFalse);
    expect(u.notifyProcessing, isFalse);
    expect(u.preferredLanguage, 'hi');
  });

  test('nominee minor detection and policy nominees parsing', () {
    final now = DateTime.now();
    final n = Nominee.fromJson({
      'id': 'n',
      'full_name': 'Meera',
      'relation': 'child',
      'share_percent': 40,
      'date_of_birth': DateTime(now.year - 7, 1, 1).toIso8601String().substring(0, 10),
      'appointee_name': 'Ravi',
    });
    expect(n.isMinor, isTrue);
    final adult = Nominee.fromJson({
      'id': 'm',
      'full_name': 'Ravi',
      'relation': 'spouse',
      'share_percent': 60,
      'date_of_birth': '1988-02-03',
    });
    expect(adult.isMinor, isFalse);
  });

  test('answers parse related clauses', () {
    final a = Answer.fromJson({
      'id': 'a',
      'question': 'q',
      'answer': 'x',
      'answerable': true,
      'confidence': 'medium',
      'citations': [],
      'disclaimer': 'd',
      'related_clauses': [
        {'type': 'waiting_period', 'title': 'Maternity', 'text': 'Maternity ... 24 months', 'page': 2},
      ],
    });
    expect(a.relatedClauses.single.type, 'waiting_period');
  });

  testWidgets('clauses screen filters by type', (tester) async {
    await tester.pumpWidget(_app(const ClausesScreen(policyId: 'p')));
    await tester.pumpAndSettle();
    expect(find.text('All (2)'), findsOneWidget);
    expect(find.text('Cosmetic surgery is not covered.'), findsOneWidget);
    await tester.tap(find.text('Exclusion (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Maternity is covered after 24 months.'), findsNothing);
    await tester.tap(find.text('Benefit (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Maternity is covered after 24 months.'), findsOneWidget);
  });

  testWidgets('comparison highlights the better value', (tester) async {
    await tester.pumpWidget(_app(const CompareScreen(ids: 'a,b')));
    await tester.pumpAndSettle();
    expect(find.text('Star Health'), findsOneWidget);
    expect(find.text('₹10,00,000'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(find.text('You pay 20% of every claim yourself.'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('insight tile shows title, detail and action', (tester) async {
    final insight = Insight.fromJson({
      'id': 'gap:no-health',
      'severity': 'high',
      'category': 'gap',
      'title': 'No health insurance found',
      'detail': 'Add your policy.',
      'action_label': 'Add policy',
      'action_link': null,
      'policy_id': null,
    });
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: InsightTile(insight)),
      ),
    );
    expect(find.text('No health insurance found'), findsOneWidget);
    expect(find.text('Add policy →'), findsOneWidget);
    expect(find.byIcon(Icons.priority_high_rounded), findsOneWidget);
  });
}
