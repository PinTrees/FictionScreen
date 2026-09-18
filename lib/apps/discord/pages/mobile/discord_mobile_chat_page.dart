import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/discord_model.dart';
import '../../widgets/discord_channel_sidebar.dart';
import '../../widgets/discord_message_tile.dart';
import '../../widgets/discord_server_sidebar.dart';

class DiscordMobileChatPage extends StatefulWidget {
  final DiscordConfig config;
  final ValueChanged<DiscordConfig>? onConfigChanged;
  final VoidCallback onEditStory;

  const DiscordMobileChatPage({
    super.key,
    required this.config,
    this.onConfigChanged,
    required this.onEditStory,
  });

  @override
  State<DiscordMobileChatPage> createState() => _DiscordMobileChatPageState();
}

class _DiscordMobileChatPageState extends State<DiscordMobileChatPage> {
  final TextEditingController _textCtrl = TextEditingController();

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;

    final newMsg = DiscordMessage(
      id: 'm-${DateTime.now().millisecondsSinceEpoch}',
      author: widget.config.currentUser,
      content: text,
      timestamp: '오늘 오후 ${_formatTime(DateTime.now())}',
    );

    final updated = widget.config.copyWith(messages: [...widget.config.messages, newMsg]);
    _textCtrl.clear();
    widget.onConfigChanged?.call(updated);
  }

  void _handleToggleReaction(DiscordMessage message, String emoji) {
    final updatedReactions = message.reactions.map((r) {
      if (r.emoji == emoji) {
        final wasReacted = r.isReacted;
        return r.copyWith(
          isReacted: !wasReacted,
          count: wasReacted ? (r.count - 1).clamp(0, 9999) : r.count + 1,
        );
      }
      return r;
    }).toList();

    final updatedMsg = message.copyWith(reactions: updatedReactions);
    final updatedMessages = widget.config.messages.map((m) => m.id == message.id ? updatedMsg : m).toList();
    widget.onConfigChanged?.call(widget.config.copyWith(messages: updatedMessages));
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final currentServer = widget.config.servers.firstWhere(
      (s) => s.id == widget.config.selectedServerId,
      orElse: () => widget.config.servers.first,
    );
    final currentChannel = currentServer.channels.firstWhere(
      (c) => c.id == widget.config.selectedChannelId,
      orElse: () => currentServer.channels.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF313338),
      appBar: AppBar(
        backgroundColor: const Color(0xFF313338),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(CupertinoIcons.bars, color: Color(0xFFB5BAC1), size: 22),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            const Icon(CupertinoIcons.number, color: Color(0xFF80848E), size: 17),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                currentChannel.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search, color: Color(0xFFB5BAC1), size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.pencil_circle, color: Color(0xFF5865F2), size: 22),
            onPressed: widget.onEditStory,
            tooltip: '시나리오 편집',
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFF1F2023), height: 1),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Row(
          children: [
            // Left Server Rail
            DiscordServerSidebar(
              servers: widget.config.servers,
              selectedServerId: widget.config.selectedServerId,
              onSelectServer: (srvId) {
                final targetServer = widget.config.servers.firstWhere((s) => s.id == srvId);
                widget.onConfigChanged?.call(
                  widget.config.copyWith(
                    selectedServerId: srvId,
                    selectedChannelId: targetServer.channels.isNotEmpty ? targetServer.channels.first.id : '',
                  ),
                );
              },
              onHomeTap: () {},
            ),
            // Channels Sidebar
            Expanded(
              child: DiscordChannelSidebar(
                server: currentServer,
                selectedChannelId: widget.config.selectedChannelId,
                onSelectChannel: (chId) {
                  widget.onConfigChanged?.call(widget.config.copyWith(selectedChannelId: chId));
                  Navigator.of(context).pop();
                },
                currentUser: widget.config.currentUser,
                isVoiceConnected: widget.config.isVoiceConnected,
                connectedVoiceChannelName: widget.config.connectedVoiceChannelName,
                onToggleVoice: () {
                  widget.onConfigChanged?.call(
                    widget.config.copyWith(isVoiceConnected: !widget.config.isVoiceConnected),
                  );
                },
                onOpenSettings: () {
                  Navigator.of(context).pop();
                  widget.onEditStory();
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Message stream
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.config.messages.length,
              itemBuilder: (context, idx) {
                final msg = widget.config.messages[idx];
                return DiscordMessageTile(
                  message: msg,
                  onToggleReaction: (emoji) => _handleToggleReaction(msg, emoji),
                );
              },
            ),
          ),

          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF2B2D31),
            child: SafeArea(
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF383A40),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: widget.onEditStory,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4E5058),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(CupertinoIcons.add, color: Color(0xFFDBDEE1), size: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _textCtrl,
                        style: const TextStyle(color: Color(0xFFDBDEE1), fontSize: 13.5),
                        decoration: InputDecoration(
                          hintText: '#${currentChannel.name}에 메시지 보내기',
                          hintStyle: const TextStyle(color: Color(0xFF6D6F78), fontSize: 12.5),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    InkWell(
                      onTap: _sendMessage,
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(CupertinoIcons.paperplane_fill, color: Color(0xFF5865F2), size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
