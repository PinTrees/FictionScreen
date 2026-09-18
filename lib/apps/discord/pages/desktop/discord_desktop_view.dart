import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/discord_model.dart';
import '../../widgets/discord_channel_sidebar.dart';
import '../../widgets/discord_members_sidebar.dart';
import '../../widgets/discord_message_tile.dart';
import '../../widgets/discord_server_sidebar.dart';

class DiscordDesktopView extends StatefulWidget {
  final DiscordConfig config;
  final ValueChanged<DiscordConfig>? onConfigChanged;
  final VoidCallback onEditStory;

  const DiscordDesktopView({
    super.key,
    required this.config,
    this.onConfigChanged,
    required this.onEditStory,
  });

  @override
  State<DiscordDesktopView> createState() => _DiscordDesktopViewState();
}

class _DiscordDesktopViewState extends State<DiscordDesktopView> {
  bool _showMembers = true;
  final TextEditingController _msgInputCtrl = TextEditingController();

  @override
  void dispose() {
    _msgInputCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgInputCtrl.text.trim();
    if (text.isEmpty) return;

    final newMsg = DiscordMessage(
      id: 'm-${DateTime.now().millisecondsSinceEpoch}',
      author: widget.config.currentUser,
      content: text,
      timestamp: '오늘 오후 ${_formatTime(DateTime.now())}',
    );

    final updatedMessages = [...widget.config.messages, newMsg];
    final updatedConfig = widget.config.copyWith(messages: updatedMessages);

    _msgInputCtrl.clear();
    widget.onConfigChanged?.call(updatedConfig);
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
      body: Row(
        children: [
          // Column 1: Servers Rail (72px)
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

          // Column 2: Channels Sidebar (240px)
          DiscordChannelSidebar(
            server: currentServer,
            selectedChannelId: widget.config.selectedChannelId,
            onSelectChannel: (chId) {
              widget.onConfigChanged?.call(widget.config.copyWith(selectedChannelId: chId));
            },
            currentUser: widget.config.currentUser,
            isVoiceConnected: widget.config.isVoiceConnected,
            connectedVoiceChannelName: widget.config.connectedVoiceChannelName,
            onToggleVoice: () {
              widget.onConfigChanged?.call(
                widget.config.copyWith(isVoiceConnected: !widget.config.isVoiceConnected),
              );
            },
            onOpenSettings: widget.onEditStory,
          ),

          // Column 3: Main Chat Feed
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                _buildChatHeader(currentChannel),

                // Messages Stream
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
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

                // Bottom Chat Input Bar
                _buildInputBar(currentChannel),
              ],
            ),
          ),

          // Column 4: Right Members Sidebar (240px)
          if (_showMembers) DiscordMembersSidebar(members: widget.config.members),
        ],
      ),
    );
  }

  Widget _buildChatHeader(DiscordChannel channel) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF313338),
        border: Border(bottom: BorderSide(color: Color(0xFF1F2023), width: 1.5)),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.number, color: Color(0xFF80848E), size: 18),
          const SizedBox(width: 8),
          Text(
            channel.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 16, color: const Color(0xFF4E5058)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '자유로운 개발 및 게임 토론 채널',
              style: TextStyle(color: Color(0xFF949BA4), fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Header Right Icons
          IconButton(
            icon: const Icon(CupertinoIcons.bell_fill, size: 16, color: Color(0xFFB5BAC1)),
            onPressed: () {},
            tooltip: '알림 설정',
            padding: const EdgeInsets.symmetric(horizontal: 6),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.pin_fill, size: 16, color: Color(0xFFB5BAC1)),
            onPressed: () {},
            tooltip: '고정된 메시지',
            padding: const EdgeInsets.symmetric(horizontal: 6),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            icon: Icon(
              _showMembers ? CupertinoIcons.person_2_fill : CupertinoIcons.person_2,
              size: 17,
              color: _showMembers ? Colors.white : const Color(0xFFB5BAC1),
            ),
            onPressed: () => setState(() => _showMembers = !_showMembers),
            tooltip: '멤버 목록 표시/숨기기',
            padding: const EdgeInsets.symmetric(horizontal: 6),
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 6),

          // Search Pill
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1F22),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              children: [
                Text('검색', style: TextStyle(color: Color(0xFF949BA4), fontSize: 11.5)),
                SizedBox(width: 24),
                Icon(CupertinoIcons.search, size: 12, color: Color(0xFF949BA4)),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Scenario Edit Action
          ElevatedButton.icon(
            onPressed: widget.onEditStory,
            icon: const Icon(CupertinoIcons.pencil, size: 12, color: Colors.white),
            label: const Text('시나리오 편집', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5865F2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(DiscordChannel channel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF383A40),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Left Add File Button
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
            const SizedBox(width: 12),

            // Input field
            Expanded(
              child: TextField(
                controller: _msgInputCtrl,
                style: const TextStyle(color: Color(0xFFDBDEE1), fontSize: 14),
                decoration: InputDecoration(
                  hintText: '#${channel.name}에 메시지 보내기',
                  hintStyle: const TextStyle(color: Color(0xFF6D6F78), fontSize: 13.5),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),

            // Right icons: Gift, GIF, Sticker, Emoji
            _buildInputIcon(CupertinoIcons.gift, () {}),
            _buildInputIcon(Icons.gif_box_outlined, () {}),
            _buildInputIcon(CupertinoIcons.smiley, () {}),
            IconButton(
              icon: const Icon(CupertinoIcons.paperplane_fill, size: 16, color: Color(0xFF5865F2)),
              onPressed: _sendMessage,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        child: Icon(icon, size: 18, color: const Color(0xFFB5BAC1)),
      ),
    );
  }
}
