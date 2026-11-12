import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

/// Typed access to the `app_settings` key-value table.
///
/// Business data never goes through shared_preferences; it lives in
/// SQLite so it is backed up and migrated together with everything
/// else. (Phase 2 adds the full shop-settings feature on top of this
/// repository and keeps only tiny UI preferences in
/// shared_preferences.)
class SettingsRepository {
  SettingsRepository(this._database);

  final AppDatabase _database;

  /// Returns the raw string value for [key], or `null` when unset.
  Future<String?> getString(String key) async {
    final query = _database.select(_database.appSettings)
      ..where((table) => table.key.equals(key));
    final row = await query.getSingleOrNull();
    return row?.value;
  }

  /// Watches the raw string value for [key].
  Stream<String?> watchString(String key) {
    final query = _database.select(_database.appSettings)
      ..where((table) => table.key.equals(key));
    return query.watchSingleOrNull().map((row) => row?.value);
  }

  /// Creates or replaces the value for [key] in one statement.
  Future<void> setString(String key, String value) {
    return _database
        .into(_database.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  }

  Future<int?> getInt(String key) async {
    final raw = await getString(key);
    return raw == null ? null : int.tryParse(raw);
  }

  Future<void> setInt(String key, int value) => setString(key, '$value');

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final raw = await getString(key);
    if (raw == null) return defaultValue;
    return raw == 'true';
  }

  Future<void> setBool(String key, bool value) =>
      setString(key, value ? 'true' : 'false');

  /// Removes a setting entirely (the row is deleted).
  Future<void> remove(String key) {
    return (_database.delete(
      _database.appSettings,
    )..where((table) => table.key.equals(key))).go();
  }

  /// Number of stored settings (used by the dashboard status card).
  Future<int> count() async {
    final countExpression = _database.appSettings.key.count();
    final query = _database.selectOnly(_database.appSettings)
      ..addColumns([countExpression]);
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }
}

/// Provides the [SettingsRepository] bound to the app database.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(appDatabaseProvider));
});

/// The configured shop name, watched live from the database.
/// Falls back to the product name until Phase 2 settings save one.
final shopNameProvider = StreamProvider<String?>((ref) {
  return ref
      .watch(settingsRepositoryProvider)
      .watchString(AppConstants.settingShopName);
});
