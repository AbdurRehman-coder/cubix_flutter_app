import 'package:cubix_app/core/utils/app_exports.dart';

class Cube3D extends StatelessWidget {
  final Gradient gradient;
  final double size;

  const Cube3D({super.key, required this.gradient, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CubePainter(gradient: gradient),
    );
  }
}

class _CubePainter extends CustomPainter {
  final Gradient gradient;

  _CubePainter({required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromLTWH(0, 0, size.width, size.height),
          )
          ..style = PaintingStyle.fill;

    // Draw rounded cube shape
    final RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.width * 0.2),
    );

    canvas.drawRRect(roundedRect, paint);

    // Optional: Light overlay for 3D effect
    final Paint light =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white.withValues(alpha: 0.25), Colors.transparent],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRRect(roundedRect, light);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
