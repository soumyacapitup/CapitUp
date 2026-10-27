import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Original illustrations drawn in code (no image assets). Each scene floats gently; static when the system asks
/// for reduced motion.
enum Scene { organise, ask, remind, family, empty, shield }

class SceneArt extends StatefulWidget {
  const SceneArt(this.scene, {super.key, this.size = 220, this.animate = true, this.backdrop = true});
  final Scene scene;
  final double size;
  final bool animate;

  /// The soft disc behind the scene. Turn off on dark panels.
  final bool backdrop;

  @override
  State<SceneArt> createState() => _SceneArtState();
}

class _SceneArtState extends State<SceneArt> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(seconds: 5));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    widget.animate && !reduce ? _c.repeat() : _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) => CustomPaint(painter: _ScenePainter(widget.scene, _c.value, widget.backdrop)),
      ),
    ),
  );
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.scene, this.t, this.backdrop);
  final Scene scene;
  final double t;
  final bool backdrop;

  // Soft vertical bob for element [i].
  double _bob(int i, double amp) => math.sin((t + i * 0.23) * 2 * math.pi) * amp;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    canvas.save();
    canvas.scale(s / 220);
    if (backdrop) _backdrop(canvas);
    switch (scene) {
      case Scene.organise:
        _organise(canvas);
      case Scene.ask:
        _ask(canvas);
      case Scene.remind:
        _remind(canvas);
      case Scene.family:
        _family(canvas);
      case Scene.empty:
        _empty(canvas);
      case Scene.shield:
        _shieldScene(canvas);
    }
    canvas.restore();
  }

  Paint _p(Color c) => Paint()..color = c;

  void _rrect(Canvas c, Rect r, double rad, Color color, {Color? border}) {
    final rr = RRect.fromRectAndRadius(r, Radius.circular(rad));
    c.drawRRect(rr, _p(color));
    if (border != null) {
      c.drawRRect(
        rr,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = border,
      );
    }
  }

  void _shadowCard(Canvas c, Rect r, double rad, Color color) {
    c.drawRRect(
      RRect.fromRectAndRadius(r.shift(const Offset(0, 6)), Radius.circular(rad)),
      Paint()
        ..color = const Color(0x220B2B2E)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    _rrect(c, r, rad, color);
  }

  void _lines(Canvas c, double x, double y, List<double> widths, {Color color = const Color(0xFFDCE5E3)}) {
    var yy = y;
    for (final w in widths) {
      _rrect(c, Rect.fromLTWH(x, yy, w, 7), 3.5, color);
      yy += 14;
    }
  }

  void _sparkle(Canvas c, Offset o, double r, Color color) {
    final path = Path()
      ..moveTo(o.dx, o.dy - r)
      ..quadraticBezierTo(o.dx, o.dy, o.dx + r, o.dy)
      ..quadraticBezierTo(o.dx, o.dy, o.dx, o.dy + r)
      ..quadraticBezierTo(o.dx, o.dy, o.dx - r, o.dy)
      ..quadraticBezierTo(o.dx, o.dy, o.dx, o.dy - r);
    c.drawPath(path, _p(color));
  }

  void _coin(Canvas c, Offset o, double r) {
    c.drawCircle(
      o,
      r,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFE08A), AppColors.gold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromCircle(center: o, radius: r)),
    );
    c.drawCircle(
      o,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.14
        ..color = const Color(0xFFC98A12),
    );
    final arrow = Path()
      ..moveTo(o.dx - r * 0.45, o.dy + r * 0.25)
      ..lineTo(o.dx - r * 0.1, o.dy - r * 0.1)
      ..lineTo(o.dx + r * 0.1, o.dy + r * 0.1)
      ..lineTo(o.dx + r * 0.45, o.dy - r * 0.3);
    c.drawPath(
      arrow,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.17
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = const Color(0xFF9A6408),
    );
  }

  void _check(Canvas c, Offset o, double r, {Color? bg}) {
    bg ??= AppColors.primary;
    c.drawCircle(o, r, _p(bg));
    final p = Path()
      ..moveTo(o.dx - r * 0.42, o.dy + r * 0.02)
      ..lineTo(o.dx - r * 0.1, o.dy + r * 0.34)
      ..lineTo(o.dx + r * 0.44, o.dy - r * 0.3);
    c.drawPath(
      p,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.22
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white,
    );
  }

  void _backdrop(Canvas c) {
    c.drawCircle(const Offset(110, 112), 92, _p(const Color(0x99FFFFFF)));
    c.drawCircle(const Offset(36, 52), 14, _p(AppColors.goldTint));
    c.drawCircle(const Offset(188, 178), 10, _p(AppColors.surfaceTint));
    _sparkle(c, Offset(186, 46 + _bob(1, 2)), 9, AppColors.gold);
    _sparkle(c, Offset(30, 170 + _bob(2, 2)), 6, AppColors.primary.withValues(alpha: 0.5));
  }

  void _organise(Canvas c) {
    c.save();
    c.translate(110, 120);
    c.rotate(-0.16);
    _shadowCard(c, const Rect.fromLTWH(-66, -62, 100, 118), 14, const Color(0xFFFFE3E3));
    c.restore();
    c.save();
    c.translate(112, 118);
    c.rotate(0.14);
    _shadowCard(c, const Rect.fromLTWH(-30, -58, 100, 118), 14, const Color(0xFFE6E2FA));
    c.restore();
    final dy = _bob(0, 3);
    _shadowCard(c, Rect.fromLTWH(58, 46 + dy, 104, 124), 16, Colors.white);
    _rrect(c, Rect.fromLTWH(70, 60 + dy, 36, 10), 5, AppColors.primary);
    _lines(c, 70, 82 + dy, [80, 64, 72]);
    _lines(c, 70, 128 + dy, [48]);
    _check(c, Offset(150, 162 + dy), 20);
    _coin(c, Offset(44, 150 + _bob(3, 3)), 16);
  }

  void _ask(Canvas c) {
    final d1 = _bob(0, 3);
    _shadowCard(c, Rect.fromLTWH(30, 40 + d1, 128, 74), 18, Colors.white);
    _lines(c, 44, 56 + d1, [96, 70]);
    _rrect(c, Rect.fromLTWH(44, 86 + d1, 84, 11), 5.5, AppColors.goldTint);
    _rrect(c, Rect.fromLTWH(44, 88 + d1, 60, 7), 3.5, AppColors.gold);
    final d2 = _bob(2, 3);
    _shadowCard(c, Rect.fromLTWH(78, 128 + d2, 116, 54), 18, AppColors.primary);
    _lines(c, 92, 142 + d2, [84, 56], color: const Color(0x66FFFFFF));
    final o = Offset(168, 70 + _bob(1, 3));
    c.drawCircle(o, 24, _p(Colors.white));
    c.drawCircle(
      o,
      24,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..color = AppColors.ink,
    );
    c.drawLine(
      o + const Offset(17, 17),
      o + const Offset(34, 34),
      Paint()
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..color = AppColors.ink,
    );
    _sparkle(c, o + const Offset(-4, -4), 8, AppColors.gold);
  }

  void _remind(Canvas c) {
    final d = _bob(0, 3);
    _shadowCard(c, Rect.fromLTWH(34, 52 + d, 128, 118), 18, Colors.white);
    _rrect(c, Rect.fromLTWH(34, 52 + d, 128, 32), 18, AppColors.primary);
    c.drawRect(Rect.fromLTWH(34, 68 + d, 128, 16), _p(AppColors.primary));
    for (var r = 0; r < 3; r++) {
      for (var col = 0; col < 4; col++) {
        final hot = r == 1 && col == 2;
        c.drawCircle(
          Offset(54 + col * 30.0, 106 + r * 22.0 + d),
          hot ? 8 : 5,
          _p(hot ? AppColors.gold : const Color(0xFFDCE5E3)),
        );
      }
    }
    final b = Offset(160, 60 + _bob(2, 4));
    c.drawCircle(b, 28, _p(AppColors.goldTint));
    final bell = Path()
      ..moveTo(b.dx - 14, b.dy + 8)
      ..quadraticBezierTo(b.dx - 14, b.dy - 16, b.dx, b.dy - 16)
      ..quadraticBezierTo(b.dx + 14, b.dy - 16, b.dx + 14, b.dy + 8)
      ..lineTo(b.dx + 18, b.dy + 12)
      ..lineTo(b.dx - 18, b.dy + 12)
      ..close();
    c.drawPath(bell, _p(AppColors.gold));
    c.drawCircle(b + const Offset(0, 17), 4.5, _p(AppColors.goldText));
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = AppColors.gold.withValues(alpha: 0.7);
    c.drawArc(Rect.fromCircle(center: b, radius: 34), -0.4, 0.5, false, ring);
    c.drawArc(Rect.fromCircle(center: b, radius: 34), math.pi - 0.1, 0.5, false, ring);
  }

  void _person(Canvas c, Offset o, double r, Color body, Color skin) {
    c.drawCircle(o + Offset(0, r * 2.1), r * 1.5, _p(body));
    c.drawCircle(o, r, _p(skin));
  }

  void _family(Canvas c) {
    final d = _bob(0, 3);
    _shadowCard(c, Rect.fromLTWH(30, 108 + d, 160, 70), 20, Colors.white);
    _person(c, Offset(62, 100 + d), 15, AppColors.life, const Color(0xFFF3C9A8));
    _person(c, Offset(110, 88 + d), 19, AppColors.primary, const Color(0xFFE5AE88));
    _person(c, Offset(158, 100 + d), 15, AppColors.gold, const Color(0xFFD9A07A));
    final s = Offset(110, 46 + _bob(2, 4));
    _shield(c, s, 22, AppColors.primary);
    _check(c, s + const Offset(0, -1), 9, bg: Colors.white);
    c.drawPath(
      Path()
        ..moveTo(s.dx - 4, s.dy - 1)
        ..lineTo(s.dx - 1, s.dy + 3)
        ..lineTo(s.dx + 5, s.dy - 4),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.primary,
    );
  }

  void _shield(Canvas c, Offset o, double r, Color color) {
    final p = Path()
      ..moveTo(o.dx, o.dy - r * 1.15)
      ..lineTo(o.dx + r, o.dy - r * 0.7)
      ..quadraticBezierTo(o.dx + r, o.dy + r * 0.7, o.dx, o.dy + r * 1.25)
      ..quadraticBezierTo(o.dx - r, o.dy + r * 0.7, o.dx - r, o.dy - r * 0.7)
      ..close();
    c.drawPath(p, _p(color));
  }

  void _empty(Canvas c) {
    final d = _bob(0, 3);
    _rrect(c, Rect.fromLTWH(44, 76 + d, 62, 22), 10, const Color(0xFFBFDCD8));
    _shadowCard(c, Rect.fromLTWH(44, 88 + d, 132, 84), 16, AppColors.primary);
    _rrect(c, Rect.fromLTWH(44, 100 + d, 132, 72), 16, AppColors.primaryDark);
    _sparkle(c, Offset(110, 62 + _bob(1, 3)), 12, AppColors.gold);
    _sparkle(c, Offset(70, 54 + _bob(2, 3)), 7, AppColors.gold);
    _sparkle(c, Offset(152, 70 + _bob(3, 3)), 8, AppColors.primary.withValues(alpha: 0.6));
  }

  void _shieldScene(Canvas c) {
    final d = _bob(0, 4);
    c.drawCircle(Offset(110, 112 + d), 58, _p(AppColors.goldTint));
    _shield(c, Offset(110, 106 + d), 46, AppColors.primary);
    _shield(c, Offset(110, 106 + d), 36, AppColors.primaryDark);
    _check(c, Offset(110, 104 + d), 20, bg: AppColors.gold);
    _coin(c, Offset(48, 80 + _bob(1, 4)), 15);
    _coin(c, Offset(176, 148 + _bob(2, 4)), 12);
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.t != t || old.scene != scene || old.backdrop != backdrop;
}
