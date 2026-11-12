import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../features/auth/domain/financial_year.dart';
import '../database/app_database.dart';
import 'settings_repository.dart';

/// Financial-year invoice numbering, e.g. `GW/2026-27/0001`.
///
/// The counter lives in the `number_sequences` table keyed by
/// prefix + financial year, so a new sequence starts automatically
/// every April and old invoice numbers are never reused. Taking a
/// number happens inside a database transaction: two users billing
/// at the same time can never receive the same number.
class InvoiceSequenceService {
  InvoiceSequenceService(this._db, this._settings, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final SettingsRepository _settings;
  final DateTime Function() _clock;

  /// The sequence key for a prefix in the financial year of [date].
  static String sequenceKey(String prefix, DateTime date) =>
      'invoice:$prefix:${FinancialYear.labelFor(date)}';

  /// Returns (without consuming) the number the next invoice would
  /// get. Used for previews in Settings.
  Future<String> peekNextInvoiceNumber() async {
    final now = _clock();
    final prefix = await _currentPrefix();
    final padding = await _currentPadding();
    final key = sequenceKey(prefix, now);
    final row = await (_db.select(
      _db.numberSequences,
    )..where((t) => t.sequenceKey.equals(key))).getSingleOrNull();
    final next = (row?.lastNumber ?? 0) + 1;
    return InvoiceNumberFormatter.format(
      prefix: prefix,
      financialYearLabel: FinancialYear.labelFor(now),
      sequence: next,
      padding: padding,
    );
  }

  /// Atomically takes the next invoice number.
  Future<String> nextInvoiceNumber() async {
    final now = _clock();
    final prefix = await _currentPrefix();
    final padding = await _currentPadding();
    final key = sequenceKey(prefix, now);
    final next = await _db.transaction(() async {
      final row = await (_db.select(
        _db.numberSequences,
      )..where((t) => t.sequenceKey.equals(key))).getSingleOrNull();
      final value = (row?.lastNumber ?? 0) + 1;
      await _db
          .into(_db.numberSequences)
          .insertOnConflictUpdate(
            NumberSequencesCompanion.insert(
              sequenceKey: key,
              lastNumber: value,
              updatedAt: now.millisecondsSinceEpoch,
            ),
          );
      return value;
    });
    return InvoiceNumberFormatter.format(
      prefix: prefix,
      financialYearLabel: FinancialYear.labelFor(now),
      sequence: next,
      padding: padding,
    );
  }

  Future<String> _currentPrefix() async {
    final prefix = await _settings.getString(
      AppConstants.settingInvoicePrefix,
    );
    return (prefix == null || prefix.isEmpty) ? 'GW' : prefix;
  }

  Future<int> _currentPadding() async {
    final padding = await _settings.getInt(AppConstants.settingInvoicePadding);
    if (padding == null || padding < 1 || padding > 8) return 4;
    return padding;
  }
}

final invoiceSequenceServiceProvider = Provider<InvoiceSequenceService>((
  ref,
) {
  return InvoiceSequenceService(
    ref.watch(appDatabaseProvider),
    ref.watch(settingsRepositoryProvider),
  );
});
