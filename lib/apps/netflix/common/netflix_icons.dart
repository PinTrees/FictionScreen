import 'package:flutter/material.dart';

/// 넷플릭스 시그니처 레드 워드마크 / N 리본 로고 위젯
class NetflixWordmark extends StatelessWidget {
  final double fontSize;
  final bool isNOnly;

  const NetflixWordmark({
    super.key,
    this.fontSize = 28,
    this.isNOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isNOnly) {
      return SizedBox(
        width: fontSize * 0.75,
        height: fontSize * 1.2,
        child: CustomPaint(
          painter: _NetflixRibbonPainter(),
        ),
      );
    }

    return Text(
      'NETFLIX',
      style: TextStyle(
        color: const Color(0xFFE50914),
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
      ),
    );
  }
}

/// 넷플릭스 시그니처 'N' 레드 리본 벡터 페인터
class _NetflixRibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 좌측 기둥 (어두운 레드)
    final leftPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.35, 0)
      ..lineTo(w * 0.35, h)
      ..lineTo(0, h)
      ..close();
    final leftPaint = Paint()..color = const Color(0xFFB81D24);
    canvas.drawPath(leftPath, leftPaint);

    // 우측 기둥 (어두운 레드)
    final rightPath = Path()
      ..moveTo(w * 0.65, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(w * 0.65, h)
      ..close();
    final rightPaint = Paint()..color = const Color(0xFFB81D24);
    canvas.drawPath(rightPath, rightPaint);

    // 대각선 리본 (밝은 시그니처 레드)
    final diagPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.35, 0)
      ..lineTo(w, h)
      ..lineTo(w * 0.65, h)
      ..close();
    final diagPaint = Paint()
      ..color = const Color(0xFFE50914)
      ..style = PaintingStyle.fill;
    canvas.drawPath(diagPath, diagPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 넷플릭스 TOP 10 상징 거대 아웃라인 3D 순위 숫자
class NetflixTop10Number extends StatelessWidget {
  final int rank;
  final double height;

  const NetflixTop10Number({
    super.key,
    required this.rank,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    final text = rank.toString();
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // 테두리 외곽선 (그레이/화이트)
          Text(
            text,
            style: TextStyle(
              fontSize: height * 0.95,
              fontWeight: FontWeight.w900,
              letterSpacing: -12,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4.0
                ..color = const Color(0xFF595959),
            ),
          ),
          // 내부 어두운 그라데이션 채움
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF222222), Color(0xFF000000)],
            ).createShader(bounds),
            child: Text(
              text,
              style: TextStyle(
                fontSize: height * 0.95,
                fontWeight: FontWeight.w900,
                letterSpacing: -12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 넷플릭스 연령 등급 뱃지 (19, 15, 12, ALL)
class NetflixAgeBadge extends StatelessWidget {
  final String rating;
  final double size;

  const NetflixAgeBadge({
    super.key,
    required this.rating,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    String label = rating;

    switch (rating) {
      case '19':
        bg = const Color(0xFFCC0000);
        border = const Color(0xFFFF4444);
        break;
      case '15':
        bg = const Color(0xFFE67E22);
        border = const Color(0xFFF39C12);
        break;
      case '12':
        bg = const Color(0xFFF1C40F);
        border = const Color(0xFFF39C12);
        break;
      case 'ALL':
      default:
        bg = const Color(0xFF27AE60);
        border = const Color(0xFF2ECC71);
        label = '전체';
        break;
    }

    return Container(
      width: size * 1.3,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.58,
          fontWeight: FontWeight.w900,
          height: 1.0,
        ),
      ),
    );
  }
}
