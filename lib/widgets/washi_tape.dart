import 'package:flutter/material.dart';

/// Renders a semi-translucent washi tape strip with torn edges
/// evoking real physical paper tape in a scrapbook.
class WashiTape extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double angle; // subtle rotation in radians

  const WashiTape({
    super.key,
    this.width = 54.0,
    this.height = 14.0,
    this.color = const Color(0x55FFFFFF),
    this.angle = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: CustomPaint(
        size: Size(width, height),
        painter: _WashiTapePainter(color: color),
      ),
    );
  }
}

class _WashiTapePainter extends CustomPainter {
  final Color color;

  _WashiTapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Create a path with serrated / torn tape ends
    final path = Path();
    const toothCount = 4;
    final leftStep = size.height / toothCount;

    // Start top-left
    path.moveTo(0, 0);

    // Top edge (clean horizontal)
    path.lineTo(size.width, 0);

    // Right torn edge
    final rightStep = size.height / toothCount;
    for (int i = 0; i < toothCount; i++) {
      final y = i * rightStep;
      final midY = y + (rightStep / 2);
      final nextY = (i + 1) * rightStep;
      path.lineTo(size.width - 2.5, midY);
      path.lineTo(size.width, nextY);
    }

    // Bottom edge
    path.lineTo(0, size.height);

    // Left torn edge
    for (int i = toothCount - 1; i >= 0; i--) {
      final y = (i + 1) * leftStep;
      final midY = y - (leftStep / 2);
      final prevY = i * leftStep;
      path.lineTo(2.5, midY);
      path.lineTo(0, prevY);
    }

    path.close();

    // Subtle drop shadow for tape thickness
    final shadowPaint = Paint()
      ..color = const Color(0x10000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawPath(path.shift(const Offset(0, 1.0)), shadowPaint);

    // Draw tape body
    canvas.drawPath(path, paint);

    // Draw subtle matte tape sheen line
    final sheenPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(4, size.height * 0.35),
      Offset(size.width - 4, size.height * 0.35),
      sheenPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WashiTapePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
