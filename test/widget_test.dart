import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pacman_game/main.dart';

void main() {
  testWidgets('Muestra el puntaje inicial', (WidgetTester tester) async {
    await tester.pumpWidget(const PacmanApp());
    expect(find.text('Puntaje: 0'), findsOneWidget);

    // Desmonta el juego para cancelar el Timer
    await tester.pumpWidget(const SizedBox());
  });
}
