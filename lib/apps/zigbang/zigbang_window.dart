import 'package:flutter/cupertino.dart';
import '../../pages/console/common/os_window_frame.dart';
import 'data/zigbang_model.dart';
import 'zigbang_screen.dart';

/// 직방 데스크톱 MDI 윈도우 프레임 (OS별 순정 헤드 자동 적용)
class ZigbangWindow extends StatefulWidget {
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

  const ZigbangWindow({
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
  State<ZigbangWindow> createState() => _ZigbangWindowState();
}

class _ZigbangWindowState extends State<ZigbangWindow> {
  late ZigbangConfig _config;

  @override
  void initState() {
    super.initState();
    _config = ZigbangConfig.defaultPreset();
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '직방 (Zigbang) - 부동산 포털 & 아파트 실거래가',
      iconAsset: 'assets/images/zigbang_icon.webp',
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
      child: ZigbangScreen(
        config: _config,
        onConfigChanged: (updated) => setState(() => _config = updated),
      ),
    );
  }
}
