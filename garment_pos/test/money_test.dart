import 'package:flutter_test/flutter_test.dart';
import 'package:garment_pos/core/utils/money.dart';

void main() {
  group('Money (integer paise arithmetic)', () {
    test('stores rupees as paise', () {
      expect(Money.fromRupees(100).paise, 10000);
      expect(const Money(10050).format(), '₹100.50');
    });

    test('parses typed amounts without floating point', () {
      expect(Money.tryParse('100')?.paise, 10000);
      expect(Money.tryParse('100.5')?.paise, 10050);
      expect(Money.tryParse('100.50')?.paise, 10050);
      expect(Money.tryParse('₹ 1,00,500.75')?.paise, 10050075);
      expect(Money.tryParse('-250.25')?.paise, -25025);
      expect(Money.tryParse('abc'), isNull);
      expect(Money.tryParse(''), isNull);
      expect(Money.tryParse('1.2.3'), isNull);
    });

    test('formats with Indian digit grouping', () {
      expect(const Money(10050075).format(), '₹1,00,500.75');
      expect(const Money(10000000).format(), '₹1,00,000.00');
      expect(const Money(50000).formatCompact(), '₹500');
      expect(const Money(-25025).format(), '-₹250.25');
    });

    test('adds, subtracts and multiplies by quantity exactly', () {
      const price = Money(19999); // ₹199.99
      expect((price * 3).paise, 59997);
      expect((price + const Money(1)).paise, 20000);
      expect((price - const Money(19999)).isZero, isTrue);
    });

    test('percentage rounds half-up to nearest paise', () {
      // 5% of ₹199.99 = ₹9.9995 -> ₹10.00
      expect(const Money(19999).percent(5).paise, 1000);
      // 18% GST-style split on ₹1,000.00
      expect(const Money(100000).percent(18).paise, 18000);
    });

    test('rounds to nearest rupee for invoice round-off', () {
      expect(const Money(10049).roundToNearestRupee().paise, 10000);
      expect(const Money(10050).roundToNearestRupee().paise, 10100);
      expect(const Money(-10050).roundToNearestRupee().paise, -10100);
    });
  });
}
