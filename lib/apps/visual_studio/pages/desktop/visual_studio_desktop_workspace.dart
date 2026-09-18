import 'package:flutter/material.dart';
import '../../data/visual_studio_model.dart';
import '../../widgets/visual_studio_bottom_panel.dart';
import '../../widgets/visual_studio_code_editor.dart';
import '../../widgets/visual_studio_solution_explorer.dart';
import '../../widgets/visual_studio_status_bar.dart';
import '../../widgets/visual_studio_toolbar.dart';
import '../../widgets/visual_studio_top_menu.dart';

class VisualStudioDesktopWorkspace extends StatelessWidget {
  final VisualStudioConfig config;
  final ValueChanged<VisualStudioConfig> onConfigChanged;
  final VoidCallback onOpenEditorDialog;

  const VisualStudioDesktopWorkspace({
    super.key,
    required this.config,
    required this.onConfigChanged,
    required this.onOpenEditorDialog,
  });

  void _toggleDebug() {
    final newDebugging = !config.isDebugging;
    final updatedLines = config.codeLines.map((l) {
      return l.copyWith(
        isExecutionLine: newDebugging && l.lineNumber == config.breakpointLine,
      );
    }).toList();

    onConfigChanged(config.copyWith(
      isDebugging: newDebugging,
      codeLines: updatedLines,
    ));
  }

  void _toggleBreakpoint(int lineNumber) {
    final updatedLines = config.codeLines.map((l) {
      if (l.lineNumber == lineNumber) {
        final newBp = !l.hasBreakpoint;
        return l.copyWith(
          hasBreakpoint: newBp,
          isExecutionLine: config.isDebugging && newBp,
        );
      }
      return l;
    }).toList();

    onConfigChanged(config.copyWith(
      breakpointLine: lineNumber,
      codeLines: updatedLines,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          // 1. Top Menu & Title Bar
          VisualStudioTopMenu(
            solutionName: config.solutionName,
            onEditStory: onOpenEditorDialog,
          ),

          // 2. Main Toolbar
          VisualStudioToolbar(
            configuration: config.configuration,
            platform: config.platform,
            isDebugging: config.isDebugging,
            onToggleDebug: _toggleDebug,
            onConfigurationChanged: (cfg) => onConfigChanged(config.copyWith(configuration: cfg)),
            onPlatformChanged: (plat) => onConfigChanged(config.copyWith(platform: plat)),
          ),

          // 3. Central IDE Area (Code Editor + Bottom Panel + Solution Explorer)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Main Editor & Bottom Tool Window area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: VisualStudioCodeEditor(
                          config: config,
                          onToggleBreakpoint: _toggleBreakpoint,
                        ),
                      ),
                      VisualStudioBottomPanel(
                        outputs: config.outputMessages,
                        buildStatus: config.buildStatus,
                      ),
                    ],
                  ),
                ),

                // Classic Visual Studio Right Docked Solution Explorer
                VisualStudioSolutionExplorer(
                  items: config.solutionItems,
                  activeFileName: config.activeFileName,
                  onSelectFile: (fileName) {
                    onConfigChanged(config.copyWith(activeFileName: fileName));
                  },
                ),
              ],
            ),
          ),

          // 4. Purple/Orange Visual Studio Status Bar
          VisualStudioStatusBar(config: config),
        ],
      ),
    );
  }
}
