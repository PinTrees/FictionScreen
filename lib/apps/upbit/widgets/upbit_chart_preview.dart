import 'package:flutter/material.dart';
import '../data/upbit_model.dart';

class UpbitChartPreview extends StatelessWidget {
  final UpbitCoinItem coin;

  const UpbitChartPreview({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // 상단 차트 주기 바 (1분, 5분, 15분, 1시간, 4시간, 일, 주)
          Row(
            children: [
              _buildIntervalButton('1분'),
              _buildIntervalButton('5분'),
              _buildIntervalButton('15분'),
              _buildIntervalButton('1시간'),
              _buildIntervalButton('일', isSelected: true),
              _buildIntervalButton('주'),
              _buildIntervalButton('월'),
              const Spacer(),
              const Text('지표', style: TextStyle(fontSize: 11, color: Colors.black54)),
              const SizedBox(width: 8),
              const Icon(Icons.settings, size: 14, color: Colors.black45),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFEEEEEE)),

          // 캔들스틱 시뮬레이션 차트
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _CandleChartPainter(isRise: coin.isRise),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalButton(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF093687) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _CandleChartPainter extends CustomPainter {
  final bool isRise;

  _CandleChartPainter({required this.isRise});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final redPaint = Paint()..color = const Color(0xFFC84A31)..strokeWidth = 1.2;
    final bluePaint = Paint()..color = const Color(0xFF1261C4)..strokeWidth = 1.2;
    final gridPaint = Paint()..color = Colors.grey.shade200..strokeWidth = 0.5;

    // 가로 가이드라인
    for (int i = 1; i <= 4; i++) {
      final y = size.height * (i / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final candleCount = 24;
    final candleWidth = (size.width / candleCount) * 0.65;
    final spacing = size.width / candleCount;

    // 캔들 시뮬레이션 데이터 렌더링
    for (int i = 0; i < candleCount; i++) {
      final x = i * spacing + spacing / 2;
      final up = (i % 3 != 0); // 대부분 상승세
      final p = up ? redPaint : bluePaint;

      final baseY = size.height * 0.5;
      final offset = (i - 12) * (isRise ? -3.5 : 2.5);
      final highY = (baseY + offset - (up ? 24 : 12)).clamp(10.0, size.height - 20);
      final lowY = (baseY + offset + (up ? 12 : 24)).clamp(10.0, size.height - 20);
      final openY = (baseY + offset + (up ? 6 : -6)).clamp(10.0, size.height - 20);
      final closeY = (baseY + offset - (up ? 10 : -10)).clamp(10.0, size.height - 20);

      // 꼬리 심지 (High - Low)
      canvas.drawLine(Offset(x, highY), Offset(x, lowY), p);

      // 몸통 (Open - Close)
      final top = openY < closeY ? openY : closeY;
      final bottom = openY < closeY ? closeY : openY;
      final rect = Rect.fromCenter(
        center: Offset(x, (top + bottom) / 2),
        width: candleWidth,
        height: (bottom - top).clamp(2.0, size.height),
      );
      canvas.drawRect(rect, Paint()..color = p.color);
    }
  }

  @override
  bool shouldRepaint(covariant _CandleChartPainter oldDelegate) => oldDelegate.isRise != isRise;
}
