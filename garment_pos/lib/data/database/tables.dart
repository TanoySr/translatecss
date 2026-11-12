import 'package:drift/drift.dart';

/// Drift table definitions for Garment POS.
///
/// Schema history:
/// - v1 (Phase 1): [AppSettings]
/// - v2 (Phase 2): [Users], [Roles], [Permissions], [RolePermissions],
///   [UserPermissions], [AuditLogs], [NumberSequences]
///
/// All monetary values in future tables must be integer columns
/// holding paise (see lib/core/utils/money.dart). Every table carries
/// created/updated timestamps as epoch milliseconds.
class AppSettings extends Table {
  /// Setting name, e.g. `shop_name`. Primary key.
  TextColumn get key => text()();

  /// Setting value stored as text; typed access goes through
  /// SettingsRepository (lib/data/repositories).
  TextColumn get value => text()();

  /// Last update time, epoch milliseconds.
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Application user accounts (Phase 2). Passwords and PINs are never
/// stored in plain text — only PBKDF2 salted hashes
/// (see PasswordHasher in features/auth).
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Login name, unique across the shop.
  TextColumn get username => text()();

  /// Display name shown in the app header and on invoices.
  TextColumn get displayName => text()();

  /// Encoded PBKDF2 hash: `pbkdf2-sha256$iterations$salt$hash`.
  TextColumn get passwordHash => text()();

  /// Encoded PBKDF2 hash of the 4–6 digit PIN, or null when unset.
  TextColumn get pinHash => text().nullable()();

  /// Role of this user (roles.id).
  IntColumn get roleId => integer().references(Roles, #id)();

  /// Disabled users cannot log in; their history is preserved.
  BoolColumn get isActive => boolean()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  /// User who created this account (users.id), null for the first
  /// owner account created during initial setup.
  IntColumn get createdBy => integer().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {username},
  ];
}

/// User roles: admin, manager, salesman (seeded, Phase 2).
class Roles extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Machine name, e.g. `admin`.
  TextColumn get name => text()();

  /// Human readable name, e.g. `Admin`.
  TextColumn get displayName => text()();

  /// System roles cannot be deleted.
  BoolColumn get isSystem => boolean()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}

/// Every permission that can be granted in the app (seeded from
/// AppPermissions in features/auth/domain, Phase 2).
class Permissions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Machine key, e.g. `profit.view`.
  TextColumn get permissionKey => text()();

  TextColumn get displayName => text()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {permissionKey},
  ];
}

/// Default permission grants per role (the permission matrix).
class RolePermissions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get roleId => integer().references(Roles, #id)();
  IntColumn get permissionId => integer().references(Permissions, #id)();

  BoolColumn get allowed => boolean()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {roleId, permissionId},
  ];
}

/// Per-user permission overrides. When a row exists it wins over the
/// role default for that user.
class UserPermissions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get permissionId => integer().references(Permissions, #id)();

  BoolColumn get allowed => boolean()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, permissionId},
  ];
}

/// Audit trail (Phase 2): who did what, when, to which record.
/// Later phases add entries for price changes, stock adjustments,
/// invoice cancellations, returns, payments, backups, etc.
class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Acting user (users.id); null for system/setup actions.
  IntColumn get userId => integer().nullable()();

  /// Action key, e.g. `user.create`, `password.reset`.
  TextColumn get action => text()();

  /// Affected record type, e.g. `user`, `invoice`.
  TextColumn get entityType => text().nullable()();

  /// Affected record id.
  IntColumn get entityId => integer().nullable()();

  /// Optional human-readable detail.
  TextColumn get details => text().nullable()();

  IntColumn get createdAt => integer()();
}

/// Running number sequences, e.g. invoice numbers per financial
/// year: key `invoice:GW:2026-27` -> last used number.
class NumberSequences extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get sequenceKey => text()();

  IntColumn get lastNumber => integer()();

  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sequenceKey},
  ];
}
