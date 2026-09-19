import 'package:flutter/material.dart';
import 'data/zigbang_model.dart';
import 'widgets/zigbang_desktop_view.dart';
import 'widgets/zigbang_mobile_view.dart';

/// 직방 (Zigbang) 반응형 스크린 (너비 720px 기준 데스크톱 포털 / 모바일 앱 자동 전환)
class ZigbangScreen extends StatelessWidget {
  final ZigbangConfig config;
  final ValueChanged<ZigbangConfig> onConfigChanged;

  const ZigbangScreen({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720) {
          return ZigbangDesktopView(
            config: config,
            onConfigChanged: onConfigChanged,
          );
        } else {
          return ZigbangMobileView(
            config: config,
            onConfigChanged: onConfigChanged,
          );
        }
      },
    );
  }
}
