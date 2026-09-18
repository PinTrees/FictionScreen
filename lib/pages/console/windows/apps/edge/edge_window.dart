import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../common/os_window_frame.dart';

/// Microsoft Edge 브라우저 창
class WindowsEdgeWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String templateId)? onOpenTemplate;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const WindowsEdgeWindow({
    super.key,
    required this.onClose,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 820,
    this.height = 540,
  });

  @override
  State<WindowsEdgeWindow> createState() => _WindowsEdgeWindowState();
}

class _WindowsEdgeWindowState extends State<WindowsEdgeWindow> {
  final TextEditingController _urlController = TextEditingController(text: 'https://fiction-screen.web.app');

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: 'Microsoft Edge',
      icon: CupertinoIcons.globe,
      style: WindowStyle.windows,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          // Edge 툴바
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white.withValues(alpha: 0.04),
            child: Row(
              children: [
                const Icon(CupertinoIcons.arrow_left, size: 14, color: Colors.white54),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.arrow_right, size: 14, color: Colors.white24),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.arrow_clockwise, size: 14, color: Colors.white54),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 26,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.lock_fill, size: 10, color: Colors.white38),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 시작 페이지
          Expanded(
            child: Container(
              color: const Color(0xFF141720),
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Microsoft Edge 시작 페이지', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('자주 방문한 사이트', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildQuickTile('카카오톡', CupertinoIcons.chat_bubble_2_fill, const Color(0xFFFEE500), () => widget.onOpenTemplate?.call('kakaotalk')),
                      const SizedBox(width: 12),
                      _buildQuickTile('인스타그램', CupertinoIcons.camera_fill, const Color(0xFFE1306C), () => widget.onOpenTemplate?.call('instagram')),
                      const SizedBox(width: 12),
                      _buildQuickTile('블루스크린', CupertinoIcons.device_desktop, const Color(0xFF0078D7), () => widget.onOpenTemplate?.call('windows_bsod')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
