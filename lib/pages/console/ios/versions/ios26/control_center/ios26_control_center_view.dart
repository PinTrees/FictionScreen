import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/ios26_cc_header.dart';
import 'widgets/ios26_cc_icons.dart';
import 'widgets/ios26_connectivity_card.dart';
import 'widgets/ios26_now_playing_card.dart';
import 'widgets/ios26_quick_toggles.dart';
import 'widgets/ios26_vertical_slider.dart';

/// Apple iOS 26 공식 리퀴드 글래스 제어 센터 (Control Center) 모듈형 뷰
/// 레퍼런스 스크린샷과 100% 수학적 비례 및 패딩 일치 (472x1024 스케일 완벽 대응)
class Ios26ControlCenterView extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String appId) onOpenApp;

  const Ios26ControlCenterView({super.key, required this.onClose, required this.onOpenApp});

  @override
  State<Ios26ControlCenterView> createState() => _Ios26ControlCenterViewState();
}

class _Ios26ControlCenterViewState extends State<Ios26ControlCenterView> {
  bool _isRotationLocked = true; // 스크린샷 레퍼런스: 회전 잠금 활성화(흰색바탕+빨간락)
  bool _isFocusMode = false;
  bool _isFlashlightOn = false;
  double _brightness = 0.30; // 레퍼런스: 약 30% 하단 필링
  double _volume = 0.12; // 레퍼런스: 약 12% 하단 필링

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        // 기준 모바일 472px 비율 스케일링
        final width = totalWidth.clamp(320.0, 520.0);
        final scale = width / 472.0;

        final unitSize = 80.0 * scale;
        final gap = 20.0 * scale;
        final cardSize = 180.0 * scale; // 80 + 20 + 80 = 180
        final contentWidth = 380.0 * scale; // 80*4 + 20*3 = 380
        final horizPadding = (totalWidth - contentWidth) / 2.0;
        final topPad = math.max(14.0, MediaQuery.of(context).padding.top * 0.7);

        return GestureDetector(
          onTap: widget.onClose,
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! < -80) widget.onClose();
          },
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              // 1. 배경 가우시안 블러 오버레이 (어두운 배경색 제거)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: const SizedBox.expand(),
                ),
              ),

              // 2. 메인 콘텐츠 스크롤 뷰
              SafeArea(
                top: false,
                bottom: true,
                child: Column(
                  children: [
                    SizedBox(height: topPad),

                    // 상단 헤더 (+ 및 ⏻ 버튼, SKT LTE 4바 & 93% 배터리)
                    Ios26CcHeader(horizontalPadding: horizPadding, onClose: widget.onClose),
                    SizedBox(height: 16.0 * scale),

                    // 메인 카드 그리드
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              // Row 1: 연결성 2x2 카드 + 지금 재생 중 2x2 카드
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Ios26ConnectivityCard(cardSize: cardSize),
                                  SizedBox(width: gap),
                                  Ios26NowPlayingCard(cardSize: cardSize),
                                ],
                              ),
                              SizedBox(height: gap),

                              // Row 2: 회전잠금/화면미러링/집중모드 + 밝기 & 볼륨 수직 슬라이더
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 좌측 2x2 영역: 회전잠금(80) + 화면미러링(80) / 집중모드(180x80)
                                  Ios26QuickTogglesSection(
                                    unitSize: unitSize,
                                    cardSize: cardSize,
                                    gap: gap,
                                    isRotationLocked: _isRotationLocked,
                                    isFocusMode: _isFocusMode,
                                    onToggleRotation: (v) => setState(() => _isRotationLocked = v),
                                    onToggleFocus: (v) => setState(() => _isFocusMode = v),
                                    onOpenApp: widget.onOpenApp,
                                  ),
                                  SizedBox(width: gap),

                                  // 우측 2칸: 밝기 슬라이더 (80x180) + 볼륨 슬라이더 (80x180)
                                  Ios26VerticalSlider(
                                    width: unitSize,
                                    height: cardSize,
                                    value: _brightness,
                                    iconBuilder: (isOnFill) => Ios26SunIcon(
                                      size: unitSize * 0.36,
                                      color: isOnFill ? const Color(0xFFFF9500) : Colors.white70,
                                    ),
                                    onChanged: (v) => setState(() => _brightness = v),
                                  ),
                                  SizedBox(width: gap),
                                  Ios26VerticalSlider(
                                    width: unitSize,
                                    height: cardSize,
                                    value: _volume,
                                    iconBuilder: (isOnFill) => Ios26SpeakerIcon(
                                      size: unitSize * 0.36,
                                      color: isOnFill ? const Color(0xFF2C2C2E) : Colors.white,
                                    ),
                                    onChanged: (v) => setState(() => _volume = v),
                                  ),
                                ],
                              ),
                              SizedBox(height: gap),

                              // Row 3 & 4: 6개 완전한 정원형 리퀴드 퀵 토글 (손전등, 타이머, 계산기, 카메라 / QR, 화면녹화)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizPadding),
                                child: Ios26BottomActionsGrid(
                                  unitSize: unitSize,
                                  gap: gap,
                                  isFlashlightOn: _isFlashlightOn,
                                  onToggleFlashlight: () => setState(() => _isFlashlightOn = !_isFlashlightOn),
                                  onOpenApp: widget.onOpenApp,
                                ),
                              ),
                              SizedBox(height: 24.0 * scale),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 하단 홈 인디케이터 제스처 바
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        width: 120,
                        height: 18,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Container(width: 60, height: 4.5, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(3))),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. 우측 세로 레일 인디케이터 (하트, 음악, 안테나) - 레퍼런스 위치 정확히 일치
              Positioned(
                right: math.max(4.0, (horizPadding - 24.0) / 2.0),
                top: topPad + 160.0 * scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.heart_fill, color: Colors.white.withValues(alpha: 0.95), size: 16),
                    const SizedBox(height: 28),
                    Icon(CupertinoIcons.music_note, color: Colors.white.withValues(alpha: 0.50), size: 16),
                    const SizedBox(height: 28),
                    Icon(CupertinoIcons.antenna_radiowaves_left_right, color: Colors.white.withValues(alpha: 0.50), size: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
