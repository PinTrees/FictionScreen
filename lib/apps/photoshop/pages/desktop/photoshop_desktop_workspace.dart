import 'package:flutter/material.dart';
import '../../data/photoshop_model.dart';
import '../../widgets/photoshop_canvas_view.dart';
import '../../widgets/photoshop_history_panel.dart';
import '../../widgets/photoshop_layers_panel.dart';
import '../../widgets/photoshop_tool_options_bar.dart';
import '../../widgets/photoshop_toolbar.dart';
import '../../widgets/photoshop_top_menu.dart';

class PhotoshopDesktopWorkspace extends StatefulWidget {
  final PhotoshopConfig config;
  final ValueChanged<PhotoshopConfig>? onConfigChanged;
  final VoidCallback onEditStory;

  const PhotoshopDesktopWorkspace({
    super.key,
    required this.config,
    this.onConfigChanged,
    required this.onEditStory,
  });

  @override
  State<PhotoshopDesktopWorkspace> createState() => _PhotoshopDesktopWorkspaceState();
}

class _PhotoshopDesktopWorkspaceState extends State<PhotoshopDesktopWorkspace> {
  void _handleToolSelected(PhotoshopTool tool) {
    widget.onConfigChanged?.call(widget.config.copyWith(selectedTool: tool));
  }

  void _handleSelectLayer(String layerId) {
    widget.onConfigChanged?.call(widget.config.copyWith(selectedLayerId: layerId));
  }

  void _handleToggleVisibility(PhotoshopLayer layer) {
    final updatedLayers = widget.config.layers.map((l) {
      if (l.id == layer.id) {
        return l.copyWith(isVisible: !l.isVisible);
      }
      return l;
    }).toList();
    widget.onConfigChanged?.call(widget.config.copyWith(layers: updatedLayers));
  }

  void _handleAddLayer() {
    final newId = 'layer-${DateTime.now().millisecondsSinceEpoch}';
    final newLayer = PhotoshopLayer(
      id: newId,
      name: '새 레이어 ${widget.config.layers.length + 1}',
      type: 'pixel',
      color: widget.config.foregroundColor,
    );
    final updatedLayers = [newLayer, ...widget.config.layers];
    final updatedHistory = [
      ...widget.config.history,
      const PhotoshopHistoryItem(id: 'h-new', name: '새 레이어', icon: Icons.layers),
    ];
    widget.onConfigChanged?.call(
      widget.config.copyWith(layers: updatedLayers, selectedLayerId: newId, history: updatedHistory),
    );
  }

  void _handleDeleteLayer() {
    if (widget.config.layers.length <= 1) return;
    final updatedLayers = widget.config.layers.where((l) => l.id != widget.config.selectedLayerId).toList();
    final nextId = updatedLayers.first.id;
    widget.onConfigChanged?.call(
      widget.config.copyWith(layers: updatedLayers, selectedLayerId: nextId),
    );
  }

  void _handleSwapColors() {
    widget.onConfigChanged?.call(
      widget.config.copyWith(
        foregroundColor: widget.config.backgroundColor,
        backgroundColor: widget.config.foregroundColor,
      ),
    );
  }

  void _handleResetColors() {
    widget.onConfigChanged?.call(
      widget.config.copyWith(
        foregroundColor: const Color(0xFF000000),
        backgroundColor: const Color(0xFFFFFFFF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Column(
        children: [
          // 1. Top Menu & Document Tab
          PhotoshopTopMenu(
            documentTitle: widget.config.documentTitle,
            zoomPercent: widget.config.zoomPercent,
            colorMode: widget.config.colorMode,
            onEditStory: widget.onEditStory,
          ),

          // 2. Tool Options Bar
          PhotoshopToolOptionsBar(
            selectedTool: widget.config.selectedTool,
            brushSize: widget.config.brushSize,
            brushOpacity: widget.config.brushOpacity,
          ),

          // 3. Main Workspace Row (Toolbar | Canvas | Right Panels)
          Expanded(
            child: Row(
              children: [
                // Left Vertical Tools
                PhotoshopToolbar(
                  selectedTool: widget.config.selectedTool,
                  onSelectTool: _handleToolSelected,
                  foregroundColor: widget.config.foregroundColor,
                  backgroundColor: widget.config.backgroundColor,
                  onSwapColors: _handleSwapColors,
                  onResetColors: _handleResetColors,
                ),

                // Center Canvas & Rulers
                Expanded(
                  child: PhotoshopCanvasView(
                    config: widget.config,
                    onSelectLayer: _handleSelectLayer,
                  ),
                ),

                // Right Panels (History + Layers)
                Column(
                  children: [
                    PhotoshopHistoryPanel(history: widget.config.history),
                    Expanded(
                      child: PhotoshopLayersPanel(
                        layers: widget.config.layers,
                        selectedLayerId: widget.config.selectedLayerId,
                        onSelectLayer: _handleSelectLayer,
                        onToggleVisibility: _handleToggleVisibility,
                        onAddLayer: _handleAddLayer,
                        onDeleteLayer: _handleDeleteLayer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Bottom Status Bar (22px)
          _buildBottomStatusBar(),
        ],
      ),
    );
  }

  Widget _buildBottomStatusBar() {
    return Container(
      height: 22,
      color: const Color(0xFF282828),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(
            '${widget.config.zoomPercent}%',
            style: const TextStyle(color: Color(0xFFB5B5B5), fontSize: 10.5),
          ),
          const SizedBox(width: 14),
          Text(
            '문서: 5.24M / 18.2M',
            style: const TextStyle(color: Color(0xFFB5B5B5), fontSize: 10.5),
          ),
          const SizedBox(width: 14),
          Text(
            '치수: ${widget.config.widthPx} x ${widget.config.heightPx} px (300 ppi)',
            style: const TextStyle(color: Color(0xFFB5B5B5), fontSize: 10.5),
          ),
          const Spacer(),
          const Text(
            '선택된 레이어: ',
            style: TextStyle(color: Color(0xFF888888), fontSize: 10.5),
          ),
          Text(
            widget.config.layers.firstWhere((l) => l.id == widget.config.selectedLayerId, orElse: () => widget.config.layers.first).name,
            style: const TextStyle(color: Color(0xFF31A8FF), fontSize: 10.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
