import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_provider.dart';
import '../../auth/data/auth_repository.dart';

/// Audit log viewer (Phase 2): latest entries first. Later phases
/// keep adding action types (price changes, cancellations, returns,
/// payments, backups) into the same table.
class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final logs = ref.watch(_auditProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.auditLog)),
      body: logs.when(
        data: (entries) => entries.isEmpty
            ? Center(child: Text(l10n.loading))
            : ListView.separated(
                itemCount: entries.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final time = DateTime.fromMillisecondsSinceEpoch(
                    entry.createdAt,
                  );
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(entry.action),
                    subtitle: Text(
                      '${entry.entityType ?? ''} ${entry.entityId ?? ''} '
                      '${entry.details ?? ''}',
                    ),
                    trailing: Text(
                      '${time.day}/${time.month}/${time.year} '
                      '${time.hour.toString().padLeft(2, '0')}:'
                      '${time.minute.toString().padLeft(2, '0')}',
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.somethingWentWrong('$e'))),
      ),
    );
  }
}

final _auditProvider = FutureProvider<List<AuditLog>>((ref) {
  return ref.watch(authRepositoryProvider).recentAuditLogs();
});
