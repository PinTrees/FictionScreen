import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// Windows 11 그림판 (Paint)
class WindowsPaintWindow extends StatefulWidget {
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

  const WindowsPaintWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 720,
    this.height = 480,
    this.isMaximized = false,
    this.style = WindowStyle.windows10,
  });

  @override
  State<WindowsPaintWindow> createState() => _WindowsPaintWindowState();
}

class _WindowsPaintWindowState extends State<WindowsPaintWindow> {
  final List<Offset?> _points = [];
  Color _selectedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '제목 없음 - 그림판',
      iconAsset: 'assets/images/windows/mspaint.png',
      icon: CupertinoIcons.paintbrush_fill,
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
      child: Column(
        children: [
          // 툴바 & 색상 팔레트
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: Colors.white.withValues(alpha: 0.05),
            child: Row(
              children: [
                IconButton(icon: const Icon(CupertinoIcons.trash, color: Colors.white70, size: 18), onPressed: () => setState(() => _points.clear())),
                const VerticalDivider(color: Colors.white12, indent: 8, endIndent: 8),
                _buildColorDot(Colors.white),
                _buildColorDot(const Color(0xFFEF4444)),
                _buildColorDot(const Color(0xFF10B981)),
                _buildColorDot(const Color(0xFF3B82F6)),
                _buildColorDot(const Color(0xFFF59E0B)),
              ],
            ),
          ),
          // 캔버스
          Expanded(
            child: Container(
              color: const Color(0xFF121212),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    RenderBox object = context.findRenderObject() as RenderBox;
                    Offset localPosition = object.globalToLocal(details.globalPosition);
                    _points.add(localPosition);
                  });
                },
                onPanEnd: (_) => _points.add(null),
                child: CustomPaint(
                  painter: _PaintPainter(_points, _selectedColor),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    final isSelected = _selectedColor == color;
    return InkWell(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: isSelected ? Border.all(color: Colors.white, width: 2) : null),
      ),
    );
  }
}

class _PaintPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;

  _PaintPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_PaintPainter oldDelegate) => true;
}
