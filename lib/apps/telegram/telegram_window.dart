import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/telegram_model.dart';
import 'telegram_screen.dart';

/// 텔레그램 데스크톱 OS 윈도우 프레임 (Telegram Desktop MDI)
class TelegramWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const TelegramWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 920,
    this.height = 620,
    this.isMaximized = false,
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
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xFF17212B),
        borderRadius: widget.isMaximized ? BorderRadius.zero : BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 24, offset: Offset(0, 10)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // 윈도우 타이틀바
          GestureDetector(
            onPanStart: widget.onTitleDragStart,
            onPanUpdate: widget.onTitleDragUpdate,
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF17212B),
                border: Border(bottom: BorderSide(color: Color(0xFF0E1621))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2B5278),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.paperplane_fill, size: 11, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${_config.selectedChat.title} - Telegram Desktop',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.minus, size: 12, color: Colors.white70),
                    onPressed: widget.onMinimize,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  ),
                  IconButton(
                    icon: Icon(widget.isMaximized ? CupertinoIcons.square_on_square : CupertinoIcons.square, size: 11, color: Colors.white70),
                    onPressed: widget.onMaximize,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.xmark, size: 12, color: Colors.white70),
                    onPressed: widget.onClose,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    hoverColor: Colors.red.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
          ),

          // 메인 텔레그램 스크린
          Expanded(
            child: TelegramScreen(
              config: _config,
              onConfigChanged: (newConfig) {
                setState(() => _config = newConfig);
              },
            ),
          ),
        ],
      ),
    );
  }
}
