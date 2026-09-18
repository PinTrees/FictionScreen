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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Ios26LiquidGlass(
        height: 92,
        borderRadius: 38,
        blurSigma: 42,
        hasCornerGlow: true,
        hasChromaticAberration: true,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Ios26AppIcon(
                  title: '',
                  imageAsset: 'assets/images/ios/icons/phone.png',
                  isEditMode: isEditMode,
                  index: 100,
                  onTap: () => onOpenApp('phone'),
                  onLongPress: onEnterEditMode,
                ),
                Ios26AppIcon(
                  title: '',
                  imageAsset: 'assets/images/ios/icons/safari.png',
                  isEditMode: isEditMode,
                  index: 101,
                  onTap: () => onOpenApp('safari'),
                  onLongPress: onEnterEditMode,
                ),
                Ios26AppIcon(
                  title: '',
                  imageAsset: 'assets/images/ios/icons/messages.png',
                  badgeCount: 3,
                  isEditMode: isEditMode,
                  index: 102,
                  onTap: () => onOpenApp('messages'),
                  onLongPress: onEnterEditMode,
                ),
                Ios26AppIcon(
                  title: '',
                  imageAsset: 'assets/images/ios/icons/music.png',
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
  }
}
