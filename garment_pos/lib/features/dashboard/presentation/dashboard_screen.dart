import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/settings/app_settings_providers.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_provider.dart';
import '../../auth/domain/permissions.dart';

/// Dashboard (Phase 1 shell, Phase 2 session header).
///
/// Shows real data only: live shop name, signed-in user and role,
/// wholesale/retail mode, database status and module tiles labelled
/// with their delivery phase. Settings, Users, Permissions and
/// Audit Log tiles are live from Phase 2.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shopName = ref.watch(shopNameProvider);
    final auth = ref.watch(authProvider);
    final user = ref.watch(currentUserProvider);
    final retailMode = ref.watch(retailModeProvider).value ?? false;

    final shopTitle = shopName.maybeWhen(
      data: (name) => (name == null || name.isEmpty) ? null : name,
      orElse: () => null,
    );

    final canManageUsers =
        auth is AuthSignedIn && auth.can(AppPermissions.usersManage);
    final canManageSettings =
        auth is AuthSignedIn && auth.can(AppPermissions.settingsManage);
    final canViewAudit =
        auth is AuthSignedIn && auth.can(AppPermissions.auditView);
    final canViewProducts =
        auth is AuthSignedIn && auth.can(AppPermissions.productsView);

    return Scaffold(
      appBar: AppBar(
        title: Text(shopTitle ?? l10n.appTitle),
        actions: [
          const _LanguageMenu(),
          if (canManageSettings)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: l10n.settings,
              onPressed: () => context.go(AppRoutes.settings),
            ),
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: l10n.lockNow,
            onPressed: () => ref.read(authProvider.notifier).lock(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.signOut,
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: (context) => _DashboardBody(
          crossAxisCount: 2,
          canManageUsers: canManageUsers,
          canViewProducts: canViewProducts,
          canManageSettings: canManageSettings,
          canViewAudit: canViewAudit,
        ),
        tablet: (context) => _DashboardBody(
          crossAxisCount: 3,
          canManageUsers: canManageUsers,
          canViewProducts: canViewProducts,
          canManageSettings: canManageSettings,
          canViewAudit: canViewAudit,
        ),
        desktop: (context) => _DashboardBody(
          crossAxisCount: 4,
          canManageUsers: canManageUsers,
          canViewProducts: canViewProducts,
          canManageSettings: canManageSettings,
          canViewAudit: canViewAudit,
        ),
      ),
      bottomNavigationBar: (user == null)
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${l10n.welcomeUser(user.displayName)} • '
                        '${l10n.roleLabel(user.roleName)}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Chip(
                      avatar: Icon(
                        retailMode ? Icons.storefront : Icons.warehouse,
                        size: 18,
                      ),
                      label: Text(
                        retailMode ? l10n.retailModeLabel : l10n.wholesaleMode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Language switcher shown in the dashboard app bar.
class _LanguageMenu extends ConsumerWidget {
  const _LanguageMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: l10n.language,
      initialValue: locale,
      onSelected: (value) =>
          ref.read(localeProvider.notifier).setLocale(value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AppLocales.bengali,
          child: Text(l10n.languageBengali),
        ),
        PopupMenuItem(
          value: AppLocales.english,
          child: Text(l10n.languageEnglish),
        ),
      ],
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({
    required this.crossAxisCount,
    required this.canManageUsers,
    required this.canViewProducts,
    required this.canManageSettings,
    required this.canViewAudit,
  });

  final int crossAxisCount;
  final bool canManageUsers;
  final bool canViewProducts;
  final bool canManageSettings;
  final bool canViewAudit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsCount = ref.watch(_settingsCountProvider);

    final tiles = <(IconData, String, int?, String?)>[
      (Icons.point_of_sale, l10n.modulePointOfSale, 5, null),
      (
        Icons.inventory_2_outlined,
        l10n.moduleInventory,
        canViewProducts ? null : 3,
        canViewProducts ? AppRoutes.inventory : null,
      ),
      (Icons.people_outline, l10n.moduleCustomers, 4, null),
      (Icons.shopping_cart_outlined, l10n.modulePurchase, 7, null),
      (Icons.account_balance_outlined, l10n.moduleAccounts, 9, null),
      (Icons.backup_outlined, l10n.moduleBackup, 10, null),
      if (canManageUsers) (Icons.group_outlined, l10n.users, null, AppRoutes.users),
      if (canManageUsers)
        (
          Icons.admin_panel_settings_outlined,
          l10n.permissions,
          null,
          AppRoutes.permissions,
        ),
      if (canViewAudit)
        (Icons.history, l10n.auditLog, null, AppRoutes.auditLog),
      if (canManageSettings)
        (Icons.settings_outlined, l10n.settings, null, AppRoutes.settings),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.verified_outlined),
            title: Text(l10n.systemStatus),
            subtitle: settingsCount.when(
              data: (count) => Text(
                '${l10n.databaseConnected} • '
                '${l10n.databaseSchemaVersion(AppDatabase.currentSchemaVersion)} • '
                '${l10n.savedSettingsCount(count)}',
              ),
              loading: () => Text(l10n.loading),
              error: (error, _) => Text(l10n.somethingWentWrong('$error')),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.modulesTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
          ),
          itemCount: tiles.length,
          itemBuilder: (context, index) {
            final (icon, label, phase, route) = tiles[index];
            return Card(
              child: InkWell(
                onTap: route == null ? null : () => context.go(route),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (phase != null) ...[
                        const SizedBox(height: 6),
                        Chip(
                          label: Text(l10n.plannedInPhase(phase)),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Live count of rows in the settings table (real database data).
final _settingsCountProvider = FutureProvider<int>((ref) {
  return ref.watch(settingsRepositoryProvider).count();
});
