import 'dart:math';
import 'package:flutter/material.dart';
import '../data/davinci_resolve_model.dart';

class DavinciColorWheels extends StatelessWidget {
  final ColorWheelValues values;
  final ValueChanged<ColorWheelValues> onChanged;

  const DavinciColorWheels({
    super.key,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF141416),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // 4 Color Wheels in a row
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildSingleWheel('LIFT', values.lift, (off) => onChanged(values.copyWith(lift: off)))),
                const SizedBox(width: 8),
                Expanded(child: _buildSingleWheel('GAMMA', values.gamma, (off) => onChanged(values.copyWith(gamma: off)))),
                const SizedBox(width: 8),
                Expanded(child: _buildSingleWheel('GAIN', values.gain, (off) => onChanged(values.copyWith(gain: off)))),
                const SizedBox(width: 8),
                Expanded(child: _buildSingleWheel('OFFSET', values.offset, (off) => onChanged(values.copyWith(offset: off)))),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Bottom Quick Sliders (Temp, Tint, Contrast, Saturation)
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B1E),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF28282C)),
            ),
            child: Row(
              children: [
                _sliderParam('Temp', values.temp.toStringAsFixed(1), const Color(0xFFFF9800)),
                _vDivider(),
                _sliderParam('Tint', values.tint.toStringAsFixed(1), const Color(0xFFE91E63)),
                _vDivider(),
                _sliderParam('Contrast', values.contrast.toStringAsFixed(2), const Color(0xFF2196F3)),
                _vDivider(),
                _sliderParam('Sat', values.saturation.toStringAsFixed(0), const Color(0xFF4CAF50)),
                const Spacer(),
                const Text('Primaries - Color Wheels', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 0.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleWheel(String label, Offset offset, ValueChanged<Offset> onMove) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFFB0B0B8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = min(constraints.maxWidth, constraints.maxHeight) - 8;
              if (size <= 20) return const SizedBox.shrink();

              return GestureDetector(
                onPanUpdate: (details) {
                  final renderBox = context.findRenderObject() as RenderBox?;
                  if (renderBox == null) return;
                  final localPos = renderBox.globalToLocal(details.globalPosition);
                  final radius = size / 2;
                  final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
                  final dx = (localPos.dx - center.dx) / radius;
                  final dy = (localPos.dy - center.dy) / radius;
                  final dist = sqrt(dx * dx + dy * dy);
                  if (dist <= 1.0) {
                    onMove(Offset(dx, dy));
                  } else {
                    onMove(Offset(dx / dist, dy / dist));
                  }
                },
                child: Center(
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: CustomPaint(
                      painter: _ColorWheelPainter(offset: offset),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'R ${(offset.dx * 10).toStringAsFixed(1)}  B ${(offset.dy * 10).toStringAsFixed(1)}',
          style: const TextStyle(color: Colors.white54, fontSize: 9.5, fontFamily: 'Consolas'),
        ),
      ],
    );
  }

  Widget _sliderParam(String label, String value, Color accent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: accent, fontSize: 10.5, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2)),
          child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Consolas')),
        ),
      ],
    );
  }

  Widget _vDivider() {
    return Container(
      width: 1,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white12,
    );
  }
}

class _ColorWheelPainter extends CustomPainter {
  final Offset offset;

  _ColorWheelPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = const Color(0xFF1B1B1E)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Color gradient ring
    final sweepGradient = SweepGradient(
      colors: const [
        Color(0xFFFF0000), // Red
        Color(0xFFFFFF00), // Yellow
        Color(0xFF00FF00), // Green
        Color(0xFF00FFFF), // Cyan
        Color(0xFF0000FF), // Blue
        Color(0xFFFF00FF), // Magenta
        Color(0xFFFF0000), // Red
      ],
    );
    final ringPaint = Paint()
      ..shader = sweepGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawCircle(center, radius - 2, ringPaint);

    // Subtle crosshairs
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(center.dx, center.dy - radius + 5), Offset(center.dx, center.dy + radius - 5), gridPaint);
    canvas.drawLine(Offset(center.dx - radius + 5, center.dy), Offset(center.dx + radius - 5, center.dy), gridPaint);
    canvas.drawCircle(center, radius * 0.4, gridPaint);

    // Pointer Dot
    final pointerX = center.dx + offset.dx * (radius - 8);
    final pointerY = center.dy + offset.dy * (radius - 8);
    final pointerCenter = Offset(pointerX, pointerY);

    // Outer glow
    final glowPaint = Paint()
      ..color = const Color(0xFFE53935).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pointerCenter, 5, glowPaint);

    // White dot
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pointerCenter, 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _ColorWheelPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}
