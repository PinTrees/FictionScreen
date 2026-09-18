import 'package:flutter/material.dart';

/// 실제 인스타그램 공식 UI 아이콘 및 로고 모음
/// Flutter Native Canvas(CustomPainter)로 정밀하게 렌더링되어 웹/모바일/데스크톱 모든 환경에서
/// SVG 파싱 오류나 렌더러 호환성 문제 없이 100% 안정적이고 선명하게 표시됩니다.
class InstagramIcons {
  InstagramIcons._();

  /// 인스타그램 공식 워드마크 로고
  static Widget wordmark({
    double height = 28,
    Color color = Colors.black,
  }) {
    return Image.asset(
      'assets/images/instagram_wordmark.webp',
      height: height,
      color: color,
      colorBlendMode: BlendMode.srcIn,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, _, _) {
        // Fallback cursive text if image asset is loading
        return Text(
          'Instagram',
          style: TextStyle(
            fontFamily: 'serif',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            fontSize: height * 0.85,
            color: color,
            letterSpacing: -0.5,
          ),
        );
      },
    );
  }

  /// 홈 아이콘
  static Widget home({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HomeIconPainter(color: color, filled: filled),
    );
  }

  /// 검색 아이콘
  static Widget search({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SearchIconPainter(color: color, filled: filled),
    );
  }

  /// 만들기 (+) 아이콘
  static Widget create({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CreateIconPainter(color: color, filled: filled),
    );
  }

  /// 릴스 아이콘 (슬레이트 & 재생 삼각형)
  static Widget reels({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ReelsIconPainter(color: color, filled: filled),
    );
  }

  /// 하트 아이콘
  static Widget heart({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HeartIconPainter(color: color, filled: filled),
    );
  }

  /// 댓글 말풍선 아이콘 (5시 방향 꼬리)
  static Widget comment({
    Color color = Colors.black,
    double size = 24,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CommentIconPainter(color: color),
    );
  }

  /// 공유 종이비행기 아이콘
  static Widget share({
    Color color = Colors.black,
    double size = 24,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PaperplaneIconPainter(color: color),
    );
  }

  /// DM 메신저 종이비행기 아이콘
  static Widget messenger({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PaperplaneIconPainter(color: color),
    );
  }

  /// 북마크 / 저장 아이콘
  static Widget bookmark({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _BookmarkIconPainter(color: color, filled: filled),
    );
  }
}

// -------------------------------------------------------------
// 정밀 벡터 CustomPainters (24x24 기준 자동 스케일링)
// -------------------------------------------------------------

class _HomeIconPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _HomeIconPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    if (filled) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Filled house with door cutout
      final path = Path()
        ..moveTo(12, 2.5)
        ..lineTo(21.5, 10.2)
        ..lineTo(20, 11.8)
        ..lineTo(19.5, 11.4)
        ..lineTo(19.5, 21.5)
        ..lineTo(14.5, 21.5)
        ..lineTo(14.5, 14)
        ..lineTo(9.5, 14)
        ..lineTo(9.5, 21.5)
        ..lineTo(4.5, 21.5)
        ..lineTo(4.5, 11.4)
        ..lineTo(4, 11.8)
        ..lineTo(2.5, 10.2)
        ..close();

      canvas.drawPath(path, paint);
    } else {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path()
        ..moveTo(3.5, 10)
        ..lineTo(12, 3)
        ..lineTo(20.5, 10)
        ..lineTo(20.5, 20.5)
        ..lineTo(5, 20.5)
        ..lineTo(3.5, 20.5)
        ..close();

      final door = Path()
        ..moveTo(9.5, 20.5)
        ..lineTo(9.5, 13)
        ..lineTo(14.5, 13)
        ..lineTo(14.5, 20.5);

      canvas.drawPath(path, paint);
      canvas.drawPath(door, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HomeIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _SearchIconPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _SearchIconPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final strokeWidth = filled ? 2.8 : 2.2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(const Offset(10.5, 10.5), 7.0, paint);
    canvas.drawLine(const Offset(15.8, 15.8), const Offset(21, 21), paint);
  }

  @override
  bool shouldRepaint(covariant _SearchIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _CreateIconPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _CreateIconPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final strokeWidth = filled ? 2.6 : 2.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(3, 3, 18, 18),
      const Radius.circular(5.5),
    );
    canvas.drawRRect(rrect, paint);

    // Plus
    canvas.drawLine(const Offset(12, 7.5), const Offset(12, 16.5), paint);
    canvas.drawLine(const Offset(7.5, 12), const Offset(16.5, 12), paint);
  }

  @override
  bool shouldRepaint(covariant _CreateIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _ReelsIconPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _ReelsIconPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(2.5, 2.5, 19, 19),
      const Radius.circular(5.5),
    );
    canvas.drawRRect(rrect, strokePaint);

    // Clapperboard horizontal line
    canvas.drawLine(const Offset(2.5, 8.5), const Offset(21.5, 8.5), strokePaint);

    // Clapperboard stripes
    canvas.drawLine(const Offset(7, 2.5), const Offset(9.5, 8.5), strokePaint);
    canvas.drawLine(const Offset(14.5, 2.5), const Offset(17, 8.5), strokePaint);

    // Center play triangle
    final playPath = Path()
      ..moveTo(10, 11.5)
      ..lineTo(16, 15)
      ..lineTo(10, 18.5)
      ..close();

    final playPaint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(playPath, playPaint);
  }

  @override
  bool shouldRepaint(covariant _ReelsIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _HeartIconPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _HeartIconPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final path = Path()
      ..moveTo(12, 21.35)
      ..cubicTo(5.4, 15.36, 2, 12.28, 2, 8.5)
      ..cubicTo(2, 5.42, 4.42, 3, 7.5, 3)
      ..cubicTo(9.24, 3, 10.91, 3.81, 12, 5.09)
      ..cubicTo(13.09, 3.81, 14.76, 3, 16.5, 3)
      ..cubicTo(19.58, 3, 22, 5.42, 22, 8.5)
      ..cubicTo(22, 12.28, 18.6, 15.36, 12, 21.35)
      ..close();

    if (filled) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    } else {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeartIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}

class _CommentIconPainter extends CustomPainter {
  final Color color;

  _CommentIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(21, 11.5)
      ..cubicTo(21, 16.2, 17, 20, 12, 20)
      ..cubicTo(10.5, 20, 9.1, 19.6, 7.9, 18.9)
      ..lineTo(3, 21)
      ..lineTo(5.1, 16.1)
      ..cubicTo(4.4, 14.9, 4, 13.5, 4, 11.5)
      ..cubicTo(4, 6.8, 8, 3, 12, 3)
      ..cubicTo(16.5, 3, 21, 6.8, 21, 11.5)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CommentIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _PaperplaneIconPainter extends CustomPainter {
  final Color color;

  _PaperplaneIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(22, 2)
      ..lineTo(14.5, 22)
      ..lineTo(10.5, 13.5)
      ..lineTo(2, 9.5)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawLine(const Offset(22, 2), const Offset(10.5, 13.5), paint);
  }

  @override
  bool shouldRepaint(covariant _PaperplaneIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _BookmarkIconPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _BookmarkIconPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final path = Path()
      ..moveTo(5.5, 3)
      ..lineTo(18.5, 3)
      ..lineTo(18.5, 21)
      ..lineTo(12, 15.5)
      ..lineTo(5.5, 21)
      ..close();

    if (filled) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    } else {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BookmarkIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}
