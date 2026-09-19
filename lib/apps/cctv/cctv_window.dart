import 'package:flutter/cupertino.dart';
import '../../pages/console/common/os_window_frame.dart';
import 'cctv_screen.dart';
import 'data/cctv_model.dart';

/// CCTV / 보안 관제 데스크톱 MDI 윈도우 프레임 (OS별 순정 헤드 자동 적용)
class CctvWindow extends StatefulWidget {
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

  const CctvWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 960,
    this.height = 640,
    this.isMaximized = false,
    this.style = WindowStyle.windows10,
  });

  @override
  State<CctvWindow> createState() => _CctvWindowState();
}

class _CctvWindowState extends State<CctvWindow> {
  late CctvConfig _config;

  @override
  void initState() {
    super.initState();
    _config = CctvConfig.defaultPreset();
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '보안 관제 센터 (CCTV NVR 9000 Surveillance)',
      icon: CupertinoIcons.videocam_fill,
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
      child: CctvScreen(
        config: _config,
        onConfigChanged: (updated) => setState(() => _config = updated),
      ),
    );
  }
}
