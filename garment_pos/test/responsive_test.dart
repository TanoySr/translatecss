import 'package:flutter_test/flutter_test.dart';
import 'package:garment_pos/core/utils/responsive.dart';

void main() {
  group('Responsive breakpoints', () {
    test('phone widths are mobile', () {
      expect(deviceClassForWidth(360), DeviceClass.mobile);
      expect(deviceClassForWidth(599), DeviceClass.mobile);
    });

    test('tablet widths are tablet', () {
      expect(deviceClassForWidth(600), DeviceClass.tablet);
      expect(deviceClassForWidth(800), DeviceClass.tablet);
      expect(deviceClassForWidth(1023), DeviceClass.tablet);
    });

    test('desktop widths are desktop', () {
      expect(deviceClassForWidth(1024), DeviceClass.desktop);
      expect(deviceClassForWidth(1920), DeviceClass.desktop);
    });
  });
}
