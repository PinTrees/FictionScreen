import 'package:flutter/cupertino.dart';
import '../../pages/console/common/os_window_frame.dart';
import 'data/telegram_model.dart';
import 'telegram_screen.dart';

/// 텔레그램 데스크톱 OS 윈도우 프레임 (각 가상 OS의 순정 헤드 디자인 자동 적용)
class TelegramWindow extends StatefulWidget {
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

  const TelegramWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 920,
    this.height = 620,
    this.isMaximized = false,
    this.style = WindowStyle.windows10,
  });

  @override
  State<TelegramWindow> createState() => _TelegramWindowState();
}

class _TelegramWindowState extends State<TelegramWindow> {
  late TelegramConfig _config;

  @override
  void initState() {
    super.initState();
    _config = TelegramConfig.defaultPreset();
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '${_config.selectedChat.title} - Telegram Desktop',
      icon: CupertinoIcons.paperplane_fill,
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
      child: TelegramScreen(
        config: _config,
        onConfigChanged: (newConfig) {
          setState(() => _config = newConfig);
        },
      ),
    );
  }
}
