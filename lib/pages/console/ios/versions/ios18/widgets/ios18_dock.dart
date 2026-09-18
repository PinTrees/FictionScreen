import 'dart:ui';
import 'package:flutter/material.dart';
import 'ios18_app_icon.dart';

/// iOS 18 순정 플로팅 프로스티드 글래스 독(Dock) 바
class Ios18Dock extends StatelessWidget {
  final Function(String appId) onOpenApp;

  const Ios18Dock({super.key, required this.onOpenApp});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Ios18AppIcon(
                  title: '',
                  imageAsset: 'assets/images/ios/icons/phone.png',
                  onTap: () => onOpenApp('phone'),
                ),
                Ios18AppIcon(
                  title: '',
                  imageAsset: 'assets/images/ios/icons/safari.png',
                  onTap: () => onOpenApp('safari'),
                ),
                Ios18AppIcon(
                  title: '',
                  imageAsset: 'assets/images/ios/icons/messages.png',
                  badgeCount: 3,
                  onTap: () => onOpenApp('messages'),
                ),
                Ios18AppIcon(
                  title: '',
                  imageAsset: 'assets/images/ios/icons/music.png',
                  onTap: () => onOpenApp('music'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
