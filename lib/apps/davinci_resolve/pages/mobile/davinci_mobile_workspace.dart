import 'package:flutter/material.dart';
import '../../data/davinci_resolve_model.dart';
import '../../widgets/davinci_color_wheels.dart';
import '../../widgets/davinci_node_graph.dart';
import '../../widgets/davinci_page_bar.dart';
import '../../widgets/davinci_timeline.dart';
import '../../widgets/davinci_viewer.dart';

class DavinciMobileWorkspace extends StatefulWidget {
  final DavinciConfig config;
  final ValueChanged<DavinciConfig> onConfigChanged;
  final VoidCallback onOpenEditDialog;

  const DavinciMobileWorkspace({
    super.key,
    required this.config,
    required this.onConfigChanged,
    required this.onOpenEditDialog,
  });

  @override
  State<DavinciMobileWorkspace> createState() => _DavinciMobileWorkspaceState();
}

class _DavinciMobileWorkspaceState extends State<DavinciMobileWorkspace> {
  int _mobileSubTab = 0; // 0: Wheels, 1: Nodes, 2: Timeline

  void _togglePlay() {
    widget.onConfigChanged(widget.config.copyWith(isPlaying: !widget.config.isPlaying));
  }

  void _selectPage(DavinciPage page) {
    widget.onConfigChanged(widget.config.copyWith(activePage: page));
  }

  void _toggleBypassNode(int nodeId) {
    final updatedNodes = widget.config.nodes.map((n) {
      if (n.id == nodeId) {
        return n.copyWith(isBypassed: !n.isBypassed);
      }
      return n;
    }).toList();
    widget.onConfigChanged(widget.config.copyWith(nodes: updatedNodes));
  }

  void _selectNode(int nodeId) {
    final updatedNodes = widget.config.nodes.map((n) {
      return n.copyWith(isSelected: n.id == nodeId);
    }).toList();
    widget.onConfigChanged(widget.config.copyWith(nodes: updatedNodes));
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return Scaffold(
      backgroundColor: const Color(0xFF141416),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1B1E),
        elevation: 0,
        toolbarHeight: 46,
        titleSpacing: 10,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0xFFE53935)),
              ),
              child: const Text('RESOLVE', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                config.projectName,
                style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFFFF8A80), size: 18),
            onPressed: widget.onOpenEditDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Viewer Monitor
          SizedBox(
            height: 200,
            child: DavinciViewer(config: config, onTogglePlay: _togglePlay),
          ),

          // 2. Mobile Sub Tab Switcher
          Container(
            height: 32,
            color: const Color(0xFF1B1B1E),
            child: Row(
              children: [
                _subTabButton(0, Icons.palette, '컬러 휠'),
                _subTabButton(1, Icons.hub, '노드 그래프'),
                _subTabButton(2, Icons.movie_creation_outlined, '타임라인'),
              ],
            ),
          ),

          // 3. Sub tab content
          Expanded(
            child: IndexedStack(
              index: _mobileSubTab,
              children: [
                DavinciColorWheels(
                  values: config.colorValues,
                  onChanged: (newVals) => widget.onConfigChanged(config.copyWith(colorValues: newVals)),
                ),
                DavinciNodeGraph(
                  nodes: config.nodes,
                  onToggleBypass: _toggleBypassNode,
                  onSelectNode: _selectNode,
                ),
                DavinciTimeline(
                  tracks: config.tracks,
                  activeTimecode: config.activeTimecode,
                  isPlaying: config.isPlaying,
                  onTogglePlay: _togglePlay,
                ),
              ],
            ),
          ),

          // 4. Bottom 7-Page Switcher
          DavinciPageBar(
            activePage: config.activePage,
            onSelectPage: _selectPage,
          ),
        ],
      ),
    );
  }

  Widget _subTabButton(int index, IconData icon, String label) {
    final isSelected = _mobileSubTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _mobileSubTab = index),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFFE53935) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: isSelected ? Colors.white : Colors.white54),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
