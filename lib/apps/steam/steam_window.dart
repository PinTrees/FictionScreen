import 'package:flutter/cupertino.dart';
import '../../pages/console/common/os_window_frame.dart';
import 'data/steam_model.dart';
import 'steam_screen.dart';

/// 스팀 (Steam) 데스크톱 MDI 윈도우 프레임 (OS별 순정 헤드 자동 적용)
class SteamWindow extends StatefulWidget {
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

  const SteamWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 980,
    this.height = 640,
    this.isMaximized = false,
    this.style = WindowStyle.windows10,
  });

  @override
  State<SteamWindow> createState() => _SteamWindowState();
}

class _SteamWindowState extends State<SteamWindow> {
  late SteamConfig _config;

  @override
  void initState() {
    super.initState();
    _config = SteamConfig.defaultPreset();
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: 'Steam',
      iconAsset: 'assets/images/steam_icon.webp',
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
      child: SteamScreen(
        config: _config,
        onConfigChanged: (updated) => setState(() => _config = updated),
      ),
    );
  }
}
