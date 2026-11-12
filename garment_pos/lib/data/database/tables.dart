import 'package:drift/drift.dart';

/// Drift table definitions for Garment POS.
///
/// Phase 1 intentionally contains a single foundation table. Every
/// later phase adds its tables through a schema-version migration
/// (see `AppDatabase` and docs/DATABASE_SCHEMA.md); existing tables
/// and data are never recreated.
///
/// All monetary values in future tables must be integer columns
/// holding paise (see lib/core/utils/money.dart).
class AppSettings extends Table {
  /// Setting name, e.g. `shop_name`. Primary key.
  TextColumn get key => text()();

  /// Setting value stored as text; typed access goes through
  /// SettingsRepository (lib/data/repositories).
  TextColumn get value => text()();

  /// Last update time, epoch milliseconds (UTC-based local time).
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {key};
}
