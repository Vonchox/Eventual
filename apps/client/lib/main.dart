import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'visuals.dart';

const pine = Color(0xFF183E32),
    ink = Color(0xFF20392F),
    muted = Color(0xFF64736A),
    lime = Color(0xFFD4ECA5),
    paper = Color(0xFFF6F7F2);
const months = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];
String dateLabel(DateTime d) => '${d.day} de ${months[d.month - 1]}';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences? prefs;
  var data = DemoData.seed();
  String? warning;
  try {
    prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('eventual.demo.v1');
    if (saved != null) {
      data = DemoData.decode(saved);
    }
  } catch (_) {
    warning = 'No pudimos recuperar los datos locales. Comenzamos con datos de ejemplo.';
  }
  runApp(EventualApp(data: data, prefs: prefs, warning: warning));
}

class EventualApp extends StatelessWidget {
  final DemoData data;
  final SharedPreferences? prefs;
  final String? warning;
  const EventualApp({super.key, required this.data, this.prefs, this.warning});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'EVENTUAL · Club de Suboficiales',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: pine, primary: pine),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, color: ink),
        bodyLarge: TextStyle(fontSize: 18, color: ink),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(56, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(56, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(18),
      ),
    ),
    home: Dashboard(initial: data, prefs: prefs, warning: warning),
  );
}

class Dashboard extends StatefulWidget {
  final DemoData initial;
  final SharedPreferences? prefs;
  final String? warning;
  const Dashboard({super.key, required this.initial, this.prefs, this.warning});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DemoData data = widget.initial;
  int page = 0;
  String category = 'Todos', search = '', role = 'Socio';
  bool calendar = false;
  DateTime calendarMonth = DateTime(DateTime.now().year, DateTime.now().month);
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  final nav = ['Inicio', 'Eventos', 'Mis confirmaciones', 'Propuestas'];
  final navIcons = [
    Icons.grid_view_rounded,
    Icons.calendar_month_outlined,
    Icons.bookmark_border_rounded,
    Icons.lightbulb_outline_rounded,
  ];
  @override
  void initState() {
    super.initState();
    if (widget.warning != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          toast(widget.warning!);
        }
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void toast(String text) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
  );
  Future<void> save() async {
    try {
      if (widget.prefs == null ||
          !await widget.prefs!.setString('eventual.demo.v1', data.encode())) {
        if (mounted) {
          toast(
            'Cambio aplicado en esta sesión. No hay almacenamiento local disponible.',
          );
        }
      }
    } catch (_) {
      if (mounted) {
        toast('Cambio aplicado, pero no se pudo guardar en el dispositivo.');
      }
    }
  }

  void go(int value) {
    setState(() => page = value);
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
  }

  Widget badge(String label, {Color? color}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: color ?? const Color(0xFFEDF2E6),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: pine,
      ),
    ),
  );
  Widget logo() => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.asset(
      'assets/club-escudo.png',
      width: 45,
      height: 52,
      fit: BoxFit.contain,
      semanticLabel:
          'Escudo del Club de Suboficiales, Fuerzas Especiales, Ecuador',
    ),
  );
  Widget sidebar() => Container(
    width: 242,
    color: pine,
    padding: const EdgeInsets.fromLTRB(22, 30, 22, 22),
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              logo(),
              const SizedBox(width: 12),
              const Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EVENTUAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.3,
                        ),
                      ),
                      Text(
                        'Juntos, siempre.',
                        style: TextStyle(
                          color: Color(0xFFBFCFC4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 44),
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 14),
            child: Text(
              'MI CLUB',
              style: TextStyle(
                color: Color(0xFFA7C1B3),
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...List.generate(
            nav.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Material(
                color: page == i ? lime : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => go(i),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          navIcons[i],
                          size: 21,
                          color: page == i ? pine : const Color(0xFFD0DDD4),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            nav[i],
                            style: TextStyle(
                              color: page == i ? pine : const Color(0xFFD0DDD4),
                              fontWeight: page == i
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (i == 2 && data.reservations.isNotEmpty)
                          Text(
                            '${data.reservations.length}',
                            style: TextStyle(color: page == i ? pine : lime),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .06),
              border: Border.all(color: Colors.white.withValues(alpha: .12)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.handshake_outlined, color: lime, size: 28),
                SizedBox(height: 12),
                Text(
                  'El club lo hacemos todos.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Cada encuentro es una nueva historia compartida.',
                  style: TextStyle(
                    color: Color(0xFFBFCFC4),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Row(
            children: [
              Icon(Icons.circle, size: 7, color: lime),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Club de Suboficiales · Ecuador',
                  style: TextStyle(fontSize: 11, color: Color(0xFFBFCFC4)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final wide = c.maxWidth >= 1080, mobile = c.maxWidth < 680;
      return Scaffold(
        key: scaffoldKey,
        drawer: wide ? null : Drawer(width: 242, child: sidebar()),
        body: Row(
          children: [
            if (wide) sidebar(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 84,
                    padding: EdgeInsets.symmetric(horizontal: mobile ? 12 : 36),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE4E9E0)),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (!wide)
                          IconButton(
                            tooltip: 'Abrir menú',
                            onPressed: () =>
                                scaffoldKey.currentState!.openDrawer(),
                            icon: const Icon(Icons.menu),
                          ),
                        if (!mobile) ...[
                          const Text(
                            'Club de Suboficiales',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '/',
                            style: TextStyle(color: Color(0xFFB4BFB3)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            nav[page],
                            style: const TextStyle(color: muted, fontSize: 14),
                          ),
                        ] else
                          const Text(
                            'EVENTUAL',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                        const Spacer(),
                        if (!mobile) ...[
                          badge('DEMO INTERACTIVA'),
                          const SizedBox(width: 22),
                        ],
                        if (!mobile)
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFFEDF1E7),
                            child: Text(
                              'AT',
                              style: TextStyle(
                                color: pine,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(width: 9),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: role,
                            style: const TextStyle(color: pine, fontSize: 13),
                            items: ['Socio', 'Presidente']
                                .map(
                                  (r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(r),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => role = v!),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(mobile ? 20 : 36),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1380),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.science_outlined,
                                    size: 15,
                                    color: muted,
                                  ),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      mobile
                                          ? 'Demo · Datos ficticios en este dispositivo.'
                                          : 'Espacio de demostración · Datos ficticios · Cambios guardados solo en este dispositivo.',
                                      style: const TextStyle(
                                        color: muted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: reset,
                                    child: const Text(
                                      'Reiniciar',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              if (page == 0)
                                ...overview(mobile)
                              else if (page == 3)
                                ...proposalsPage(mobile)
                              else
                                ...eventsPage(mobile),
                              const SizedBox(height: 38),
                              const Divider(color: Color(0xFFE2E6DC)),
                              const SizedBox(height: 12),
                              const Wrap(
                                spacing: 30,
                                runSpacing: 10,
                                children: [
                                  Text(
                                    'EVENTUAL / Encuentros que nos unen.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: muted,
                                    ),
                                  ),
                                  Text(
                                    'Primera etapa · Web, móvil y escritorio',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );

  List<Widget> overview(bool mobile) => [
    Wrap(
      spacing: 24,
      runSpacing: 14,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TU COMUNIDAD, MÁS CERCA',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                color: muted,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Qué gusto verte, Antonio.',
              style: TextStyle(
                fontSize: mobile ? 29 : 36,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.3,
                color: ink,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Siempre hay un buen motivo para volver a encontrarnos.',
              style: TextStyle(color: muted, fontSize: 15),
            ),
          ],
        ),
        OutlinedButton.icon(
          onPressed: newProposal,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Proponer evento'),
        ),
      ],
    ),
    const SizedBox(height: 28),
    hero(mobile),
    const SizedBox(height: 26),
    LayoutBuilder(
      builder: (context, c) {
        final width = mobile ? (c.maxWidth - 12) / 2 : (c.maxWidth - 48) / 3;
        return Wrap(
          spacing: mobile ? 12 : 24,
          runSpacing: 12,
          children: [
            stat(
              'Próximos encuentros',
              data.events
                  .where((e) => e.date.isAfter(DateTime.now()))
                  .length
                  .toString()
                  .padLeft(2, '0'),
              'Momentos para compartir',
              Icons.calendar_today_outlined,
              width,
            ),
            stat(
              'Mis confirmaciones',
              data.reservations.length.toString().padLeft(2, '0'),
              'Tu lugar ya está reservado',
              Icons.check_circle_outline,
              width,
            ),
            if (!mobile)
              stat(
                'Propuestas del club',
                data.proposals.length.toString().padLeft(2, '0'),
                'Las buenas ideas comienzan contigo',
                Icons.wb_sunny_outlined,
                width,
              ),
          ],
        );
      },
    ),
    const SizedBox(height: 34),
    Row(
      children: [
        const Expanded(
          child: Text(
            'Tu próximo buen momento',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              letterSpacing: -.6,
            ),
          ),
        ),
        TextButton(onPressed: () => go(1), child: const Text('Ver todos →')),
      ],
    ),
    const SizedBox(height: 7),
    const Text(
      'Descubre lo que estamos preparando para ti.',
      style: TextStyle(color: muted, fontSize: 14),
    ),
    const SizedBox(height: 20),
    eventGrid(data.events.take(3).toList()),
    const SizedBox(height: 28),
    Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0DF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, size: 32, color: pine),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Y si el próximo encuentro nace de tu idea?',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                ),
                SizedBox(height: 5),
                Text(
                  'Propón una actividad. Hagamos que suceda juntos.',
                  style: TextStyle(color: muted, fontSize: 14),
                ),
              ],
            ),
          ),
          if (!mobile)
            TextButton(
              onPressed: newProposal,
              child: const Text('Compartir mi idea →'),
            ),
        ],
      ),
    ),
  ];

  Widget hero(bool mobile) {
    final upcoming = data.events
        .where((e) => e.date.isAfter(DateTime.now()))
        .toList();
    if (upcoming.isEmpty) {
      return const SizedBox.shrink();
    }
    final e = upcoming.first;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: pine,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: HeroPattern())),
          Padding(
            padding: EdgeInsets.all(mobile ? 25 : 36),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      badge('EL PRÓXIMO ENCUENTRO', color: lime),
                      const SizedBox(height: 23),
                      Text(
                        e.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: mobile ? 34 : 44,
                          fontWeight: FontWeight.w600,
                          height: 1.08,
                          letterSpacing: -1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Las mejores historias se viven en compañía.\nVen a compartir una más con tu club.',
                        style: TextStyle(
                          color: Color(0xFFD4DFD5),
                          fontSize: 15,
                          height: 1.65,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Wrap(
                        spacing: 18,
                        runSpacing: 10,
                        children: [
                          heroInfo(
                            Icons.calendar_today_outlined,
                            '${dateLabel(e.date)} · ${e.date.hour}:00',
                          ),
                          heroInfo(
                            Icons.location_on_outlined,
                            e.place.split(' · ').first,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: lime,
                          foregroundColor: pine,
                        ),
                        onPressed: () => details(e),
                        icon: const Icon(Icons.arrow_outward, size: 18),
                        label: const Text(
                          'Descubrir el evento',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!mobile) ...[
                  const SizedBox(width: 30),
                  Expanded(
                    flex: 4,
                    child: Transform.rotate(
                      angle: -.07,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F2E8),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .15),
                              blurRadius: 30,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'NOS VEMOS EL',
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 2,
                                    color: muted,
                                  ),
                                ),
                                Icon(
                                  Icons.north_east,
                                  color: pine.withValues(alpha: .6),
                                  size: 19,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '${e.date.day}'.padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 91,
                                height: 1.05,
                                letterSpacing: -6,
                                color: pine,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              months[e.date.month - 1].toUpperCase(),
                              style: const TextStyle(
                                letterSpacing: 5,
                                fontSize: 15,
                                color: pine,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.people_outline,
                                  size: 18,
                                  color: pine,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    '${data.confirmed(e)} personas confirmadas',
                                    style: const TextStyle(
                                      color: pine,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget heroInfo(IconData icon, String text) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: lime),
      const SizedBox(width: 7),
      Flexible(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    ],
  );
  Widget stat(
    String title,
    String number,
    String hint,
    IconData icon,
    double width,
  ) => Container(
    width: width,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE4E8DD)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13, color: muted),
              ),
            ),
            Icon(icon, size: 20, color: pine),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          number,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
            color: ink,
          ),
        ),
        const SizedBox(height: 5),
        Text(hint, style: const TextStyle(fontSize: 11, color: muted)),
      ],
    ),
  );

  Widget eventGrid(List<ClubEvent> events) => LayoutBuilder(
    builder: (context, c) {
      if (events.isEmpty) {
        return empty(
          'Todavía no hay eventos aquí.',
          'Prueba otro filtro o comparte una propuesta.',
          Icons.event_available_outlined,
        );
      }
      final count = c.maxWidth >= 950
          ? 3
          : c.maxWidth >= 610
          ? 2
          : 1;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: events
            .map(
              (e) => SizedBox(
                width: (c.maxWidth - 20 * (count - 1)) / count,
                child: eventCard(e),
              ),
            )
            .toList(),
      );
    },
  );
  Widget eventCard(ClubEvent e) {
    final reserved = data.reservations.containsKey(e.id);
    final color = e.category == 'Deportivo'
        ? const Color(0xFFE2EACD)
        : e.id == 'evt-3'
        ? const Color(0xFFEFE2CB)
        : const Color(0xFFDDE7DF);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFE1E6DC)),
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => details(e),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 155,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: EventArt(e.category, color, e.id == 'evt-3'),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: badge(
                      e.category,
                      color: Colors.white.withValues(alpha: .92),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      width: 49,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${e.date.day}'.padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            months[e.date.month - 1]
                                .substring(0, 3)
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: muted,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          e.place,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: muted, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: data.confirmed(e) / e.capacity,
                      minHeight: 4,
                      color: const Color(0xFF76936A),
                      backgroundColor: const Color(0xFFEDF0E7),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '${data.confirmed(e)} de ${e.capacity} confirmados',
                        style: const TextStyle(fontSize: 11, color: muted),
                      ),
                      const Spacer(),
                      Icon(
                        reserved ? Icons.check_circle : Icons.arrow_forward,
                        size: 18,
                        color: pine,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reserved
                        ? 'Tu asistencia está confirmada'
                        : 'Ver detalles del encuentro',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: pine,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> eventsPage(bool mobile) {
    final selected = data.events
        .where(
          (e) =>
              (page != 2 || data.reservations.containsKey(e.id)) &&
              (category == 'Todos' || e.category == category) &&
              '${e.title} ${e.place}'.toLowerCase().contains(
                search.toLowerCase(),
              ),
        )
        .toList();
    return [
      Text(
        page == 2 ? 'Tu lugar está aquí.' : 'Nos encontramos pronto.',
        style: TextStyle(
          fontSize: mobile ? 30 : 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        page == 2
            ? 'Consulta o modifica los encuentros a los que asistirás.'
            : 'Planes, personas y buenos momentos. Elige tu próximo encuentro.',
        style: const TextStyle(fontSize: 15, color: muted),
      ),
      const SizedBox(height: 26),
      TextField(
        controller: searchController,
        onChanged: (v) => setState(() => search = v),
        decoration: const InputDecoration(
          fillColor: Colors.white,
          hintText: 'Buscar por evento o lugar…',
          prefixIcon: Icon(Icons.search),
        ),
      ),
      const SizedBox(height: 18),
      Wrap(
        spacing: 9,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final type in ['Todos', 'Social', 'Deportivo'])
            ChoiceChip(
              label: Text(type),
              selected: category == type,
              onSelected: (_) => setState(() => category = type),
              selectedColor: lime,
              showCheckmark: false,
              side: BorderSide.none,
              backgroundColor: Colors.white,
            ),
          if (page == 1)
            TextButton.icon(
              onPressed: () => setState(() => calendar = !calendar),
              icon: Icon(
                calendar
                    ? Icons.view_agenda_outlined
                    : Icons.calendar_month_outlined,
              ),
              label: Text(calendar ? 'Ver tarjetas' : 'Ver calendario'),
            ),
        ],
      ),
      const SizedBox(height: 22),
      if (calendar && page == 1)
        calendarView(selected)
      else if (selected.isEmpty && page == 2)
        empty(
          'Aún no has confirmado un encuentro.',
          'Explora los eventos y reserva un momento para compartir.',
          Icons.bookmark_border,
        )
      else
        eventGrid(selected),
    ];
  }

  Widget calendarView(List<ClubEvent> events) {
    final start = DateTime(calendarMonth.year, calendarMonth.month),
        count = DateTime(calendarMonth.year, calendarMonth.month + 1, 0).day;
    final offset = start.weekday - 1;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Mes anterior',
                onPressed: () => setState(
                  () => calendarMonth = DateTime(start.year, start.month - 1),
                ),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  '${months[start.month - 1]} ${start.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Mes siguiente',
                onPressed: () => setState(
                  () => calendarMonth = DateTime(start.year, start.month + 1),
                ),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              for (final d in ['L', 'M', 'X', 'J', 'V', 'S', 'D'])
                Expanded(
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: muted),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, c) => Wrap(
              children: List.generate(((count + offset + 6) ~/ 7) * 7, (i) {
                final day = i - offset + 1;
                final matches = events
                    .where(
                      (e) =>
                          e.date.year == start.year &&
                          e.date.month == start.month &&
                          e.date.day == day,
                    )
                    .toList();
                return SizedBox(
                  width: c.maxWidth / 7,
                  height: c.maxWidth < 500 ? 64 : 94,
                  child: day < 1 || day > count
                      ? null
                      : Padding(
                          padding: const EdgeInsets.all(3),
                          child: Material(
                            color: matches.isEmpty ? paper : lime,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: matches.isEmpty
                                  ? null
                                  : () => details(matches.first),
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$day',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (matches.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      if (c.maxWidth > 500)
                                        Text(
                                          matches.first.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 10),
                                        )
                                      else
                                        const Icon(
                                          Icons.circle,
                                          size: 7,
                                          color: pine,
                                        ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Los días en verde tienen un encuentro. Selecciona uno para ver sus detalles.',
            style: TextStyle(fontSize: 12, color: muted),
          ),
        ],
      ),
    );
  }

  Widget empty(String title, String hint, IconData icon) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        Icon(icon, color: pine, size: 42),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 9),
        Text(
          hint,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: muted),
        ),
      ],
    ),
  );

  List<Widget> proposalsPage(bool mobile) => [
    Wrap(
      spacing: 24,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Las ideas nos reúnen.',
              style: TextStyle(
                fontSize: mobile ? 30 : 36,
                fontWeight: FontWeight.w700,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Un espacio para imaginar el próximo encuentro.',
              style: TextStyle(color: muted, fontSize: 15),
            ),
          ],
        ),
        FilledButton.icon(
          onPressed: newProposal,
          icon: const Icon(Icons.add),
          label: const Text('Compartir una idea'),
        ),
      ],
    ),
    const SizedBox(height: 26),
    if (role == 'Presidente')
      Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: lime.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Perfil de presidente simulado. Aprobar crea un evento de ejemplo con 60 cupos y lugar por definir.',
          style: TextStyle(fontSize: 14),
        ),
      ),
    if (data.proposals.isEmpty)
      empty(
        'Tu idea puede ser la primera.',
        '¿Una salida, un campeonato, un almuerzo? Cuéntanos.',
        Icons.lightbulb_outline,
      )
    else
      ...data.proposals.map(
        (p) => Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1E6DC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  badge(p.category),
                  badge(
                    p.status,
                    color: p.status == 'Aprobada'
                        ? lime
                        : const Color(0xFFF5EACF),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                p.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(p.reason, style: const TextStyle(color: muted, height: 1.5)),
              const SizedBox(height: 15),
              Text(
                'Fecha sugerida: ${dateLabel(p.date)} ${p.date.year} · ${p.id}',
                style: const TextStyle(fontSize: 12, color: muted),
              ),
              if (role == 'Presidente' && p.status == 'Pendiente') ...[
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () async {
                    setState(() => data.approve(p));
                    await save();
                    if (mounted) {
                      toast('Idea aprobada. Ya puedes verla en Eventos.');
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Aprobar idea'),
                ),
              ],
            ],
          ),
        ),
      ),
  ];

  Future<void> details(ClubEvent e) async {
    int guests = data.reservations[e.id] ?? 0;
    String? error;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) {
          final reserved = data.reservations.containsKey(e.id);
          return AlertDialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.all(18),
            constraints: const BoxConstraints(maxWidth: 600),
            titlePadding: const EdgeInsets.fromLTRB(26, 20, 18, 0),
            title: Row(
              children: [
                badge(e.category),
                const Spacer(),
                IconButton(
                  tooltip: 'Cerrar detalle',
                  onPressed: () => Navigator.pop(dialogContext),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      e.title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.8,
                      ),
                    ),
                    const SizedBox(height: 18),
                    detailLine(
                      Icons.calendar_today_outlined,
                      '${dateLabel(e.date)} de ${e.date.year} · ${e.date.hour}:00',
                    ),
                    detailLine(Icons.location_on_outlined, e.place),
                    detailLine(
                      Icons.people_outline,
                      '${e.capacity - data.confirmed(e)} cupos disponibles de ${e.capacity}',
                    ),
                    const SizedBox(height: 18),
                    Text(
                      e.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (reserved) ...[
                      badge('Tu asistencia está confirmada', color: lime),
                      const SizedBox(height: 16),
                    ],
                    const Text(
                      '¿Con quién vienes?',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tu lugar + hasta 5 acompañantes. En esta demo solo registramos la cantidad.',
                      style: TextStyle(fontSize: 13, color: muted),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton.filledTonal(
                          tooltip: 'Quitar acompañante',
                          onPressed: guests > 0
                              ? () => update(() {
                                  guests--;
                                  error = null;
                                })
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Text(
                            '$guests',
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                        IconButton.filledTonal(
                          tooltip: 'Añadir acompañante',
                          onPressed: guests < 5
                              ? () => update(() {
                                  guests++;
                                  error = null;
                                })
                              : null,
                          icon: const Icon(Icons.add),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            '${guests + 1} ${guests == 0 ? 'persona' : 'personas'} en total',
                            style: const TextStyle(fontSize: 13, color: muted),
                          ),
                        ),
                      ],
                    ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(24),
            actions: [
              if (reserved)
                TextButton(
                  onPressed: () async {
                    setState(() => data.reservations.remove(e.id));
                    Navigator.pop(dialogContext);
                    await save();
                    if (mounted) {
                      toast(
                        'Confirmación cancelada. Tus cupos están disponibles nuevamente.',
                      );
                    }
                  },
                  child: const Text('Cancelar asistencia'),
                ),
              FilledButton.icon(
                onPressed: () async {
                  try {
                    data.reserve(e, guests);
                  } catch (err) {
                    update(
                      () => error = err is ArgumentError
                          ? err.message.toString()
                          : (err as StateError).message,
                    );
                    return;
                  }
                  setState(() {});
                  Navigator.pop(dialogContext);
                  await save();
                  if (mounted) {
                    toast(
                      reserved
                          ? 'Tu confirmación se actualizó.'
                          : '¡Nos vemos pronto! Tu asistencia está confirmada.',
                    );
                  }
                },
                icon: const Icon(Icons.check),
                label: Text(
                  reserved ? 'Guardar cambios' : 'Confirmar asistencia',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget detailLine(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, size: 19, color: pine),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    ),
  );

  Future<void> newProposal() async {
    final form = GlobalKey<FormState>();
    final title = TextEditingController(), reason = TextEditingController();
    String type = 'Social';
    DateTime date = DateTime.now().add(const Duration(days: 30));
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(18),
          constraints: const BoxConstraints(maxWidth: 580),
          title: const Text(
            'Tu idea, nuestro próximo encuentro',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Form(
                key: form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Comparte una actividad que te gustaría vivir con el club.',
                      style: TextStyle(color: muted, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: title,
                      maxLength: 70,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del encuentro',
                      ),
                      validator: (v) => (v ?? '').trim().length < 5
                          ? 'Escribe un nombre de al menos 5 caracteres.'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de actividad',
                      ),
                      items: ['Social', 'Deportivo']
                          .map(
                            (v) => DropdownMenuItem(value: v, child: Text(v)),
                          )
                          .toList(),
                      onChanged: (v) => type = v!,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final now = DateTime.now();
                        final chosen = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(now.year, now.month, now.day + 1),
                          lastDate: DateTime(now.year + 2),
                        );
                        if (chosen != null) {
                          update(
                            () => date = DateTime(
                              chosen.year,
                              chosen.month,
                              chosen.day,
                              12,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.calendar_today_outlined, size: 18),
                      label: Text(
                        'Fecha sugerida: ${dateLabel(date)} ${date.year}',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: reason,
                      maxLines: 4,
                      maxLength: 1000,
                      decoration: const InputDecoration(
                        labelText: '¿Por qué sería un buen encuentro?',
                        alignLabelWithHint: true,
                      ),
                      validator: (v) => (v ?? '').trim().length < 30
                          ? 'Cuéntanos un poco más: mínimo 30 caracteres.'
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Volver'),
            ),
            FilledButton(
              onPressed: () async {
                if (!form.currentState!.validate()) {
                  return;
                }
                final p = Proposal(
                  id: 'PRO-${DateTime.now().millisecondsSinceEpoch}',
                  title: title.text.trim(),
                  category: type,
                  reason: reason.text.trim(),
                  date: date,
                );
                setState(() {
                  data.proposals.insert(0, p);
                  page = 3;
                });
                Navigator.pop(dialogContext);
                await save();
                if (mounted) {
                  toast(
                    'Tu propuesta está registrada y pendiente de revisión.',
                  );
                }
              },
              child: const Text('Enviar propuesta'),
            ),
          ],
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 250));
    title.dispose();
    reason.dispose();
  }

  Future<void> reset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('¿Volver a empezar?'),
        content: const Text(
          'Se eliminarán las confirmaciones y propuestas de esta demo en tu dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Conservar datos'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Reiniciar demo'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() {
        data = DemoData.seed();
        page = 0;
        search = '';
        category = 'Todos';
        calendar = false;
        searchController.clear();
      });
      await save();
    }
  }
}
