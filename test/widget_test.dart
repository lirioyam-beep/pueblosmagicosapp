import 'package:flutter_test/flutter_test.dart';

import 'package:pueblosmagicosapp/main.dart';

void main() {
  testWidgets('Muestra la pantalla inicial de acceso', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Xíimbal Yucatán'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });
}
