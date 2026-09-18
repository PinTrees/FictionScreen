import 'package:flutter/material.dart';
import '../data/photoshop_model.dart';

class PhotoshopToolOptionsBar extends StatelessWidget {
  final PhotoshopTool selectedTool;
  final double brushSize;
  final double brushOpacity;
  final ValueChanged<double>? onBrushSizeChanged;
  final ValueChanged<double>? onBrushOpacityChanged;

  const PhotoshopToolOptionsBar({
    super.key,
    required this.selectedTool,
    required this.brushSize,
    required this.brushOpacity,
    this.onBrushSizeChanged,
    this.onBrushOpacityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFF282828),
        border: Border(
          top: BorderSide(color: Color(0xFF383838), width: 1),
          bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // Current tool icon
          Icon(selectedTool.icon, size: 15, color: const Color(0xFF31A8FF)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 12, color: Color(0xFF9E9E9E)),
          const SizedBox(width: 10),
          Container(width: 1, height: 16, color: const Color(0xFF383838)),
          const SizedBox(width: 10),

          // Options based on tool
          if (selectedTool == PhotoshopTool.brush || selectedTool == PhotoshopTool.eraser) ...[
            _buildLabel('크기:'),
            const SizedBox(width: 4),
            _buildBadge('${brushSize.round()} px'),
            const SizedBox(width: 12),
            _buildLabel('모드:'),
            const SizedBox(width: 4),
            _buildBadge('표준 ▼'),
            const SizedBox(width: 12),
            _buildLabel('불투명도:'),
            const SizedBox(width: 4),
            _buildBadge('${brushOpacity.round()}%'),
            const SizedBox(width: 12),
            _buildLabel('흐름:'),
            const SizedBox(width: 4),
            _buildBadge('100%'),
            const SizedBox(width: 12),
            _buildLabel('매끄러움:'),
            const SizedBox(width: 4),
            _buildBadge('10%'),
          ] else ...[
            // Move / General Options
            const Row(
              children: [
                Icon(Icons.check_box, size: 13, color: Color(0xFF31A8FF)),
                SizedBox(width: 4),
                Text('자동 선택: 레이어', style: TextStyle(color: Color(0xFFD6D6D6), fontSize: 11)),
                SizedBox(width: 14),
                Icon(Icons.check_box, size: 13, color: Color(0xFF31A8FF)),
                SizedBox(width: 4),
                Text('변형 컨트롤 표시', style: TextStyle(color: Color(0xFFD6D6D6), fontSize: 11)),
              ],
            ),
            const SizedBox(width: 16),
            const Row(
              children: [
                Icon(Icons.align_horizontal_left, size: 14, color: Color(0xFF9E9E9E)),
                SizedBox(width: 6),
                Icon(Icons.align_horizontal_center, size: 14, color: Color(0xFF9E9E9E)),
                SizedBox(width: 6),
                Icon(Icons.align_horizontal_right, size: 14, color: Color(0xFF9E9E9E)),
                SizedBox(width: 10),
                Icon(Icons.align_vertical_top, size: 14, color: Color(0xFF9E9E9E)),
                SizedBox(width: 6),
                Icon(Icons.align_vertical_center, size: 14, color: Color(0xFF9E9E9E)),
                SizedBox(width: 6),
                Icon(Icons.align_vertical_bottom, size: 14, color: Color(0xFF9E9E9E)),
              ],
            ),
          ],

          const Spacer(),

          // Right Workspace Preset selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF383838),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Row(
              children: [
                Text('필수(기본값)', style: TextStyle(color: Color(0xFFD6D6D6), fontSize: 11)),
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, size: 12, color: Color(0xFF9E9E9E)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 11, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFF454545), width: 0.8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFFD6D6D6), fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}
