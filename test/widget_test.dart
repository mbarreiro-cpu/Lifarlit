import 'package:flutter_test/flutter_test.dart';
import 'package:lifarlit/main.dart';

void main() {
  testWidgets('La aplicación Lifarlit se inicia', (WidgetTester tester) async {
    await tester.pumpWidget(const LifarlitApp());

    expect(find.text('¡Bienvenido a Lifarlit!'), findsOneWidget);
  });
}
