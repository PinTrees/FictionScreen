import 'package:flutter/material.dart';
import '../data/photoshop_model.dart';

class PhotoshopToolbar extends StatelessWidget {
  final PhotoshopTool selectedTool;
  final ValueChanged<PhotoshopTool> onSelectTool;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback onSwapColors;
  final VoidCallback onResetColors;

  const PhotoshopToolbar({
    super.key,
    required this.selectedTool,
    required this.onSelectTool,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onSwapColors,
    required this.onResetColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      decoration: const BoxDecoration(
        color: Color(0xFF282828),
        border: Border(right: BorderSide(color: Color(0xFF1E1E1E), width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          // Tool list
          ...PhotoshopTool.values.map((tool) {
            final isSelected = tool == selectedTool;
            return Tooltip(
              message: '${tool.label} (${tool.shortcut})',
              child: InkWell(
                onTap: () => onSelectTool(tool),
                borderRadius: BorderRadius.circular(3),
                child: Container(
                  width: 32,
                  height: 30,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3E3E3E) : Colors.transparent,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF555555) : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        tool.icon,
                        size: 16,
                        color: isSelected ? Colors.white : const Color(0xFFB5B5B5),
                      ),
                      // Small triangle at bottom right corner (indicates more tools under sub-menu)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 3,
                          height: 3,
                          color: const Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // Color Swatches (Foreground & Background)
          Container(
            width: 38,
            height: 48,
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Stack(
              children: [
                // Reset B/W icon (top left)
                Positioned(
                  left: 2,
                  top: 0,
                  child: InkWell(
                    onTap: onResetColors,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF9E9E9E), width: 0.8),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Container(color: Colors.black)),
                          Expanded(child: Container(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                // Swap curved arrow (top right)
                Positioned(
                  right: 4,
                  top: 0,
                  child: InkWell(
                    onTap: onSwapColors,
                    child: const Icon(Icons.sync_alt, size: 10, color: Color(0xFF9E9E9E)),
                  ),
                ),

                // Background Swatch (bottom right)
                Positioned(
                  right: 6,
                  bottom: 4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(color: const Color(0xFF555555), width: 1.5),
                    ),
                  ),
                ),

                // Foreground Swatch (top left, overlaps background swatch)
                Positioned(
                  left: 4,
                  bottom: 10,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: foregroundColor,
                      border: Border.all(color: const Color(0xFF555555), width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
