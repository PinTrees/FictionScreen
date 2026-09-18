import 'package:flutter/material.dart';
import '../../data/davinci_resolve_model.dart';
import '../../widgets/davinci_color_wheels.dart';
import '../../widgets/davinci_node_graph.dart';
import '../../widgets/davinci_page_bar.dart';
import '../../widgets/davinci_scopes.dart';
import '../../widgets/davinci_timeline.dart';
import '../../widgets/davinci_top_menu.dart';
import '../../widgets/davinci_viewer.dart';

class DavinciDesktopWorkspace extends StatelessWidget {
  final DavinciConfig config;
  final ValueChanged<DavinciConfig> onConfigChanged;
  final VoidCallback onOpenEditDialog;

  const DavinciDesktopWorkspace({
    super.key,
    required this.config,
    required this.onConfigChanged,
    required this.onOpenEditDialog,
  });

  void _togglePlay() {
    onConfigChanged(config.copyWith(isPlaying: !config.isPlaying));
  }

  void _selectPage(DavinciPage page) {
    onConfigChanged(config.copyWith(activePage: page));
  }

  void _toggleBypassNode(int nodeId) {
    final updatedNodes = config.nodes.map((n) {
      if (n.id == nodeId) {
        return n.copyWith(isBypassed: !n.isBypassed);
      }
      return n;
    }).toList();
    onConfigChanged(config.copyWith(nodes: updatedNodes));
  }

  void _selectNode(int nodeId) {
    final updatedNodes = config.nodes.map((n) {
      return n.copyWith(isSelected: n.id == nodeId);
    }).toList();
    onConfigChanged(config.copyWith(nodes: updatedNodes));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF141416),
      child: Column(
        children: [
          // 1. Top Bar & Menu
          DavinciTopMenu(
            projectName: config.projectName,
            resolution: config.resolution,
            onEditStory: onOpenEditDialog,
          ),

          // 2. Central Workspace depending on active Page
          Expanded(
            child: _buildPageBody(),
          ),

          // 3. Bottom 7-Page Switcher Bar
          DavinciPageBar(
            activePage: config.activePage,
            onSelectPage: _selectPage,
          ),
        ],
      ),
    );
  }

  Widget _buildPageBody() {
    switch (config.activePage) {
      case DavinciPage.color:
        return _buildColorPage();
      case DavinciPage.edit:
      case DavinciPage.cut:
        return _buildEditPage();
      case DavinciPage.deliver:
        return _buildDeliverPage();
      case DavinciPage.media:
      case DavinciPage.fusion:
      case DavinciPage.fairlight:
        return _buildGenericProPage();
    }
  }

  Widget _buildColorPage() {
    return Column(
      children: [
        // Upper row: Viewer (40%) + Node Graph (35%) + RGB Scopes (25%)
        Expanded(
          flex: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: DavinciViewer(config: config, onTogglePlay: _togglePlay),
              ),
              Container(width: 1, color: const Color(0xFF28282C)),
              Expanded(
                flex: 4,
                child: DavinciNodeGraph(
                  nodes: config.nodes,
                  onToggleBypass: _toggleBypassNode,
                  onSelectNode: _selectNode,
                ),
              ),
              Container(width: 1, color: const Color(0xFF28282C)),
              const Expanded(
                flex: 3,
                child: DavinciScopes(),
              ),
            ],
          ),
        ),
        Container(height: 1, color: const Color(0xFF28282C)),

        // Lower row: Interactive Primaries Color Wheels
        Expanded(
          flex: 4,
          child: DavinciColorWheels(
            values: config.colorValues,
            onChanged: (newVals) => onConfigChanged(config.copyWith(colorValues: newVals)),
          ),
        ),
      ],
    );
  }

  Widget _buildEditPage() {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: DavinciViewer(config: config, onTogglePlay: _togglePlay),
        ),
        Container(height: 1, color: const Color(0xFF28282C)),
        Expanded(
          flex: 4,
          child: DavinciTimeline(
            tracks: config.tracks,
            activeTimecode: config.activeTimecode,
            isPlaying: config.isPlaying,
            onTogglePlay: _togglePlay,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliverPage() {
    return Container(
      color: const Color(0xFF1B1B1E),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Render Settings Card
          Container(
            width: 320,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141416),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF28282C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Render Settings', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _renderOption('Preset', 'YouTube 2160p 4K Ultra HD'),
                _renderOption('Format', 'QuickTime / MP4'),
                _renderOption('Video Codec', 'H.265 Main 10 (HEVC)'),
                _renderOption('Resolution', config.resolution),
                _renderOption('Frame Rate', '24.000 fps'),
                _renderOption('Quality', 'Automatic (Best)'),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.queue_play_next, size: 16),
                    label: const Text('Add to Render Queue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Render Queue Job Status
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF141416),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF28282C)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Render Queue (렌더링 대기열)', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  const Divider(color: Color(0xFF28282C), height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1B1E),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF3F3F46)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.video_file, color: Color(0xFFE53935), size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${config.projectName}_FinalMaster_4K.mov', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('${config.resolution} · ${config.renderStatus}', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: const Color(0xFF4CAF50).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                          child: const Text('Ready (준비 완료)', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericProPage() {
    return Container(
      color: const Color(0xFF141416),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(config.activePage.icon, size: 48, color: const Color(0xFFE53935)),
            const SizedBox(height: 12),
            Text(
              'DaVinci Resolve Studio - ${config.activePage.label} Workspace',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '${config.activePage.label} 전용 고성능 전문 엔진이 활성화되었습니다.',
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderOption(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11.5)),
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
