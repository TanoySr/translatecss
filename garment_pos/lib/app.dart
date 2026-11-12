import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/localization/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/security/activity_tracker.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_provider.dart';
import 'features/auth/presentation/lock_screen.dart';
import 'l10n/app_localizations.dart';

/// Root widget of Garment POS.
///
/// Wires the Material 3 theme, go_router navigation and
/// Bengali/English localization, and enforces the Phase 2 session
/// rules globally:
/// - while the session is [AuthLocked], the lock screen replaces
///   the whole UI;
/// - [ActivityTracker] locks the session after inactivity.
class GarmentPosApp extends ConsumerWidget {
  const GarmentPosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final auth = ref.watch(authProvider);
    return MaterialApp.router(
      title: 'Garment POS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: locale,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
      builder: (context, child) {
        if (auth is AuthLocked) {
          return LockScreen(user: auth.user);
        }
        return ActivityTracker(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
