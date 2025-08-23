import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/auth_providers.dart';
import 'features/auth/auth_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/referrals/share_link_screen.dart';
import 'features/rewards/rewards_screen.dart';
import 'features/insights/insights_screen.dart';

GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: GoRouterAuthNotifier(ref),
    redirect: (context, state) {
      final loggedIn = ref.read(isLoggedInProvider);
      final loggingIn = state.matchedLocation == '/auth';
      if (!loggedIn) return loggingIn ? null : '/auth';
      if (loggingIn) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (c, s) => const AuthScreen()),
      GoRoute(path: '/dashboard', builder: (c, s) => const DashboardScreen()),
      GoRoute(path: '/share', builder: (c, s) => const ShareLinkScreen()),
      GoRoute(path: '/rewards', builder: (c, s) => const RewardsScreen()),
      GoRoute(path: '/insights', builder: (c, s) => const InsightsScreen()),
    ],
  );
}

class GoRouterAuthNotifier extends ChangeNotifier {
  GoRouterAuthNotifier(this.ref) {
    ref.listen<bool>(isLoggedInProvider, (_, __) => notifyListeners());
  }
  final WidgetRef ref;
}
