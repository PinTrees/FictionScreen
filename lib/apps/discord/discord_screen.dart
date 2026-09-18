import 'package:flutter/material.dart';
import 'data/discord_model.dart';
import 'pages/desktop/discord_desktop_view.dart';
import 'pages/mobile/discord_mobile_chat_page.dart';
import 'widgets/discord_edit_dialog.dart';

class DiscordScreen extends StatefulWidget {
  final DiscordConfig config;
  final ValueChanged<DiscordConfig>? onConfigChanged;

  const DiscordScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<DiscordScreen> createState() => _DiscordScreenState();
}

class _DiscordScreenState extends State<DiscordScreen> {
  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => DiscordEditDialog(
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
          return DiscordDesktopView(
            config: widget.config,
            onConfigChanged: widget.onConfigChanged,
            onEditStory: _openEditDialog,
          );
        }

        return DiscordMobileChatPage(
          config: widget.config,
          onConfigChanged: widget.onConfigChanged,
          onEditStory: _openEditDialog,
        );
      },
    );
  }
}
