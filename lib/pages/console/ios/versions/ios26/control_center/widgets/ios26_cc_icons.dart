import 'dart:math' as math;
import 'package:flutter/material.dart';

/// iOS 26 제어 센터 전용 무결점 벡터 아이콘 라이브러리
/// 외부 폰트 파일/트리셰이킹에 구애받지 않고 웹/모바일 모든 환경에서 100% 선명하게 렌더링

// 1. 비행기 모드 아이콘 (45도 대각선 정밀 비행기 벡터)
class Ios26AirplaneIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26AirplaneIcon({super.key, this.size = 28, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _AirplanePainter(color));
}

class _AirplanePainter extends CustomPainter {
  final Color color;
  _AirplanePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final w = size.width;
    final h = size.height;

    canvas.save();
    canvas.translate(w / 2, h / 2);
    canvas.rotate(-math.pi / 4); // 45도 회전
    canvas.translate(-w / 2, -h / 2);

    final path = Path();
    path.moveTo(w * 0.50, h * 0.12);
    path.cubicTo(w * 0.54, h * 0.12, w * 0.56, h * 0.22, w * 0.55, h * 0.38);
    path.lineTo(w * 0.90, h * 0.54);
    path.lineTo(w * 0.90, h * 0.62);
    path.lineTo(w * 0.54, h * 0.56);
    path.lineTo(w * 0.53, h * 0.78);
    path.lineTo(w * 0.68, h * 0.88);
    path.lineTo(w * 0.68, h * 0.94);
    path.lineTo(w * 0.50, h * 0.90);
    path.lineTo(w * 0.32, h * 0.94);
    path.lineTo(w * 0.32, h * 0.88);
    path.lineTo(w * 0.47, h * 0.78);
    path.lineTo(w * 0.46, h * 0.56);
    path.lineTo(w * 0.10, h * 0.62);
    path.lineTo(w * 0.10, h * 0.54);
    path.lineTo(w * 0.45, h * 0.38);
    path.cubicTo(w * 0.44, h * 0.22, w * 0.46, h * 0.12, w * 0.50, h * 0.12);
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AirplanePainter oldDelegate) => oldDelegate.color != color;
}

// 2. AirDrop 아이콘 (상향 동심원 방사 파동 + 안테나 점)
class Ios26AirDropIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26AirDropIcon({super.key, this.size = 28, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _AirDropPainter(color));
}

class _AirDropPainter extends CustomPainter {
  final Color color;
  _AirDropPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.088
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final center = Offset(size.width / 2, size.height * 0.70);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width * 0.22), -math.pi * 0.85, math.pi * 0.70, false, strokePaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width * 0.38), -math.pi * 0.85, math.pi * 0.70, false, strokePaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width * 0.54), -math.pi * 0.85, math.pi * 0.70, false, strokePaint);
    final dotPaint = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    canvas.drawCircle(center, size.width * 0.07, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _AirDropPainter oldDelegate) => oldDelegate.color != color;
}

// 3. Wi-Fi 아이콘 (와이파이 파동 + 슬래시 지원)
class Ios26WifiIcon extends StatelessWidget {
  final double size;
  final Color color;
  final bool isSlashed;
  const Ios26WifiIcon({super.key, this.size = 28, this.color = Colors.white, this.isSlashed = false});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _WifiPainter(color, isSlashed));
}

class _WifiPainter extends CustomPainter {
  final Color color;
  final bool isSlashed;
  _WifiPainter(this.color, this.isSlashed);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final center = Offset(size.width / 2, size.height * 0.78);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width * 0.30), -math.pi * 0.75, math.pi * 0.50, false, stroke);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width * 0.50), -math.pi * 0.75, math.pi * 0.50, false, stroke);
    final dot = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    canvas.drawCircle(center, size.width * 0.07, dot);

    if (isSlashed) {
      final slash = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.09..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(size.width * 0.18, size.height * 0.82), Offset(size.width * 0.82, size.height * 0.20), slash);
    }
  }

  @override
  bool shouldRepaint(covariant _WifiPainter oldDelegate) => oldDelegate.color != color || oldDelegate.isSlashed != isSlashed;
}

// 4. 셀룰러 신호 바 아이콘 (4단 안테나 바)
class Ios26CellularIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26CellularIcon({super.key, this.size = 14, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _CellularPainter(color));
}

class _CellularPainter extends CustomPainter {
  final Color color;
  _CellularPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final w = size.width;
    final h = size.height;
    final barW = w * 0.17;
    final gap = w * 0.08;

    final heights = [h * 0.32, h * 0.52, h * 0.74, h * 0.96];
    for (int i = 0; i < 4; i++) {
      final x = i * (barW + gap);
      final y = h - heights[i];
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, y, barW, heights[i]), Radius.circular(barW * 0.35)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CellularPainter oldDelegate) => oldDelegate.color != color;
}

// 5. 블루투스 룬 아이콘
class Ios26BluetoothIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26BluetoothIcon({super.key, this.size = 14, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _BluetoothPainter(color));
}

class _BluetoothPainter extends CustomPainter {
  final Color color;
  _BluetoothPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.28, h * 0.28);
    path.lineTo(w * 0.72, h * 0.68);
    path.lineTo(w * 0.50, h * 0.88);
    path.lineTo(w * 0.50, h * 0.12);
    path.lineTo(w * 0.72, h * 0.32);
    path.lineTo(w * 0.28, h * 0.72);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BluetoothPainter oldDelegate) => oldDelegate.color != color;
}

// 6. 개인용 핫스팟 (체인 링크) 아이콘
class Ios26HotspotIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26HotspotIcon({super.key, this.size = 14, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _HotspotPainter(color));
}

class _HotspotPainter extends CustomPainter {
  final Color color;
  _HotspotPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    canvas.save();
    canvas.translate(w * 0.38, h * 0.38);
    canvas.rotate(-math.pi / 4);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: w * 0.46, height: h * 0.26), Radius.circular(h * 0.13)), stroke);
    canvas.restore();

    canvas.save();
    canvas.translate(w * 0.62, h * 0.62);
    canvas.rotate(-math.pi / 4);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: w * 0.46, height: h * 0.26), Radius.circular(h * 0.13)), stroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HotspotPainter oldDelegate) => oldDelegate.color != color;
}

// 7. 지구본/위성 (Globe) 아이콘
class Ios26GlobeIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26GlobeIcon({super.key, this.size = 14, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _GlobePainter(color));
}

class _GlobePainter extends CustomPainter {
  final Color color;
  _GlobePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.09..isAntiAlias = true;
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.42;

    canvas.drawCircle(center, r, stroke);
    canvas.drawLine(Offset(center.dx - r, center.dy), Offset(center.dx + r, center.dy), stroke);
    canvas.drawOval(Rect.fromCenter(center: center, width: r * 0.95, height: r * 2), stroke);
  }

  @override
  bool shouldRepaint(covariant _GlobePainter oldDelegate) => oldDelegate.color != color;
}

// 8. AirPlay 오디오 아이콘 (동심 호 + 상향 삼각형)
class Ios26AirPlayIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26AirPlayIcon({super.key, this.size = 20, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _AirPlayPainter(color));
}

class _AirPlayPainter extends CustomPainter {
  final Color color;
  _AirPlayPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.09..strokeCap = StrokeCap.round..isAntiAlias = true;
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h * 0.65);

    canvas.drawArc(Rect.fromCircle(center: center, radius: w * 0.34), -math.pi * 0.85, math.pi * 0.70, false, stroke);
    canvas.drawArc(Rect.fromCircle(center: center, radius: w * 0.50), -math.pi * 0.85, math.pi * 0.70, false, stroke);

    final tri = Path();
    tri.moveTo(w * 0.50, h * 0.54);
    tri.lineTo(w * 0.68, h * 0.86);
    tri.lineTo(w * 0.32, h * 0.86);
    tri.close();
    final fill = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    canvas.drawPath(tri, fill);
  }

  @override
  bool shouldRepaint(covariant _AirPlayPainter oldDelegate) => oldDelegate.color != color;
}

// 9. 회전 잠금 (Rotation Lock) 아이콘 (시계방향 원형 화살표 + 중앙 자물쇠)
class Ios26RotationLockIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26RotationLockIcon({super.key, this.size = 30, this.color = const Color(0xFFFF3B30)});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _RotationLockPainter(color));
}

class _RotationLockPainter extends CustomPainter {
  final Color color;
  _RotationLockPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.088..strokeCap = StrokeCap.round..isAntiAlias = true;
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.38;

    canvas.drawArc(Rect.fromCircle(center: center, radius: r), -math.pi * 0.60, math.pi * 1.65, false, stroke);

    final arrowAngle = -math.pi * 0.60 + math.pi * 1.65;
    final arrowTip = Offset(center.dx + r * math.cos(arrowAngle), center.dy + r * math.sin(arrowAngle));
    final arrowPaint = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final arrowPath = Path();
    arrowPath.moveTo(arrowTip.dx, arrowTip.dy);
    arrowPath.lineTo(arrowTip.dx + size.width * 0.12, arrowTip.dy - size.width * 0.02);
    arrowPath.lineTo(arrowTip.dx + size.width * 0.04, arrowTip.dy + size.width * 0.12);
    arrowPath.close();
    canvas.drawPath(arrowPath, arrowPaint);

    final lockBody = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + size.height * 0.06), width: size.width * 0.30, height: size.height * 0.24),
      Radius.circular(size.width * 0.05),
    );
    canvas.drawRRect(lockBody, arrowPaint);

    final shackle = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.075..strokeCap = StrokeCap.round..isAntiAlias = true;
    final shackleRect = Rect.fromCenter(center: Offset(center.dx, center.dy - size.height * 0.06), width: size.width * 0.18, height: size.height * 0.18);
    canvas.drawArc(shackleRect, math.pi, math.pi, false, shackle);
  }

  @override
  bool shouldRepaint(covariant _RotationLockPainter oldDelegate) => oldDelegate.color != color;
}

// 10. 화면 미러링 (Screen Mirroring) 아이콘 (두 개의 겹친 둥근 직사각형)
class Ios26ScreenMirrorIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26ScreenMirrorIcon({super.key, this.size = 28, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _ScreenMirrorPainter(color));
}

class _ScreenMirrorPainter extends CustomPainter {
  final Color color;
  _ScreenMirrorPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.088..isAntiAlias = true;
    final w = size.width;
    final h = size.height;
    final r = Radius.circular(w * 0.10);

    final backRect = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.24, h * 0.10, w * 0.66, h * 0.54), r);
    canvas.drawRRect(backRect, stroke);

    final frontRect = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.10, h * 0.36, w * 0.66, h * 0.54), r);
    canvas.drawRRect(frontRect, stroke);
  }

  @override
  bool shouldRepaint(covariant _ScreenMirrorPainter oldDelegate) => oldDelegate.color != color;
}

// 11. 손전등 (Flashlight) 아이콘
class Ios26FlashlightIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26FlashlightIcon({super.key, this.size = 30, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _FlashlightPainter(color));
}

class _FlashlightPainter extends CustomPainter {
  final Color color;
  _FlashlightPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final w = size.width;
    final h = size.height;

    final head = Path();
    head.moveTo(w * 0.30, h * 0.12);
    head.lineTo(w * 0.70, h * 0.12);
    head.lineTo(w * 0.64, h * 0.32);
    head.lineTo(w * 0.36, h * 0.32);
    head.close();
    canvas.drawPath(head, paint);

    final body = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.37, h * 0.34, w * 0.26, h * 0.52), Radius.circular(w * 0.05));
    canvas.drawRRect(body, paint);

    final switchPaint = Paint()..color = Colors.black.withValues(alpha: 0.35)..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.44, h * 0.42, w * 0.12, h * 0.16), Radius.circular(w * 0.03)), switchPaint);
  }

  @override
  bool shouldRepaint(covariant _FlashlightPainter oldDelegate) => oldDelegate.color != color;
}

// 12. 스톱워치/타이머 (Timer) 아이콘
class Ios26TimerIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26TimerIcon({super.key, this.size = 30, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _TimerPainter(color));
}

class _TimerPainter extends CustomPainter {
  final Color color;
  _TimerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.09..strokeCap = StrokeCap.round..isAntiAlias = true;
    final center = Offset(size.width / 2, size.height * 0.56);
    final r = size.width * 0.36;

    canvas.drawCircle(center, r, stroke);

    final fill = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.43, size.height * 0.08, size.width * 0.14, size.height * 0.08), Radius.circular(size.width * 0.03)), fill);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-size.width * 0.05, -r - size.height * 0.08, size.width * 0.10, size.height * 0.06), Radius.circular(size.width * 0.02)), fill);
    canvas.restore();

    final hand = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.08..strokeCap = StrokeCap.round;
    canvas.drawLine(center, Offset(center.dx + r * 0.55 * math.cos(-math.pi / 3), center.dy + r * 0.55 * math.sin(-math.pi / 3)), hand);
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) => oldDelegate.color != color;
}

// 13. 계산기 (Calculator) 아이콘
class Ios26CalculatorIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26CalculatorIcon({super.key, this.size = 28, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _CalculatorPainter(color));
}

class _CalculatorPainter extends CustomPainter {
  final Color color;
  _CalculatorPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.085..isAntiAlias = true;
    final fill = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final w = size.width;
    final h = size.height;

    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.12, h * 0.08, w * 0.76, h * 0.84), Radius.circular(w * 0.16)), stroke);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.24, h * 0.20, w * 0.52, h * 0.14), Radius.circular(w * 0.05)), fill);

    const rows = 3;
    const cols = 3;
    final startX = w * 0.26;
    final startY = h * 0.44;
    final stepX = w * 0.24;
    final stepY = h * 0.14;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        canvas.drawCircle(Offset(startX + c * stepX, startY + r * stepY), w * 0.045, fill);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CalculatorPainter oldDelegate) => oldDelegate.color != color;
}

// 14. 카메라 (Camera) 아이콘
class Ios26CameraIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26CameraIcon({super.key, this.size = 30, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _CameraPainter(color));
}

class _CameraPainter extends CustomPainter {
  final Color color;
  _CameraPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.085..isAntiAlias = true;
    final fill = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final w = size.width;
    final h = size.height;

    final body = Path();
    body.moveTo(w * 0.12, h * 0.32);
    body.lineTo(w * 0.34, h * 0.32);
    body.lineTo(w * 0.40, h * 0.20);
    body.lineTo(w * 0.60, h * 0.20);
    body.lineTo(w * 0.66, h * 0.32);
    body.lineTo(w * 0.88, h * 0.32);
    body.quadraticBezierTo(w * 0.94, h * 0.32, w * 0.94, h * 0.38);
    body.lineTo(w * 0.94, h * 0.78);
    body.quadraticBezierTo(w * 0.94, h * 0.84, w * 0.88, h * 0.84);
    body.lineTo(w * 0.12, h * 0.84);
    body.quadraticBezierTo(w * 0.06, h * 0.84, w * 0.06, h * 0.78);
    body.lineTo(w * 0.06, h * 0.38);
    body.quadraticBezierTo(w * 0.06, h * 0.32, w * 0.12, h * 0.32);
    body.close();
    canvas.drawPath(body, stroke);

    canvas.drawCircle(Offset(w / 2, h * 0.58), w * 0.18, stroke);
    canvas.drawCircle(Offset(w * 0.82, h * 0.42), w * 0.04, fill);
  }

  @override
  bool shouldRepaint(covariant _CameraPainter oldDelegate) => oldDelegate.color != color;
}

// 15. QR 코드 스캐너 (QR Code) 아이콘
class Ios26QrCodeIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26QrCodeIcon({super.key, this.size = 28, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _QrCodePainter(color));
}

class _QrCodePainter extends CustomPainter {
  final Color color;
  _QrCodePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.085..strokeCap = StrokeCap.round..isAntiAlias = true;
    final fill = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final w = size.width;
    final h = size.height;
    final arm = w * 0.22;

    canvas.drawPath(Path()..moveTo(w * 0.12, h * 0.12 + arm)..lineTo(w * 0.12, h * 0.12)..lineTo(w * 0.12 + arm, h * 0.12), stroke);
    canvas.drawPath(Path()..moveTo(w * 0.88 - arm, h * 0.12)..lineTo(w * 0.88, h * 0.12)..lineTo(w * 0.88, h * 0.12 + arm), stroke);
    canvas.drawPath(Path()..moveTo(w * 0.12, h * 0.88 - arm)..lineTo(w * 0.12, h * 0.88)..lineTo(w * 0.12 + arm, h * 0.88), stroke);
    canvas.drawPath(Path()..moveTo(w * 0.88 - arm, h * 0.88)..lineTo(w * 0.88, h * 0.88)..lineTo(w * 0.88, h * 0.88 - arm), stroke);

    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.28, h * 0.28, w * 0.16, h * 0.16), Radius.circular(w * 0.03)), fill);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.56, h * 0.28, w * 0.16, h * 0.16), Radius.circular(w * 0.03)), fill);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.28, h * 0.56, w * 0.16, h * 0.16), Radius.circular(w * 0.03)), fill);
    canvas.drawCircle(Offset(w * 0.64, h * 0.64), w * 0.06, fill);
  }

  @override
  bool shouldRepaint(covariant _QrCodePainter oldDelegate) => oldDelegate.color != color;
}

// 16. 화면 녹화 (Screen Record) 아이콘 (동심원 링 + 내부 솔리드 원)
class Ios26RecordIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26RecordIcon({super.key, this.size = 30, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _RecordPainter(color));
}

class _RecordPainter extends CustomPainter {
  final Color color;
  _RecordPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.088..isAntiAlias = true;
    final fill = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, size.width * 0.38, stroke);
    canvas.drawCircle(center, size.width * 0.18, fill);
  }

  @override
  bool shouldRepaint(covariant _RecordPainter oldDelegate) => oldDelegate.color != color;
}

// 17. 태양 (Sun) 아이콘 (밝기 슬라이더 내부)
class Ios26SunIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26SunIcon({super.key, this.size = 24, this.color = const Color(0xFFFF9500)});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _SunPainter(color));
}

class _SunPainter extends CustomPainter {
  final Color color;
  _SunPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.10..strokeCap = StrokeCap.round..isAntiAlias = true;
    final center = Offset(size.width / 2, size.height / 2);
    final coreR = size.width * 0.20;

    canvas.drawCircle(center, coreR, fill);

    const rayCount = 8;
    final innerR = size.width * 0.30;
    final outerR = size.width * 0.44;

    for (int i = 0; i < rayCount; i++) {
      final angle = i * (2 * math.pi / rayCount);
      final p1 = Offset(center.dx + innerR * math.cos(angle), center.dy + innerR * math.sin(angle));
      final p2 = Offset(center.dx + outerR * math.cos(angle), center.dy + outerR * math.sin(angle));
      canvas.drawLine(p1, p2, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _SunPainter oldDelegate) => oldDelegate.color != color;
}

// 18. 스피커 (Speaker) 아이콘 (볼륨 슬라이더 내부)
class Ios26SpeakerIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26SpeakerIcon({super.key, this.size = 24, this.color = const Color(0xFF2C2C2E)});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _SpeakerPainter(color));
}

class _SpeakerPainter extends CustomPainter {
  final Color color;
  _SpeakerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.09..strokeCap = StrokeCap.round..isAntiAlias = true;
    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(w * 0.14, h * 0.38);
    path.lineTo(w * 0.32, h * 0.38);
    path.lineTo(w * 0.54, h * 0.20);
    path.lineTo(w * 0.54, h * 0.80);
    path.lineTo(w * 0.32, h * 0.62);
    path.lineTo(w * 0.14, h * 0.62);
    path.close();
    canvas.drawPath(path, fill);

    final center = Offset(w * 0.44, h * 0.50);
    canvas.drawArc(Rect.fromCircle(center: center, radius: w * 0.24), -math.pi * 0.30, math.pi * 0.60, false, stroke);
    canvas.drawArc(Rect.fromCircle(center: center, radius: w * 0.38), -math.pi * 0.30, math.pi * 0.60, false, stroke);
  }

  @override
  bool shouldRepaint(covariant _SpeakerPainter oldDelegate) => oldDelegate.color != color;
}

// 19. 초승달 (Crescent Moon) 아이콘 (집중 모드용)
class Ios26MoonIcon extends StatelessWidget {
  final double size;
  final Color color;
  const Ios26MoonIcon({super.key, this.size = 20, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size(size, size), painter: _MoonPainter(color));
}

class _MoonPainter extends CustomPainter {
  final Color color;
  _MoonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true;
    final w = size.width;
    final h = size.height;

    final moon = Path();
    moon.moveTo(w * 0.55, h * 0.10);
    moon.cubicTo(w * 0.25, h * 0.18, w * 0.15, h * 0.55, w * 0.35, h * 0.85);
    moon.cubicTo(w * 0.55, h * 1.00, w * 0.85, h * 0.90, w * 0.92, h * 0.70);
    moon.cubicTo(w * 0.60, h * 0.72, w * 0.40, h * 0.52, w * 0.55, h * 0.10);
    moon.close();

    canvas.drawPath(moon, paint);
  }

  @override
  bool shouldRepaint(covariant _MoonPainter oldDelegate) => oldDelegate.color != color;
}
