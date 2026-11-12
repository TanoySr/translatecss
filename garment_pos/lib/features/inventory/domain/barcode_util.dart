/// Internal barcode generation for product variants.
///
/// Every variant gets a unique 13-digit EAN-style code that starts
/// with `20` (the GS1 prefix range reserved for internal/store use),
/// followed by the zero-padded variant id and a standard EAN-13
/// check digit. Scanners read it like any EAN-13, but it can never
/// collide with a manufacturer's real EAN.
class BarcodeUtil {
  const BarcodeUtil._();

  /// Builds the full 13-digit code for a variant id.
  static String forVariantId(int variantId) {
    if (variantId < 0 || variantId > 999999999) {
      throw ArgumentError('variantId out of range: $variantId');
    }
    final first12 = '20${variantId.toString().padLeft(10, '0')}';
    return '$first12${checkDigit(first12)}';
  }

  /// EAN-13 check digit for the first 12 digits.
  static int checkDigit(String first12) {
    if (first12.length != 12 || int.tryParse(first12) == null) {
      throw ArgumentError('first12 must be 12 digits');
    }
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      final digit = int.parse(first12[i]);
      sum += (i.isEven ? digit : digit * 3);
    }
    return (10 - (sum % 10)) % 10;
  }

  /// True when [code] is 13 digits with a valid check digit.
  static bool isValid(String code) {
    final trimmed = code.trim();
    if (trimmed.length != 13 || int.tryParse(trimmed) == null) return false;
    return checkDigit(trimmed.substring(0, 12)).toString() == trimmed[12];
  }
}
