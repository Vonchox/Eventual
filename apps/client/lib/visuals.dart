import 'package:flutter/material.dart';

const _pine = Color(0xFF183E32);

class HeroPattern extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF315C45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 0; i < 7; i++) {
      canvas.drawCircle(
        Offset(size.width * .94, size.height * .7),
        100 + i * 48,
        p,
      );
    }
    canvas.drawCircle(
      Offset(size.width * .82, -30),
      130,
      Paint()..color = const Color(0xFF224D39),
    );
    canvas.drawCircle(
      Offset(size.width * .59, size.height + 65),
      145,
      Paint()..color = const Color(0xFF244A37),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EventArt extends CustomPainter {
  final String type;
  final Color color;
  final bool food;
  EventArt(this.type, this.color, this.food);
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = color);
    final stroke = Paint()
      ..color = _pine.withValues(alpha: .2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(s.width * .52, s.height * .72),
        40 + i * 26,
        stroke,
      );
    }
    final p = Paint()..color = _pine.withValues(alpha: .75);
    final cx = s.width * .52, cy = s.height * .68;
    if (type == 'Deportivo') {
      canvas.drawCircle(
        Offset(cx, cy),
        38,
        Paint()..color = const Color(0xFFF9FAEE),
      );
      canvas.drawCircle(
        Offset(cx, cy),
        38,
        p
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      final path = Path()
        ..moveTo(cx, cy - 19)
        ..lineTo(cx + 19, cy - 5)
        ..lineTo(cx + 12, cy + 17)
        ..lineTo(cx - 12, cy + 17)
        ..lineTo(cx - 19, cy - 5)
        ..close();
      canvas.drawPath(path, p..style = PaintingStyle.fill);
      for (final o in [
        const Offset(0, -37),
        const Offset(35, -11),
        const Offset(22, 30),
        const Offset(-22, 30),
        const Offset(-35, -11),
      ]) {
        canvas.drawCircle(Offset(cx + o.dx, cy + o.dy), 5, p);
      }
    } else if (food) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy), width: 102, height: 62),
        Paint()..color = const Color(0xFFFCF8EA),
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy), width: 75, height: 40),
        stroke..strokeWidth = 2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - 16, cy - 10, 32, 20),
          const Radius.circular(10),
        ),
        p,
      );
      canvas.drawLine(
        Offset(cx - 64, cy - 24),
        Offset(cx - 64, cy + 27),
        p..strokeWidth = 3,
      );
      canvas.drawLine(Offset(cx + 64, cy - 24), Offset(cx + 64, cy + 27), p);
    } else {
      for (int i = -1; i < 2; i++) {
        canvas.drawCircle(
          Offset(cx + i * 39, cy - (i == 0 ? 16 : 4)),
          i == 0 ? 15 : 12,
          p,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx + i * 39 - 16, cy + (i == 0 ? 5 : 15), 32, 27),
            const Radius.circular(15),
          ),
          p,
        );
      }
    }
    canvas.drawCircle(
      Offset(20, s.height + 20),
      65,
      Paint()..color = _pine.withValues(alpha: .07),
    );
  }

  @override
  bool shouldRepaint(covariant EventArt oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.color != color ||
      oldDelegate.food != food;
}
