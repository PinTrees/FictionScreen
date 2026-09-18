import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 18 Messages (iMessage) 앱
class IosMessagesWindow extends StatefulWidget {
  final VoidCallback onClose;

  const IosMessagesWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<IosMessagesWindow> createState() => _IosMessagesWindowState();
}

class _IosMessagesWindowState extends State<IosMessagesWindow> {
  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'FictionScreen 지원팀',
      'avatar': 'FS',
      'time': '오후 5:20',
      'preview': 'iOS 18 최신 에디션에 오신 것을 환영합니다!',
      'unread': 1,
    },
    {
      'name': '김철수',
      'avatar': '철수',
      'time': '어제',
      'preview': '오늘 저녁 약속 장소 어디야?',
      'unread': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // iOS Messages 타이틀 바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: widget.onClose,
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.chevron_left, color: Color(0xFF007AFF), size: 20),
                        SizedBox(width: 4),
                        Text('편집', style: TextStyle(color: Color(0xFF007AFF), fontSize: 16)),
                      ],
                    ),
                  ),
                  const Text('메시지', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Icon(CupertinoIcons.square_pencil, color: Color(0xFF007AFF), size: 22),
                ],
              ),
            ),

            // 메시지 대화 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  final unread = chat['unread'] as int;

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white12)),
                    ),
                    child: Row(
                      children: [
                        if (unread > 0)
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(color: Color(0xFF007AFF), shape: BoxShape.circle),
                          )
                        else
                          const SizedBox(width: 18),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF3A3A3C),
                          child: Text(chat['avatar'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(chat['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Text(chat['time'] as String, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(chat['preview'] as String, style: const TextStyle(color: Colors.white54, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
