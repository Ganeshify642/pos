import 'package:flutter_test/flutter_test.dart';
import 'package:gopal_vadapav_pos/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DeliveryBillApp());
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Gopal Vadapav POS'), findsOneWidget);
  });
}
