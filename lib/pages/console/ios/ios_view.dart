import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'versions/ios16/ios16_view.dart';
import 'versions/ios17/ios17_view.dart';
import 'versions/ios18/ios18_view.dart';
import 'versions/ios26/ios26_view.dart';

/// iOS 모바일 운영체제 뷰 오케스트레이터 (버전별 분기 라우팅)
/// - 기본 플래그십: 최신 iOS 26 (WWDC 2025 공식 리퀴드 글래스 탑재)
class IosView extends StatelessWidget {
  final String iosVersion;
  final User? user;
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final Function(String osKey)? onSelectOs;

  const IosView({
    super.key,
    this.iosVersion = '26',
    this.user,
    required this.timeString,
    required this.dateString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
    this.onSelectOs,
  });

  @override
  Widget build(BuildContext context) {
    switch (iosVersion) {
      case '16':
        return Ios16View(
          user: user,
          timeString: timeString,
          dateString: dateString,
          currentWallpaper: currentWallpaper,
          onOpenTemplate: onOpenTemplate,
          onOpenSettings: onOpenSettings,
          onSignOut: onSignOut,
          onGoHome: onGoHome,
        );
      case '17':
        return Ios17View(
          user: user,
          timeString: timeString,
          dateString: dateString,
          currentWallpaper: currentWallpaper,
          onOpenTemplate: onOpenTemplate,
          onOpenSettings: onOpenSettings,
          onSignOut: onSignOut,
          onGoHome: onGoHome,
        );
      case '18':
        return Ios18View(
          user: user,
          timeString: timeString,
          dateString: dateString,
          currentWallpaper: currentWallpaper,
          onOpenTemplate: onOpenTemplate,
          onOpenSettings: onOpenSettings,
          onSignOut: onSignOut,
          onGoHome: onGoHome,
          onSelectOs: onSelectOs,
        );
      case '26':
      default:
        return Ios26View(
          user: user,
          timeString: timeString,
          dateString: dateString,
          currentWallpaper: currentWallpaper,
          onOpenTemplate: onOpenTemplate,
          onOpenSettings: onOpenSettings,
          onSignOut: onSignOut,
          onGoHome: onGoHome,
          onSelectOs: onSelectOs,
        );
    }
  }
}
