import 'package:flutter/material.dart';
import 'data/visual_studio_model.dart';
import 'pages/desktop/visual_studio_desktop_workspace.dart';
import 'pages/mobile/visual_studio_mobile_workspace.dart';
import 'widgets/visual_studio_edit_dialog.dart';

class VisualStudioScreen extends StatefulWidget {
  final VisualStudioConfig config;
  final ValueChanged<VisualStudioConfig>? onConfigChanged;

  const VisualStudioScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<VisualStudioScreen> createState() => _VisualStudioScreenState();
}

class _VisualStudioScreenState extends State<VisualStudioScreen> {
  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => VisualStudioEditDialog(
        initialConfig: widget.config,
        onSave: (updated) {
          widget.onConfigChanged?.call(updated);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 750;

        if (isDesktop) {
          return VisualStudioDesktopWorkspace(
            config: widget.config,
            onConfigChanged: (cfg) => widget.onConfigChanged?.call(cfg),
            onOpenEditorDialog: _openEditDialog,
          );
        }

        return VisualStudioMobileWorkspace(
          config: widget.config,
          onConfigChanged: (cfg) => widget.onConfigChanged?.call(cfg),
          onOpenEditorDialog: _openEditDialog,
        );
      },
    );
  }
}
