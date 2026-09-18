import 'package:flutter/material.dart';
import '../../data/photoshop_model.dart';
import '../../widgets/photoshop_canvas_view.dart';
import '../../widgets/photoshop_layers_panel.dart';

class PhotoshopMobileWorkspace extends StatefulWidget {
  final PhotoshopConfig config;
  final ValueChanged<PhotoshopConfig>? onConfigChanged;
  final VoidCallback onEditStory;

  const PhotoshopMobileWorkspace({
    super.key,
    required this.config,
    this.onConfigChanged,
    required this.onEditStory,
  });

  @override
  State<PhotoshopMobileWorkspace> createState() => _PhotoshopMobileWorkspaceState();
}

class _PhotoshopMobileWorkspaceState extends State<PhotoshopMobileWorkspace> {
  bool _showLayersSheet = false;

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
    widget.onConfigChanged?.call(widget.config.copyWith(layers: updatedLayers, selectedLayerId: newId));
  }

  void _handleDeleteLayer() {
    if (widget.config.layers.length <= 1) return;
    final updatedLayers = widget.config.layers.where((l) => l.id != widget.config.selectedLayerId).toList();
    widget.onConfigChanged?.call(widget.config.copyWith(layers: updatedLayers, selectedLayerId: updatedLayers.first.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF282828),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF001E36),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF31A8FF), width: 1),
            ),
            child: const Center(
              child: Text(
                'Ps',
                style: TextStyle(color: Color(0xFF31A8FF), fontWeight: FontWeight.w900, fontSize: 13),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.config.documentTitle,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${widget.config.widthPx}x${widget.config.heightPx} px · ${widget.config.colorMode}',
              style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 10.5),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, size: 20, color: Color(0xFFD6D6D6)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.redo, size: 20, color: Color(0xFFD6D6D6)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20, color: Color(0xFF31A8FF)),
            onPressed: widget.onEditStory,
            tooltip: '시나리오 편집',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Center Canvas
          Positioned.fill(
            child: PhotoshopCanvasView(
              config: widget.config,
              onSelectLayer: _handleSelectLayer,
            ),
          ),

          // Sliding Layers Panel overlay (if toggled)
          if (_showLayersSheet)
            Positioned(
              right: 0,
              top: 0,
              bottom: 60,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10),
                  ],
                ),
                child: PhotoshopLayersPanel(
                  layers: widget.config.layers,
                  selectedLayerId: widget.config.selectedLayerId,
                  onSelectLayer: _handleSelectLayer,
                  onToggleVisibility: _handleToggleVisibility,
                  onAddLayer: _handleAddLayer,
                  onDeleteLayer: _handleDeleteLayer,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 56,
        color: const Color(0xFF282828),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMobileToolBtn(Icons.open_with, '이동', true, () {}),
            _buildMobileToolBtn(Icons.brush, '브러시', false, () {}),
            _buildMobileToolBtn(Icons.auto_fix_normal, '지우개', false, () {}),
            _buildMobileToolBtn(Icons.title, '문자', false, () {}),
            _buildMobileToolBtn(
              Icons.layers,
              '레이어',
              _showLayersSheet,
              () => setState(() => _showLayersSheet = !_showLayersSheet),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileToolBtn(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF31A8FF) : const Color(0xFFB5B5B5),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF31A8FF) : const Color(0xFF888888),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
