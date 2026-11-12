import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../l10n/app_localizations.dart';

/// Phase 1 dashboard shell.
///
/// Shows real data only: the live shop name, database connectivity,
/// schema version and saved-settings count, all read from SQLite.
/// Business modules appear as tiles labelled with the phase that
/// will implement them; no fake sales/profit numbers are shown.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shopName = ref.watch(shopNameProvider);

    final shopTitle = shopName.maybeWhen(
      data: (name) => (name == null || name.isEmpty) ? null : name,
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(shopTitle ?? l10n.appTitle),
        actions: [
          const _LanguageMenu(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: (context) => const _DashboardBody(crossAxisCount: 2),
        tablet: (context) => const _DashboardBody(crossAxisCount: 3),
        desktop: (context) => const _DashboardBody(crossAxisCount: 4),
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
  const _DashboardBody({required this.crossAxisCount});

  final int crossAxisCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsCount = ref.watch(_settingsCountProvider);

    final modules = <(IconData, String, int)>[
      (Icons.point_of_sale, l10n.modulePointOfSale, 5),
      (Icons.inventory_2_outlined, l10n.moduleInventory, 3),
      (Icons.people_outline, l10n.moduleCustomers, 4),
      (Icons.shopping_cart_outlined, l10n.modulePurchase, 7),
      (Icons.account_balance_outlined, l10n.moduleAccounts, 9),
      (Icons.backup_outlined, l10n.moduleBackup, 10),
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
              error: (error, _) =>
                  Text(l10n.somethingWentWrong('$error')),
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
          itemCount: modules.length,
          itemBuilder: (context, index) {
            final (icon, label, phase) = modules[index];
            return Card(
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
                    const SizedBox(height: 6),
                    Chip(
                      label: Text(l10n.plannedInPhase(phase)),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
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
