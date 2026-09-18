import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'versions/oneui6/oneui6_view.dart';
import 'versions/oneui7/oneui7_view.dart';
import 'versions/oneui9/oneui9_view.dart';

/// Samsung Galaxy 모바일 운영체제 뷰 오케스트레이터 (버전별 분기 라우팅)
/// - 기본 플래그십: 최신 One UI 9 (Android 17, S26 Ultra, 좌우 멀티페이지 슬라이드, 깃허브 공식 아이콘 & 배경화면)
/// - One UI 7: S25 Ultra 플래그십
/// - One UI 6: One UI 6.1 레거시 지원
class GalaxyView extends StatelessWidget {
  final String oneUiVersion;
  final User? user;
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final Function(String osKey)? onSelectOs;

  const GalaxyView({
    super.key,
    this.oneUiVersion = '9',
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
    switch (oneUiVersion) {
      case '6':
        return OneUi6View(
          timeString: timeString,
          dateString: dateString,
          currentWallpaper: currentWallpaper,
          onOpenTemplate: onOpenTemplate,
          onOpenSettings: onOpenSettings,
          onSignOut: onSignOut,
          onGoHome: onGoHome,
        );
      case '7':
        return OneUi7View(
          timeString: timeString,
          dateString: dateString,
          currentWallpaper: currentWallpaper,
          onOpenTemplate: onOpenTemplate,
          onOpenSettings: onOpenSettings,
          onSignOut: onSignOut,
          onGoHome: onGoHome,
        );
      case '9':
      default:
        return OneUi9View(
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
