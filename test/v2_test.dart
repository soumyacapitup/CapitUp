import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/l10n/app_localizations.dart';
import 'package:insureiq/app/theme/app_theme.dart';
import 'package:insureiq/core/ui/art.dart';
import 'package:insureiq/core/ui/skeleton.dart';
import 'package:insureiq/core/widgets/async_states.dart';
import 'package:insureiq/core/widgets/policy_card.dart';
import 'package:insureiq/features/auth/presentation/onboarding_screen.dart';
import 'package:insureiq/features/home/home_hero.dart';
import 'package:insureiq/features/policy/data/models.dart';
import 'package:insureiq/core/security/app_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _app(Widget child, {List overrides = const []}) => ProviderScope(
  // ignore: argument_type_not_assignable
  overrides: [...overrides],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
    builder: (context, child) =>
        MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child!),
    home: child,
  ),
);

void _size(double w, double h) {
  final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
  view.physicalSize = Size(w, h);
  view.devicePixelRatio = 1;
}

Policy _policy({int days = 12}) => Policy.fromJson({
  'id': 'p1',
  'policy_type': 'health',
  'insurer': 'Star Health',
  'plan_name': 'A very long plan name that keeps going to test ellipsis handling in the card',
  'verified': true,
  'source': 'upload',
  'status': 'expiring_soon',
  'field_confidence': <String, dynamic>{},
  'details': <String, dynamic>{},
  'sum_insured': 1000000,
  'start_date': DateTime.now().subtract(const Duration(days: 353)).toIso8601String().substring(0, 10),
  'end_date': DateTime.now().add(Duration(days: days)).toIso8601String().substring(0, 10),
  'days_to_expiry': days,
});

void main() {
  setUp(() => _size(320, 640)); // a small phone, where overflow bugs show up first

  testWidgets('every scene paints without errors', (tester) async {
    await tester.pumpWidget(
      _app(Scaffold(body: Wrap(children: [for (final s in Scene.values) SceneArt(s, size: 100)]))),
    );
    await tester.pump();
    expect(find.byType(SceneArt), findsNWidgets(Scene.values.length));
  });

  testWidgets('onboarding: four pages, Next advances, last page says Get started (320 px wide)', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(_app(const OnboardingScreen(), overrides: [sharedPrefsProvider.overrideWithValue(prefs)]));
    await tester.pumpAndSettle();
    expect(find.text('All your cover, one place'), findsOneWidget);
    for (final title in ['Ask in plain words', 'Renewals never sneak up', 'Family and nominees, sorted']) {
      await tester.tap(find.text('Next').hitTestable());
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
    }
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Next'), findsNothing);
  });

  testWidgets('policy card shows days left in a validity ring and does not overflow (320 px)', (tester) async {
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: PolicyCard(policy: _policy()),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Ends in 12 days'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('loading shows skeleton blocks, not a spinner', (tester) async {
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: AsyncValueView<int>(value: const AsyncLoading(), data: (_) => const SizedBox()),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(PageSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('empty state shows the illustration and its action', (tester) async {
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: EmptyView(
            icon: Icons.folder,
            title: 'Nothing here yet',
            message: 'Add a policy.',
            action: FilledButton(onPressed: () {}, child: const Text('Add a policy')),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(SceneArt), findsOneWidget);
    expect(find.text('Add a policy'), findsOneWidget);
  });

  testWidgets('service tile is labelled for screen readers and tappable', (tester) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: ServiceTile(icon: Icons.add, label: 'Add policy', color: Colors.teal, onTap: () => taps++),
        ),
      ),
    );
    await tester.tap(find.text('Add policy'));
    expect(taps, 1);
    expect(find.bySemanticsLabel('Add policy'), findsWidgets);
    semantics.dispose();
  });

  test('button labels keep the Indian-script fallback fonts (Hindi on filled/outlined buttons)', () {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      for (final style in [theme.filledButtonTheme.style!, theme.outlinedButtonTheme.style!]) {
        final text = style.textStyle!.resolve({})!;
        expect(text.fontFamilyFallback, contains('NotoSansDevanagari'));
      }
    }
  });
}
