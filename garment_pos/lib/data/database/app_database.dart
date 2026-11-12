import 'package:drift/drift.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// The Garment POS database (SQLite through Drift).
///
/// Schema versioning rules for the whole project:
/// 1. [schemaVersion] only ever increases.
/// 2. Every increase ships with a step in [migration] that upgrades
///    the previous version *without deleting business data*.
/// 3. A migration regression test (test/database_test.dart and the
///    per-phase tests) must prove old data survives the upgrade.
///
/// Phase 1 = schema version 1 (foundation `app_settings` table).
/// Users/auth arrive in Phase 2 (version 2), inventory in Phase 3
/// (version 3), and so on — see docs/DATABASE_SCHEMA.md.
@DriftDatabase(tables: [AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Current schema version. Increment by exactly 1 per migration.
  static const int currentSchemaVersion = 1;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, from, to) async {
        // Future schema steps are added here, oldest first, e.g.:
        // if (from < 2) { ... Phase 2 tables ... }
        // Each step must preserve existing rows. Never drop a
        // business table as part of an upgrade.
      },
      beforeOpen: (details) async {
        // Enforce foreign keys for every connection.
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
