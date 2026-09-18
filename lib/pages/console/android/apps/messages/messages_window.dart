import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 메시지 앱
class SamsungMessagesWindow extends StatefulWidget {
  final VoidCallback onClose;

  const SamsungMessagesWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<SamsungMessagesWindow> createState() => _SamsungMessagesWindowState();
}

class _SamsungMessagesWindowState extends State<SamsungMessagesWindow> {
  final List<Map<String, dynamic>> _chats = [
    {
      'name': '김철수',
      'avatar': '김',
      'time': '오후 4:20',
      'preview': '오늘 오후 6시에 강남역에서 볼까?',
      'unread': 1,
    },
    {
      'name': 'FictionScreen 지원팀',
      'avatar': 'FS',
      'time': '어제',
      'preview': 'Samsung One UI 6.1 고해상도 디자인이 반영되었습니다.',
      'unread': 0,
    },
    {
      'name': '1588-0000 (국민카드)',
      'avatar': '💳',
      'time': '9월 15일',
      'preview': '[Web발신] 승인 12,500원 (일시불) 토스 체크카드',
      'unread': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 One UI 대형 헤더 영역
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF161822),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: widget.onClose,
                        child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 20),
                      ),
                      const Row(
                        children: [
                          Icon(CupertinoIcons.search, color: Colors.white70, size: 18),
                          SizedBox(width: 16),
                          Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white70, size: 18),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '메시지',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '읽지 않은 메시지 1개',
                    style: TextStyle(color: Color(0xFF60A5FA), fontSize: 12),
                  ),
                ],
              ),
            ),

            // 대화 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  final unread = chat['unread'] as int;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: unread > 0 ? const Color(0xFF3B82F6).withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFF3B82F6),
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
                                  Text(
                                    chat['name'] as String,
                                    style: TextStyle(
                                      color: unread > 0 ? Colors.white : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(chat['time'] as String, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                chat['preview'] as String,
                                style: TextStyle(color: unread > 0 ? Colors.white70 : Colors.white54, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
