import 'package:drift/drift.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/settings_repository.dart';
import '../domain/app_user.dart';
import '../domain/password_hasher.dart';
import '../domain/permissions.dart';

/// All user, role, permission and audit-log data access (Phase 2).
///
/// Passwords, PINs and the recovery key are stored only as PBKDF2
/// salted hashes. Every security-relevant mutation writes an
/// audit_logs row in the same call.
class AuthRepository {
  AuthRepository(
    this._db, {
    PasswordHasher? hasher,
    SettingsRepository? settings,
  }) : _hasher = hasher ?? PasswordHasher(),
       _settings = settings ?? SettingsRepository(_db);

  final AppDatabase _db;
  final PasswordHasher _hasher;
  final SettingsRepository _settings;

  int _now() => DateTime.now().millisecondsSinceEpoch;

  // ----------------------------------------------------------------
  // Seeding
  // ----------------------------------------------------------------

  /// Creates roles, permissions and the default matrix when missing.
  /// Safe to call on every app start (idempotent).
  Future<void> ensureSeedData() async {
    await _db.transaction(() async {
      final now = _now();
      for (final roleName in AppRoles.all) {
        final existing = await (_db.select(
          _db.roles,
        )..where((t) => t.name.equals(roleName))).getSingleOrNull();
        if (existing == null) {
          await _db
              .into(_db.roles)
              .insert(
                RolesCompanion.insert(
                  name: roleName,
                  displayName: AppRoles.displayName(roleName),
                  isSystem: true,
                  createdAt: now,
                  updatedAt: now,
                ),
              );
        }
      }
      for (final entry in AppPermissions.all.entries) {
        final existing = await (_db.select(
          _db.permissions,
        )..where((t) => t.permissionKey.equals(entry.key))).getSingleOrNull();
        if (existing == null) {
          await _db
              .into(_db.permissions)
              .insert(
                PermissionsCompanion.insert(
                  permissionKey: entry.key,
                  displayName: entry.value,
                  createdAt: now,
                  updatedAt: now,
                ),
              );
        }
      }
      // Default role grants (only inserted when missing, so admin
      // customisations are never overwritten).
      final roleRows = await _db.select(_db.roles).get();
      final permissionRows = await _db.select(_db.permissions).get();
      for (final role in roleRows) {
        final defaults = AppPermissions.defaultsForRole(role.name);
        for (final permission in permissionRows) {
          final existing =
              await (_db.select(_db.rolePermissions)..where(
                    (t) =>
                        t.roleId.equals(role.id) &
                        t.permissionId.equals(permission.id),
                  ))
                  .getSingleOrNull();
          if (existing == null) {
            await _db
                .into(_db.rolePermissions)
                .insert(
                  RolePermissionsCompanion.insert(
                    roleId: role.id,
                    permissionId: permission.id,
                    allowed: defaults[permission.permissionKey] ?? false,
                    createdAt: now,
                    updatedAt: now,
                  ),
                );
          }
        }
      }
    });
  }

  // ----------------------------------------------------------------
  // Users
  // ----------------------------------------------------------------

  Future<bool> hasAnyUser() async {
    final count = _db.users.id.count();
    final query = _db.selectOnly(_db.users)..addColumns([count]);
    final row = await query.getSingle();
    return (row.read(count) ?? 0) > 0;
  }

  Future<Role> roleByName(String name) {
    return (_db.select(
      _db.roles,
    )..where((t) => t.name.equals(name))).getSingle();
  }

  Future<List<Role>> listRoles() => _db.select(_db.roles).get();

  Future<List<Permission>> listPermissions() =>
      _db.select(_db.permissions).get();

  AppUser _toAppUser(User user, String roleName) {
    return AppUser(
      id: user.id,
      username: user.username,
      displayName: user.displayName,
      roleId: user.roleId,
      roleName: roleName,
      isActive: user.isActive,
      hasPin: user.pinHash != null && user.pinHash!.isNotEmpty,
    );
  }

  Future<AppUser?> userById(int id) async {
    final user = await (_db.select(
      _db.users,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (user == null) return null;
    final role = await (_db.select(
      _db.roles,
    )..where((t) => t.id.equals(user.roleId))).getSingle();
    return _toAppUser(user, role.name);
  }

  /// All users with their role names, newest first.
  Future<List<AppUser>> listUsers() async {
    final query = _db.select(_db.users).join([
      innerJoin(_db.roles, _db.roles.id.equalsExp(_db.users.roleId)),
    ])..orderBy([OrderingTerm.desc(_db.users.id)]);
    final rows = await query.get();
    return rows.map((row) {
      return _toAppUser(
        row.readTable(_db.users),
        row.readTable(_db.roles).name,
      );
    }).toList();
  }

  /// Creates the very first owner (Admin) account during setup and
  /// stores the PBKDF2 hash of the one-time recovery key.
  Future<AppUser> createOwner({
    required String username,
    required String displayName,
    required String password,
    required String pin,
    required String recoveryKeyPlain,
  }) async {
    await ensureSeedData();
    final adminRole = await roleByName(AppRoles.admin);
    final now = _now();
    final passwordHash = await _hasher.hash(password);
    final pinHash = await _hasher.hash(pin);
    final id = await _db
        .into(_db.users)
        .insert(
          UsersCompanion.insert(
            username: username.trim(),
            displayName: displayName.trim(),
            passwordHash: passwordHash,
            pinHash: Value(pinHash),
            roleId: adminRole.id,
            isActive: true,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _settings.setString(
      AppConstants.settingRecoveryKeyHash,
      await _hasher.hash(RecoveryKey.normalize(recoveryKeyPlain)),
    );
    await logAction(
      userId: id,
      action: 'user.setup',
      entityType: 'user',
      entityId: id,
      details: 'Owner account created',
    );
    return (await userById(id))!;
  }

  /// Creates another user. Throws [AuthException] on duplicates.
  Future<AppUser> createUser({
    required int actorId,
    required String username,
    required String displayName,
    required String password,
    String? pin,
    required String roleName,
  }) async {
    final existing = await (_db.select(
      _db.users,
    )..where((t) => t.username.equals(username.trim()))).getSingleOrNull();
    if (existing != null) {
      throw const AuthException('Username already exists');
    }
    final role = await roleByName(roleName);
    final now = _now();
    final id = await _db
        .into(_db.users)
        .insert(
          UsersCompanion.insert(
            username: username.trim(),
            displayName: displayName.trim(),
            passwordHash: await _hasher.hash(password),
            pinHash: pin == null
                ? const Value.absent()
                : Value(await _hasher.hash(pin)),
            roleId: role.id,
            isActive: true,
            createdAt: now,
            updatedAt: now,
            createdBy: Value(actorId),
          ),
        );
    await logAction(
      userId: actorId,
      action: 'user.create',
      entityType: 'user',
      entityId: id,
      details: 'Created user $username ($roleName)',
    );
    return (await userById(id))!;
  }

  Future<void> updateUser({
    required int actorId,
    required int userId,
    required String displayName,
    required String roleName,
  }) async {
    final role = await roleByName(roleName);
    await (_db.update(_db.users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(
        displayName: Value(displayName.trim()),
        roleId: Value(role.id),
        updatedAt: Value(_now()),
      ),
    );
    await logAction(
      userId: actorId,
      action: 'user.update',
      entityType: 'user',
      entityId: userId,
      details: 'Updated user, role=$roleName',
    );
  }

  Future<void> setUserActive({
    required int actorId,
    required int userId,
    required bool active,
  }) async {
    await (_db.update(_db.users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(isActive: Value(active), updatedAt: Value(_now())),
    );
    await logAction(
      userId: actorId,
      action: active ? 'user.enable' : 'user.disable',
      entityType: 'user',
      entityId: userId,
    );
  }

  // ----------------------------------------------------------------
  // Authentication
  // ----------------------------------------------------------------

  /// Username + password login. Returns null on any failure
  /// (unknown user, disabled user or wrong password) so the UI can
  /// show one generic message.
  Future<AppUser?> authenticateWithPassword(
    String username,
    String password,
  ) async {
    final user = await (_db.select(
      _db.users,
    )..where((t) => t.username.equals(username.trim()))).getSingleOrNull();
    if (user == null || !user.isActive) return null;
    if (!await _hasher.verify(password, user.passwordHash)) return null;
    final role = await (_db.select(
      _db.roles,
    )..where((t) => t.id.equals(user.roleId))).getSingle();
    await logAction(userId: user.id, action: 'auth.login_password');
    return _toAppUser(user, role.name);
  }

  /// PIN login for a specific user (user picks their name first).
  Future<AppUser?> authenticateWithPin(int userId, String pin) async {
    final user = await (_db.select(
      _db.users,
    )..where((t) => t.id.equals(userId))).getSingleOrNull();
    if (user == null || !user.isActive) return null;
    final pinHash = user.pinHash;
    if (pinHash == null || pinHash.isEmpty) return null;
    if (!await _hasher.verify(pin, pinHash)) return null;
    final role = await (_db.select(
      _db.roles,
    )..where((t) => t.id.equals(user.roleId))).getSingle();
    await logAction(userId: user.id, action: 'auth.login_pin');
    return _toAppUser(user, role.name);
  }

  /// Users that can appear on the PIN-login picker (active, has PIN).
  Future<List<AppUser>> listUsersForPinLogin() async {
    final users = await listUsers();
    return users.where((u) => u.isActive && u.hasPin).toList();
  }

  // ----------------------------------------------------------------
  // Password / PIN management
  // ----------------------------------------------------------------

  /// Admin resets another user's password (audited).
  Future<void> resetPassword({
    required int actorId,
    required int targetUserId,
    required String newPassword,
  }) async {
    await (_db.update(_db.users)..where((t) => t.id.equals(targetUserId)))
        .write(
          UsersCompanion(
            passwordHash: Value(await _hasher.hash(newPassword)),
            updatedAt: Value(_now()),
          ),
        );
    await logAction(
      userId: actorId,
      action: 'password.reset',
      entityType: 'user',
      entityId: targetUserId,
    );
  }

  /// Sets or replaces a user's PIN (audited without the PIN itself).
  Future<void> setPin({
    required int actorId,
    required int targetUserId,
    required String newPin,
  }) async {
    await (_db.update(_db.users)..where((t) => t.id.equals(targetUserId)))
        .write(
          UsersCompanion(
            pinHash: Value(await _hasher.hash(newPin)),
            updatedAt: Value(_now()),
          ),
        );
    await logAction(
      userId: actorId,
      action: 'pin.change',
      entityType: 'user',
      entityId: targetUserId,
    );
  }

  /// Owner forgot-password flow: verify the recovery key, then set a
  /// new password for the (first) admin account. Returns false when
  /// the key does not match. Audited as `password.recovery_reset`.
  Future<bool> resetAdminPasswordWithRecoveryKey({
    required String recoveryKeyPlain,
    required String newPassword,
  }) async {
    final storedHash = await _settings.getString(
      AppConstants.settingRecoveryKeyHash,
    );
    if (storedHash == null) return false;
    final ok = await _hasher.verify(
      RecoveryKey.normalize(recoveryKeyPlain),
      storedHash,
    );
    if (!ok) return false;
    final adminRole = await roleByName(AppRoles.admin);
    final admin = await (_db.select(_db.users)..where(
          (t) => t.roleId.equals(adminRole.id) & t.isActive.equals(true),
        ))
        .getSingleOrNull();
    if (admin == null) return false;
    await (_db.update(_db.users)..where((t) => t.id.equals(admin.id))).write(
      UsersCompanion(
        passwordHash: Value(await _hasher.hash(newPassword)),
        updatedAt: Value(_now()),
      ),
    );
    await logAction(
      userId: admin.id,
      action: 'password.recovery_reset',
      entityType: 'user',
      entityId: admin.id,
    );
    return true;
  }

  // ----------------------------------------------------------------
  // Permissions
  // ----------------------------------------------------------------

  /// Effective permissions for a user: role defaults overridden by
  /// per-user rows in user_permissions.
  Future<Map<String, bool>> effectivePermissions(int userId) async {
    final user = await (_db.select(
      _db.users,
    )..where((t) => t.id.equals(userId))).getSingleOrNull();
    if (user == null) return const {};
    final permissions = await listPermissions();
    final byId = {for (final p in permissions) p.id: p.permissionKey};
    final result = <String, bool>{
      for (final p in permissions) p.permissionKey: false,
    };
    final roleGrants = await (_db.select(
      _db.rolePermissions,
    )..where((t) => t.roleId.equals(user.roleId))).get();
    for (final grant in roleGrants) {
      final key = byId[grant.permissionId];
      if (key != null) result[key] = grant.allowed;
    }
    final userGrants = await (_db.select(
      _db.userPermissions,
    )..where((t) => t.userId.equals(userId))).get();
    for (final grant in userGrants) {
      final key = byId[grant.permissionId];
      if (key != null) result[key] = grant.allowed;
    }
    return result;
  }

  Future<bool> can(int userId, String permissionKey) async {
    final permissions = await effectivePermissions(userId);
    return permissions[permissionKey] ?? false;
  }

  /// Role matrix as permissionKey -> allowed, for the matrix screen.
  Future<Map<String, bool>> rolePermissions(int roleId) async {
    final permissions = await listPermissions();
    final byId = {for (final p in permissions) p.id: p.permissionKey};
    final result = <String, bool>{
      for (final p in permissions) p.permissionKey: false,
    };
    final grants = await (_db.select(
      _db.rolePermissions,
    )..where((t) => t.roleId.equals(roleId))).get();
    for (final grant in grants) {
      final key = byId[grant.permissionId];
      if (key != null) result[key] = grant.allowed;
    }
    return result;
  }

  /// Updates one cell of the role permission matrix (audited).
  Future<void> setRolePermission({
    required int actorId,
    required int roleId,
    required String permissionKey,
    required bool allowed,
  }) async {
    final permission = await (_db.select(
      _db.permissions,
    )..where((t) => t.permissionKey.equals(permissionKey))).getSingle();
    final now = _now();
    await _db
        .into(_db.rolePermissions)
        .insertOnConflictUpdate(
          RolePermissionsCompanion.insert(
            roleId: roleId,
            permissionId: permission.id,
            allowed: allowed,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await logAction(
      userId: actorId,
      action: 'permission.change',
      entityType: 'role',
      entityId: roleId,
      details: '$permissionKey = $allowed',
    );
  }

  // ----------------------------------------------------------------
  // Audit log
  // ----------------------------------------------------------------

  Future<void> logAction({
    int? userId,
    required String action,
    String? entityType,
    int? entityId,
    String? details,
  }) {
    return _db
        .into(_db.auditLogs)
        .insert(
          AuditLogsCompanion.insert(
            userId: Value(userId),
            action: action,
            entityType: Value(entityType),
            entityId: Value(entityId),
            details: Value(details),
            createdAt: _now(),
          ),
        );
  }

  /// Most recent audit entries first.
  Future<List<AuditLog>> recentAuditLogs({int limit = 200}) {
    final query = _db.select(_db.auditLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.id)])
      ..limit(limit);
    return query.get();
  }
}

/// Business-level authentication failure (e.g. duplicate username).
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
