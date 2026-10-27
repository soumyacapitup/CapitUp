import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/appearance.dart';
import '../core/brand.dart';
import '../core/locale.dart';
import '../core/push/push_service.dart';
import '../core/security/app_lock.dart';
import '../core/strings.dart';
import '../features/account/data/account_repository.dart';
import '../features/auth/data/auth_controller.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class InsureApp extends ConsumerWidget {
  const InsureApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    ref.listen(authControllerProvider, (prev, next) {
      if (next.status == AuthStatus.signedIn && prev?.status != AuthStatus.signedIn) {
        PushService.registerForUser(ref.read(accountRepositoryProvider), router);
      }
    });
    return MaterialApp.router(
      title: Brand.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      locale: ref.watch(appLocaleProvider),
      supportedLocales: AppLocaleController.supported,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) => AppThemeScope(
        child: AppStringsScope(child: AppLockGate(child: child ?? const SizedBox.shrink())),
      ),
    );
  }
}
