import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ios18/ios18_view.dart';

/// iOS 17 버전 뷰 (버전별 아키텍처 모듈)
class Ios17View extends StatelessWidget {
  final User? user;
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const Ios17View({
    super.key,
    required this.user,
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
