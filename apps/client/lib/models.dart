import 'dart:convert';

class ClubEvent {
  final String id, title, category, place, description;
  final DateTime date;
  final int capacity, attendees;
  const ClubEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.place,
    required this.description,
    required this.date,
    required this.capacity,
    required this.attendees,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'place': place,
    'description': description,
    'date': date.toIso8601String(),
    'capacity': capacity,
    'attendees': attendees,
  };
  factory ClubEvent.fromJson(Map<String, dynamic> j) => ClubEvent(
    id: j['id'],
    title: j['title'],
    category: j['category'],
    place: j['place'],
    description: j['description'],
    date: DateTime.parse(j['date']),
    capacity: j['capacity'],
    attendees: j['attendees'],
  );
}

class Proposal {
  final String id, title, category, reason, status;
  final DateTime date;
  const Proposal({
    required this.id,
    required this.title,
    required this.category,
    required this.reason,
    required this.date,
    this.status = 'Pendiente',
  });
  Proposal approved() => Proposal(
    id: id,
    title: title,
    category: category,
    reason: reason,
    date: date,
    status: 'Aprobada',
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'reason': reason,
    'date': date.toIso8601String(),
    'status': status,
  };
  factory Proposal.fromJson(Map<String, dynamic> j) => Proposal(
    id: j['id'],
    title: j['title'],
    category: j['category'],
    reason: j['reason'],
    date: DateTime.parse(j['date']),
    status: j['status'],
  );
}

class DemoData {
  final List<ClubEvent> events;
  final Map<String, int> reservations;
  final List<Proposal> proposals;
  DemoData({
    required this.events,
    Map<String, int>? reservations,
    List<Proposal>? proposals,
  }) : reservations = reservations ?? {},
       proposals = proposals ?? [];
  factory DemoData.seed({DateTime? now}) {
    final base = now ?? DateTime.now();
    DateTime day(int days, int hour) =>
        DateTime(base.year, base.month, base.day + days, hour);
    return DemoData(
      events: [
        ClubEvent(
          id: 'evt-1',
          title: 'Un día para reencontrarnos',
          category: 'Social',
          place: 'Sede social del club · Quito',
          description: 'Compartamos una tarde de buena conversación, música y un almuerzo en familia. Una oportunidad para volver a ver a nuestros compañeros y crear nuevos recuerdos. Incluye almuerzo y actividades para acompañantes.',
          date: day(21, 12),
          capacity: 120,
          attendees: 76,
        ),
        ClubEvent(
          id: 'evt-2',
          title: 'Copa de la camaradería',
          category: 'Deportivo',
          place: 'Canchas del club · Quito',
          description: 'Una jornada de fútbol, compañerismo y juego limpio. Inscríbete y participa con tu equipo o acompáñanos desde las gradas. Lleva ropa cómoda, protección solar y agua.',
          date: day(28, 9),
          capacity: 80,
          attendees: 42,
        ),
        ClubEvent(
          id: 'evt-3',
          title: 'Sabores y tradiciones',
          category: 'Social',
          place: 'Jardines de la sede · Quito',
          description: 'Celebremos nuestras tradiciones con una mesa compartida, platos típicos y música ecuatoriana. Ven con tu familia y disfruta de una tarde al aire libre.',
          date: day(35, 13),
          capacity: 100,
          attendees: 58,
        ),
      ],
    );
  }
  int confirmed(ClubEvent e) =>
      e.attendees +
      (reservations.containsKey(e.id) ? reservations[e.id]! + 1 : 0);
  void reserve(ClubEvent e, int guests) {
    if (guests < 0 || guests > 5) {
      throw ArgumentError('Puedes registrar de 0 a 5 acompañantes.');
    }
    if (e.date.isBefore(DateTime.now())) {
      throw StateError('Este evento ya finalizó.');
    }
    if (e.attendees + guests + 1 > e.capacity) {
      throw StateError('No hay cupos suficientes para este grupo.');
    }
    reservations[e.id] = guests;
  }

  void approve(Proposal p) {
    final i = proposals.indexWhere((v) => v.id == p.id);
    if (i < 0 || proposals[i].status != 'Pendiente') {
      throw StateError('La propuesta ya fue procesada.');
    }
    events.add(
      ClubEvent(
        id: 'event-${p.id}',
        title: p.title,
        category: p.category,
        place: 'Lugar por definir · propuesta aprobada',
        description: p.reason,
        date: p.date,
        capacity: 60,
        attendees: 0,
      ),
    );
    events.sort((a, b) => a.date.compareTo(b.date));
    proposals[i] = p.approved();
  }

  String encode() => jsonEncode({
    'version': 1,
    'events': events.map((e) => e.toJson()).toList(),
    'reservations': reservations,
    'proposals': proposals.map((p) => p.toJson()).toList(),
  });
  factory DemoData.decode(String text) {
    final j = jsonDecode(text) as Map<String, dynamic>;
    if (j['version'] != 1) {
      throw const FormatException('Versión incompatible');
    }
    return DemoData(
      events: (j['events'] as List).map((e) => ClubEvent.fromJson(e)).toList(),
      reservations: Map<String, int>.from(j['reservations']),
      proposals: (j['proposals'] as List)
          .map((p) => Proposal.fromJson(p))
          .toList(),
    );
  }
}
