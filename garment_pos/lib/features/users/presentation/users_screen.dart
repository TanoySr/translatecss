import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_provider.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/domain/permissions.dart';

/// User management (Phase 2): create, edit, enable/disable users,
/// reset passwords and set PINs. Requires the users.manage
/// permission; every action is written to the audit log by
/// AuthRepository.
class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    final canManage =
        auth is AuthSignedIn && auth.can(AppPermissions.usersManage);
    final users = ref.watch(_usersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.users)),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => _showUserDialog(context, ref, null),
              icon: const Icon(Icons.person_add),
              label: Text(l10n.addUser),
            )
          : null,
      body: users.when(
        data: (list) => list.isEmpty
            ? Center(child: Text(l10n.noUsersYet))
            : ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = list[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        user.displayName.isEmpty
                            ? '?'
                            : user.displayName[0].toUpperCase(),
                      ),
                    ),
                    title: Text('${user.displayName} (${user.username})'),
                    subtitle: Text(
                      '${l10n.role}: ${AppRoles.displayName(user.roleName)} • '
                      '${user.isActive ? l10n.active : l10n.inactive}',
                    ),
                    trailing: canManage
                        ? PopupMenuButton<String>(
                            onSelected: (action) =>
                                _onAction(context, ref, user, action),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text(l10n.editUser),
                              ),
                              PopupMenuItem(
                                value: 'password',
                                child: Text(l10n.resetPassword),
                              ),
                              PopupMenuItem(
                                value: 'pin',
                                child: Text(l10n.setPin),
                              ),
                              PopupMenuItem(
                                value: 'toggle',
                                child: Text(
                                  user.isActive ? l10n.disable : l10n.enable,
                                ),
                              ),
                            ],
                          )
                        : null,
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.somethingWentWrong('$e'))),
      ),
    );
  }

  Future<void> _onAction(
    BuildContext context,
    WidgetRef ref,
    AppUser user,
    String action,
  ) async {
    final actor = ref.read(currentUserProvider);
    if (actor == null) return;
    final repo = ref.read(authRepositoryProvider);
    switch (action) {
      case 'edit':
        await _showUserDialog(context, ref, user);
      case 'password':
        await _showSecretDialog(
          context,
          ref,
          title: AppLocalizations.of(context).resetPassword,
          onSave: (value) => repo.resetPassword(
            actorId: actor.id,
            targetUserId: user.id,
            newPassword: value,
          ),
        );
      case 'pin':
        await _showSecretDialog(
          context,
          ref,
          title: AppLocalizations.of(context).setPin,
          onSave: (value) => repo.setPin(
            actorId: actor.id,
            targetUserId: user.id,
            newPin: value,
          ),
        );
      case 'toggle':
        await repo.setUserActive(
          actorId: actor.id,
          userId: user.id,
          active: !user.isActive,
        );
        ref.invalidate(_usersProvider);
    }
  }

  Future<void> _showSecretDialog(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required Future<void> Function(String value) onSave,
  }) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(labelText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (saved == true && controller.text.isNotEmpty) {
      await onSave(controller.text);
      ref.invalidate(_usersProvider);
    }
  }

  Future<void> _showUserDialog(
    BuildContext context,
    WidgetRef ref,
    AppUser? existing,
  ) async {
    final l10n = AppLocalizations.of(context);
    final actor = ref.read(currentUserProvider);
    if (actor == null) return;
    final username = TextEditingController(text: existing?.username ?? '');
    final displayName = TextEditingController(
      text: existing?.displayName ?? '',
    );
    final password = TextEditingController();
    final pin = TextEditingController();
    var roleName = existing?.roleName ?? AppRoles.salesman;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(existing == null ? l10n.addUser : l10n.editUser),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: username,
                  enabled: existing == null,
                  decoration: InputDecoration(labelText: l10n.username),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: displayName,
                  decoration: InputDecoration(labelText: l10n.displayName),
                ),
                if (existing == null) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10n.password),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: pin,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10n.pin),
                  ),
                ],
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: roleName,
                  decoration: InputDecoration(labelText: l10n.role),
                  items: AppRoles.all
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(AppRoles.displayName(r)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => roleName = value ?? roleName),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
          ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
    if (saved != true) return;
    final repo = ref.read(authRepositoryProvider);
    try {
      if (existing == null) {
        await repo.createUser(
          actorId: actor.id,
          username: username.text,
          displayName: displayName.text,
          password: password.text,
          pin: pin.text.trim().isEmpty ? null : pin.text.trim(),
          roleName: roleName,
        );
      } else {
        await repo.updateUser(
          actorId: actor.id,
          userId: existing.id,
          displayName: displayName.text,
          roleName: roleName,
        );
      }
      ref.invalidate(_usersProvider);
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }
}

final _usersProvider = FutureProvider<List<AppUser>>((ref) {
  return ref.watch(authRepositoryProvider).listUsers();
});
