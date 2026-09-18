import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/instagram_model.dart';

class InstagramDmPage extends StatefulWidget {
  final InstagramConfig config;
  final VoidCallback onBack;

  const InstagramDmPage({
    super.key,
    required this.config,
    required this.onBack,
  });

  @override
  State<InstagramDmPage> createState() => _InstagramDmPageState();
}

class _InstagramDmPageState extends State<InstagramDmPage> {
  InstagramDmThread? _activeThread;
  final TextEditingController _msgController = TextEditingController();

  final List<Map<String, String>> _notes = [
    {'name': '내 노트', 'note': '메모 공유...', 'isMe': 'true', 'letter': 'S'},
    {'name': 'minji_film', 'note': '오늘도 화이팅 ✨', 'isMe': 'false', 'letter': '민'},
    {'name': 'photo_lover', 'note': '제주 노을 보러 옴 🌅', 'isMe': 'false', 'letter': 'P'},
    {'name': 'code_runner', 'note': '열일 코딩 중 💻', 'isMe': 'false', 'letter': 'C'},
  ];

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isNotEmpty && _activeThread != null) {
      setState(() {
        _activeThread!.messages.add(
          InstagramDmMessage(
            sender: widget.config.username,
            text: text,
            time: '방금',
            isMe: true,
          ),
        );
      });
      _msgController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_activeThread != null) {
      return _buildChatConversationView();
    }
    return _buildThreadListView();
  }

  Widget _buildThreadListView() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 0.8)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(CupertinoIcons.chevron_left, color: Colors.black87, size: 22),
                  onPressed: widget.onBack,
                ),
                Text(
                  widget.config.username,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
                ),
                const Icon(CupertinoIcons.chevron_down, size: 14, color: Colors.black87),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.square_pencil, color: Colors.black87, size: 22),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(CupertinoIcons.search, size: 16, color: Colors.black45),
                  SizedBox(width: 8),
                  Text('검색', style: TextStyle(color: Colors.black45, fontSize: 13)),
                ],
              ),
            ),
          ),

          // Notes Tray
          SizedBox(
            height: 105,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      // Speech Bubble
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          note['note']!,
                          style: const TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Avatar
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: note['isMe'] == 'true' ? const Color(0xFFF97316) : Colors.indigo.shade400,
                        child: Text(
                          note['letter']!,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        note['name']!,
                        style: const TextStyle(fontSize: 11, color: Colors.black87),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Messages / Requests header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('메시지', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('요청 (1)', style: TextStyle(color: Color(0xFF0095F6), fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // DM Threads List
          ...widget.config.dmThreads.map((thread) {
            return ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: thread.avatarBg,
                    child: Text(
                      thread.avatarLetter,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  if (thread.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(
                thread.username,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: Text(
                '${thread.lastMessage} · ${thread.timeAgo}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: thread.unreadCount > 0 ? Colors.black87 : Colors.black54,
                  fontWeight: thread.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: thread.unreadCount > 0
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0095F6),
                        shape: BoxShape.circle,
                      ),
                    )
                  : const Icon(CupertinoIcons.camera, size: 20, color: Colors.black45),
              onTap: () {
                setState(() {
                  _activeThread = thread;
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChatConversationView() {
    final thread = _activeThread!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 0.8)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(CupertinoIcons.chevron_left, color: Colors.black87, size: 22),
                  onPressed: () {
                    setState(() {
                      _activeThread = null;
                    });
                  },
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: thread.avatarBg,
                  child: Text(
                    thread.avatarLetter,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      thread.username,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      thread.isOnline ? '현재 활동 중' : '최근 활동',
                      style: const TextStyle(fontSize: 11, color: Colors.black45),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.phone, color: Colors.black87, size: 20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.videocam, color: Colors.black87, size: 24),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: thread.messages.length,
              itemBuilder: (context, index) {
                final msg = thread.messages[index];
                return Align(
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(
                      color: msg.isMe ? const Color(0xFF0095F6) : const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isMe ? Colors.white : Colors.black87,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Message input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 0.8)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0095F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(CupertinoIcons.camera_fill, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _msgController,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: '메시지 보내기...',
                        hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(CupertinoIcons.paperplane_fill, color: Color(0xFF0095F6), size: 22),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
