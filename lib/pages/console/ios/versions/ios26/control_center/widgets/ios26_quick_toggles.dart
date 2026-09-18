import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios26_cc_icons.dart';
import 'ios26_circle_glass_button.dart';

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
    return SizedBox(
      width: cardSize,
      child: Column(
        children: [
          // 1. 회전 잠금 (원형 흰색/적색락) + 화면 미러링 (원형 듀얼스크린) - gap만큼 정확히 떨어짐
          Row(
            children: [
              Ios26CircleGlassButton(
                size: unitSize,
                isActive: isRotationLocked,
                activeBgColor: Colors.white,
                onTap: () => onToggleRotation(!isRotationLocked),
                child: Ios26RotationLockIcon(size: unitSize * 0.40, color: isRotationLocked ? const Color(0xFFFF3B30) : Colors.white),
              ),
              SizedBox(width: gap),
              Ios26CircleGlassButton(
                size: unitSize,
                isActive: false,
                onTap: () {},
                child: Ios26ScreenMirrorIcon(size: unitSize * 0.40, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: gap),

          // 2. 집중 모드 (Focus) 가로형 알약 캡슐 (너비 = cardSize, 높이 = unitSize)
          GestureDetector(
            onTap: () => onToggleFocus(!isFocusMode),
            child: Container(
              width: cardSize,
              height: unitSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(unitSize / 2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.14), blurRadius: 16, offset: const Offset(0, 6)),
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.20), width: 0.8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(unitSize / 2),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.24),
                          Colors.white.withValues(alpha: 0.10),
                          Colors.white.withValues(alpha: 0.16),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: unitSize * 0.16),
                    child: Row(
                      children: [
                        Container(
                          width: unitSize * 0.52,
                          height: unitSize * 0.52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFocusMode ? const Color(0xFF5856D6) : Colors.white.withValues(alpha: 0.16),
                          ),
                          child: Center(child: Ios26MoonIcon(size: unitSize * 0.28)),
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
              ),
            ),
          ),
        ],
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
            Ios26CircleGlassButton(
              size: unitSize,
              isActive: isFlashlightOn,
              onTap: onToggleFlashlight,
              child: Ios26FlashlightIcon(size: unitSize * 0.40, color: isFlashlightOn ? Colors.black : Colors.white),
            ),
            Ios26CircleGlassButton(
              size: unitSize,
              onTap: () => onOpenApp('clock'),
              child: Ios26TimerIcon(size: unitSize * 0.40),
            ),
            Ios26CircleGlassButton(
              size: unitSize,
              onTap: () => onOpenApp('calculator'),
              child: Ios26CalculatorIcon(size: unitSize * 0.40),
            ),
            Ios26CircleGlassButton(
              size: unitSize,
              onTap: () => onOpenApp('camera'),
              child: Ios26CameraIcon(size: unitSize * 0.40),
            ),
          ],
        ),
        SizedBox(height: gap),

        // Row 4: 2개 완전한 정원형 버튼 (QR 스캐너, 화면 녹화)
        Row(
          children: [
            Ios26CircleGlassButton(
              size: unitSize,
              onTap: () {},
              child: Ios26QrCodeIcon(size: unitSize * 0.40),
            ),
            SizedBox(width: gap),
            Ios26CircleGlassButton(
              size: unitSize,
              onTap: () {},
              child: Ios26RecordIcon(size: unitSize * 0.40),
            ),
          ],
        ),
      ],
    );
  }
}
