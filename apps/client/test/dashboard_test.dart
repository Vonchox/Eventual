import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventual_client/main.dart';
import 'package:eventual_client/models.dart';

void main() {
  testWidgets('Desktop flow confirms and cancels without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final data = DemoData.seed();
    await tester.pumpWidget(EventualApp(data: data));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Descubrir el evento'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Añadir acompañante'));
    await tester.tap(find.text('Confirmar asistencia'));
    await tester.pumpAndSettle();
    expect(data.reservations[data.events.first.id], 1);
    await tester.tap(find.text('Descubrir el evento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar asistencia'));
    await tester.pumpAndSettle();
    expect(data.reservations, isEmpty);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Phone opens navigation and proposal validation', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final data = DemoData.seed();
    await tester.pumpWidget(EventualApp(data: data));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Abrir menú'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Propuestas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compartir una idea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enviar propuesta'));
    await tester.pumpAndSettle();
    expect(
      find.text('Escribe un nombre de al menos 5 caracteres.'),
      findsOneWidget,
    );
    expect(data.proposals, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
