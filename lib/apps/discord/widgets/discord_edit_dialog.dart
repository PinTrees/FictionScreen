import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/discord_model.dart';

class DiscordEditDialog extends StatefulWidget {
  final DiscordConfig config;
  final ValueChanged<DiscordConfig> onSave;

  const DiscordEditDialog({
    super.key,
    required this.config,
    required this.onSave,
  });

  @override
  State<DiscordEditDialog> createState() => _DiscordEditDialogState();
}

class _DiscordEditDialogState extends State<DiscordEditDialog> {
  late TextEditingController _serverNameCtrl;
  late TextEditingController _channelNameCtrl;
  late TextEditingController _userNameCtrl;
  late TextEditingController _userTagCtrl;
  late TextEditingController _userStatusTextCtrl;

  // New message fields
  final TextEditingController _msgAuthorCtrl = TextEditingController(text: 'FictionUser');
  final TextEditingController _msgContentCtrl = TextEditingController(text: '');
  bool _msgIsBot = false;
  Color _selectedRoleColor = const Color(0xFF00D26A);

  bool _isVoiceConnected = false;
  late TextEditingController _voiceChannelCtrl;

  final List<Color> _roleColors = [
    const Color(0xFFF1C40F), // Gold / Admin
    const Color(0xFF9B59B6), // Purple / Senior
    const Color(0xFF3498DB), // Blue / Mod
    const Color(0xFF2ECC71), // Green / Dev
    const Color(0xFFE91E63), // Pink
    const Color(0xFFE67E22), // Orange
    const Color(0xFFF2F3F5), // White / Default
  ];

  @override
  void initState() {
    super.initState();
    final cfg = widget.config;
    final currentServer = cfg.servers.firstWhere((s) => s.id == cfg.selectedServerId, orElse: () => cfg.servers.first);
    final currentChannel = currentServer.channels.firstWhere((c) => c.id == cfg.selectedChannelId, orElse: () => currentServer.channels.first);

    _serverNameCtrl = TextEditingController(text: currentServer.name);
    _channelNameCtrl = TextEditingController(text: currentChannel.name);
    _userNameCtrl = TextEditingController(text: cfg.currentUser.name);
    _userTagCtrl = TextEditingController(text: cfg.currentUser.tag);
    _userStatusTextCtrl = TextEditingController(text: cfg.currentUser.statusText ?? '');

    _isVoiceConnected = cfg.isVoiceConnected;
    _voiceChannelCtrl = TextEditingController(text: cfg.connectedVoiceChannelName);
  }

  @override
  void dispose() {
    _serverNameCtrl.dispose();
    _channelNameCtrl.dispose();
    _userNameCtrl.dispose();
    _userTagCtrl.dispose();
    _userStatusTextCtrl.dispose();
    _msgAuthorCtrl.dispose();
    _msgContentCtrl.dispose();
    _voiceChannelCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final cfg = widget.config;

    // Update server & channel name
    final updatedServers = cfg.servers.map((srv) {
      if (srv.id == cfg.selectedServerId) {
        final updatedChannels = srv.channels.map((ch) {
          if (ch.id == cfg.selectedChannelId) {
            return ch.copyWith(name: _channelNameCtrl.text.trim());
          }
          return ch;
        }).toList();
        return srv.copyWith(
          name: _serverNameCtrl.text.trim(),
          channels: updatedChannels,
        );
      }
      return srv;
    }).toList();

    // Update current user
    final updatedCurrentUser = cfg.currentUser.copyWith(
      name: _userNameCtrl.text.trim(),
      tag: _userTagCtrl.text.trim(),
      statusText: _userStatusTextCtrl.text.trim().isNotEmpty ? _userStatusTextCtrl.text.trim() : null,
    );

    // If new message entered, append it
    var updatedMessages = List<DiscordMessage>.from(cfg.messages);
    final newText = _msgContentCtrl.text.trim();
    if (newText.isNotEmpty) {
      final newAuthor = DiscordUser(
        id: 'u-${DateTime.now().millisecondsSinceEpoch}',
        name: _msgAuthorCtrl.text.trim().isNotEmpty ? _msgAuthorCtrl.text.trim() : '익명',
        roleColor: _selectedRoleColor,
        isBot: _msgIsBot,
        avatarColor: _selectedRoleColor,
      );
      final newMsg = DiscordMessage(
        id: 'm-${DateTime.now().millisecondsSinceEpoch}',
        author: newAuthor,
        content: newText,
        timestamp: '오늘 오후 ${_formatTime(DateTime.now())}',
      );
      updatedMessages.add(newMsg);
    }

    final updatedConfig = cfg.copyWith(
      servers: updatedServers,
      currentUser: updatedCurrentUser,
      messages: updatedMessages,
      isVoiceConnected: _isVoiceConnected,
      connectedVoiceChannelName: _voiceChannelCtrl.text.trim(),
    );

    widget.onSave(updatedConfig);
    Navigator.of(context).pop();
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF313338),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 520,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5865F2).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.game_controller_solid, size: 20, color: Color(0xFF5865F2)),
                ),
                const SizedBox(width: 10),
                const Text(
                  '디스코드 시나리오 편집',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, size: 18, color: Color(0xFF949BA4)),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('서버 및 채널 설정'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _serverNameCtrl,
                            label: '서버 이름',
                            hint: '서버명을 입력하세요',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _channelNameCtrl,
                            label: '현재 채널명',
                            hint: '일반-채팅',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildSectionHeader('내 프로필 설정'),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildTextField(
                            controller: _userNameCtrl,
                            label: '내 닉네임',
                            hint: 'FictionUser',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            controller: _userTagCtrl,
                            label: '태그 (#)',
                            hint: '1337',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _userStatusTextCtrl,
                      label: '상태 메시지 (Playing / 활동)',
                      hint: '리그 오브 레전드 플레이 중',
                    ),
                    const SizedBox(height: 16),

                    _buildSectionHeader('음성 채널 연결 상태'),
                    Row(
                      children: [
                        Switch(
                          value: _isVoiceConnected,
                          activeThumbColor: const Color(0xFF23A55A),
                          onChanged: (v) => setState(() => _isVoiceConnected = v),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            controller: _voiceChannelCtrl,
                            label: '연결된 음성 채널명',
                            hint: '회의실 1 (화면공유)',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildSectionHeader('새 메시지 추가 (채팅 전송 시뮬레이션)'),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildTextField(
                            controller: _msgAuthorCtrl,
                            label: '작성자 이름',
                            hint: 'DevMaster',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            const Text(
                              '봇(BOT)',
                              style: TextStyle(color: Color(0xFFB5BAC1), fontSize: 12),
                            ),
                            Checkbox(
                              value: _msgIsBot,
                              activeColor: const Color(0xFF5865F2),
                              onChanged: (v) => setState(() => _msgIsBot = v ?? false),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '역할 색상 선택',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF949BA4), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: _roleColors.map((c) {
                        final isSelected = _selectedRoleColor == c;
                        return InkWell(
                          onTap: () => setState(() => _selectedRoleColor = c),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _msgContentCtrl,
                      label: '메시지 내용',
                      hint: '전송할 메시지를 입력하세요 (@everyone 등 가능)',
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Footer Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(color: Color(0xFF949BA4))),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5865F2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('적용하기', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFFB5BAC1),
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF949BA4), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13, color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF6D6F78)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            isDense: true,
            filled: true,
            fillColor: const Color(0xFF1E1F22),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF3F4147)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF5865F2)),
            ),
          ),
        ),
      ],
    );
  }
}
