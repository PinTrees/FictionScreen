import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// macOS Messages (iMessage) 창
class MessagesWindow extends StatefulWidget {
  final VoidCallback onClose;

  const MessagesWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<MessagesWindow> createState() => _MessagesWindowState();
}

class _MessagesWindowState extends State<MessagesWindow> {
  int _selectedChatIndex = 0;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'FictionScreen Team',
      'avatar': 'FS',
      'avatarColor': Color(0xFF6366F1),
      'time': '오후 5:30',
      'unread': 1,
      'messages': [
        {'isMe': false, 'text': '안녕하세요! FictionScreen 가상 OS 환경에 오신 것을 환영합니다.', 'time': '오후 5:20'},
        {'isMe': false, 'text': 'macOS Sequoia 에디션 기본 앱들이 모두 완벽하게 연동되었습니다.', 'time': '오후 5:25'},
        {'isMe': true, 'text': '디자인이 아주 정밀하네요! 감사합니다.', 'time': '오후 5:28'},
        {'isMe': false, 'text': '카카오톡, 인스타그램, 유튜브 템플릿도 언제든 에디터로 열람하실 수 있습니다.', 'time': '오후 5:30'},
      ],
    },
    {
      'name': 'Apple Support',
      'avatar': '',
      'avatarColor': Color(0xFF64748B),
      'time': '어제',
      'unread': 0,
      'messages': [
        {'isMe': false, 'text': 'Apple 계정 보안 확인: 새로운 macOS 기기에서 로그인이 감지되었습니다.', 'time': '어제'},
        {'isMe': true, 'text': '확인했습니다.', 'time': '어제'},
      ],
    },
    {
      'name': '김서연 (크리에이터)',
      'avatar': '서연',
      'avatarColor': Color(0xFFEC4899),
      'time': '화요일',
      'unread': 0,
      'messages': [
        {'isMe': false, 'text': '유튜브 썸네일이랑 캡처 화면 픽션스크린으로 너무 잘 쓰고 있어요!', 'time': '화요일'},
        {'isMe': true, 'text': '도움이 되어 기쁩니다 :)', 'time': '화요일'},
      ],
    },
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      final chat = _chats[_selectedChatIndex];
      (chat['messages'] as List).add({
        'isMe': true,
        'text': text,
        'time': '방금',
      });
      _textController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentChat = _chats[_selectedChatIndex];
    final messages = currentChat['messages'] as List;

    return OsWindowFrame(
      title: 'Messages',
      style: WindowStyle.macos,
      width: 760,
      height: 500,
      onClose: widget.onClose,
      child: Row(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 28,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(CupertinoIcons.search, size: 13, color: Colors.white38),
                              SizedBox(width: 6),
                              Text('검색', style: TextStyle(color: Colors.white38, fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(CupertinoIcons.square_pencil, size: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      final isSelected = _selectedChatIndex == index;
                      final lastMsg = (chat['messages'] as List).last['text'] as String;

                      return InkWell(
                        onTap: () => setState(() => _selectedChatIndex = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          color: isSelected ? const Color(0xFF3B82F6).withValues(alpha: 0.25) : Colors.transparent,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: chat['avatarColor'] as Color,
                                child: Text(
                                  chat['avatar'] as String,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          chat['name'] as String,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          chat['time'] as String,
                                          style: const TextStyle(color: Colors.white38, fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      lastMsg,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white70 : Colors.white54,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                  ),
                  child: Row(
                    children: [
                      Text(
                        currentChat['name'] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('iMessage', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      const Icon(CupertinoIcons.video_camera, size: 18, color: Colors.white70),
                      const SizedBox(width: 14),
                      const Icon(CupertinoIcons.phone, size: 16, color: Colors.white70),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final bool isMe = msg['isMe'] as bool;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isMe) ...[
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: currentChat['avatarColor'] as Color,
                                child: Text(
                                  currentChat['avatar'] as String,
                                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isMe ? const Color(0xFF007AFF) : const Color(0xFF3A3A3C),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  msg['text'] as String,
                                  style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.add_circled, size: 20, color: Colors.white54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _textController,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                  decoration: const InputDecoration(
                                    hintText: 'iMessage',
                                    hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (_) => _sendMessage(),
                                ),
                              ),
                              InkWell(
                                onTap: _sendMessage,
                                child: const Icon(CupertinoIcons.arrow_up_circle_fill, size: 22, color: Color(0xFF007AFF)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
