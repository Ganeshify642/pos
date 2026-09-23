import 'package:flutter_test/flutter_test.dart';
import 'package:gopal_vadapav_pos/services/thermal_receipt_builder.dart';

void main() {
  group('Cash Drawer ESC/POS Kick Bytes Tests', () {
    test('Pin 2 primary pulse kick command bytes match ESC/POS standard', () {
      final bytes = ThermalReceiptBuilder.buildCashDrawerKickBytes(pin: 2);
      // ESC p 0 25 250
      expect(bytes, equals([27, 112, 0, 25, 250]));
      expect(bytes[0], equals(27)); // ESC
      expect(bytes[1], equals(112)); // 'p'
      expect(bytes[2], equals(0)); // Pin 2 (connector pin 2)
      expect(bytes[3], equals(25)); // pulse ON time
      expect(bytes[4], equals(250)); // pulse OFF time
    });

    test('Pin 5 alternative pulse kick command bytes match ESC/POS standard', () {
      final bytes = ThermalReceiptBuilder.buildCashDrawerKickBytes(pin: 5);
      // ESC p 1 25 250
      expect(bytes, equals([27, 112, 1, 25, 250]));
      expect(bytes[0], equals(27)); // ESC
      expect(bytes[1], equals(112)); // 'p'
      expect(bytes[2], equals(1)); // Pin 5 (connector pin 5)
      expect(bytes[3], equals(25)); // pulse ON time
      expect(bytes[4], equals(250)); // pulse OFF time
    });

    test('Default universal kick command sends both Pin 2 and Pin 5 pulses', () {
      final bytes = ThermalReceiptBuilder.buildCashDrawerKickBytes();
      expect(bytes, equals([27, 112, 0, 25, 250, 27, 112, 1, 25, 250]));
      expect(bytes.length, equals(10));
    });
  });
}
