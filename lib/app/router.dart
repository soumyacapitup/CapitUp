import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/async_states.dart';
import '../features/account/presentation/family_screen.dart';
import '../features/account/presentation/notifications_screen.dart';
import '../features/account/presentation/settings_screens.dart';
import '../features/assistant/ask_screen.dart';
import '../features/auth/data/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/auth/presentation/profile_setup_screen.dart';
import '../features/coverage/coverage_report_screen.dart';
import '../features/emergency/emergency_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/home/home_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/policy/presentation/clauses_screen.dart';
import '../features/policy/presentation/nominees_screen.dart';
import '../features/portfolio/compare_screen.dart';
import '../features/policy/presentation/add_policy_screen.dart';
import '../features/policy/presentation/policy_detail_screen.dart';
import '../features/policy/presentation/policy_form_screen.dart';
import '../features/policy/presentation/policy_health_screen.dart';
import '../features/policy/presentation/processing_screen.dart';
import '../features/portfolio/portfolio_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/rewards/rewards_screen.dart';
import '../features/shell/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(authControllerProvider, (_, _) => refresh.value++);
  ref.listen(onboardingDoneProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final loc = state.matchedLocation;
      final onAuthPage = loc == '/login' || loc == '/otp' || loc == '/welcome';
      final onboarded = ref.read(onboardingDoneProvider);
      return switch (auth.status) {
        AuthStatus.unknown => loc == '/splash' ? null : '/splash',
        AuthStatus.signedOut when !onboarded => loc == '/welcome' ? null : '/welcome',
        AuthStatus.signedOut => (onAuthPage && loc != '/welcome') ? null : '/login',
        AuthStatus.signedIn when auth.needsProfile => loc == '/profile-setup' ? null : '/profile-setup',
        AuthStatus.signedIn => (onAuthPage || loc == '/splash' || loc == '/profile-setup') ? '/' : null,
      };
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, _) => const Scaffold(body: LoadingView()),
      ),
      GoRoute(path: '/welcome', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: '/otp',
        builder: (_, s) => OtpScreen(args: s.extra! as OtpArgs),
      ),
      GoRoute(path: '/profile-setup', builder: (_, _) => const ProfileSetupScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/', builder: (_, _) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/portfolio', builder: (_, _) => const PortfolioScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/explore', builder: (_, _) => const ExploreScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen())],
          ),
        ],
      ),
      GoRoute(path: '/add', builder: (_, _) => const AddPolicyScreen()),
      GoRoute(
        path: '/report/sample',
        builder: (_, s) => CoverageReportScreen(initialType: s.uri.queryParameters['type'] ?? 'health'),
      ),
      GoRoute(path: '/rewards', builder: (_, _) => const RewardsScreen()),
      GoRoute(path: '/emergency', builder: (_, _) => const EmergencyScreen()),
      GoRoute(path: '/family', builder: (_, _) => const FamilyScreen()),
      GoRoute(path: '/insights', builder: (_, _) => const InsightsScreen()),
      GoRoute(path: '/compare', builder: (_, _) => const CompareSelectScreen()),
      GoRoute(
        path: '/compare/view',
        builder: (_, s) => CompareScreen(ids: s.uri.queryParameters['ids'] ?? ''),
      ),
      GoRoute(path: '/notifications', builder: (_, _) => const NotificationsScreen()),
      GoRoute(path: '/settings/notifications', builder: (_, _) => const NotificationSettingsScreen()),
      GoRoute(path: '/settings/profile', builder: (_, _) => const EditProfileScreen()),
      GoRoute(path: '/support', builder: (_, _) => const SupportScreen()),
      GoRoute(path: '/privacy', builder: (_, _) => const PrivacyScreen()),
      GoRoute(
        path: '/add/manual',
        builder: (_, _) => const PolicyFormScreen(mode: PolicyFormMode.manual),
      ),
      GoRoute(
        path: '/add/processing/:documentId',
        builder: (_, s) => ProcessingScreen(documentId: s.pathParameters['documentId']!),
      ),
      GoRoute(
        path: '/policy/:id',
        builder: (_, s) => PolicyDetailScreen(policyId: s.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'verify',
            builder: (_, s) => PolicyFormScreen(mode: PolicyFormMode.verify, policyId: s.pathParameters['id']),
          ),
          GoRoute(
            path: 'edit',
            builder: (_, s) => PolicyFormScreen(mode: PolicyFormMode.edit, policyId: s.pathParameters['id']),
          ),
          GoRoute(
            path: 'ask',
            builder: (_, s) =>
                AskScreen(policyId: s.pathParameters['id']!, initialQuestion: s.uri.queryParameters['q']),
          ),
          GoRoute(
            path: 'health',
            builder: (_, s) => PolicyHealthScreen(policyId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'report',
            builder: (_, s) => CoverageReportScreen(policyId: s.pathParameters['id']),
          ),
          GoRoute(
            path: 'nominees',
            builder: (_, s) => NomineesScreen(policyId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'clauses',
            builder: (_, s) => ClausesScreen(policyId: s.pathParameters['id']!),
          ),
        ],
      ),
    ],
  );
});
