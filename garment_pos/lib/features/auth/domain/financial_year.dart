/// Indian financial year (1 April – 31 March) helpers and the
/// invoice number formatter.
///
/// Invoice numbers look like `GW/2026-27/0001`:
/// `<prefix>/<financial year>/<zero-padded sequence>`.
/// A new sequence starts every financial year; issued numbers are
/// never reused or changed (see InvoiceSequenceService).
class FinancialYear {
  const FinancialYear._();

  /// Returns the financial-year start year for [date].
  /// April–December belong to the FY starting that calendar year;
  /// January–March belong to the FY started the previous year.
  static int startYearFor(DateTime date) =>
      date.month >= 4 ? date.year : date.year - 1;

  /// Short label, e.g. `2026-27` for FY 2026-04-01..2027-03-31.
  static String labelFor(DateTime date) {
    final start = startYearFor(date);
    final endShort = ((start + 1) % 100).toString().padLeft(2, '0');
    return '$start-$endShort';
  }
}

/// Builds invoice/document numbers from prefix + FY + sequence.
class InvoiceNumberFormatter {
  const InvoiceNumberFormatter._();

  static String format({
    required String prefix,
    required String financialYearLabel,
    required int sequence,
    int padding = 4,
  }) {
    final number = sequence.toString().padLeft(padding, '0');
    return '$prefix/$financialYearLabel/$number';
  }
}
