import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';

/// iOS 26 리퀴드 글래스 퀵 토글 컴포넌트 모음 (회전잠금, 무음, 집중모드, 원형 퀵액션)
class Ios26QuickTogglesSection extends StatelessWidget {
  final bool isRotationLocked;
  final bool isSilentMode;
  final bool isFocusMode;
  final bool isFlashlightOn;
  final ValueChanged<bool> onToggleRotation;
  final ValueChanged<bool> onToggleSilent;
  final ValueChanged<bool> onToggleFocus;
  final ValueChanged<bool> onToggleFlashlight;
  final Function(String appId) onOpenApp;

  const Ios26QuickTogglesSection({
    super.key,
    required this.isRotationLocked,
    required this.isSilentMode,
    required this.isFocusMode,
    required this.isFlashlightOn,
    required this.onToggleRotation,
    required this.onToggleSilent,
    required this.onToggleFocus,
    required this.onToggleFlashlight,
    required this.onOpenApp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. 회전 잠금 및 무음 벨소리 2열
        Row(
          children: [
            Expanded(
              child: _buildSquareButton(
                icon: CupertinoIcons.lock_rotation,
                isActive: isRotationLocked,
                activeColor: const Color(0xFF007AFF),
                onTap: () => onToggleRotation(!isRotationLocked),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSquareButton(
                icon: CupertinoIcons.bell_fill,
                isActive: isSilentMode,
                activeColor: const Color(0xFFFF3B30),
                onTap: () => onToggleSilent(!isSilentMode),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 2. 집중 모드 (Focus) 가로형 알약 캡슐
        GestureDetector(
          onTap: () => onToggleFocus(!isFocusMode),
          child: Ios26LiquidGlass(
            height: 66,
            borderRadius: 33,
            blurSigma: 32,
            hasCornerGlow: false,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: isFocusMode ? const Color(0xFF5856D6) : Colors.white.withValues(alpha: 0.15)),
                  child: const Icon(CupertinoIcons.moon_fill, color: Colors.white, size: 19),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('집중 모드', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -0.2)),
                ),
                const Icon(CupertinoIcons.chevron_up_chevron_down, color: Colors.white70, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildSquareButton({
    required IconData icon,
    bool isActive = false,
    Color activeColor = const Color(0xFF007AFF),
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Ios26LiquidGlass(
        height: 66,
        borderRadius: 22,
        blurSigma: 34,
        hasCornerGlow: false,
        child: Container(
          decoration: BoxDecoration(color: isActive ? activeColor : Colors.transparent, borderRadius: BorderRadius.circular(22)),
          child: Center(child: Icon(icon, color: Colors.white, size: 26)),
        ),
      ),
    );
  }
}

/// 하단 6개 원형 리퀴드 퀵 토글 (손전등, 타이머, 계산기, 카메라, QR스캐너, 화면녹화)
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
        // Row 1: 손전등, 타이머, 계산기, 카메라
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildCircleActionButton(
                icon: Icons.flashlight_on_rounded,
                isActive: isFlashlightOn,
                activeColor: const Color(0xFFFFD60A),
                activeIconColor: Colors.black,
                onTap: onToggleFlashlight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCircleActionButton(
                icon: CupertinoIcons.stopwatch_fill,
                onTap: () => onOpenApp('clock'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCircleActionButton(
                icon: CupertinoIcons.number_square_fill,
                onTap: () => onOpenApp('calculator'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCircleActionButton(
                icon: CupertinoIcons.camera_fill,
                onTap: () => onOpenApp('camera'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Row 2: QR 스캐너, 화면 녹화
        Row(
          children: [
            Expanded(
              child: _buildCircleActionButton(
                icon: CupertinoIcons.qrcode_viewfinder,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCircleActionButton(
                icon: Icons.radio_button_checked,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            const Spacer(),
            const SizedBox(width: 12),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildCircleActionButton({
    required IconData icon,
    bool isActive = false,
    Color activeColor = const Color(0xFF007AFF),
    Color activeIconColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Ios26LiquidGlass(
        height: 66,
        borderRadius: 33,
        blurSigma: 32,
        hasCornerGlow: false,
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? activeColor : Colors.transparent),
          child: Center(child: Icon(icon, color: isActive ? activeIconColor : Colors.white, size: 24)),
        ),
      ),
    );
  }
}
