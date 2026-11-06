import 'package:flutter_test/flutter_test.dart';
import 'package:siswabantu_app/main.dart';

void main() {
  testWidgets('SiswaBantu app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SiswaBantuMobileApp());
    expect(find.text('SiswaBantu'), findsWidgets);
  });
}
