import 'package:flutter/material.dart';
import '../../pages/console/common/os_window_frame.dart';
import 'data/dcinside_model.dart';
import 'dcinside_screen.dart';

class DcinsideWindow extends StatefulWidget {
  final double width;
  final double height;
  final WindowStyle style;
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final bool? isMaximized;

  const DcinsideWindow({
    super.key,
    this.width = 960,
    this.height = 640,
    required this.style,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.isMaximized,
  });

  @override
  State<DcinsideWindow> createState() => _DcinsideWindowState();
}

class _DcinsideWindowState extends State<DcinsideWindow> {
  late DcinsideConfig _config;

  @override
  void initState() {
    super.initState();
    _config = DcinsideConfig.defaultPreset();
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '디시인사이드 (${_config.galleryName})',
      iconAsset: 'assets/images/dcinside_icon.webp',
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
      child: DcinsideScreen(
        config: _config,
        onConfigChanged: (updated) => setState(() => _config = updated),
      ),
    );
  }
}
