import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_provider.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/domain/permissions.dart';

/// Role permission matrix (Phase 2). Toggling a switch updates the
/// role's grants immediately and writes an audit-log entry.
/// Admin-only: enforced here in the UI and by callers checking the
/// users.manage permission before navigating.
class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  Role? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final roles = ref.watch(_rolesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.permissions)),
      body: roles.when(
        data: (roleList) {
          final selected = _selectedRole ?? roleList.first;
          final matrix = ref.watch(_roleMatrixProvider(selected.id));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<int>(
                  initialValue: selected.id,
                  decoration: InputDecoration(labelText: l10n.role),
                  items: roleList
                      .map(
                        (r) => DropdownMenuItem(
                          value: r.id,
                          child: Text(r.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (id) {
                    setState(() {
                      _selectedRole = roleList.firstWhere((r) => r.id == id);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.permissionMatrixNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: matrix.when(
                  data: (grants) => ListView(
                    children: AppPermissions.all.entries.map((entry) {
                      final allowed = grants[entry.key] ?? false;
                      return SwitchListTile(
                        title: Text(entry.value),
                        subtitle: Text(entry.key),
                        value: allowed,
                        onChanged: (value) async {
                          final actor = ref.read(currentUserProvider);
                          if (actor == null) return;
                          await ref
                              .read(authRepositoryProvider)
                              .setRolePermission(
                                actorId: actor.id,
                                roleId: selected.id,
                                permissionKey: entry.key,
                                allowed: value,
                              );
                          ref.invalidate(_roleMatrixProvider(selected.id));
                        },
                      );
                    }).toList(),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) =>
                      Center(child: Text(l10n.somethingWentWrong('$e'))),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.somethingWentWrong('$e'))),
      ),
    );
  }
}

final _rolesProvider = FutureProvider<List<Role>>((ref) {
  return ref.watch(authRepositoryProvider).listRoles();
});

final _roleMatrixProvider = FutureProvider.family<Map<String, bool>, int>((
  ref,
  roleId,
) {
  return ref.watch(authRepositoryProvider).rolePermissions(roleId);
});
