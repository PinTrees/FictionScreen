import 'dart:math' as math;
import 'package:flutter/material.dart';

/// iOS 26 제어 센터 상단 헤더 (+ 및 ⏻ 유틸리티 버튼, SKT LTE 4바 & 93% 배터리)
class Ios26CcHeader extends StatelessWidget {
  final double horizontalPadding;
  final VoidCallback onClose;

  const Ios26CcHeader({super.key, required this.horizontalPadding, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          // 1. 최상단 유틸리티 버튼 행 (+ 및 ⏻) - 스크린샷 100% 일치
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 32,
                  height: 32,
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  child: const _HeaderPlusIcon(size: 19, color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 32,
                  height: 32,
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: const _HeaderPowerIcon(size: 19, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. 상태 서브헤더 (4바 SKT LTE | 🔒 93% 🔋⚡)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 통신사 4바 + SKT LTE
              Row(
                children: [
                  _buildSignalBars(),
                  const SizedBox(width: 6),
                  const Text('SKT LTE', style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
                ],
              ),

              // 잠금 + 배터리 93% + 녹색 충전 배터리
              Row(
                children: [
                  const _HeaderLockIcon(size: 12, color: Colors.white),
                  const SizedBox(width: 4),
                  const Text('93%', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 5),
                  // 녹색 충전 배터리 캡슐
                  Container(
                    width: 25,
                    height: 12.5,
                    padding: const EdgeInsets.all(1.2),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.5), border: Border.all(color: Colors.white, width: 1.1)),
                    child: Container(
                      decoration: BoxDecoration(color: const Color(0xFF34C759), borderRadius: BorderRadius.circular(1.5)),
                      child: const Center(child: Icon(Icons.bolt_rounded, color: Colors.black, size: 10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignalBars() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildBar(4), const SizedBox(width: 1.5),
        _buildBar(6), const SizedBox(width: 1.5),
        _buildBar(8), const SizedBox(width: 1.5),
        _buildBar(10),
      ],
    );
  }

  Widget _buildBar(double height) => Container(width: 2.5, height: height, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0.8)));
}

class _HeaderPlusIcon extends StatelessWidget {
  final double size;
  final Color color;
  const _HeaderPlusIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PlusPainter(color),
    );
  }
}

class _PlusPainter extends CustomPainter {
  final Color color;
  _PlusPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.0..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), stroke);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), stroke);
  }

  @override
  bool shouldRepaint(covariant _PlusPainter oldDelegate) => oldDelegate.color != color;
}

class _HeaderPowerIcon extends StatelessWidget {
  final double size;
  final Color color;
  const _HeaderPowerIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PowerPainter(color),
    );
  }
}

class _PowerPainter extends CustomPainter {
  final Color color;
  _PowerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.9..strokeCap = StrokeCap.round;
    final center = Offset(size.width / 2, size.height / 2 + 1);
    final r = size.width * 0.40;

    // 270도 원호
    canvas.drawArc(Rect.fromCircle(center: center, radius: r), -math.pi * 0.25, math.pi * 1.50, false, stroke);
    // 상단 수직선
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, center.dy), stroke);
  }

  @override
  bool shouldRepaint(covariant _PowerPainter oldDelegate) => oldDelegate.color != color;
}

class _HeaderLockIcon extends StatelessWidget {
  final double size;
  final Color color;
  const _HeaderLockIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LockPainter(color),
    );
  }
}

class _LockPainter extends CustomPainter {
  final Color color;
  _LockPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color..style = PaintingStyle.fill;
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.2..strokeCap = StrokeCap.round;

    final body = RRect.fromRectAndRadius(Rect.fromLTWH(0, size.height * 0.40, size.width, size.height * 0.60), const Radius.circular(2));
    canvas.drawRRect(body, fill);

    final shackle = Rect.fromCenter(center: Offset(size.width / 2, size.height * 0.40), width: size.width * 0.60, height: size.height * 0.50);
    canvas.drawArc(shackle, math.pi, math.pi, false, stroke);
  }

  @override
  bool shouldRepaint(covariant _LockPainter oldDelegate) => oldDelegate.color != color;
}
