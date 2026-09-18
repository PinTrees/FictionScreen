import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'versions/macos27/macos27_view.dart';
import 'versions/sequoia/sequoia_view.dart';

/// Apple macOS 데스크톱 뷰 오케스트레이터 (버전별 분기 라우팅)
/// - 기본 플래그십: 최신 macOS 27 Golden Gate (Liquid Glass 디자인, Siri AI Spotlight, 골든게이트 에어리얼 배경화면)
/// - 레거시: macOS 15 Sequoia
class MacosView extends StatelessWidget {
  final String macosVersion;
  final User? user;
  final String timeString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final Function(String osKey)? onSelectOs;
  final Function(String wallpaperKey)? onWallpaperChanged;

  const MacosView({
    super.key,
    this.macosVersion = '27',
    this.user,
    required this.timeString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
    this.onSelectOs,
    this.onWallpaperChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (macosVersion) {
      case '15':
        return SequoiaView(
          user: user,
          timeString: timeString,
          currentWallpaper: currentWallpaper,
          onOpenTemplate: onOpenTemplate,
          onOpenSettings: onOpenSettings,
          onSignOut: onSignOut,
          onGoHome: onGoHome,
          onSelectOs: onSelectOs,
        );
      case '27':
      default:
        return Macos27View(
          user: user,
          timeString: timeString,
          currentWallpaper: currentWallpaper,
          onOpenTemplate: onOpenTemplate,
          onOpenSettings: onOpenSettings,
          onSignOut: onSignOut,
          onGoHome: onGoHome,
          onSelectOs: onSelectOs,
          onWallpaperChanged: onWallpaperChanged,
        );
    }
  }
}
