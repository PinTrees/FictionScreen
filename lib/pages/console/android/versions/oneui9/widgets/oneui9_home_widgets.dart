import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 9 홈 화면 위젯 모음 (media_1789750911144.png 1:1 레퍼런스 싱크)

/// 1. 좌측 2x2 날씨 카드
class OneUi9WeatherCard extends StatelessWidget {
  final VoidCallback? onTap;

  const OneUi9WeatherCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF388BFD), Color(0xFF2563EB)]),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 40,
                height: 30,
                child: Stack(
                  children: [
                    Positioned(right: 0, top: 0, child: Container(width: 18, height: 18, decoration: const BoxDecoration(color: Color(0xFFFBBF24), shape: BoxShape.circle))),
                    Positioned(left: 0, bottom: 0, child: const Icon(CupertinoIcons.cloud_fill, color: Colors.white, size: 28)),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('31°', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: -1)),
                const SizedBox(height: 2),
                Text(
                  'Thunderstorms\npossible around 1...\nNew Delhi',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 10.5, height: 1.18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. 우측 상단 Now brief 화이트 캡슐 필
class OneUi9NowBriefCapsule extends StatelessWidget {
  final VoidCallback? onTap;

  const OneUi9NowBriefCapsule({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
              child: CustomPaint(painter: _NowBriefIconPainter()),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Now brief',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xFF1E293B), fontSize: 14.5, fontWeight: FontWeight.w700, letterSpacing: -0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NowBriefIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawArc(Rect.fromCircle(center: center.translate(0, 2), radius: 8), math.pi, math.pi, true, paint);
    final linePaint = Paint()..color = Colors.white..strokeWidth = 1.8..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(center.dx - 9, center.dy + 4), Offset(center.dx + 9, center.dy + 4), linePaint);
    canvas.drawLine(Offset(center.dx - 5, center.dy + 8), Offset(center.dx + 5, center.dy + 8), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3. 우측 하단 Samsung Health Start 캡슐 필
class OneUi9HealthStartCapsule extends StatelessWidget {
  final VoidCallback? onTap;

  const OneUi9HealthStartCapsule({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Start',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xFF1E293B), fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.3),
              ),
            ),
            SizedBox(
              width: 40,
              height: 36,
              child: CustomPaint(painter: _HealthHeartPainter()),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthHeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    Path createHeart(double scale, Offset center) {
      final path = Path();
      final sw = w * scale;
      final sh = h * scale;
      final left = center.dx - sw / 2;
      final top = center.dy - sh / 2;
      path.moveTo(left + sw * 0.5, top + sh * 0.85);
      path.cubicTo(left + sw * 0.05, top + sh * 0.55, left, top + sh * 0.25, left + sw * 0.25, top + sh * 0.08);
      path.cubicTo(left + sw * 0.42, top - sh * 0.02, left + sw * 0.5, top + sh * 0.2, left + sw * 0.5, top + sh * 0.2);
      path.cubicTo(left + sw * 0.5, top + sh * 0.2, left + sw * 0.58, top - sh * 0.02, left + sw * 0.75, top + sh * 0.08);
      path.cubicTo(left + sw * 1.0, top + sh * 0.25, left + sw * 0.95, top + sh * 0.55, left + sw * 0.5, top + sh * 0.85);
      path.close();
      return path;
    }

    final c = Offset(w / 2 + 1, h / 2);
    final pGreen = Paint()..color = const Color(0xFF22C55E)..style = PaintingStyle.stroke..strokeWidth = 3.0..strokeCap = StrokeCap.round;
    final pBlue = Paint()..color = const Color(0xFF06B6D4)..style = PaintingStyle.stroke..strokeWidth = 2.8..strokeCap = StrokeCap.round;
    final pPink = Paint()..color = const Color(0xFFEC4899)..style = PaintingStyle.stroke..strokeWidth = 2.6..strokeCap = StrokeCap.round;

    canvas.drawPath(createHeart(0.95, c), pGreen);
    canvas.drawPath(createHeart(0.75, c), pBlue);
    canvas.drawPath(createHeart(0.55, c), pPink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 4. Google 캡슐 검색바
class OneUi9GoogleSearchCapsule extends StatelessWidget {
  final VoidCallback? onTap;

  const OneUi9GoogleSearchCapsule({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            SizedBox(width: 24, height: 24, child: CustomPaint(painter: _GoogleLogoPainter())),
            const Spacer(),
            const Icon(CupertinoIcons.mic_fill, color: Color(0xFF4285F4), size: 21),
            const SizedBox(width: 14),
            SizedBox(width: 22, height: 22, child: CustomPaint(painter: _GoogleLensPainter())),
          ],
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final strokeWidth = size.width * 0.22;

    final bluePaint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.stroke..strokeWidth = strokeWidth;
    final greenPaint = Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.stroke..strokeWidth = strokeWidth;
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.stroke..strokeWidth = strokeWidth;
    final redPaint = Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.stroke..strokeWidth = strokeWidth;

    canvas.drawArc(rect, -0.6, 1.2, false, bluePaint);
    canvas.drawArc(rect, 0.6, 1.5, false, greenPaint);
    canvas.drawArc(rect, 2.1, 1.1, false, yellowPaint);
    canvas.drawArc(rect, 3.2, 1.3, false, redPaint);

    final barPaint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(center.dx - 1, center.dy - strokeWidth / 2, radius + 1, strokeWidth), barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoogleLensPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    final paint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.stroke..strokeWidth = 2.2;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 3.2, Paint()..color = const Color(0xFFEA4335));
    canvas.drawCircle(Offset(size.width - 5, 5), 1.5, Paint()..color = const Color(0xFF34A853));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 5. One UI 9 공용 앱 아이콘 (배지 지원)
class OneUi9AppItem extends StatelessWidget {
  final String label;
  final Widget iconWidget;
  final int? badgeCount;
  final VoidCallback onTap;

  const OneUi9AppItem({
    super.key,
    required this.label,
    required this.iconWidget,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                iconWidget,
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    top: -3,
                    right: -3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                      child: Text('$badgeCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: -0.2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// 6. Google 폴더 아이콘 (9개 미니 앱 그리드)
class OneUi9GoogleFolderWidget extends StatelessWidget {
  final VoidCallback onTap;
  final int? badgeCount;

  const OneUi9GoogleFolderWidget({super.key, required this.onTap, this.badgeCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMiniDot(const Color(0xFF4285F4)),
                          _buildMiniDot(const Color(0xFFEA4335)),
                          _buildMiniDot(const Color(0xFFFBBC05)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMiniDot(const Color(0xFF34A853)),
                          _buildMiniDot(const Color(0xFFEA4335)),
                          _buildMiniDot(const Color(0xFF4285F4)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMiniDot(const Color(0xFFFF0000)),
                          _buildMiniDot(const Color(0xFF10B981)),
                          _buildMiniDot(const Color(0xFF6366F1)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    top: -3,
                    right: -3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                      child: Text('$badgeCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Text('Google', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMiniDot(Color color) => Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

/// 7. Samsung Gallery 공식 꽃잎 로고 아이콘
class OneUi9GalleryIcon extends StatelessWidget {
  const OneUi9GalleryIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFD946EF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: const Color(0xFFD946EF).withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CustomPaint(painter: _SamsungGalleryPetalsPainter()),
        ),
      ),
    );
  }
}

class _SamsungGalleryPetalsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = Colors.white..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * math.pi / 180;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      final petalRect = Rect.fromCenter(center: const Offset(0, -9), width: 6.5, height: 12);
      canvas.drawRRect(RRect.fromRectAndRadius(petalRect, const Radius.circular(3.5)), paint);
      canvas.restore();
    }
    canvas.drawCircle(center, 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 8. Google Play Store 공식 삼각 아이콘
class OneUi9PlayStoreIcon extends StatelessWidget {
  const OneUi9PlayStoreIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CustomPaint(painter: _PlayStoreLogoPainter()),
        ),
      ),
    );
  }
}

class _PlayStoreLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    final bluePath = Path()..moveTo(2, 2)..lineTo(w * 0.58, h * 0.5)..lineTo(2, h - 2)..close();
    canvas.drawPath(bluePath, Paint()..color = const Color(0xFF00C3FF));

    final greenPath = Path()..moveTo(2, 2)..lineTo(w * 0.72, h * 0.38)..lineTo(w * 0.58, h * 0.5)..close();
    canvas.drawPath(greenPath, Paint()..color = const Color(0xFF00E676));

    final redPath = Path()..moveTo(2, h - 2)..lineTo(w * 0.72, h * 0.62)..lineTo(w * 0.58, h * 0.5)..close();
    canvas.drawPath(redPath, Paint()..color = const Color(0xFFFF334B));

    final yellowPath = Path()..moveTo(w * 0.58, h * 0.5)..lineTo(w * 0.72, h * 0.38)..lineTo(w - 2, h * 0.5)..lineTo(w * 0.72, h * 0.62)..close();
    canvas.drawPath(yellowPath, Paint()..color = const Color(0xFFFFD400));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 9. Samsung Galaxy Store 쇼핑백 아이콘
class OneUi9StoreIcon extends StatelessWidget {
  const OneUi9StoreIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF43F5E),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: const Color(0xFFF43F5E).withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(CupertinoIcons.bag_fill, color: Colors.white, size: 28),
              Positioned(
                top: 14,
                child: Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFFF43F5E), shape: BoxShape.circle)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 10. Samsung One UI 9 하단 도크: Camera 아이콘
class OneUi9CameraIcon extends StatelessWidget {
  const OneUi9CameraIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 8, left: 10, child: Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle))),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF94A3B8), width: 2),
            ),
            child: Center(
              child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF38BDF8), shape: BoxShape.circle)),
            ),
          ),
        ],
      ),
    );
  }
}

/// 11. Samsung One UI 9 하단 도크: Internet 아이콘
class OneUi9InternetIcon extends StatelessWidget {
  const OneUi9InternetIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: const Color(0xFF4F46E5).withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CustomPaint(painter: _SaturnPlanetPainter()),
        ),
      ),
    );
  }
}

class _SaturnPlanetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 9, Paint()..color = Colors.white);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 4);
    final ringRect = Rect.fromCenter(center: Offset.zero, width: 26, height: 7);
    canvas.drawOval(ringRect, Paint()..color = const Color(0xFF38BDF8)..style = PaintingStyle.stroke..strokeWidth = 2.4);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
