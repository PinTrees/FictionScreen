import 'package:flutter/cupertino.dart';
import '../../pages/console/common/os_window_frame.dart';
import 'data/naver_model.dart';
import 'naver_screen.dart';

/// 네이버 데스크톱 MDI 윈도우 프레임 (OS별 순정 헤드 자동 적용)
class NaverWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;
  final WindowStyle style;

  const NaverWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 1000,
    this.height = 660,
    this.isMaximized = false,
    this.style = WindowStyle.windows10,
  });

  @override
  State<NaverWindow> createState() => _NaverWindowState();
}

class _NaverWindowState extends State<NaverWindow> {
  late NaverConfig _config;

  @override
  void initState() {
    super.initState();
    _config = NaverConfig.defaultPreset();
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: 'NAVER - 대한민국 종합 포털 & 뉴스스탠드',
      iconAsset: 'assets/images/naver_icon.webp',
      style: widget.style,
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: NaverScreen(
        config: _config,
        onConfigChanged: (updated) => setState(() => _config = updated),
      ),
    );
  }
}
