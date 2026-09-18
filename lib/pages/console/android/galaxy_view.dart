import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'versions/oneui6/oneui6_view.dart';
import 'versions/oneui7/oneui7_view.dart';

/// Samsung Galaxy 모바일 운영체제 뷰 오케스트레이터 (버전별 분기 라우팅)
/// - 기본 플래그십: 최신 One UI 7 (S25 Ultra / S26 펀치홀, 나우 바, 스플릿 퀵 세팅 탑재)
/// - 레거시 지원: One UI 6 (One UI 6.1 스타일)
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
    this.oneUiVersion = '7',
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
      default:
        return OneUi7View(
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
