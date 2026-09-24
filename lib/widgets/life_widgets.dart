import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/life_theme.dart';

class LifeLogo extends StatelessWidget {
  const LifeLogo({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: LifeColors.teal,
      borderRadius: BorderRadius.circular(size * .3),
      boxShadow: const [
        BoxShadow(
          color: Color(0x33177E78),
          blurRadius: 24,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.auto_awesome_rounded,
          color: LifeColors.yellow,
          size: size * .45,
        ),
        Positioned(
          right: size * .15,
          top: size * .14,
          child: CircleAvatar(
            radius: size * .055,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    ),
  );
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: Colors.white.withValues(alpha: .8)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1122304A),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: child,
  );
}

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.icon,
    required this.label,
    this.color = LifeColors.mint,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 19, color: LifeColors.navy),
        const SizedBox(width: 7),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ],
    ),
  );
}

class StoryStage extends StatelessWidget {
  const StoryStage({
    super.key,
    required this.scene,
    required this.character,
    required this.speaker,
  });
  final String scene;
  final String character;
  final String speaker;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$scene scene with $speaker speaking',
    image: true,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: CustomPaint(
          painter: _StoryPainter(scene: scene, character: character),
        ),
      ),
    ),
  );
}

class _StoryPainter extends CustomPainter {
  _StoryPainter({required this.scene, required this.character});
  final String scene;
  final String character;

  @override
  void paint(Canvas canvas, Size size) {
    final sky = switch (scene) {
      'school' => const Color(0xFFCEE5F2),
      'road' => const Color(0xFFFFDFB5),
      'online' => const Color(0xFFDCD7F6),
      'park' => const Color(0xFFD8F0D0),
      'market' => const Color(0xFFFFE7C5),
      _ => const Color(0xFFFFE3CC),
    };
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          colors: [sky, Colors.white],
        ).createShader(Offset.zero & size),
    );
    final ground = Paint()
      ..color = scene == 'park'
          ? const Color(0xFF9DCB82)
          : const Color(0xFFE9CBA7);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * .68, size.width, size.height * .32),
      ground,
    );
    _drawEnvironment(canvas, size);
    _drawCharacter(canvas, size, size.width * .7, character == 'guide');
    _drawCharacter(canvas, size, size.width * .27, true, small: true);
  }

  void _drawEnvironment(Canvas c, Size s) {
    final p = Paint()..color = Colors.white.withValues(alpha: .8);
    if (scene == 'online') {
      final screen = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          s.width * .08,
          s.height * .12,
          s.width * .46,
          s.height * .48,
        ),
        const Radius.circular(16),
      );
      c.drawRRect(screen, Paint()..color = const Color(0xFF36445F));
      for (var i = 0; i < 3; i++) {
        c.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              s.width * .14,
              s.height * (.19 + i * .11),
              s.width * .3,
              s.height * .065,
            ),
            const Radius.circular(12),
          ),
          Paint()..color = i.isEven ? LifeColors.teal : Colors.white,
        );
      }
    } else if (scene == 'school') {
      c.drawRect(
        Rect.fromLTWH(
          s.width * .08,
          s.height * .12,
          s.width * .4,
          s.height * .29,
        ),
        Paint()..color = const Color(0xFF52796F),
      );
      c.drawRect(
        Rect.fromLTWH(
          s.width * .1,
          s.height * .14,
          s.width * .36,
          s.height * .25,
        ),
        Paint()..color = const Color(0xFF84A98C),
      );
    } else if (scene == 'market') {
      for (var i = 0; i < 3; i++) {
        c.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              s.width * (.05 + i * .18),
              s.height * .25,
              s.width * .14,
              s.height * .38,
            ),
            const Radius.circular(8),
          ),
          Paint()
            ..color = [LifeColors.coral, LifeColors.yellow, LifeColors.teal][i],
        );
      }
    } else if (scene == 'road') {
      c.drawRect(
        Rect.fromLTWH(0, s.height * .56, s.width, s.height * .15),
        Paint()..color = const Color(0xFF87919B),
      );
      c.drawRect(
        Rect.fromLTWH(
          s.width * .1,
          s.height * .2,
          s.width * .28,
          s.height * .36,
        ),
        Paint()..color = const Color(0xFFF1C27D),
      );
      c.drawRect(
        Rect.fromLTWH(
          s.width * .17,
          s.height * .33,
          s.width * .13,
          s.height * .23,
        ),
        Paint()..color = LifeColors.teal,
      );
    } else {
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            s.width * .07,
            s.height * .22,
            s.width * .42,
            s.height * .34,
          ),
          const Radius.circular(12),
        ),
        p,
      );
      c.drawRect(
        Rect.fromLTWH(
          s.width * .12,
          s.height * .27,
          s.width * .32,
          s.height * .24,
        ),
        Paint()..color = const Color(0xFFB9DEF3),
      );
    }
  }

  void _drawCharacter(
    Canvas c,
    Size s,
    double x,
    bool friendly, {
    bool small = false,
  }) {
    final scale = small ? .76 : 1.0;
    final head = Offset(x, s.height * (small ? .42 : .36));
    final radius = s.height * .105 * scale;
    c.drawOval(
      Rect.fromCenter(
        center: Offset(x, s.height * .68),
        width: radius * 2.2,
        height: s.height * .38 * scale,
      ),
      Paint()..color = small ? LifeColors.teal : const Color(0xFF546E9E),
    );
    c.drawCircle(head, radius, Paint()..color = const Color(0xFFE8B98B));
    c.drawArc(
      Rect.fromCircle(center: head, radius: radius),
      math.pi,
      math.pi,
      true,
      Paint()
        ..color = friendly ? const Color(0xFF3C2A25) : const Color(0xFF5A463B),
    );
    final eye = Paint()..color = LifeColors.navy;
    c.drawCircle(Offset(x - radius * .35, head.dy), radius * .08, eye);
    c.drawCircle(Offset(x + radius * .35, head.dy), radius * .08, eye);
    c.drawArc(
      Rect.fromCenter(
        center: Offset(x, head.dy + radius * .24),
        width: radius * .55,
        height: radius * .35,
      ),
      0,
      math.pi,
      false,
      Paint()
        ..color = LifeColors.navy
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
  }

  @override
  bool shouldRepaint(covariant _StoryPainter oldDelegate) =>
      oldDelegate.scene != scene || oldDelegate.character != character;
}

class PageWidth extends StatelessWidget {
  const PageWidth({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 28),
  });
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Padding(padding: padding, child: child),
    ),
  );
}
