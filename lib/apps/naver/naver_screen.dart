import 'package:flutter/material.dart';
import 'data/naver_model.dart';
import 'widgets/naver_desktop_view.dart';
import 'widgets/naver_mobile_view.dart';

/// 네이버 (Naver) 반응형 스크린 (너비 760px 기준 데스크톱 포털 / 모바일 앱 자동 전환)
class NaverScreen extends StatelessWidget {
  final NaverConfig config;
  final ValueChanged<NaverConfig> onConfigChanged;

  const NaverScreen({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 760) {
          return NaverDesktopView(
            config: config,
            onConfigChanged: onConfigChanged,
          );
        } else {
          return NaverMobileView(
            config: config,
            onConfigChanged: onConfigChanged,
          );
        }
      },
    );
  }
}
