import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/discord_model.dart';

class DiscordChannelSidebar extends StatelessWidget {
  final DiscordServer server;
  final String selectedChannelId;
  final ValueChanged<String> onSelectChannel;
  final DiscordUser currentUser;
  final bool isVoiceConnected;
  final String connectedVoiceChannelName;
  final VoidCallback onToggleVoice;
  final VoidCallback onOpenSettings;

  const DiscordChannelSidebar({
    super.key,
    required this.server,
    required this.selectedChannelId,
    required this.onSelectChannel,
    required this.currentUser,
    required this.isVoiceConnected,
    required this.connectedVoiceChannelName,
    required this.onToggleVoice,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final textChannels = server.channels.where((c) => c.type != DiscordChannelType.voice).toList();
    final voiceChannels = server.channels.where((c) => c.type == DiscordChannelType.voice).toList();

    return Container(
      width: 240,
      color: const Color(0xFF2B2D31),
      child: Column(
        children: [
          // Server Header Banner
          _buildServerHeader(),

          // Channel List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              children: [
                _buildCategoryHeader('텍스트 채널'),
                ...textChannels.map((c) => _buildChannelTile(c)),
                const SizedBox(height: 12),
                _buildCategoryHeader('음성 채널'),
                ...voiceChannels.map((c) => _buildChannelTile(c)),
              ],
            ),
          ),

          // Voice Connected Status Overlay
          if (isVoiceConnected) _buildVoiceStatusOverlay(),

          // Bottom Current User Profile Strip
          _buildCurrentUserBar(),
        ],
      ),
    );
  }

  Widget _buildServerHeader() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF2B2D31),
        border: Border(bottom: BorderSide(color: Color(0xFF1F2023), width: 1.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              server.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(CupertinoIcons.chevron_down, color: Color(0xFF949BA4), size: 14),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          const Icon(CupertinoIcons.chevron_down, size: 10, color: Color(0xFF949BA4)),
          const SizedBox(width: 4),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF949BA4),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelTile(DiscordChannel channel) {
    final isSelected = channel.id == selectedChannelId;
    final isVoice = channel.type == DiscordChannelType.voice;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isVoice) {
              onToggleVoice();
            }
            onSelectChannel(channel.id);
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF404249) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  isVoice ? CupertinoIcons.volume_down : CupertinoIcons.number,
                  size: 17,
                  color: isSelected ? Colors.white : const Color(0xFF80848E),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    channel.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF949BA4),
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (channel.hasMention)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF23F43),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${channel.unreadCount > 0 ? channel.unreadCount : 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceStatusOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF232428),
        border: Border(bottom: BorderSide(color: Color(0xFF1F2023), width: 1)),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.waveform, color: Color(0xFF23A55A), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '음성 연결됨',
                  style: TextStyle(color: Color(0xFF23A55A), fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
                Text(
                  connectedVoiceChannelName,
                  style: const TextStyle(color: Color(0xFF949BA4), fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.phone_down_fill, color: Color(0xFFF23F43), size: 16),
            onPressed: onToggleVoice,
            tooltip: '연결 끊기',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0xFF232428),
      child: Row(
        children: [
          // Avatar + Status dot
          Stack(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: currentUser.avatarColor,
                child: Text(
                  currentUser.name.isNotEmpty ? currentUser.name.characters.first : 'U',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF23A55A),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF232428), width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser.name,
                  style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '#${currentUser.tag}',
                  style: const TextStyle(color: Color(0xFF949BA4), fontSize: 10.5),
                ),
              ],
            ),
          ),
          // Action icons: Mic, Headset, Settings
          _buildUserActionIcon(CupertinoIcons.mic_fill, () {}),
          _buildUserActionIcon(CupertinoIcons.headphones, () {}),
          _buildUserActionIcon(CupertinoIcons.gear_alt_fill, onOpenSettings),
        ],
      ),
    );
  }

  Widget _buildUserActionIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4.5),
        child: Icon(icon, size: 16, color: const Color(0xFFB5BAC1)),
      ),
    );
  }
}
