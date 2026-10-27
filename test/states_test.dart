import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/l10n/app_localizations.dart';
import 'package:insureiq/app/theme/app_theme.dart';
import 'package:insureiq/core/network/api_exception.dart';
import 'package:insureiq/core/widgets/async_states.dart';

/// The shared loading / error / empty states must fit small phones and large text, and the error must be announced.
void main() {
  for (final w in [320.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('loading, error and empty states @ ${w.toInt()}px, text x$scale', (tester) async {
        tester.view.physicalSize = Size(w, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final handle = tester.ensureSemantics();
        final states = <Widget>[
          const AsyncValueView<int>(value: AsyncLoading(), data: _noop),
          AsyncValueView<int>(
            value: AsyncError(
              ApiException('network', 'Could not reach the server. Check your internet connection and try again.'),
              StackTrace.empty,
            ),
            data: _noop,
            onRetry: () {},
          ),
          EmptyView(
            icon: Icons.folder,
            title: 'No policies yet, so there is nothing to show here',
            message: 'Add your first policy to see its cover, renewal date and gaps in one place.',
            action: FilledButton(onPressed: () {}, child: const Text('Add a policy')),
          ),
        ];
        for (final state in states) {
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: AppTheme.light(),
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(disableAnimations: true, textScaler: TextScaler.linear(scale)),
                  child: child!,
                ),
                home: Scaffold(body: state),
              ),
            ),
          );
          await tester.pump();
          expect(tester.takeException(), isNull);
        }
        handle.dispose();
      });
    }
  }
}

Widget _noop(int _) => const SizedBox();
