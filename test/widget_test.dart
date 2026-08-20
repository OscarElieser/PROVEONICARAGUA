import 'package:flutter_test/flutter_test.dart';
import 'package:proveo_premium/main.dart';

void main() {
  testWidgets('PROVEO inicia correctamente', (tester) async {
    await tester.pumpWidget(const ProveoApp());
    expect(find.text('Conectamos confianza. Impulsamos negocios.'), findsOneWidget);
  });
}
