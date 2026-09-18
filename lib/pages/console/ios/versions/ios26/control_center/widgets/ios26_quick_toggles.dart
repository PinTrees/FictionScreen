import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';
import 'ios26_cc_icons.dart';

/// Apple iOS 26 리퀴드 글래스 퀵 토글 섹션 (회전잠금, 화면미러링, 집중모드 알약 캡슐)
class Ios26QuickTogglesSection extends StatelessWidget {
  final double unitSize;
  final double cardSize;
  final double gap;
  final bool isRotationLocked;
  final bool isFocusMode;
  final ValueChanged<bool> onToggleRotation;
  final ValueChanged<bool> onToggleFocus;
  final Function(String appId) onOpenApp;

  const Ios26QuickTogglesSection({
    super.key,
    required this.unitSize,
    required this.cardSize,
    required this.gap,
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
              size: unitSize,
              child: Ios26RotationLockIcon(size: unitSize * 0.40, color: isRotationLocked ? const Color(0xFFFF3B30) : Colors.white),
              isActive: isRotationLocked,
              activeBgColor: Colors.white,
              onTap: () => onToggleRotation(!isRotationLocked),
            ),
            // 화면 미러링 원형 버튼
            _buildCircleButton(
              size: unitSize,
              child: Ios26ScreenMirrorIcon(size: unitSize * 0.40, color: Colors.white),
              isActive: false,
              activeBgColor: Colors.white,
              onTap: () {},
            ),
          ],
        ),
        SizedBox(height: gap),

        // 2. 집중 모드 (Focus) 가로형 알약 캡슐 (너비 = cardSize, 높이 = unitSize)
        GestureDetector(
          onTap: () => onToggleFocus(!isFocusMode),
          child: Ios26LiquidGlass(
            width: cardSize,
            height: unitSize,
            borderRadius: unitSize / 2,
            blurSigma: 36,
            tintColor: const Color(0xFF0F2644),
            hasCornerGlow: false,
            padding: EdgeInsets.symmetric(horizontal: unitSize * 0.18),
            child: Row(
              children: [
                Container(
                  width: unitSize * 0.50,
                  height: unitSize * 0.50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFocusMode ? const Color(0xFF5856D6) : Colors.white.withValues(alpha: 0.16),
                  ),
                  child: Center(child: Ios26MoonIcon(size: unitSize * 0.26)),
                ),
                SizedBox(width: unitSize * 0.12),
                const Expanded(
                  child: Text('집중 모드', style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600, letterSpacing: -0.2)),
                ),
                const Icon(CupertinoIcons.chevron_up_chevron_down, color: Colors.white70, size: 13),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required double size,
    required Widget child,
    required bool isActive,
    required Color activeBgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Ios26LiquidGlass(
        width: size,
        height: size,
        borderRadius: size / 2,
        blurSigma: 36,
        tintColor: isActive ? Colors.white : const Color(0xFF0F2644),
        hasCornerGlow: false,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeBgColor : Colors.transparent,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// 하단 6개 완전한 정원형 리퀴드 퀵 토글 (손전등, 타이머, 계산기, 카메라, QR스캐너, 화면녹화)
class Ios26BottomActionsGrid extends StatelessWidget {
  final double unitSize;
  final double gap;
  final bool isFlashlightOn;
  final VoidCallback onToggleFlashlight;
  final Function(String appId) onOpenApp;

  const Ios26BottomActionsGrid({
    super.key,
    required this.unitSize,
    required this.gap,
    required this.isFlashlightOn,
    required this.onToggleFlashlight,
    required this.onOpenApp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 3: 4개 완전한 정원형 버튼 (손전등, 타이머, 계산기, 카메라)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionCircle(
              size: unitSize,
              child: Ios26FlashlightIcon(size: unitSize * 0.40, color: isFlashlightOn ? Colors.black : Colors.white),
              isActive: isFlashlightOn,
              onTap: onToggleFlashlight,
            ),
            _buildActionCircle(
              size: unitSize,
              child: Ios26TimerIcon(size: unitSize * 0.40),
              onTap: () => onOpenApp('clock'),
            ),
            _buildActionCircle(
              size: unitSize,
              child: Ios26CalculatorIcon(size: unitSize * 0.40),
              onTap: () => onOpenApp('calculator'),
            ),
            _buildActionCircle(
              size: unitSize,
              child: Ios26CameraIcon(size: unitSize * 0.40),
              onTap: () => onOpenApp('camera'),
            ),
          ],
        ),
        SizedBox(height: gap),

        // Row 4: 2개 완전한 정원형 버튼 (QR 스캐너, 화면 녹화)
        Row(
          children: [
            _buildActionCircle(
              size: unitSize,
              child: Ios26QrCodeIcon(size: unitSize * 0.40),
              onTap: () {},
            ),
            SizedBox(width: gap),
            _buildActionCircle(
              size: unitSize,
              child: Ios26RecordIcon(size: unitSize * 0.40),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCircle({
    required double size,
    required Widget child,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Ios26LiquidGlass(
        width: size,
        height: size,
        borderRadius: size / 2,
        blurSigma: 36,
        tintColor: isActive ? Colors.white : const Color(0xFF0F2644),
        hasCornerGlow: false,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.transparent,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
