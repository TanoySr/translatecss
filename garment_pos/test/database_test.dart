import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garment_pos/core/constants/app_constants.dart';
import 'package:garment_pos/data/database/app_database.dart';
import 'package:garment_pos/data/repositories/settings_repository.dart';

void main() {
  group('AppDatabase (schema v1) + SettingsRepository', () {
    late AppDatabase database;
    late SettingsRepository repository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      repository = SettingsRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('database initialises at schema version 2', () {
      expect(database.schemaVersion, 2);
      expect(AppDatabase.currentSchemaVersion, 2);
    });

    test('Phase 2 tables exist (users, roles, audit, sequences)', () async {
      // Each query would throw if its v2 table had not been created.
      expect(await database.select(database.users).get(), isEmpty);
      expect(await database.select(database.roles).get(), isEmpty);
      expect(await database.select(database.auditLogs).get(), isEmpty);
      expect(await database.select(database.numberSequences).get(), isEmpty);
    });

    test('settings table is created and starts empty', () async {
      expect(await repository.count(), 0);
      expect(await repository.getString(AppConstants.settingShopName), isNull);
    });

    test('a setting can be saved, read back and overwritten', () async {
      await repository.setString(AppConstants.settingShopName, 'My Shop');
      expect(
        await repository.getString(AppConstants.settingShopName),
        'My Shop',
      );

      // Same key must update the single row, not create a duplicate.
      await repository.setString(AppConstants.settingShopName, 'New Shop');
      expect(
        await repository.getString(AppConstants.settingShopName),
        'New Shop',
      );
      expect(await repository.count(), 1);
    });

    test('typed int/bool access round-trips through text storage', () async {
      await repository.setInt('auto_lock_minutes', 5);
      await repository.setBool('retail_mode_enabled', true);

      expect(await repository.getInt('auto_lock_minutes'), 5);
      expect(await repository.getBool('retail_mode_enabled'), isTrue);
      expect(
        await repository.getBool('missing_key', defaultValue: true),
        isTrue,
      );
    });

    test('removing a setting deletes only that key', () async {
      await repository.setString('a', '1');
      await repository.setString('b', '2');
      await repository.remove('a');
      expect(await repository.getString('a'), isNull);
      expect(await repository.getString('b'), '2');
      expect(await repository.count(), 1);
    });
  });
}
