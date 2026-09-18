import 'package:flutter/material.dart';
import '../control_center/ios26_control_center_view.dart';

/// Apple iOS 26 공식 리퀴드 글래스 제어 센터 (Control Center)
/// - 하위 모듈 분리: lib/pages/console/ios/versions/ios26/control_center/
class Ios26ControlCenter extends StatelessWidget {
  final VoidCallback onClose;
  final Function(String appId) onOpenApp;

  const Ios26ControlCenter({super.key, required this.onClose, required this.onOpenApp});

  @override
  Widget build(BuildContext context) {
    return Ios26ControlCenterView(onClose: onClose, onOpenApp: onOpenApp);
  }
}
