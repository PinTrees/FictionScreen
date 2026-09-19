import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/telegram_model.dart';

/// 텔레그램 채널 및 메시지 실시간 편집 다이얼로그
class TelegramEditDialog extends StatefulWidget {
  final TelegramConfig config;
  final ValueChanged<TelegramConfig> onSave;

  const TelegramEditDialog({
    super.key,
    required this.config,
    required this.onSave,
  });

  @override
  State<TelegramEditDialog> createState() => _TelegramEditDialogState();
}

class _TelegramEditDialogState extends State<TelegramEditDialog> {
  late TelegramConfig _tempConfig;
  late TelegramChat _activeChat;

  late TextEditingController _titleCtrl;
  late TextEditingController _subtitleCtrl;
  late TextEditingController _newMsgCtrl;
  late TextEditingController _viewsCtrl;
  bool _newMsgIsMe = false;

  @override
  void initState() {
    super.initState();
    _tempConfig = widget.config.copyWith();
    _activeChat = _tempConfig.selectedChat;

    _titleCtrl = TextEditingController(text: _activeChat.title);
    _subtitleCtrl = TextEditingController(text: _activeChat.subtitle);
    _newMsgCtrl = TextEditingController();
    _viewsCtrl = TextEditingController(text: '120.5K');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _newMsgCtrl.dispose();
    _viewsCtrl.dispose();
    super.dispose();
  }

  void _applyChatChanges() {
    _activeChat.title = _titleCtrl.text.trim();
    _activeChat.subtitle = _subtitleCtrl.text.trim();
    widget.onSave(_tempConfig);
  }

  void _addNewMessage() {
    final text = _newMsgCtrl.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final newMsg = TelegramMessage(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      senderName: _newMsgIsMe ? '나' : _activeChat.title,
      isMe: _newMsgIsMe,
      text: text,
      time: timeStr,
      isChannelPost: _activeChat.isChannel,
      views: _activeChat.isChannel ? _viewsCtrl.text.trim() : null,
      reactions: [
        TelegramReaction(emoji: '🔥', count: 120),
        TelegramReaction(emoji: '🚀', count: 85),
      ],
    );

    setState(() {
      _activeChat.messages.add(newMsg);
      _newMsgCtrl.clear();
    });
    widget.onSave(_tempConfig);
  }

  void _deleteMessage(String id) {
    setState(() {
      _activeChat.messages.removeWhere((m) => m.id == id);
    });
    widget.onSave(_tempConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E222D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF333A4C)),
      ),
      child: Container(
        width: 620,
        constraints: const BoxConstraints(maxHeight: 640),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 다이얼로그 헤더
            Row(
              children: [
                const Icon(CupertinoIcons.paperplane_fill, color: Color(0xFF5288C1), size: 22),
                const SizedBox(width: 10),
                const Text(
                  '텔레그램 스토리 & 채널 편집기',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, size: 16, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  // 1. 프리셋 채널 전환
                  const Text('채팅방 / 채널 선택', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _tempConfig.chats.map((chat) {
                      final isSelected = chat.id == _activeChat.id;
                      return ChoiceChip(
                        label: Text(chat.title, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 11.5)),
                        selected: isSelected,
                        selectedColor: const Color(0xFF2B5278),
                        backgroundColor: const Color(0xFF151821),
                        onSelected: (sel) {
                          if (sel) {
                            setState(() {
                              _tempConfig.selectedChatId = chat.id;
                              _activeChat = chat;
                              _titleCtrl.text = chat.title;
                              _subtitleCtrl.text = chat.subtitle;
                            });
                            widget.onSave(_tempConfig);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 2. 활성 채널 정보 수정
                  const Text('채널 / 상대방 정보', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleCtrl,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          decoration: const InputDecoration(
                            labelText: '이름 / 채널명',
                            labelStyle: TextStyle(color: Colors.white60, fontSize: 11),
                            filled: true,
                            fillColor: Color(0xFF151821),
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _applyChatChanges(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _subtitleCtrl,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          decoration: const InputDecoration(
                            labelText: '구독자 수 / 온라인 상태',
                            labelStyle: TextStyle(color: Colors.white60, fontSize: 11),
                            filled: true,
                            fillColor: Color(0xFF151821),
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _applyChatChanges(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      FilterChip(
                        label: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.checkmark_seal_fill, size: 14, color: Color(0xFF5288C1)),
                            SizedBox(width: 4),
                            Text('블루 체크 인증 마크', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                        selected: _activeChat.isVerified,
                        selectedColor: const Color(0xFF2B5278),
                        backgroundColor: const Color(0xFF151821),
                        onSelected: (val) {
                          setState(() => _activeChat.isVerified = val);
                          _applyChatChanges();
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.pin_fill, size: 14, color: Colors.white70),
                            SizedBox(width: 4),
                            Text('상단 핀 고정', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                        selected: _activeChat.isPinned,
                        selectedColor: const Color(0xFF2B5278),
                        backgroundColor: const Color(0xFF151821),
                        onSelected: (val) {
                          setState(() => _activeChat.isPinned = val);
                          _applyChatChanges();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 3. 새 메시지 추가
                  const Text('새 메시지 추가', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _newMsgCtrl,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: '메시지 내용을 입력하세요...',
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                      filled: true,
                      fillColor: Color(0xFF151821),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('상대방/채널 메시지', style: TextStyle(fontSize: 11)),
                        selected: !_newMsgIsMe,
                        onSelected: (val) => setState(() => _newMsgIsMe = !val),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('내가 보낸 메시지', style: TextStyle(fontSize: 11)),
                        selected: _newMsgIsMe,
                        onSelected: (val) => setState(() => _newMsgIsMe = val),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5288C1),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(CupertinoIcons.plus, size: 14),
                        label: const Text('메시지 추가', style: TextStyle(fontSize: 11.5)),
                        onPressed: _addNewMessage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 4. 등록된 메시지 목록 관리
                  const Text('등록된 메시지 목록 (삭제/관리)', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _activeChat.messages.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 6),
                    itemBuilder: (context, idx) {
                      final m = _activeChat.messages[idx];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151821),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF282D3C)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: m.isMe ? const Color(0xFF2B5278) : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                m.isMe ? '나' : m.senderName,
                                style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                m.text,
                                style: const TextStyle(color: Colors.white, fontSize: 11.5),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(m.time, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(CupertinoIcons.trash, size: 14, color: Color(0xFFEF4444)),
                              onPressed: () => _deleteMessage(m.id),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5288C1),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('완료', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
