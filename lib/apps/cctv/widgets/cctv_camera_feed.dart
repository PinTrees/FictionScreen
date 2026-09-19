import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/cctv_model.dart';

class CctvCameraFeed extends StatelessWidget {
  final CctvChannel channel;
  final DateTime currentDisplayTime;
  final bool isSelected;
  final bool showScanlines;
  final bool showNoise;
  final bool showRecBlink;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  const CctvCameraFeed({
    super.key,
    required this.channel,
    required this.currentDisplayTime,
    this.isSelected = false,
    this.showScanlines = true,
    this.showNoise = true,
    this.showRecBlink = true,
    this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBlinkOn = (currentDisplayTime.millisecond ~/ 500) % 2 == 0;

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: channel.isMotionDetected && isBlinkOn
                ? const Color(0xFFFF2222)
                : isSelected
                    ? const Color(0xFF00FF66)
                    : const Color(0xFF222831),
            width: isSelected || (channel.isMotionDetected && isBlinkOn) ? 2.0 : 1.0,
          ),
        ),
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. 카메라 가상 배경 씬
              if (channel.isSignalLost)
                _buildSignalLostScene(isBlinkOn)
              else
                _buildFilteredScene(),

              // 2. 모션 감지 타겟팅 박스
              if (channel.isMotionDetected && !channel.isSignalLost)
                _buildMotionTrackingOverlay(isBlinkOn),

              // 3. CRT 수평 스캔라인 오버레이
              if (showScanlines)
                const Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _CctvScanlinePainter()),
                  ),
                ),

              // 4. 노이즈 및 비네트 그라데이션
              if (showNoise && !channel.isSignalLost)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _CctvNoisePainter(seed: currentDisplayTime.millisecond),
                    ),
                  ),
                ),

              // 5. OSD (On-Screen Display) 오버레이 정보
              _buildOsdOverlay(isBlinkOn),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredScene() {
    Widget sceneWidget = CustomPaint(
      painter: _CctvScenePainter(sceneType: channel.sceneType),
    );

    // 필터 효과 적용
    switch (channel.filterMode) {
      case CctvFilterMode.nightVisionGreen:
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.1, 0.4, 0.1, 0, 0,
            0.2, 0.9, 0.2, 0, 20,
            0.1, 0.3, 0.1, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          child: sceneWidget,
        );
      case CctvFilterMode.nightVisionMono:
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.299, 0.587, 0.114, 0, 0,
            0.299, 0.587, 0.114, 0, 0,
            0.299, 0.587, 0.114, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          child: sceneWidget,
        );
      case CctvFilterMode.highContrast:
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            1.5, 1.5, 1.5, 0, -80,
            1.5, 1.5, 1.5, 0, -80,
            1.5, 1.5, 1.5, 0, -80,
            0, 0, 0, 1, 0,
          ]),
          child: sceneWidget,
        );
      case CctvFilterMode.normal:
        return sceneWidget;
    }
  }

  Widget _buildSignalLostScene(bool isBlinkOn) {
    return Container(
      color: const Color(0xFF0F1115),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle_fill,
              color: isBlinkOn ? const Color(0xFFFF3B30) : Colors.white38,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(
              'NO SIGNAL',
              style: TextStyle(
                fontFamily: 'monospace',
                color: isBlinkOn ? const Color(0xFFFF3B30) : Colors.white54,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'VIDEO CARRIER LOST - RETRYING SYNC',
              style: TextStyle(
                fontFamily: 'monospace',
                color: Colors.white38,
                fontSize: 10,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotionTrackingOverlay(bool isBlinkOn) {
    final rect = channel.motionRect ?? const Rect.fromLTWH(0.4, 0.3, 0.25, 0.4);

    return LayoutBuilder(
      builder: (context, constraints) {
        final left = rect.left * constraints.maxWidth;
        final top = rect.top * constraints.maxHeight;
        final width = rect.width * constraints.maxWidth;
        final height = rect.height * constraints.maxHeight;

        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              width: width,
              height: height,
              child: CustomPaint(
                painter: _TargetBoxPainter(
                  color: isBlinkOn ? const Color(0xFFFF2222) : const Color(0xFFFFCC00),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        color: const Color(0xFFFF2222).withValues(alpha: 0.8),
                        child: Text(
                          channel.motionTarget ?? 'MOTION TARGET',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          color: Colors.black.withValues(alpha: 0.7),
                          child: const Text(
                            'TRACKING [LOCK]',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: Color(0xFFFFCC00),
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOsdOverlay(bool isBlinkOn) {
    final timeStr = _formatTimestamp(currentDisplayTime);

    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 상단 OSD 행 (카메라명 & REC 인디케이터)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 채널 번호 및 구역
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        channel.code,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Color(0xFF00FF66),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        channel.location,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // REC 상태 뱃지
                if (channel.isRecording)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: showRecBlink && isBlinkOn ? const Color(0xFFFF2222) : Colors.transparent,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'REC',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: Color(0xFFFF2222),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: Colors.black.withValues(alpha: 0.6),
                    child: const Text(
                      'PAUSE',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.orangeAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            // 하단 OSD 행 (타임스탬프 & 기술 제원)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 실시간 타임스탬프
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    timeStr,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white,
                      fontSize: 11,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // 비트레이트 및 해상도 정보
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    '1080P 30FPS H.265',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final w = weekdays[dt.weekday - 1];
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');
    final ms = (dt.millisecond ~/ 10).toString().padLeft(2, '0');
    return '$y-$m-$d $w $hh:$mm:$ss.$ms';
  }
}

// CRT 스캔라인 페인터
class _CctvScanlinePainter extends CustomPainter {
  const _CctvScanlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.28)
      ..strokeWidth = 1.0;

    for (double y = 0; y < size.height; y += 3.0) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 노이즈 페인터
class _CctvNoisePainter extends CustomPainter {
  final int seed;
  const _CctvNoisePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final paint = Paint()..strokeWidth = 1.0;

    // 미세 정전기 도트 렌더링
    for (int i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final alpha = random.nextDouble() * 0.15;
      paint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), 0.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CctvNoisePainter oldDelegate) => oldDelegate.seed != seed;
}

// 타겟팅 박스 페인터 (각 모서리 브래킷 렌더링)
class _TargetBoxPainter extends CustomPainter {
  final Color color;
  const _TargetBoxPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const cornerLength = 10.0;

    // Top-Left
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    // Top-Right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom-Left
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    // Bottom-Right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);

    // 중앙 크로스헤어
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(Offset(center.dx - 4, center.dy), Offset(center.dx + 4, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - 4), Offset(center.dx, center.dy + 4), paint);
  }

  @override
  bool shouldRepaint(covariant _TargetBoxPainter oldDelegate) => oldDelegate.color != color;
}

// 가상 CCTV 씬 페인터 (장소별 현실감 넘치는 감시 카메라 앵글 렌더링)
class _CctvScenePainter extends CustomPainter {
  final String sceneType;
  const _CctvScenePainter({required this.sceneType});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF14181F);
    canvas.drawRect(Offset.zero & size, bgPaint);

    switch (sceneType) {
      case 'lobby':
        _paintLobby(canvas, size);
        break;
      case 'parking':
        _paintParking(canvas, size);
        break;
      case 'elevator':
        _paintElevator(canvas, size);
        break;
      case 'server':
        _paintServerRoom(canvas, size);
        break;
      case 'stairs':
        _paintStairs(canvas, size);
        break;
      case 'rooftop':
        _paintRooftop(canvas, size);
        break;
      case 'hallway':
        _paintHallway(canvas, size);
        break;
      case 'dock':
        _paintDock(canvas, size);
        break;
      default:
        _paintControlRoom(canvas, size);
        break;
    }
  }

  void _paintLobby(Canvas canvas, Size size) {
    // 바닥 타일 투시선
    final linePaint = Paint()
      ..color = const Color(0xFF2E3440)
      ..strokeWidth = 1.2;
    final vp = Offset(size.width * 0.5, size.height * 0.35); // 소실점

    for (double x = 0; x <= size.width; x += size.width * 0.15) {
      canvas.drawLine(vp, Offset(x, size.height), linePaint);
    }
    // 카운터 데스크
    final deskPaint = Paint()..color = const Color(0xFF222831);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.15, size.height * 0.55, size.width * 0.7, size.height * 0.35), deskPaint);

    // 출입구 유리문 실루엣
    final doorPaint = Paint()
      ..color = const Color(0xFF4C566A).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.35, size.height * 0.15, size.width * 0.3, size.height * 0.4), doorPaint);

    // 피사체 실루엣 (침입자)
    final shadowPaint = Paint()..color = const Color(0xFF0B0E14);
    canvas.drawCircle(Offset(size.width * 0.52, size.height * 0.42), size.width * 0.04, shadowPaint); // 머리
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.47, size.height * 0.46, size.width * 0.1, size.height * 0.26), const Radius.circular(6)),
      shadowPaint,
    );
  }

  void _paintParking(Canvas canvas, Size size) {
    final floorPaint = Paint()..color = const Color(0xFF1E232B);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.3, size.width, size.height * 0.7), floorPaint);

    // 콘크리트 기둥
    final pillarPaint = Paint()..color = const Color(0xFF3B4252);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.15, size.height * 0.1, size.width * 0.15, size.height * 0.8), pillarPaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.7, size.height * 0.1, size.width * 0.15, size.height * 0.8), pillarPaint);

    // 노란색 안전선
    final yellowLine = Paint()
      ..color = const Color(0xFFEBCB8B).withValues(alpha: 0.7)
      ..strokeWidth = 3.0;
    canvas.drawLine(Offset(size.width * 0.15, size.height * 0.8), Offset(size.width * 0.3, size.height * 0.8), yellowLine);
    canvas.drawLine(Offset(size.width * 0.7, size.height * 0.8), Offset(size.width * 0.85, size.height * 0.8), yellowLine);

    // 검은 세단 실루엣
    final carPaint = Paint()..color = const Color(0xFF0F1218);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.36, size.height * 0.5, size.width * 0.28, size.height * 0.25), const Radius.circular(10)),
      carPaint,
    );
  }

  void _paintElevator(Canvas canvas, Size size) {
    // 스테인리스 금속 벽면
    final wallPaint = Paint()..color = const Color(0xFF282C34);
    canvas.drawRect(Offset.zero & size, wallPaint);

    // 닫힌 문 틈새선
    final seamPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), seamPaint);

    // 스테인리스 손잡이 바
    final barPaint = Paint()
      ..color = const Color(0xFF61AFEF).withValues(alpha: 0.3)
      ..strokeWidth = 5.0;
    canvas.drawLine(Offset(size.width * 0.1, size.height * 0.6), Offset(size.width * 0.9, size.height * 0.6), barPaint);

    // 상단 층수 인디케이터
    final displayPaint = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.42, size.height * 0.12, size.width * 0.16, size.height * 0.1), displayPaint);
  }

  void _paintServerRoom(Canvas canvas, Size size) {
    // 랙 캐비닛 3대
    final rackPaint = Paint()..color = const Color(0xFF1E222A);
    for (int i = 0; i < 3; i++) {
      final rx = size.width * (0.15 + i * 0.26);
      canvas.drawRect(Rect.fromLTWH(rx, size.height * 0.15, size.width * 0.2, size.height * 0.75), rackPaint);

      // 깜빡이는 서버 LED
      final ledPaint = Paint();
      for (int slot = 0; slot < 8; slot++) {
        final sy = size.height * (0.2 + slot * 0.08);
        ledPaint.color = slot % 3 == 0 ? const Color(0xFF98C379) : const Color(0xFFE06C75);
        canvas.drawCircle(Offset(rx + 8, sy), 2.5, ledPaint);
        canvas.drawCircle(Offset(rx + 16, sy), 2.5, ledPaint);
      }
    }
  }

  void _paintStairs(Canvas canvas, Size size) {
    // 지그재그 계단
    final stairPaint = Paint()
      ..color = const Color(0xFF2C323C)
      ..strokeWidth = 2.0;
    for (int i = 0; i < 6; i++) {
      final y = size.height * (0.3 + i * 0.1);
      final x = size.width * (0.2 + i * 0.1);
      canvas.drawLine(Offset(x, y), Offset(x + size.width * 0.1, y), stairPaint);
      canvas.drawLine(Offset(x + size.width * 0.1, y), Offset(x + size.width * 0.1, y + size.height * 0.1), stairPaint);
    }
  }

  void _paintRooftop(Canvas canvas, Size size) {
    // 어두운 밤하늘과 난간
    final skyPaint = Paint()..color = const Color(0xFF0D1117);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.6), skyPaint);

    final railPaint = Paint()
      ..color = const Color(0xFF484F58)
      ..strokeWidth = 2.5;
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.6), railPaint);
    for (double x = 0; x <= size.width; x += size.width * 0.1) {
      canvas.drawLine(Offset(x, size.height * 0.6), Offset(x, size.height), railPaint);
    }
  }

  void _paintHallway(Canvas canvas, Size size) {
    final vp = Offset(size.width * 0.5, size.height * 0.4);
    final p = Paint()
      ..color = const Color(0xFF282C34)
      ..strokeWidth = 1.5;
    canvas.drawLine(vp, const Offset(0, 0), p);
    canvas.drawLine(vp, Offset(size.width, 0), p);
    canvas.drawLine(vp, Offset(0, size.height), p);
    canvas.drawLine(vp, Offset(size.width, size.height), p);
  }

  void _paintDock(Canvas canvas, Size size) {
    final containerPaint = Paint()..color = const Color(0xFF2D3748);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.2, size.height * 0.3, size.width * 0.6, size.height * 0.5), containerPaint);
  }

  void _paintControlRoom(Canvas canvas, Size size) {
    final deskPaint = Paint()..color = const Color(0xFF1F232A);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4), deskPaint);
    final monPaint = Paint()..color = const Color(0xFF333842);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.3, size.height * 0.4, size.width * 0.4, size.height * 0.25), monPaint);
  }

  @override
  bool shouldRepaint(covariant _CctvScenePainter oldDelegate) => oldDelegate.sceneType != sceneType;
}
