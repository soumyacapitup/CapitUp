import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/l10n/app_localizations.dart';
import 'package:insureiq/app/theme/app_theme.dart';
import 'package:insureiq/core/widgets/policy_card.dart';
import 'package:insureiq/features/policy/data/models.dart';

Policy _policy({bool verified = true, String status = 'expiring_soon', int? days = 12}) => Policy(
  id: 'p1',
  policyType: 'motor',
  insurer: 'Acko',
  sumInsured: 450000,
  verified: verified,
  source: 'manual',
  status: status,
  daysToExpiry: days,
  fieldConfidence: const {},
  details: const {},
);

Widget _wrap(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: AppTheme.light(),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('policy card shows insurer, cover and expiry status', (tester) async {
    await tester.pumpWidget(_wrap(PolicyCard(policy: _policy())));
    expect(find.text('Acko'), findsOneWidget);
    expect(find.text('Motor · ₹4.5 L cover'), findsOneWidget);
    expect(find.text('Ends in 12 days'), findsOneWidget);
  });

  testWidgets('unverified policy asks for review', (tester) async {
    await tester.pumpWidget(_wrap(StatusChip(policy: _policy(verified: false))));
    expect(find.text('Review needed'), findsOneWidget);
  });
}
