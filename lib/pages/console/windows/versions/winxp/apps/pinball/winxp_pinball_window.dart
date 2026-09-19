import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../../widgets/winxp_window_frame.dart';

/// Windows XP 3D 핀볼 (3D Pinball for Windows - Space Cadet)
class WinXpPinballWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const WinXpPinballWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 480,
    this.height = 640,
    this.isMaximized = false,
  });

  @override
  State<WinXpPinballWindow> createState() => _WinXpPinballWindowState();
}

class _WinXpPinballWindowState extends State<WinXpPinballWindow> with SingleTickerProviderStateMixin {
  int _score = 0;
  int _highScore = 750000;
  int _ballsRemaining = 3;
  String _rank = 'Cadet (사관후보생)';

  // 물리 시뮬레이션 상태
  Offset _ballPos = const Offset(360, 480);
  Offset _ballVel = Offset.zero;
  bool _ballInPlay = false;
  bool _leftFlipperActive = false;
  bool _rightFlipperActive = false;
  int _hitBumperIndex = -1;

  late Ticker _ticker;
  final FocusNode _focusNode = FocusNode();

  // 범퍼 위치 (x, y, radius, points)
  final List<Map<String, dynamic>> _bumpers = [
    {'x': 180.0, 'y': 160.0, 'r': 24.0, 'pts': 500, 'color': Color(0xFFEF4444)},
    {'x': 250.0, 'y': 150.0, 'r': 24.0, 'pts': 500, 'color': Color(0xFF3B82F6)},
    {'x': 215.0, 'y': 220.0, 'r': 26.0, 'pts': 1000, 'color': Color(0xFFEAB308)},
  ];

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!_ballInPlay) return;

    setState(() {
      // 중력 적용
      _ballVel = Offset(_ballVel.dx, _ballVel.dy + 0.38);

      // 감속/마찰
      _ballVel = Offset(_ballVel.dx * 0.995, _ballVel.dy * 0.995);

      // 위치 갱신
      _ballPos += _ballVel;

      const double tableLeft = 60.0;
      const double tableRight = 380.0;
      const double tableTop = 60.0;
      const double tableBottom = 540.0;

      // 좌/우 벽 충돌
      if (_ballPos.dx < tableLeft + 10) {
        _ballPos = Offset(tableLeft + 10, _ballPos.dy);
        _ballVel = Offset(-_ballVel.dx * 0.75, _ballVel.dy);
      } else if (_ballPos.dx > tableRight - 10) {
        _ballPos = Offset(tableRight - 10, _ballPos.dy);
        _ballVel = Offset(-_ballVel.dx * 0.75, _ballVel.dy);
      }

      // 상단 벽 충돌
      if (_ballPos.dy < tableTop + 10) {
        _ballPos = Offset(_ballPos.dx, tableTop + 10);
        _ballVel = Offset(_ballVel.dx, -_ballVel.dy * 0.75);
      }

      // 범퍼 충돌 검사
      for (int i = 0; i < _bumpers.length; i++) {
        final b = _bumpers[i];
        final bx = b['x'] as double;
        final by = b['y'] as double;
        final br = b['r'] as double;

        final dist = (Offset(bx, by) - _ballPos).distance;
        if (dist < br + 10) {
          final normal = (_ballPos - Offset(bx, by)) / dist;
          _ballVel = normal * 11.5;
          _score += b['pts'] as int;
          _hitBumperIndex = i;

          Timer(const Duration(milliseconds: 150), () {
            if (mounted) setState(() => _hitBumperIndex = -1);
          });

          _checkRank();
          break;
        }
      }

      // 플리퍼 영역 충돌
      const double flipperY = 460.0;
      if (_ballPos.dy >= flipperY && _ballPos.dy <= flipperY + 30) {
        // 좌측 플리퍼 영역 (120 ~ 200)
        if (_ballPos.dx >= 110 && _ballPos.dx <= 200) {
          if (_leftFlipperActive) {
            _ballVel = Offset(Random().nextDouble() * 3 + 2, -13.0);
            _score += 250;
          } else {
            _ballVel = Offset(-2, -4);
          }
        }
        // 우측 플리퍼 영역 (240 ~ 330)
        else if (_ballPos.dx >= 240 && _ballPos.dx <= 330) {
          if (_rightFlipperActive) {
            _ballVel = Offset(-(Random().nextDouble() * 3 + 2), -13.0);
            _score += 250;
          } else {
            _ballVel = Offset(2, -4);
          }
        }
      }

      // 바닥으로 떨어짐 (Drain)
      if (_ballPos.dy > tableBottom) {
        _ballInPlay = false;
        _ballsRemaining--;

        if (_ballsRemaining > 0) {
          _resetBallForLaunch();
        } else {
          // 게임 오버
          if (_score > _highScore) _highScore = _score;
        }
      }
    });
  }

  void _resetBallForLaunch() {
    _ballPos = const Offset(360, 480);
    _ballVel = Offset.zero;
  }

  void _launchBall() {
    if (_ballsRemaining <= 0) {
      setState(() {
        _score = 0;
        _ballsRemaining = 3;
        _rank = 'Cadet (사관후보생)';
        _resetBallForLaunch();
      });
    }

    if (!_ballInPlay) {
      setState(() {
        _ballInPlay = true;
        _ballVel = Offset(-1.5, -15.5);
      });
    }
  }

  void _checkRank() {
    if (_score > 100000 && _rank.startsWith('Cadet')) {
      _rank = 'Ensign (소위)';
    } else if (_score > 300000 && _rank.startsWith('Ensign')) {
      _rank = 'Lieutenant (중위)';
    } else if (_score > 600000 && _rank.startsWith('Lieutenant')) {
      _rank = 'Commander (중령)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WinXpWindowFrame(
      title: '3D Pinball for Windows - Space Cadet',
      iconAsset: 'assets/images/windows/desk.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.keyZ) {
              setState(() => _leftFlipperActive = true);
            } else if (event.logicalKey == LogicalKeyboardKey.slash) {
              setState(() => _rightFlipperActive = true);
            } else if (event.logicalKey == LogicalKeyboardKey.space) {
              _launchBall();
            }
          } else if (event is KeyUpEvent) {
            if (event.logicalKey == LogicalKeyboardKey.keyZ) {
              setState(() => _leftFlipperActive = false);
            } else if (event.logicalKey == LogicalKeyboardKey.slash) {
              setState(() => _rightFlipperActive = false);
            }
          }
        },
        child: Container(
          color: const Color(0xFF101018),
          child: Column(
            children: [
              // 1. 메뉴바
              Container(
                height: 22,
                color: const Color(0xFFECE9D8),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: const Row(
                  children: [
                    Text('게임(G)  ', style: TextStyle(fontSize: 11, color: Colors.black87)),
                    Text('옵션(O)  ', style: TextStyle(fontSize: 11, color: Colors.black87)),
                    Text('도움말(H)', style: TextStyle(fontSize: 11, color: Colors.black87)),
                  ],
                ),
              ),

              // 2. 상단 우주선 핀볼 스코어보드 (Space Cadet HUD)
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border(bottom: BorderSide(color: Color(0xFF3B82F6), width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 현재 점수 LCD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('PLAYER 1', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold)),
                        Text(
                          _score.toString().padLeft(8, '0'),
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            color: Color(0xFF38BDF8),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),

                    // 사관 계급 배지
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('MISSION RANK', style: TextStyle(color: Colors.white54, fontSize: 9)),
                        Text(_rank, style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),

                    // 잔여 볼 수
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('BALLS', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold)),
                        Row(
                          children: List.generate(
                            3,
                            (i) => Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Icon(
                                CupertinoIcons.circle_fill,
                                size: 10,
                                color: i < _ballsRemaining ? const Color(0xFFE2E8F0) : Colors.white24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. 핀볼 테이블 그래픽 뷰포트
              Expanded(
                child: Stack(
                  children: [
                    // 테이블 배경 (우주선 내부 아트워크)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(0.0, -0.2),
                            radius: 0.9,
                            colors: [Color(0xFF281850), Color(0xFF130924), Color(0xFF070312)],
                          ),
                        ),
                        child: CustomPaint(
                          painter: _PinballTablePainter(
                            leftFlipperActive: _leftFlipperActive,
                            rightFlipperActive: _rightFlipperActive,
                            bumpers: _bumpers,
                            hitBumperIndex: _hitBumperIndex,
                          ),
                        ),
                      ),
                    ),

                    // 은색 금속 볼 (Metallic Ball)
                    Positioned(
                      left: _ballPos.dx - 8,
                      top: _ballPos.dy - 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            center: Alignment(-0.3, -0.3),
                            colors: [Colors.white, Color(0xFFCBD5E1), Color(0xFF475569), Color(0xFF0F172A)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 4,
                              offset: const Offset(1, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 발사대 (Plunger) 버튼 오버레이
                    if (!_ballInPlay)
                      Positioned(
                        right: 18,
                        bottom: 40,
                        child: ScaleButton(
                          onTap: _launchBall,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFF991B1B)]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFFEF4444).withValues(alpha: 0.6), blurRadius: 10),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(CupertinoIcons.play_arrow_solid, color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text('발사 (SPACE)', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // 게임 오버 오버레이
                    if (_ballsRemaining <= 0)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.75),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'GAME OVER',
                                style: TextStyle(color: Color(0xFFEF4444), fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 3),
                              ),
                              const SizedBox(height: 6),
                              Text('최종 점수: $_score', style: const TextStyle(color: Colors.white, fontSize: 15)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _launchBall,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('새 게임 시작'),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // 4. 하단 조작 컨트롤러 (터치/마우스용 좌우 플리퍼 버튼)
              Container(
                height: 48,
                color: const Color(0xFF0B0718),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    // 좌측 플리퍼 버튼
                    Expanded(
                      child: GestureDetector(
                        onTapDown: (_) => setState(() => _leftFlipperActive = true),
                        onTapUp: (_) => setState(() => _leftFlipperActive = false),
                        onTapCancel: () => setState(() => _leftFlipperActive = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _leftFlipperActive ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF38BDF8), width: 1),
                          ),
                          alignment: Alignment.center,
                          child: const Text('◀ 왼쪽 플리퍼 (Z)', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // 발사 버튼
                    IconButton(
                      onPressed: _launchBall,
                      icon: const Icon(CupertinoIcons.play_circle_fill, color: Color(0xFF38BDF8), size: 28),
                      tooltip: '발사 (Space)',
                    ),
                    const SizedBox(width: 14),

                    // 우측 플리퍼 버튼
                    Expanded(
                      child: GestureDetector(
                        onTapDown: (_) => setState(() => _rightFlipperActive = true),
                        onTapUp: (_) => setState(() => _rightFlipperActive = false),
                        onTapCancel: () => setState(() => _rightFlipperActive = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _rightFlipperActive ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF38BDF8), width: 1),
                          ),
                          alignment: Alignment.center,
                          child: const Text('오른쪽 플리퍼 (/) ▶', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const ScaleButton({super.key, required this.child, required this.onTap});

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Transform.scale(scale: _pressed ? 0.94 : 1.0, child: widget.child),
    );
  }
}

/// 핀볼 테이블 커스텀 페인터
class _PinballTablePainter extends CustomPainter {
  final bool leftFlipperActive;
  final bool rightFlipperActive;
  final List<Map<String, dynamic>> bumpers;
  final int hitBumperIndex;

  _PinballTablePainter({
    required this.leftFlipperActive,
    required this.rightFlipperActive,
    required this.bumpers,
    required this.hitBumperIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // 외곽 프레임 가이드라인
    final path = Path()
      ..moveTo(60, size.height - 40)
      ..lineTo(60, 100)
      ..quadraticBezierTo(size.width / 2, 30, size.width - 60, 100)
      ..lineTo(size.width - 60, size.height - 40);
    canvas.drawPath(path, borderPaint);

    // 발사 레인 분리대
    canvas.drawLine(
      Offset(size.width - 85, 120),
      Offset(size.width - 85, size.height - 60),
      Paint()..color = const Color(0xFF60A5FA)..strokeWidth = 2,
    );

    // 공격 범퍼 그리기
    for (int i = 0; i < bumpers.length; i++) {
      final b = bumpers[i];
      final bx = b['x'] as double;
      final by = b['y'] as double;
      final br = b['r'] as double;
      final isHit = hitBumperIndex == i;

      final paint = Paint()
        ..color = isHit ? Colors.white : (b['color'] as Color)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(bx, by), br, paint);

      // 범퍼 림
      canvas.drawCircle(
        Offset(bx, by),
        br,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke,
      );

      // 범퍼 중앙 링
      canvas.drawCircle(
        Offset(bx, by),
        br * 0.45,
        Paint()..color = Colors.black.withValues(alpha: 0.5),
      );
    }

    // 좌측 플리퍼
    final leftAngle = leftFlipperActive ? -0.5 : 0.45;
    canvas.save();
    canvas.translate(130, size.height - 110);
    canvas.rotate(leftAngle);
    final flipperPaint = Paint()..color = const Color(0xFFEF4444);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(0, -6, 65, 12), const Radius.circular(5)),
      flipperPaint,
    );
    canvas.restore();

    // 우측 플리퍼
    final rightAngle = rightFlipperActive ? 0.5 : -0.45;
    canvas.save();
    canvas.translate(310, size.height - 110);
    canvas.rotate(rightAngle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-65, -6, 65, 12), const Radius.circular(5)),
      flipperPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PinballTablePainter oldDelegate) => true;
}
