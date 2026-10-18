import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/scrapbook_theme.dart';

/// Wraps content in a subtle off-white cream background with an authentic
/// light film-grain paper texture.
class GrainBackground extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double grainIntensity; // 0.0 to 1.0

  const GrainBackground({
    super.key,
    required this.child,
    this.backgroundColor = ScrapbookTheme.creamBackground,
    this.grainIntensity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background film-grain overlay
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _FilmGrainPainter(
                    intensity: grainIntensity,
                  ),
                ),
              ),
            ),
          ),
          // App Content
          child,
        ],
      ),
    );
  }
}

/// CustomPainter generating a soft analog film-grain texture
/// using deterministic pseudo-random micro-speckles.
class _FilmGrainPainter extends CustomPainter {
  final double intensity;

  _FilmGrainPainter({this.intensity = 0.05});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Use deterministic seed so grain doesn't jitter or redraw differently
    final random = math.Random(4289);
    final paintDark = Paint()
      ..color = const Color(0xFF2B241E).withOpacity(intensity * 0.9)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.square;

    final paintLight = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(intensity * 1.2)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.square;

    // Density of noise points
    final pointCount = ((size.width * size.height) / 80).clamp(1500, 14000).toInt();

    final List<Offset> darkPoints = [];
    final List<Offset> lightPoints = [];

    for (int i = 0; i < pointCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      if (random.nextBool()) {
        darkPoints.add(Offset(x, y));
      } else {
        lightPoints.add(Offset(x, y));
      }
    }

    canvas.drawPoints(ui.PointMode.points, darkPoints, paintDark);
    canvas.drawPoints(ui.PointMode.points, lightPoints, paintLight);
  }

  @override
  bool shouldRepaint(covariant _FilmGrainPainter oldDelegate) {
    return oldDelegate.intensity != intensity;
  }
}
