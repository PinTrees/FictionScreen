import 'package:flutter/material.dart';
import 'data/chrome_model.dart';
import 'pages/desktop/chrome_desktop_workspace.dart';
import 'pages/mobile/chrome_mobile_workspace.dart';
import 'widgets/chrome_edit_dialog.dart';

class ChromeScreen extends StatefulWidget {
  final ChromeConfig config;
  final ValueChanged<ChromeConfig>? onConfigChanged;

  const ChromeScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<ChromeScreen> createState() => _ChromeScreenState();
}

class _ChromeScreenState extends State<ChromeScreen> {
  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ChromeEditDialog(
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
          return ChromeDesktopWorkspace(
            config: widget.config,
            onConfigChanged: (cfg) => widget.onConfigChanged?.call(cfg),
            onOpenEditDialog: _openEditDialog,
          );
        }

        return ChromeMobileWorkspace(
          config: widget.config,
          onConfigChanged: (cfg) => widget.onConfigChanged?.call(cfg),
          onOpenEditDialog: _openEditDialog,
        );
      },
    );
  }
}
