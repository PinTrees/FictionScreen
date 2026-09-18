import 'package:flutter/material.dart';

/// 유튜브 공식 UI 아이콘 및 로고 모음 (Flutter Native CustomPainter 기반)
/// 웹, 모바일, 데스크톱 모든 환경에서 100% 선명하고 깨짐 없이 렌더링됩니다.
class YouTubeIcons {
  YouTubeIcons._();

  /// 유튜브 공식 로고 (빨간색 재생 버튼 + YouTube 워드마크)
  static Widget logo({
    double height = 20,
    bool isDark = false,
  }) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F0F0F);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Red Play Icon
        Container(
          width: height * 1.4,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFFF0000),
            borderRadius: BorderRadius.circular(height * 0.28),
          ),
          child: Center(
            child: CustomPaint(
              size: Size(height * 0.45, height * 0.5),
              painter: _PlayTrianglePainter(),
            ),
          ),
        ),
        const SizedBox(width: 4),
        // YouTube text
        Text(
          'YouTube',
          style: TextStyle(
            color: textColor,
            fontSize: height * 0.9,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  /// 홈 아이콘
  static Widget home({bool filled = false, Color color = Colors.black, double size = 24}) {
    return CustomPaint(size: Size(size, size), painter: _YtHomePainter(color: color, filled: filled));
  }

  /// Shorts 아이콘
  static Widget shorts({bool filled = false, Color color = Colors.black, double size = 24}) {
    return CustomPaint(size: Size(size, size), painter: _YtShortsPainter(color: color, filled: filled));
  }

  /// 만들기 (+) 아이콘
  static Widget create({Color color = Colors.black, double size = 32}) {
    return CustomPaint(size: Size(size, size), painter: _YtCreatePainter(color: color));
  }

  /// 구독 아이콘
  static Widget subscriptions({bool filled = false, Color color = Colors.black, double size = 24}) {
    return CustomPaint(size: Size(size, size), painter: _YtSubscriptionsPainter(color: color, filled: filled));
  }

  /// 보관함 / You 아이콘
  static Widget library({bool filled = false, Color color = Colors.black, double size = 24}) {
    return CustomPaint(size: Size(size, size), painter: _YtLibraryPainter(color: color, filled: filled));
  }

  /// 캐스트(Cast) 아이콘
  static Widget cast({Color color = Colors.black, double size = 22}) {
    return CustomPaint(size: Size(size, size), painter: _YtCastPainter(color: color));
  }

  /// 좋아요 (Thumbs Up)
  static Widget thumbsUp({bool filled = false, Color color = Colors.black, double size = 20}) {
    return CustomPaint(size: Size(size, size), painter: _YtThumbsUpPainter(color: color, filled: filled));
  }

  /// 싫어요 (Thumbs Down)
  static Widget thumbsDown({bool filled = false, Color color = Colors.black, double size = 20}) {
    return CustomPaint(size: Size(size, size), painter: _YtThumbsDownPainter(color: color, filled: filled));
  }

  /// 공유 (Share)
  static Widget share({Color color = Colors.black, double size = 20}) {
    return CustomPaint(size: Size(size, size), painter: _YtSharePainter(color: color));
  }

  /// 오프라인 저장 / 다운로드
  static Widget download({Color color = Colors.black, double size = 20}) {
    return CustomPaint(size: Size(size, size), painter: _YtDownloadPainter(color: color));
  }

  /// 리믹스 (Remix)
  static Widget remix({Color color = Colors.black, double size = 20}) {
    return CustomPaint(size: Size(size, size), painter: _YtRemixPainter(color: color));
  }
}

// -------------------------------------------------------------
// YouTube Custom Painters
// -------------------------------------------------------------

class _PlayTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _YtHomePainter extends CustomPainter {
  final Color color;
  final bool filled;

  _YtHomePainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final path = Path()
      ..moveTo(12, 3)
      ..lineTo(21, 10.5)
      ..lineTo(21, 21)
      ..lineTo(14, 21)
      ..lineTo(14, 14)
      ..lineTo(10, 14)
      ..lineTo(10, 21)
      ..lineTo(3, 21)
      ..lineTo(3, 10.5)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _YtHomePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _YtShortsPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _YtShortsPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final path = Path()
      ..moveTo(17.7, 10.5)
      ..cubicTo(19.2, 9.5, 19.7, 7.5, 18.7, 6)
      ..cubicTo(17.7, 4.5, 15.7, 4, 14.2, 5)
      ..lineTo(6.3, 10.5)
      ..cubicTo(4.8, 11.5, 4.3, 13.5, 5.3, 15)
      ..cubicTo(6.3, 16.5, 8.3, 17, 9.8, 16)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);

    // Play triangle
    final playPath = Path()
      ..moveTo(10.5, 9.5)
      ..lineTo(14.5, 12)
      ..lineTo(10.5, 14.5)
      ..close();

    final playPaint = Paint()
      ..color = filled ? Colors.white : color
      ..style = PaintingStyle.fill;

    canvas.drawPath(playPath, playPaint);
  }

  @override
  bool shouldRepaint(covariant _YtShortsPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _YtCreatePainter extends CustomPainter {
  final Color color;

  _YtCreatePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 32.0, size.height / 32.0);

    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    canvas.drawCircle(const Offset(16, 16), 14, circlePaint);

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(16, 9), const Offset(16, 23), linePaint);
    canvas.drawLine(const Offset(9, 16), const Offset(23, 16), linePaint);
  }

  @override
  bool shouldRepaint(covariant _YtCreatePainter oldDelegate) => oldDelegate.color != color;
}

class _YtSubscriptionsPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _YtSubscriptionsPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round;

    // Top stacked lines
    canvas.drawLine(const Offset(6, 4), const Offset(18, 4), paint);
    canvas.drawLine(const Offset(4, 7), const Offset(20, 7), paint);

    // Main box
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(2, 10, 20, 11),
      const Radius.circular(3),
    );
    canvas.drawRRect(rrect, paint);

    // Play triangle
    final playPath = Path()
      ..moveTo(10, 13)
      ..lineTo(15, 15.5)
      ..lineTo(10, 18)
      ..close();

    final playPaint = Paint()
      ..color = filled ? Colors.white : color
      ..style = PaintingStyle.fill;

    canvas.drawPath(playPath, playPaint);
  }

  @override
  bool shouldRepaint(covariant _YtSubscriptionsPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _YtLibraryPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _YtLibraryPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(4, 6)
      ..lineTo(20, 6)
      ..lineTo(20, 18)
      ..lineTo(4, 18)
      ..close();

    canvas.drawPath(path, paint);

    // User / You circle and body
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(12, 10), 2.2, circlePaint);

    final bodyPath = Path()
      ..moveTo(8, 15)
      ..cubicTo(8, 13, 10, 12.5, 12, 12.5)
      ..cubicTo(14, 12.5, 16, 13, 16, 15)
      ..close();
    canvas.drawPath(bodyPath, circlePaint);
  }

  @override
  bool shouldRepaint(covariant _YtLibraryPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _YtCastPainter extends CustomPainter {
  final Color color;

  _YtCastPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 22.0, size.height / 22.0);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final tvPath = Path()
      ..moveTo(2, 6)
      ..lineTo(20, 6)
      ..lineTo(20, 18)
      ..lineTo(14, 18);
    canvas.drawPath(tvPath, paint);

    canvas.drawArc(const Rect.fromLTWH(0, 14, 8, 8), 3.14, 1.57, false, paint);
    canvas.drawArc(const Rect.fromLTWH(0, 10, 16, 16), 3.14, 1.57, false, paint);
  }

  @override
  bool shouldRepaint(covariant _YtCastPainter oldDelegate) => oldDelegate.color != color;
}

class _YtThumbsUpPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _YtThumbsUpPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 20.0, size.height / 20.0);

    final path = Path()
      ..moveTo(2, 17)
      ..lineTo(5, 17)
      ..lineTo(5, 8)
      ..lineTo(2, 8)
      ..close()
      ..moveTo(6, 8)
      ..lineTo(10, 2)
      ..cubicTo(11, 2, 12, 3, 12, 5)
      ..lineTo(11, 8)
      ..lineTo(17, 8)
      ..cubicTo(18.5, 8, 19, 9.5, 19, 10.5)
      ..lineTo(17.5, 16)
      ..cubicTo(17, 17, 16, 17, 15, 17)
      ..lineTo(6, 17)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _YtThumbsUpPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _YtThumbsDownPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _YtThumbsDownPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 20.0, size.height / 20.0);

    final path = Path()
      ..moveTo(2, 3)
      ..lineTo(5, 3)
      ..lineTo(5, 12)
      ..lineTo(2, 12)
      ..close()
      ..moveTo(6, 12)
      ..lineTo(10, 18)
      ..cubicTo(11, 18, 12, 17, 12, 15)
      ..lineTo(11, 12)
      ..lineTo(17, 12)
      ..cubicTo(18.5, 12, 19, 10.5, 19, 9.5)
      ..lineTo(17.5, 4)
      ..cubicTo(17, 3, 16, 3, 15, 3)
      ..lineTo(6, 3)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _YtThumbsDownPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _YtSharePainter extends CustomPainter {
  final Color color;

  _YtSharePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 20.0, size.height / 20.0);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final arrow = Path()
      ..moveTo(12, 4)
      ..lineTo(18, 9)
      ..lineTo(12, 14);
    canvas.drawPath(arrow, paint);

    final stem = Path()
      ..moveTo(17, 9)
      ..cubicTo(11, 9, 4, 11, 3, 17);
    canvas.drawPath(stem, paint);
  }

  @override
  bool shouldRepaint(covariant _YtSharePainter oldDelegate) => oldDelegate.color != color;
}

class _YtDownloadPainter extends CustomPainter {
  final Color color;

  _YtDownloadPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 20.0, size.height / 20.0);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawLine(const Offset(10, 3), const Offset(10, 13), paint);
    canvas.drawLine(const Offset(6, 9.5), const Offset(10, 13.5), paint);
    canvas.drawLine(const Offset(14, 9.5), const Offset(10, 13.5), paint);
    canvas.drawLine(const Offset(3, 17), const Offset(17, 17), paint);
  }

  @override
  bool shouldRepaint(covariant _YtDownloadPainter oldDelegate) => oldDelegate.color != color;
}

class _YtRemixPainter extends CustomPainter {
  final Color color;

  _YtRemixPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 20.0, size.height / 20.0);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final rrect1 = RRect.fromRectAndRadius(const Rect.fromLTWH(3, 3, 10, 10), const Radius.circular(2.5));
    final rrect2 = RRect.fromRectAndRadius(const Rect.fromLTWH(7, 7, 10, 10), const Radius.circular(2.5));

    canvas.drawRRect(rrect1, paint);
    canvas.drawRRect(rrect2, paint);
  }

  @override
  bool shouldRepaint(covariant _YtRemixPainter oldDelegate) => oldDelegate.color != color;
}
