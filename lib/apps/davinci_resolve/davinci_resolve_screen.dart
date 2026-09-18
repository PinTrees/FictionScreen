import 'package:flutter/material.dart';
import 'data/davinci_resolve_model.dart';
import 'pages/desktop/davinci_desktop_workspace.dart';
import 'pages/mobile/davinci_mobile_workspace.dart';
import 'widgets/davinci_edit_dialog.dart';

class DavinciResolveScreen extends StatefulWidget {
  final DavinciConfig config;
  final ValueChanged<DavinciConfig>? onConfigChanged;

  const DavinciResolveScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<DavinciResolveScreen> createState() => _DavinciResolveScreenState();
}

class _DavinciResolveScreenState extends State<DavinciResolveScreen> {
  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => DavinciResolveEditDialog(
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
          return DavinciDesktopWorkspace(
            config: widget.config,
            onConfigChanged: (cfg) => widget.onConfigChanged?.call(cfg),
            onOpenEditDialog: _openEditDialog,
          );
        }

        return DavinciMobileWorkspace(
          config: widget.config,
          onConfigChanged: (cfg) => widget.onConfigChanged?.call(cfg),
          onOpenEditDialog: _openEditDialog,
        );
      },
    );
  }
}
