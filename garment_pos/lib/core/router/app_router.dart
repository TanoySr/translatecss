import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

/// Central route table for Garment POS (go_router).
///
/// Phase 1 ships the dashboard shell and a foundation settings
/// screen. Later phases register their routes here (login in
/// Phase 2, POS in Phase 5, ...) — route paths are stable from the
/// start so deep links and shortcuts never break.
class AppRoutes {
  const AppRoutes._();

  static const String dashboard = '/';
  static const String settings = '/settings';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
