import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garment_pos/core/constants/app_constants.dart';
import 'package:garment_pos/data/database/app_database.dart';
import 'package:garment_pos/data/repositories/invoice_sequence_service.dart';
import 'package:garment_pos/data/repositories/settings_repository.dart';
import 'package:garment_pos/features/auth/domain/financial_year.dart';

void main() {
  group('FinancialYear (Indian FY, Apr–Mar)', () {
    test('April starts a new financial year', () {
      expect(FinancialYear.labelFor(DateTime(2026, 4, 1)), '2026-27');
      expect(FinancialYear.labelFor(DateTime(2026, 12, 31)), '2026-27');
    });

    test('January–March belong to the previous FY', () {
      expect(FinancialYear.labelFor(DateTime(2027, 1, 15)), '2026-27');
      expect(FinancialYear.labelFor(DateTime(2027, 3, 31)), '2026-27');
    });
  });

  group('InvoiceSequenceService', () {
    late AppDatabase database;
    late SettingsRepository settings;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      settings = SettingsRepository(database);
    });

    tearDown(() async => database.close());

    test('formats numbers as PREFIX/FY/0001 and increments', () async {
      final service = InvoiceSequenceService(
        database,
        settings,
        clock: () => DateTime(2026, 6, 15),
      );
      expect(await service.peekNextInvoiceNumber(), 'GW/2026-27/0001');
      expect(await service.nextInvoiceNumber(), 'GW/2026-27/0001');
      expect(await service.nextInvoiceNumber(), 'GW/2026-27/0002');
      expect(await service.peekNextInvoiceNumber(), 'GW/2026-27/0003');
    });

    test('a new financial year starts a fresh sequence', () async {
      var now = DateTime(2026, 6, 15);
      final service = InvoiceSequenceService(
        database,
        settings,
        clock: () => now,
      );
      expect(await service.nextInvoiceNumber(), 'GW/2026-27/0001');
      now = DateTime(2027, 5, 1); // next FY
      expect(await service.nextInvoiceNumber(), 'GW/2027-28/0001');
      // The old year's counter is untouched.
      now = DateTime(2027, 2, 1);
      expect(await service.nextInvoiceNumber(), 'GW/2026-27/0002');
    });

    test('custom prefix from settings is honoured', () async {
      await settings.setString(AppConstants.settingInvoicePrefix, 'RM');
      final service = InvoiceSequenceService(
        database,
        settings,
        clock: () => DateTime(2026, 6, 15),
      );
      expect(await service.nextInvoiceNumber(), 'RM/2026-27/0001');
    });
  });
}
