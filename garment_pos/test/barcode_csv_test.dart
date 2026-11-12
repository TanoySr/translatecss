import 'package:flutter_test/flutter_test.dart';
import 'package:garment_pos/core/utils/csv_codec.dart';
import 'package:garment_pos/features/inventory/domain/barcode_util.dart';

void main() {
  group('BarcodeUtil', () {
    test('generated codes are 13 digits with valid check digit', () {
      for (final id in [1, 42, 123456, 999999999]) {
        final code = BarcodeUtil.forVariantId(id);
        expect(code, hasLength(13));
        expect(code.startsWith('20'), isTrue);
        expect(BarcodeUtil.isValid(code), isTrue, reason: code);
      }
    });

    test('tampered codes are invalid', () {
      final code = BarcodeUtil.forVariantId(7);
      final tampered = '${code.substring(0, 12)}${(int.parse(code[12]) + 1) % 10}';
      expect(BarcodeUtil.isValid(tampered), isFalse);
      expect(BarcodeUtil.isValid('123'), isFalse);
      expect(BarcodeUtil.isValid('abcdefghijklm'), isFalse);
    });
  });

  group('CsvCodec', () {
    test('round-trips commas, quotes and newlines', () {
      final rows = [
        ['code', 'name', 'note'],
        ['A1', 'Men\'s "Premium" Tee, Blue', 'line1\nline2'],
        ['B2', 'Plain', ''],
      ];
      final text = CsvCodec.encode(rows);
      expect(CsvCodec.parse(text), rows);
    });

    test('parses CRLF and trailing newline', () {
      expect(CsvCodec.parse('a,b\r\n1,2\r\n'), [
        ['a', 'b'],
        ['1', '2'],
      ]);
    });
  });
}
