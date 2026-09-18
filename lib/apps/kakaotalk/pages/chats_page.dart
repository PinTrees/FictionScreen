import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/chat_list_item_model.dart';

class ChatsPage extends StatelessWidget {
  final List<KakaoChatListItem> chatList;
  final Function(KakaoChatListItem) onSelectChatRoom;

  const ChatsPage({
    super.key,
    required this.chatList,
    required this.onSelectChatRoom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 상단 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text('채팅', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
              const Spacer(),
              const Icon(CupertinoIcons.search, size: 20, color: Colors.black87),
              const SizedBox(width: 16),
              const Icon(CupertinoIcons.chat_bubble_text, size: 20, color: Colors.black87),
              const SizedBox(width: 16),
              const Icon(CupertinoIcons.gear, size: 20, color: Colors.black87),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              final chat = chatList[index];
              return _buildChatRow(chat);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatRow(KakaoChatListItem chat) {
    return GestureDetector(
      onTap: () => onSelectChatRoom(chat),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: chat.isGroup ? const Color(0xFFFEE500) : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  chat.roomTitle[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: chat.isGroup ? Colors.black : const Color(0xFF555555),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          chat.roomTitle,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.memberCount > 2) ...[
                        const SizedBox(width: 4),
                        Text('${chat.memberCount}', style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E))),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    chat.lastMessage,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat.lastTime, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                const SizedBox(height: 4),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
