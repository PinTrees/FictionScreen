import 'package:flutter/material.dart';
import '../data/photoshop_model.dart';

class PhotoshopLayersPanel extends StatelessWidget {
  final List<PhotoshopLayer> layers;
  final String selectedLayerId;
  final ValueChanged<String> onSelectLayer;
  final ValueChanged<PhotoshopLayer> onToggleVisibility;
  final VoidCallback onAddLayer;
  final VoidCallback onDeleteLayer;

  const PhotoshopLayersPanel({
    super.key,
    required this.layers,
    required this.selectedLayerId,
    required this.onSelectLayer,
    required this.onToggleVisibility,
    required this.onAddLayer,
    required this.onDeleteLayer,
  });

  @override
  Widget build(BuildContext context) {
    final activeLayer = layers.firstWhere((l) => l.id == selectedLayerId, orElse: () => layers.first);

    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Color(0xFF282828),
        border: Border(left: BorderSide(color: Color(0xFF1E1E1E), width: 1)),
      ),
      child: Column(
        children: [
          // Panel Tabs: 레이어 / 채널 / 패스
          Container(
            height: 28,
            color: const Color(0xFF232323),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Row(
              children: [
                Text(
                  '레이어',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  '채널',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 11.5,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  '패스',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // Blend Mode & Opacity
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF1E1E1E))),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Blend Mode Dropdown
                    Expanded(
                      child: Container(
                        height: 22,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: const Color(0xFF454545)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              activeLayer.blendMode,
                              style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 11),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_drop_down, size: 12, color: Color(0xFF9E9E9E)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Opacity Badge
                    Container(
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: const Color(0xFF454545)),
                      ),
                      child: Row(
                        children: [
                          const Text('불투명도: ', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 10.5)),
                          Text(
                            '${(activeLayer.opacity * 100).round()}%',
                            style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Locks Row
                const Row(
                  children: [
                    Text('잠금: ', style: TextStyle(color: Color(0xFF888888), fontSize: 10.5)),
                    Icon(Icons.brush, size: 12, color: Color(0xFF888888)),
                    SizedBox(width: 6),
                    Icon(Icons.open_with, size: 12, color: Color(0xFF888888)),
                    SizedBox(width: 6),
                    Icon(Icons.crop_square, size: 12, color: Color(0xFF888888)),
                    SizedBox(width: 6),
                    Icon(Icons.lock, size: 12, color: Color(0xFF888888)),
                    Spacer(),
                    Text('칠: 100%', style: TextStyle(color: Color(0xFF888888), fontSize: 10.5)),
                  ],
                ),
              ],
            ),
          ),

          // Layers List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: layers.length,
              itemBuilder: (context, idx) {
                final layer = layers[idx];
                final isSelected = layer.id == selectedLayerId;

                return InkWell(
                  onTap: () => onSelectLayer(layer.id),
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF464646) : Colors.transparent,
                      border: Border(
                        bottom: const BorderSide(color: Color(0xFF1E1E1E), width: 0.5),
                        left: isSelected ? const BorderSide(color: Color(0xFF31A8FF), width: 2.5) : BorderSide.none,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Eye Icon (Visibility)
                        InkWell(
                          onTap: () => onToggleVisibility(layer),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              layer.isVisible ? Icons.visibility : Icons.visibility_off,
                              size: 15,
                              color: layer.isVisible ? const Color(0xFFD6D6D6) : const Color(0xFF555555),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Layer Thumbnail
                        Container(
                          width: 32,
                          height: 24,
                          decoration: BoxDecoration(
                            color: layer.color.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: const Color(0xFF555555), width: 0.8),
                          ),
                          child: Center(
                            child: layer.type == 'text'
                                ? const Text('T', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13))
                                : Icon(
                                    layer.type == 'shape' ? Icons.crop_square : Icons.image,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Layer Name
                        Expanded(
                          child: Text(
                            layer.name,
                            style: TextStyle(
                              color: layer.isVisible ? Colors.white : const Color(0xFF757575),
                              fontSize: 11.5,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Lock Indicator
                        if (layer.isLocked)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(Icons.lock, size: 12, color: Color(0xFF9E9E9E)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Action Bar: fx, mask, folder, new layer, trash
          Container(
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF232323),
              border: Border(top: BorderSide(color: Color(0xFF1E1E1E))),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionIcon('fx', () {}),
                _buildActionIcon('◫', () {}),
                _buildActionIcon('◐', () {}),
                _buildActionIcon('📁', () {}),
                InkWell(
                  onTap: onAddLayer,
                  child: const Icon(Icons.add_box_outlined, size: 15, color: Color(0xFFD6D6D6)),
                ),
                InkWell(
                  onTap: onDeleteLayer,
                  child: const Icon(Icons.delete_outline, size: 15, color: Color(0xFFD6D6D6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          label,
          style: const TextStyle(color: Color(0xFFB5B5B5), fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
