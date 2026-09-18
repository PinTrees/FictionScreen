import 'package:flutter/material.dart';

/// 로또 6/45 공식 5색 입체 구체(3D Ball) 위젯
class LotteryBallWidget extends StatelessWidget {
  final int number;
  final double size;
  final bool isBonus;
  final bool isMatched; // 영수증에서 당첨 번호 일치 시 도장 링 표시

  const LotteryBallWidget({
    super.key,
    required this.number,
    this.size = 42.0,
    this.isBonus = false,
    this.isMatched = false,
  });

  /// 번호 대역별 공식 색상 페어 (탑 하이라이트 색상, 베이스 섀도우 색상)
  static (Color, Color) getBallColors(int num) {
    if (num <= 10) {
      // 1 ~ 10: 노랑 / 황금색
      return (const Color(0xFFFFD54F), const Color(0xFFF59E0B));
    } else if (num <= 20) {
      // 11 ~ 20: 파랑
      return (const Color(0xFF60A5FA), const Color(0xFF2563EB));
    } else if (num <= 30) {
      // 21 ~ 30: 빨강
      return (const Color(0xFFF87171), const Color(0xFFDC2626));
    } else if (num <= 40) {
      // 31 ~ 40: 회색
      return (const Color(0xFFCBD5E1), const Color(0xFF64748B));
    } else {
      // 41 ~ 45: 초록
      return (const Color(0xFF86EFAC), const Color(0xFF16A34A));
    }
  }

  @override
  Widget build(BuildContext context) {
    final (lightColor, darkColor) = getBallColors(number);

    Widget ball = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 0.85,
          colors: [
            Colors.white.withValues(alpha: 0.95),
            lightColor,
            darkColor,
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: darkColor.withValues(alpha: 0.45),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: size * 0.15,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: size * 0.44,
            letterSpacing: -0.5,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 2,
                offset: const Offset(0.5, 0.5),
              ),
            ],
          ),
        ),
      ),
    );

    if (isMatched) {
      // 실제 복권에 찍히는 빨간색 도장 링 표식
      return Stack(
        alignment: Alignment.center,
        children: [
          ball,
          Container(
            width: size + 8,
            height: size + 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFEF4444),
                width: 2.2,
              ),
            ),
          ),
        ],
      );
    }

    return ball;
  }
}
