import 'package:flutter/material.dart';
import 'data/photoshop_model.dart';
import 'pages/desktop/photoshop_desktop_workspace.dart';
import 'pages/mobile/photoshop_mobile_workspace.dart';
import 'widgets/photoshop_edit_dialog.dart';

class PhotoshopScreen extends StatefulWidget {
  final PhotoshopConfig config;
  final ValueChanged<PhotoshopConfig>? onConfigChanged;

  const PhotoshopScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<PhotoshopScreen> createState() => _PhotoshopScreenState();
}

class _PhotoshopScreenState extends State<PhotoshopScreen> {
  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => PhotoshopEditDialog(
        config: widget.config,
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
          return PhotoshopDesktopWorkspace(
            config: widget.config,
            onConfigChanged: widget.onConfigChanged,
            onEditStory: _openEditDialog,
          );
        }

        return PhotoshopMobileWorkspace(
          config: widget.config,
          onConfigChanged: widget.onConfigChanged,
          onEditStory: _openEditDialog,
        );
      },
    );
  }
}
