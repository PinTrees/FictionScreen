import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/ios26_cc_header.dart';
import 'widgets/ios26_connectivity_card.dart';
import 'widgets/ios26_now_playing_card.dart';
import 'widgets/ios26_quick_toggles.dart';
import 'widgets/ios26_vertical_slider.dart';

/// Apple iOS 26 공식 리퀴드 글래스 (Liquid Glass) 제어 센터 (Control Center) 모듈형 뷰
class Ios26ControlCenterView extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String appId) onOpenApp;

  const Ios26ControlCenterView({super.key, required this.onClose, required this.onOpenApp});

  @override
  State<Ios26ControlCenterView> createState() => _Ios26ControlCenterViewState();
}

class _Ios26ControlCenterViewState extends State<Ios26ControlCenterView> {
  bool _isRotationLocked = false;
  bool _isSilentMode = true;
  bool _isFocusMode = false;
  bool _isFlashlightOn = false;
  double _brightness = 0.65;
  double _volume = 0.72;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < -80) widget.onClose();
      },
      behavior: HitTestBehavior.translucent,
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // 1. 상단 바 & 통신사/배터리 헤더
            Ios26CcHeader(onClose: widget.onClose),
            const SizedBox(height: 10),

            // 2. 메인 모듈 그리드 + 우측 iOS 26 레일 탭
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 14),
                    // 메인 모듈 스크롤 영역
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // Row 1: 연결성 2x2 카드 + 지금 재생 중 2x2 미디어 카드
                            const Row(
                              children: [
                                Expanded(child: Ios26ConnectivityCard()),
                                SizedBox(width: 14),
                                Expanded(child: Ios26NowPlayingCard()),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Row 2: 회전잠금/무음/집중모드 + 수직 밝기 & 음량 슬라이더
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 11,
                                  child: Ios26QuickTogglesSection(
                                    isRotationLocked: _isRotationLocked,
                                    isSilentMode: _isSilentMode,
                                    isFocusMode: _isFocusMode,
                                    isFlashlightOn: _isFlashlightOn,
                                    onToggleRotation: (v) => setState(() => _isRotationLocked = v),
                                    onToggleSilent: (v) => setState(() => _isSilentMode = v),
                                    onToggleFocus: (v) => setState(() => _isFocusMode = v),
                                    onToggleFlashlight: (v) => setState(() => _isFlashlightOn = v),
                                    onOpenApp: widget.onOpenApp,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 5,
                                  child: Ios26VerticalSlider(
                                    value: _brightness,
                                    icon: CupertinoIcons.sun_max_fill,
                                    iconColor: const Color(0xFFFF9500),
                                    onChanged: (v) => setState(() => _brightness = v),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 5,
                                  child: Ios26VerticalSlider(
                                    value: _volume,
                                    icon: CupertinoIcons.speaker_2_fill,
                                    iconColor: const Color(0xFF007AFF),
                                    onChanged: (v) => setState(() => _volume = v),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Row 3 & 4: 원형 퀵 액션 토글 (손전등, 타이머, 계산기, 카메라, QR, 화면녹화)
                            Ios26BottomActionsGrid(
                              isFlashlightOn: _isFlashlightOn,
                              onToggleFlashlight: () => setState(() => _isFlashlightOn = !_isFlashlightOn),
                              onOpenApp: widget.onOpenApp,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),

                    // 우측 iOS 26 페이지 스위처 레일 (하트, 음악, 무선 안테나) - 스크린샷 레퍼런스 일치
                    Padding(
                      padding: const EdgeInsets.only(top: 172, right: 6, left: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.heart_fill, color: Colors.white.withValues(alpha: 0.95), size: 16),
                          const SizedBox(height: 24),
                          Icon(CupertinoIcons.music_note, color: Colors.white.withValues(alpha: 0.55), size: 16),
                          const SizedBox(height: 24),
                          Icon(CupertinoIcons.antenna_radiowaves_left_right, color: Colors.white.withValues(alpha: 0.55), size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. 하단 닫기 핸들 바
            GestureDetector(
              onTap: widget.onClose,
              child: Container(
                width: 120,
                height: 18,
                alignment: Alignment.center,
                color: Colors.transparent,
                child: Container(
                  width: 60,
                  height: 4.5,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(3)),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
