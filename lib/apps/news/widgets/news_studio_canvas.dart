import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/news_model.dart';

class NewsStudioCanvas extends StatefulWidget {
  final NewsConfig config;

  const NewsStudioCanvas({
    super.key,
    required this.config,
  });

  @override
  State<NewsStudioCanvas> createState() => _NewsStudioCanvasState();
}

class _NewsStudioCanvasState extends State<NewsStudioCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // 1. 메인 뷰포트 (레이아웃 모드에 따른 분기)
            _buildMainViewport(),

            // 2. 수화 통역사 원형 창 (우측 하단)
            if (widget.config.showSignLanguage)
              _buildSignLanguagePip(),

            // 3. CRT 스캔라인 오버레이 (옵션)
            if (widget.config.crtScanlines)
              _buildCrtScanlines(),
          ],
        );
      },
    );
  }

  Widget _buildMainViewport() {
    switch (widget.config.layoutMode) {
      case NewsLayoutMode.studioAnchor:
        return _buildStudioAnchorView();
      case NewsLayoutMode.fieldSplit:
        return _buildFieldSplitView();
      case NewsLayoutMode.fullScene:
        return _buildFieldSceneView(isFullScene: true);
    }
  }

  /// 앵커 단독 스튜디오 뷰
  Widget _buildStudioAnchorView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, -0.3),
          radius: 1.2,
          colors: [
            Color(0xFF132B4F),
            Color(0xFF091426),
            Color(0xFF040810),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 스튜디오 배경 디지털 곡면 디스플레이 벽
          _buildStudioCurvedScreen(),

          // 앵커 데스크 & 인물 일러스트 실루엣
          Positioned(
            bottom: 60,
            child: _buildAnchorFigureAndDesk(),
          ),
        ],
      ),
    );
  }

  /// 2분할 (스튜디오 앵커 + 현장 연결 PIP)
  Widget _buildFieldSplitView() {
    return Container(
      color: const Color(0xFF060D18),
      child: Row(
        children: [
          // 좌측: 스튜디오 앵커 (48%)
          Expanded(
            flex: 48,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildStudioAnchorView(),
                Positioned(
                  top: 50,
                  left: 16,
                  child: _buildLocationBadge('스튜디오 앵커'),
                ),
              ],
            ),
          ),

          // 중앙 분할 라인
          Container(
            width: 3,
            color: const Color(0xFF1E3A5F),
          ),

          // 우측: 현장 생중계 화면 (52%)
          Expanded(
            flex: 52,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildFieldSceneView(isFullScene: false),
                Positioned(
                  top: 50,
                  right: 16,
                  child: _buildLocationBadge('${widget.config.reportLocation} | ${widget.config.reporterName}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF64B5F6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.location_solid, color: Color(0xFFFF5252), size: 13),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 스튜디오 배경 곡면 디스플레이 벽
  Widget _buildStudioCurvedScreen() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _StudioBackgroundPainter(
          phase: _animController.value * 2 * math.pi,
          theme: widget.config.channelTheme,
        ),
      ),
    );
  }

  /// 앵커 데스크 및 앵커 실루엣 그래픽
  Widget _buildAnchorFigureAndDesk() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 앵커 상반신 실루엣
        Container(
          width: 200,
          height: 190,
          alignment: Alignment.bottomCenter,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // 머리
              Positioned(
                top: 15,
                child: Container(
                  width: 54,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E50),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF64B5F6).withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              // 헤어 스타일
              Positioned(
                top: 10,
                child: Container(
                  width: 60,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A2530),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                ),
              ),
              // 슈트 어깨/몸통
              Positioned(
                bottom: 0,
                child: Container(
                  width: 170,
                  height: 125,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2A3644), Color(0xFF18222D)],
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(55)),
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // 와이셔츠 & 넥타이/카라
                      Container(
                        width: 32,
                        height: 55,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: const BoxDecoration(
                          color: Color(0xFFECEFF1),
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 12,
                            height: 48,
                            color: const Color(0xFFC62828),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // 방송용 글래스 앵커 데스크
        Container(
          width: 440,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF455A64),
                Color(0xFF263238),
                Color(0xFF102027),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            border: Border.all(
              color: const Color(0xFF80D8FF).withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00B0FF).withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 태블릿 / 원고
              Container(
                width: 70,
                height: 38,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Center(
                  child: Text('NEWS', style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 20),
              // 방송용 데스크탑 마이크
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCFD8DC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(width: 2, height: 18, color: Colors.grey),
                  Container(width: 18, height: 4, color: Colors.black54),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 현장 화면 렌더러 (사건별 특화 비주얼)
  Widget _buildFieldSceneView({required bool isFullScene}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B141F),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0E1A29),
            const Color(0xFF070D15),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 현장 테마별 배경 일러스트 페인터
          CustomPaint(
            painter: _FieldScenePainter(
              sceneType: widget.config.fieldSceneType,
              phase: _animController.value * 2 * math.pi,
            ),
          ),

          // 우측 상단/상단 현장 안내 오버레이
          Positioned(
            left: 16,
            bottom: isFullScene ? 140 : 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00E676),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.config.reportLocation} [생중계]',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 수화 통역사 원형 창 (우측 하단)
  Widget _buildSignLanguagePip() {
    return Positioned(
      right: 20,
      bottom: 120,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [Color(0xFF263238), Color(0xFF0A1218)],
          ),
          border: Border.all(
            color: const Color(0xFF64B5F6).withValues(alpha: 0.9),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 통역사 실루엣 & 손동작 모션
              CustomPaint(
                size: const Size(110, 110),
                painter: _SignLanguagePainter(phase: _animController.value * 2 * math.pi),
              ),
              // 하단 '수화 통역' 뱃지
              Positioned(
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    '수화통역',
                    style: TextStyle(
                      color: Color(0xFF81D4FA),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CRT 모니터 스캔라인 효과
  Widget _buildCrtScanlines() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
              colors: [
                Colors.black.withValues(alpha: 0.15),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.15),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

/// 스튜디오 백월 디지털 그래픽 페인터
class _StudioBackgroundPainter extends CustomPainter {
  final double phase;
  final NewsChannelTheme theme;

  _StudioBackgroundPainter({required this.phase, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1E3A5F).withValues(alpha: 0.35)
      ..strokeWidth = 1.0;

    // 수평 수직 그리드 라인
    const spacing = 35.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 중앙 지구본 원형 링 모션
    final ringPaint = Paint()
      ..color = const Color(0xFF42A5F5).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width * 0.5, size.height * 0.35);
    canvas.drawCircle(center, 120, ringPaint);
    canvas.drawCircle(center, 90, ringPaint);

    // 펄스 발광 광채
    final glowPaint = Paint()
      ..color = const Color(0xFF1976D2).withValues(alpha: 0.12 + 0.05 * math.sin(phase))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, 140, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _StudioBackgroundPainter oldDelegate) => true;
}

/// 현장 카메라 테마별 비주얼 페인터
class _FieldScenePainter extends CustomPainter {
  final FieldSceneType sceneType;
  final double phase;

  _FieldScenePainter({required this.sceneType, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    switch (sceneType) {
      case FieldSceneType.police:
        _drawPoliceScene(canvas, size);
        break;
      case FieldSceneType.prosecution:
        _drawProsecutionScene(canvas, size);
        break;
      case FieldSceneType.briefing:
        _drawBriefingScene(canvas, size);
        break;
      case FieldSceneType.disaster:
        _drawDisasterScene(canvas, size);
        break;
      case FieldSceneType.nightCity:
        _drawNightCityScene(canvas, size);
        break;
    }
  }

  // 1. 경찰 사건 현장: 폴리스라인 & 적/청 경광등 점멸
  void _drawPoliceScene(Canvas canvas, Size size) {
    // 경광등 플래시
    final flashVal = (math.sin(phase * 3) + 1) / 2;
    final redGlow = Paint()
      ..color = Colors.red.withValues(alpha: 0.25 * flashVal)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    final blueGlow = Paint()
      ..color = Colors.blue.withValues(alpha: 0.25 * (1 - flashVal))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.4), 100, redGlow);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.4), 100, blueGlow);

    // 노란 폴리스라인 테이프 (가로 대각선 가로지름)
    final tapePaint = Paint()
      ..color = const Color(0xFFFFD600)
      ..style = PaintingStyle.fill;

    final tapePath = Path()
      ..moveTo(0, size.height * 0.65)
      ..lineTo(size.width, size.height * 0.55)
      ..lineTo(size.width, size.height * 0.62)
      ..lineTo(0, size.height * 0.72)
      ..close();
    canvas.drawPath(tapePath, tapePaint);

    // 폴리스라인 텍스트
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'POLICE LINE DO NOT CROSS   경찰통제선   POLICE LINE   경찰통제선',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(20, size.height * 0.62);
    canvas.rotate(-0.1);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  // 2. 검찰청 포토라인: 법원/검찰 대리석 기둥 & 플래시 세례
  void _drawProsecutionScene(Canvas canvas, Size size) {
    final pillarPaint = Paint()..color = const Color(0xFF1F2D3D);
    for (double x = 40; x < size.width; x += 90) {
      canvas.drawRect(Rect.fromLTWH(x, 40, 45, size.height), pillarPaint);
    }

    // 취재진 카메라 플래시 터짐 효과
    final flashVal = (math.sin(phase * 5) > 0.8) ? 1.0 : 0.0;
    if (flashVal > 0) {
      final flashPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);
      canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.5), 120, flashPaint);
    }

    // 마이크 다발
    final micPaint = Paint()..color = const Color(0xFF00E5FF).withValues(alpha: 0.7);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.35, size.height * 0.7, 120, 10), micPaint);
  }

  // 3. 긴급 기자회견 브리핑
  void _drawBriefingScene(Canvas canvas, Size size) {
    final backdropPaint = Paint()..color = const Color(0xFF0F1E36);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backdropPaint);

    // 단상 (Podium)
    final podiumPaint = Paint()..color = const Color(0xFF2C3E50);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.3, size.height * 0.5, size.width * 0.4, size.height * 0.5), podiumPaint);

    // 마이크 스탠드 3개
    final micPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 3;
    canvas.drawLine(Offset(size.width * 0.4, size.height * 0.5), Offset(size.width * 0.4, size.height * 0.42), micPaint);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.5), Offset(size.width * 0.5, size.height * 0.4), micPaint);
    canvas.drawLine(Offset(size.width * 0.6, size.height * 0.5), Offset(size.width * 0.6, size.height * 0.42), micPaint);
  }

  // 4. 도심 싱크홀 / 붕괴 재난 현장
  void _drawDisasterScene(Canvas canvas, Size size) {
    // 붉은색 경보 안개
    final hazePaint = Paint()
      ..color = Colors.orange.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), hazePaint);

    // 붕괴 크랙 라인
    final crackPaint = Paint()
      ..color = const Color(0xFFFF5722)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final crackPath = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.4, size.height * 0.6)
      ..lineTo(size.width * 0.55, size.height * 0.7)
      ..lineTo(size.width * 0.75, size.height * 0.55)
      ..lineTo(size.width * 0.9, size.height * 0.8);
    canvas.drawPath(crackPath, crackPaint);
  }

  // 5. 심야 빗속 도심
  void _drawNightCityScene(Canvas canvas, Size size) {
    // 빌딩 실루엣
    final bldgPaint = Paint()..color = const Color(0xFF101C2B);
    canvas.drawRect(Rect.fromLTWH(30, size.height * 0.3, 70, size.height), bldgPaint);
    canvas.drawRect(Rect.fromLTWH(130, size.height * 0.2, 90, size.height), bldgPaint);
    canvas.drawRect(Rect.fromLTWH(240, size.height * 0.35, 60, size.height), bldgPaint);

    // 빗줄기
    final rainPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 1.0;
    for (int i = 0; i < 40; i++) {
      final x = (i * 27 + phase * 60) % size.width;
      final y = (i * 41 + phase * 120) % size.height;
      canvas.drawLine(Offset(x, y), Offset(x - 3, y + 15), rainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FieldScenePainter oldDelegate) => true;
}

/// 수화 통역사 애니메이션 페인터
class _SignLanguagePainter extends CustomPainter {
  final double phase;

  _SignLanguagePainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.55);

    // 몸통
    final bodyPaint = Paint()..color = const Color(0xFF37474F);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 30), width: 70, height: 60),
      bodyPaint,
    );

    // 머리
    final headPaint = Paint()..color = const Color(0xFFFFCC80);
    canvas.drawCircle(Offset(center.dx, center.dy - 16), 16, headPaint);

    // 헤어
    final hairPaint = Paint()..color = const Color(0xFF212121);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx, center.dy - 18), radius: 17),
      math.pi,
      math.pi,
      true,
      hairPaint,
    );

    // 양손 수화 모션 (좌우 손동작 애니메이션)
    final handPaint = Paint()..color = const Color(0xFFFFCC80);
    final leftHandY = center.dy + math.sin(phase * 2) * 10;
    final rightHandY = center.dy + math.cos(phase * 2) * 10;

    canvas.drawCircle(Offset(center.dx - 22, leftHandY), 6, handPaint);
    canvas.drawCircle(Offset(center.dx + 22, rightHandY), 6, handPaint);
  }

  @override
  bool shouldRepaint(covariant _SignLanguagePainter oldDelegate) => true;
}
