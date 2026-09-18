import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'versions/ios16/ios16_view.dart';
import 'versions/ios17/ios17_view.dart';
import 'versions/ios18/ios18_view.dart';

/// iOS 모바일 운영체제 뷰 오케스트레이터 (버전별 분기 라우팅)
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

  const IosView({
    super.key,
    this.iosVersion = '18',
    this.user,
    required this.timeString,
    required this.dateString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
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
      default:
        return Ios18View(
          user: user,
          timeString: timeString,
          dateString: dateString,
          currentWallpaper: currentWallpaper,
          onOpenTemplate: onOpenTemplate,
          onOpenSettings: onOpenSettings,
          onSignOut: onSignOut,
          onGoHome: onGoHome,
        );
    }
  }
}
