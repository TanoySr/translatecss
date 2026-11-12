import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/app_localizations.dart';

/// Foundation settings screen (Phase 1).
///
/// Only the language preference is editable here, and it is saved to
/// the real SQLite settings table through [localeProvider]. The full
/// shop settings, login and security settings arrive in Phase 2.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.language,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          RadioGroup<Locale>(
            groupValue: locale,
            onChanged: (value) {
              if (value != null) {
                ref.read(localeProvider.notifier).setLocale(value);
              }
            },
            child: Column(
              children: [
                RadioListTile<Locale>(
                  value: AppLocales.bengali,
                  title: Text(l10n.languageBengali),
                ),
                RadioListTile<Locale>(
                  value: AppLocales.english,
                  title: Text(l10n.languageEnglish),
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: Text(l10n.systemStatus),
            subtitle: Text(
              '${l10n.databaseConnected} • '
              '${l10n.databaseSchemaVersion(AppDatabase.currentSchemaVersion)}',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.settingsFoundationNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
