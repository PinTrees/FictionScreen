import 'package:flutter/material.dart';
import 'ios26_app_icon.dart';
import 'ios26_liquid_glass.dart';

/// Apple iOS 26 공식 리퀴드 글래스 (Liquid Glass) 독(Dock) 바
/// - WWDC 2025 광학 렌더러 적용 (채도 증폭 + 프리즘 색수차 분산 + 코너 글로우)
class Ios26Dock extends StatelessWidget {
  final Function(String appId) onOpenApp;
  final bool isEditMode;
  final VoidCallback? onEnterEditMode;

  const Ios26Dock({
    super.key,
    required this.onOpenApp,
    this.isEditMode = false,
    this.onEnterEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        // Image 2 레퍼런스 기준: 화면 너비의 약 16.5%를 각 아이콘이 차지 (대형화)
        final dockIconSize = (availableWidth * 0.165).clamp(66.0, 82.0);
        final dockHeight = (dockIconSize + 26.0).clamp(94.0, 108.0);
        final dockRadius = dockHeight / 2;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Ios26LiquidGlass(
            height: dockHeight,
            borderRadius: dockRadius, // 완전한 알약(Stadium Pill) 형태
            blurSigma: 32,
            hasCornerGlow: true,
            hasChromaticAberration: true,
            tintColor: const Color(0xFF0F3A6E),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Ios26AppIcon(
                      title: '',
                      size: dockIconSize,
                      imageAsset: 'assets/images/ios/icons26/phone.png',
                      isEditMode: isEditMode,
                      index: 100,
                      onTap: () => onOpenApp('phone'),
                      onLongPress: onEnterEditMode,
                    ),
                    Ios26AppIcon(
                      title: '',
                      size: dockIconSize,
                      imageAsset: 'assets/images/ios/icons26/safari.png',
                      isEditMode: isEditMode,
                      index: 101,
                      onTap: () => onOpenApp('safari'),
                      onLongPress: onEnterEditMode,
                    ),
                    Ios26AppIcon(
                      title: '',
                      size: dockIconSize,
                      imageAsset: 'assets/images/ios/icons26/messages.png',
                      badgeCount: 3,
                      isEditMode: isEditMode,
                      index: 102,
                      onTap: () => onOpenApp('messages'),
                      onLongPress: onEnterEditMode,
                    ),
                    Ios26AppIcon(
                      title: '',
                      size: dockIconSize,
                      imageAsset: 'assets/images/ios/icons26/music.png',
                      isEditMode: isEditMode,
                      index: 103,
                      onTap: () => onOpenApp('music'),
                      onLongPress: onEnterEditMode,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
