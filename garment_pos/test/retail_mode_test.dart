import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garment_pos/core/constants/app_constants.dart';
import 'package:garment_pos/data/database/app_database.dart';
import 'package:garment_pos/data/repositories/settings_repository.dart';

void main() {
  group('Retail Mode setting (Phase 2)', () {
    late AppDatabase database;
    late SettingsRepository settings;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      settings = SettingsRepository(database);
    });

    tearDown(() async => database.close());

    test('defaults to OFF (wholesale)', () async {
      expect(
        await settings.getBool(AppConstants.settingRetailModeEnabled),
        isFalse,
      );
    });

    test('can be switched ON and OFF without touching other data', () async {
      await settings.setString(AppConstants.settingShopName, 'My Shop');
      await settings.setBool(AppConstants.settingRetailModeEnabled, true);
      expect(
        await settings.getBool(AppConstants.settingRetailModeEnabled),
        isTrue,
      );
      await settings.setBool(AppConstants.settingRetailModeEnabled, false);
      expect(
        await settings.getBool(AppConstants.settingRetailModeEnabled),
        isFalse,
      );
      // Unrelated data is unchanged by the toggles.
      expect(await settings.getString(AppConstants.settingShopName), 'My Shop');
    });
  });
}
