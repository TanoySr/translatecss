import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_provider.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/setup_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/users/presentation/audit_log_screen.dart';
import '../../features/users/presentation/permissions_screen.dart';
import '../../features/users/presentation/users_screen.dart';
import '../../l10n/app_localizations.dart';

/// Central route table for Garment POS (go_router).
///
/// `/` is the auth gate: it decides between first-time setup, login
/// and the dashboard from [authProvider]. Locked sessions are
/// handled globally in GarmentPosApp, so no route is reachable
/// while locked.
class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String settings = '/settings';
  static const String users = '/users';
  static const String permissions = '/permissions';
  static const String auditLog = '/audit-log';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.users,
      name: 'users',
      builder: (context, state) => const UsersScreen(),
    ),
    GoRoute(
      path: AppRoutes.permissions,
      name: 'permissions',
      builder: (context, state) => const PermissionsScreen(),
    ),
    GoRoute(
      path: AppRoutes.auditLog,
      name: 'audit-log',
      builder: (context, state) => const AuditLogScreen(),
    ),
  ],
);

/// Decides the first screen from the authentication state.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(authProvider)) {
      AuthLoading() => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.loading),
            ],
          ),
        ),
      ),
      AuthNeedsSetup() => const SetupScreen(),
      AuthSignedOut() => const LoginScreen(),
      AuthLocked() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      AuthSignedIn() => const DashboardScreen(),
    };
  }
}
