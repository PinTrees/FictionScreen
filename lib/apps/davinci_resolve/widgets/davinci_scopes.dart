import 'package:flutter/material.dart';

class DavinciScopes extends StatelessWidget {
  const DavinciScopes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B1B1E),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.stacked_line_chart, size: 13, color: Color(0xFFE53935)),
              SizedBox(width: 6),
              Text(
                'RGB PARADE SCOPE',
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              Spacer(),
              Text('10-bit Video (0-1023)', style: TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0E0E10),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF28282C)),
              ),
              child: CustomPaint(
                painter: _RgbParadePainter(),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RgbParadePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final channelWidth = size.width / 3;

    // Grid lines (0, 256, 512, 768, 1024)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 0.8;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Dividers between R, G, B channels
    final divPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(channelWidth, 0), Offset(channelWidth, size.height), divPaint);
    canvas.drawLine(Offset(channelWidth * 2, 0), Offset(channelWidth * 2, size.height), divPaint);

    // Channel 1: RED Waveform
    _drawChannelWave(canvas, 0, channelWidth, size.height, const Color(0xFFFF5252));

    // Channel 2: GREEN Waveform
    _drawChannelWave(canvas, channelWidth, channelWidth, size.height, const Color(0xFF69F0AE));

    // Channel 3: BLUE Waveform
    _drawChannelWave(canvas, channelWidth * 2, channelWidth, size.height, const Color(0xFF448AFF));
  }

  void _drawChannelWave(Canvas canvas, double startX, double width, double height, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final step = width / 20;

    path.moveTo(startX, height * 0.85);
    for (int i = 1; i <= 20; i++) {
      final x = startX + i * step;
      // Simulated realistic video waveform peaks
      final mod = (i % 3 == 0) ? 0.35 : ((i % 2 == 0) ? 0.55 : 0.75);
      final y = height * mod;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);

    // Fill glow
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final fillPath = Path.from(path)
      ..lineTo(startX + width, height)
      ..lineTo(startX, height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
