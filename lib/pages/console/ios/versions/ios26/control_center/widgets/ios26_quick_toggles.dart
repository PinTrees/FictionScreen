import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';

/// iOS 26 리퀴드 글래스 퀵 토글 섹션 (회전잠금, 화면미러링, 집중모드 알약 캡슐)
class Ios26QuickTogglesSection extends StatelessWidget {
  final bool isRotationLocked;
  final bool isFocusMode;
  final ValueChanged<bool> onToggleRotation;
  final ValueChanged<bool> onToggleFocus;
  final Function(String appId) onOpenApp;

  const Ios26QuickTogglesSection({
    super.key,
    required this.isRotationLocked,
    required this.isFocusMode,
    required this.onToggleRotation,
    required this.onToggleFocus,
    required this.onOpenApp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. 회전 잠금 (원형 흰색/적색락) + 화면 미러링 (원형 듀얼스크린)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 회전 잠금 원형 버튼 (스크린샷 레퍼런스: 흰색 바탕에 붉은색 락)
            _buildCircleButton(
              icon: CupertinoIcons.lock_rotation,
              isActive: isRotationLocked,
              activeBgColor: Colors.white,
              activeIconColor: const Color(0xFFFF3B30),
              inactiveIconColor: Colors.white,
              onTap: () => onToggleRotation(!isRotationLocked),
            ),
            // 화면 미러링 원형 버튼
            _buildCircleButton(
              icon: CupertinoIcons.rectangle_on_rectangle,
              isActive: false,
              activeBgColor: Colors.white,
              activeIconColor: Colors.black,
              inactiveIconColor: Colors.white,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2. 집중 모드 (Focus) 가로형 알약 캡슐
        GestureDetector(
          onTap: () => onToggleFocus(!isFocusMode),
          child: Ios26LiquidGlass(
            height: 64,
            borderRadius: 32,
            blurSigma: 36,
            tintColor: const Color(0xFF0F2644),
            hasCornerGlow: false,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFocusMode ? const Color(0xFF5856D6) : Colors.white.withValues(alpha: 0.16),
                  ),
                  child: const Icon(CupertinoIcons.moon_fill, color: Colors.white, size: 19),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('집중 모드', style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600, letterSpacing: -0.2)),
                ),
                const Icon(CupertinoIcons.chevron_up_chevron_down, color: Colors.white70, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required bool isActive,
    required Color activeBgColor,
    required Color activeIconColor,
    required Color inactiveIconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Ios26LiquidGlass(
        width: 74,
        height: 74,
        borderRadius: 37,
        blurSigma: 36,
        tintColor: isActive ? Colors.white : const Color(0xFF0F2644),
        hasCornerGlow: false,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeBgColor : Colors.transparent,
          ),
          child: Center(
            child: Icon(
              icon,
              color: isActive ? activeIconColor : inactiveIconColor,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

/// 하단 6개 원형 리퀴드 퀵 토글 (손전등, 타이머, 계산기, 카메라, QR스캐너, 화면녹화) - 100% 완전한 정원형
class Ios26BottomActionsGrid extends StatelessWidget {
  final bool isFlashlightOn;
  final VoidCallback onToggleFlashlight;
  final Function(String appId) onOpenApp;

  const Ios26BottomActionsGrid({
    super.key,
    required this.isFlashlightOn,
    required this.onToggleFlashlight,
    required this.onOpenApp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: 4개 완전한 정원형 버튼 (손전등, 타이머, 계산기, 카메라)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionCircle(
              icon: Icons.flashlight_on_rounded,
              isActive: isFlashlightOn,
              activeBgColor: Colors.white,
              activeIconColor: Colors.black,
              onTap: onToggleFlashlight,
            ),
            _buildActionCircle(
              icon: CupertinoIcons.stopwatch_fill,
              onTap: () => onOpenApp('clock'),
            ),
            _buildActionCircle(
              icon: CupertinoIcons.number_square_fill,
              onTap: () => onOpenApp('calculator'),
            ),
            _buildActionCircle(
              icon: CupertinoIcons.camera_fill,
              onTap: () => onOpenApp('camera'),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Row 2: 2개 완전한 정원형 버튼 (QR 스캐너, 화면 녹화)
        Row(
          children: [
            _buildActionCircle(
              icon: CupertinoIcons.qrcode_viewfinder,
              onTap: () {},
            ),
            const SizedBox(width: 14),
            _buildActionCircle(
              icon: Icons.radio_button_checked,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCircle({
    required IconData icon,
    bool isActive = false,
    Color activeBgColor = Colors.white,
    Color activeIconColor = Colors.black,
    required VoidCallback onTap,
  }) {
    const double circleSize = 64.0;

    return GestureDetector(
      onTap: onTap,
      child: Ios26LiquidGlass(
        width: circleSize,
        height: circleSize,
        borderRadius: circleSize / 2,
        blurSigma: 36,
        tintColor: isActive ? Colors.white : const Color(0xFF0F2644),
        hasCornerGlow: false,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeBgColor : Colors.transparent,
          ),
          child: Center(
            child: Icon(
              icon,
              color: isActive ? activeIconColor : Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
