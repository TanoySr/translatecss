import '../constants/app_constants.dart';

/// Immutable money value stored as integer paise.
///
/// All financial arithmetic in Garment POS (price, discount, tax,
/// profit, due, round-off) must go through integer paise so that
/// results are always exact. Example: ₹100.50 is [Money] with
/// `paise == 10050`.
class Money implements Comparable<Money> {
  const Money(this.paise);

  /// Creates a [Money] value from whole rupees. `Money.fromRupees(100)`
  /// is ₹100.00.
  factory Money.fromRupees(int rupees) =>
      Money(rupees * AppConstants.paisePerRupee);

  /// Parses user-typed text such as `100`, `100.5`, `100.50`,
  /// `₹ 1,00,500.75` into paise without using any floating point math.
  ///
  /// Returns `null` when the text is not a valid amount. A leading `-`
  /// is accepted (used for adjustments/refunds). More than two decimal
  /// digits are rounded half-up to the nearest paise.
  static Money? tryParse(String input) {
    var text = input.trim().replaceAll('₹', '').replaceAll(',', '').trim();
    if (text.isEmpty) return null;

    var negative = false;
    if (text.startsWith('-')) {
      negative = true;
      text = text.substring(1).trim();
    } else if (text.startsWith('+')) {
      text = text.substring(1).trim();
    }
    if (text.isEmpty) return null;

    final parts = text.split('.');
    if (parts.length > 2) return null;

    final rupeesPart = parts[0];
    if (rupeesPart.isEmpty && parts.length == 1) return null;
    final rupees = rupeesPart.isEmpty ? 0 : int.tryParse(rupeesPart);
    if (rupees == null) return null;

    var paisePart = 0;
    if (parts.length == 2) {
      var fraction = parts[1];
      if (fraction.isEmpty) return null;
      if (int.tryParse(fraction) == null) return null;
      var roundUp = false;
      if (fraction.length > 2) {
        roundUp = int.parse(fraction[2]) >= 5;
        fraction = fraction.substring(0, 2);
      }
      paisePart = int.parse(fraction.padRight(2, '0'));
      if (roundUp) paisePart += 1;
    }

    var total = rupees * AppConstants.paisePerRupee + paisePart;
    if (negative) total = -total;
    return Money(total);
  }

  /// Amount in paise. ₹1.00 == 100.
  final int paise;

  static const Money zero = Money(0);

  bool get isZero => paise == 0;
  bool get isNegative => paise < 0;
  bool get isPositive => paise > 0;

  Money operator +(Money other) => Money(paise + other.paise);
  Money operator -(Money other) => Money(paise - other.paise);
  Money operator -() => Money(-paise);

  /// Multiplies by a whole quantity (pieces, sets, cartons).
  Money operator *(int quantity) => Money(paise * quantity);

  /// Percentage of this amount, e.g. `amount.percent(5)` is 5%.
  /// The result is rounded half-up to the nearest paise, entirely in
  /// integer arithmetic, so invoice totals stay reproducible.
  Money percent(int percentage) {
    final sign = paise < 0 ? -1 : 1;
    final absolute = paise.abs();
    final scaled = absolute * percentage;
    final result = (scaled + 50) ~/ 100;
    return Money(sign * result);
  }

  /// Rounds to the nearest whole rupee (used by invoice round-off).
  /// 49 paise rounds down, 50 paise rounds up.
  Money roundToNearestRupee() {
    final sign = paise < 0 ? -1 : 1;
    final absolute = paise.abs();
    final rupees = (absolute + 50) ~/ AppConstants.paisePerRupee;
    return Money(sign * rupees * AppConstants.paisePerRupee);
  }

  /// Formats as Indian Rupees with Indian digit grouping,
  /// e.g. `₹1,00,500.50`. Negative amounts render as `-₹500.00`.
  String format({bool showSymbol = true}) {
    final negative = paise < 0;
    final absolute = paise.abs();
    final rupees = absolute ~/ AppConstants.paisePerRupee;
    final remainder = absolute % AppConstants.paisePerRupee;
    final grouped = _indianGrouping(rupees);
    final symbol = showSymbol ? '₹' : '';
    final sign = negative ? '-' : '';
    return '$sign$symbol$grouped.${remainder.toString().padLeft(2, '0')}';
  }

  /// Formats without paise when the amount is a whole rupee,
  /// e.g. `₹1,000`, otherwise `₹1,000.50`.
  String formatCompact() {
    if (paise % AppConstants.paisePerRupee == 0) {
      final negative = paise < 0;
      final rupees = paise.abs() ~/ AppConstants.paisePerRupee;
      return '${negative ? '-' : ''}₹${_indianGrouping(rupees)}';
    }
    return format();
  }

  /// Indian numbering: last 3 digits, then groups of 2.
  /// 100500 -> `1,00,500`.
  static String _indianGrouping(int value) {
    final digits = value.toString();
    if (digits.length <= 3) return digits;
    final lastThree = digits.substring(digits.length - 3);
    var rest = digits.substring(0, digits.length - 3);
    final groups = <String>[];
    while (rest.length > 2) {
      groups.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) groups.insert(0, rest);
    return '${groups.join(',')},$lastThree';
  }

  @override
  int compareTo(Money other) => paise.compareTo(other.paise);

  bool operator <(Money other) => paise < other.paise;
  bool operator <=(Money other) => paise <= other.paise;
  bool operator >(Money other) => paise > other.paise;
  bool operator >=(Money other) => paise >= other.paise;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Money && other.paise == paise);

  @override
  int get hashCode => paise.hashCode;

  @override
  String toString() => format();
}
