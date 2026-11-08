import 'package:flutter_test/flutter_test.dart';
import 'package:eventual_client/models.dart';

void main() {
  test(
    'Changing a reservation replaces the group, cancellation frees places',
    () {
      final data = DemoData.seed();
      final e = data.events.first;
      data.reserve(e, 2);
      expect(data.confirmed(e), e.attendees + 3);
      data.reserve(e, 4);
      expect(data.confirmed(e), e.attendees + 5);
      data.reservations.remove(e.id);
      expect(data.confirmed(e), e.attendees);
    },
  );
  test(
    'Capacity and companion limits reject invalid groups without mutations',
    () {
      final e = ClubEvent(
        id: 'small',
        title: 'Evento',
        category: 'Social',
        place: 'Club',
        description: 'Prueba',
        date: DateTime.now().add(const Duration(days: 25)),
        capacity: 3,
        attendees: 1,
      );
      final data = DemoData(events: [e]);
      data.reserve(e, 1);
      expect(data.confirmed(e), 3);
      expect(() => data.reserve(e, 2), throwsStateError);
      expect(data.reservations[e.id], 1);
      expect(() => data.reserve(e, -1), throwsArgumentError);
      expect(() => data.reserve(e, 6), throwsArgumentError);
    },
  );
  test('Approval creates only one event and survives storage round trip', () {
    final data = DemoData.seed();
    final p = Proposal(
      id: 'p1',
      title: 'Caminata del club',
      category: 'Deportivo',
      reason: 'Compartir una mañana saludable entre amigos del club.',
      date: DateTime.now().add(const Duration(days: 40)),
    );
    data.proposals.add(p);
    data.approve(p);
    expect(data.proposals.single.status, 'Aprobada');
    expect(() => data.approve(p), throwsStateError);
    expect(data.events.where((e) => e.id == 'event-p1').length, 1);
    data.reserve(data.events.first, 1);
    final restored = DemoData.decode(data.encode());
    expect(restored.events.length, 4);
    expect(restored.reservations, data.reservations);
    expect(restored.proposals.single.status, 'Aprobada');
  });
}
