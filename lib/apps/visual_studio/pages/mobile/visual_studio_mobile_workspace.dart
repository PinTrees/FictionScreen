import 'package:flutter/material.dart';
import '../../data/visual_studio_model.dart';
import '../../widgets/visual_studio_bottom_panel.dart';
import '../../widgets/visual_studio_code_editor.dart';
import '../../widgets/visual_studio_solution_explorer.dart';
import '../../widgets/visual_studio_status_bar.dart';

class VisualStudioMobileWorkspace extends StatefulWidget {
  final VisualStudioConfig config;
  final ValueChanged<VisualStudioConfig> onConfigChanged;
  final VoidCallback onOpenEditorDialog;

  const VisualStudioMobileWorkspace({
    super.key,
    required this.config,
    required this.onConfigChanged,
    required this.onOpenEditorDialog,
  });

  @override
  State<VisualStudioMobileWorkspace> createState() => _VisualStudioMobileWorkspaceState();
}

class _VisualStudioMobileWorkspaceState extends State<VisualStudioMobileWorkspace> {
  int _activeTab = 0; // 0: 코드, 1: 솔루션, 2: 출력

  void _toggleBreakpoint(int lineNumber) {
    final updatedLines = widget.config.codeLines.map((l) {
      if (l.lineNumber == lineNumber) {
        final newBp = !l.hasBreakpoint;
        return l.copyWith(
          hasBreakpoint: newBp,
          isExecutionLine: widget.config.isDebugging && newBp,
        );
      }
      return l;
    }).toList();

    widget.onConfigChanged(widget.config.copyWith(
      breakpointLine: lineNumber,
      codeLines: updatedLines,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D30),
        elevation: 0,
        toolbarHeight: 48,
        titleSpacing: 10,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF68217A),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                config.activeFileName,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              config.isDebugging ? Icons.stop : Icons.play_arrow,
              color: config.isDebugging ? Colors.redAccent : const Color(0xFF4EC9B0),
              size: 20,
            ),
            tooltip: config.isDebugging ? '디버깅 중지' : '디버깅 시작 (F5)',
            onPressed: () {
              final newDebugging = !config.isDebugging;
              final updatedLines = config.codeLines.map((l) {
                return l.copyWith(
                  isExecutionLine: newDebugging && l.lineNumber == config.breakpointLine,
                );
              }).toList();

              widget.onConfigChanged(config.copyWith(
                isDebugging: newDebugging,
                codeLines: updatedLines,
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_note, color: Color(0xFFC586C0), size: 20),
            tooltip: '시나리오 편집',
            onPressed: widget.onOpenEditorDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Sub tabs for mobile
          Container(
            height: 34,
            color: const Color(0xFF252526),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildTabButton(0, Icons.code, config.activeFileName),
                const SizedBox(width: 6),
                _buildTabButton(1, Icons.account_tree_outlined, '솔루션'),
                const SizedBox(width: 6),
                _buildTabButton(2, Icons.terminal, '출력/오류'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: IndexedStack(
              index: _activeTab,
              children: [
                VisualStudioCodeEditor(
                  config: config,
                  onToggleBreakpoint: _toggleBreakpoint,
                ),
                SizedBox.expand(
                  child: VisualStudioSolutionExplorer(
                    items: config.solutionItems,
                    activeFileName: config.activeFileName,
                    onSelectFile: (fileName) {
                      widget.onConfigChanged(config.copyWith(activeFileName: fileName));
                      setState(() => _activeTab = 0);
                    },
                  ),
                ),
                SizedBox.expand(
                  child: VisualStudioBottomPanel(
                    outputs: config.outputMessages,
                    buildStatus: config.buildStatus,
                  ),
                ),
              ],
            ),
          ),

          // Status bar
          VisualStudioStatusBar(config: config),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, IconData icon, String label) {
    final isSelected = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E1E1E) : Colors.transparent,
          border: Border(
            top: BorderSide(
              color: isSelected ? const Color(0xFF68217A) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : Colors.white60,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
