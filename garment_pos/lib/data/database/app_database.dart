import 'package:drift/drift.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// The Garment POS database (SQLite through Drift).
///
/// Schema versioning rules for the whole project:
/// 1. [schemaVersion] only ever increases.
/// 2. Every increase ships with a step in [migration] that upgrades
///    the previous version *without deleting business data*.
/// 3. A migration regression test must prove old data survives.
///
/// History:
/// - v1 (Phase 1): `app_settings`
/// - v2 (Phase 2): users, roles, permissions, role_permissions,
///   user_permissions, audit_logs, number_sequences
@DriftDatabase(
  tables: [
    AppSettings,
    Users,
    Roles,
    Permissions,
    RolePermissions,
    UserPermissions,
    AuditLogs,
    NumberSequences,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Current schema version. Increment by exactly 1 per migration.
  static const int currentSchemaVersion = 3;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          // Phase 2: authentication, roles/permissions, audit log
          // and number sequences. Existing v1 data (app_settings)
          // is untouched by this step.
          await migrator.createTable(users);
          await migrator.createTable(roles);
          await migrator.createTable(permissions);
          await migrator.createTable(rolePermissions);
          await migrator.createTable(userPermissions);
          await migrator.createTable(auditLogs);
          await migrator.createTable(numberSequences);
        }
        // Future steps are added below, oldest first. Each step
        // must preserve existing rows; never drop a business table.
      },
      beforeOpen: (details) async {
        // Enforce foreign keys for every connection.
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
