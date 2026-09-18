import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Apple iOS 26 리퀴드 글래스 정밀 원형 버튼 컴포넌트
/// - 연하고 은은하며 상하 살짝 비대칭으로 도톰한 리퀴드 글래스 굴절 림 적용 (media_1789747178861.png 100% 일치)
/// - 하단 1.6px 도톰한 유체 굴절 바운스 림 & 상단 0.9px 섬세한 스펙큘러 하이라이트
class Ios26CircleGlassButton extends StatelessWidget {
  final double size;
  final Widget child;
  final bool isActive;
  final Color activeBgColor;
  final VoidCallback onTap;

  const Ios26CircleGlassButton({
    super.key,
    required this.size,
    required this.child,
    this.isActive = false,
    this.activeBgColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isActive ? 0.24 : 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. 배경 (활성 시 솔리드 화이트/컬러, 비활성 시 가우시안 블러 유체 글래스)
              if (isActive)
                Container(color: activeBgColor)
              else
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.20),
                          Colors.white.withValues(alpha: 0.06),
                          Colors.white.withValues(alpha: 0.13),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

              // 2. 비대칭 리퀴드 글래스 아웃라인 (상단 0.9px 은은한 하이라이트 / 하단 1.6px 도톰한 굴절 림)
              if (!isActive)
                const Positioned.fill(
                  child: CustomPaint(
                    painter: LiquidGlassAsymmetricRimPainter(),
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 0.8),
                  ),
                ),

              // 3. 중앙 아이콘
              Center(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

/// 연하고 살짝 비대칭으로 도톰한 리퀴드 글래스 굴절 림 페인터 (media_1789747178861.png 100% 일치)
class LiquidGlassAsymmetricRimPainter extends CustomPainter {
  const LiquidGlassAsymmetricRimPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. 전체 베이스 미세 테두리 (극도로 얇고 은은함 - 0.6px, alpha: 0.12)
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = Colors.white.withValues(alpha: 0.12)
      ..isAntiAlias = true;
    canvas.drawCircle(center, radius - 0.3, basePaint);

    // 2. 상단 섬세한 하이라이트 림 (시계방향 -135도 ~ -45도, 두께: 0.9px, alpha: 0.32)
    final topRect = Rect.fromCircle(center: center, radius: radius - 0.5);
    final topPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: -math.pi * 0.85,
        endAngle: -math.pi * 0.15,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.32),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(topRect);

    canvas.drawArc(topRect, -math.pi * 0.85, math.pi * 0.70, false, topPaint);

    // 3. 하단 살짝 비대칭으로 도톰하고 은은한 바운스 림 (시계방향 25도 ~ 155도, 두께: 1.6px, alpha: 0.42)
    final bottomRect = Rect.fromCircle(center: center, radius: radius - 0.8);
    final bottomPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: math.pi * 0.15,
        endAngle: math.pi * 0.85,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.42),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(bottomRect);

    canvas.drawArc(bottomRect, math.pi * 0.15, math.pi * 0.70, false, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
