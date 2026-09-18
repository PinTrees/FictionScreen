import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// macOS Mail (메일) 창
class MailWindow extends StatefulWidget {
  final VoidCallback onClose;

  const MailWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<MailWindow> createState() => _MailWindowState();
}

class _MailWindowState extends State<MailWindow> {
  int _selectedMailIndex = 0;

  final List<Map<String, dynamic>> _emails = [
    {
      'sender': 'FictionScreen Team',
      'email': 'support@fiction-screen.web.app',
      'subject': 'FictionScreen 가상 OS 콘솔에 오신 것을 환영합니다',
      'date': '오늘 오후 4:30',
      'preview': '안녕하세요! FictionScreen 스튜디오를 이용해주셔서 진심으로 감사드립니다.',
      'body': '안녕하세요, 창작자님!\n\n'
          'FictionScreen은 숏폼, 웹소설, 유튜브 영상 제작자분들을 위한 현실적인 페이크 스크린 제작 스튜디오입니다.\n\n'
          '이번 업데이트를 통해 macOS Sequoia 환경의 모든 기본 앱들이 완벽하게 구현되었습니다.\n'
          '이제 실감나는 카카오톡, 인스타그램, 윈도우 블루스크린 화면을 자유롭게 연출해 보세요!\n\n'
          '감사합니다.\nFictionScreen 팀 드림',
    },
    {
      'sender': 'Apple Developer',
      'email': 'developer@apple.com',
      'subject': 'macOS Sequoia 에디션 라이브 릴리즈 안내',
      'date': '어제 오전 10:15',
      'preview': '새로운 macOS Sequoia 디자인 가이드라인이 반영된 가상 데스크톱 환경이 릴리즈되었습니다.',
      'body': '새로운 macOS Sequoia 디자인 가이드라인이 반영된 가상 데스크톱 환경이 릴리즈되었습니다.\n\n'
          '- 2K 고해상도 WebP 레티나 최적화 완료\n'
          '- 상단 글로벌 메뉴바 및 글래스모피즘 독 탑재\n'
          '- 실감나는 신호등 버튼 및 다크 테마 완벽 연동',
    },
    {
      'sender': 'YouTube Creators',
      'email': 'no-reply@youtube.com',
      'subject': '이번 달 채널 성과 및 신규 숏폼 템플릿 안내',
      'date': '9월 15일',
      'preview': '채널 조회수가 지난달 대비 140% 상승했습니다! 추천 템플릿을 확인해보세요.',
      'body': '축하합니다! 창작자님의 채널 조회수가 지난달 대비 140% 상승했습니다.\n\n'
          '몰입감 높은 스토리텔링을 위해 FictionScreen의 다양한 메신저 및 OS 화면 템플릿을 적극 활용해 보세요.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mail = _emails[_selectedMailIndex];

    return OsWindowFrame(
      title: 'Mail - 받은 편지함',
      style: WindowStyle.macos,
      width: 820,
      height: 520,
      onClose: widget.onClose,
      child: Column(
        children: [
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: const Row(
              children: [
                Icon(CupertinoIcons.reply, size: 16, color: Colors.white60),
                SizedBox(width: 14),
                Icon(CupertinoIcons.reply_all, size: 16, color: Colors.white38),
                SizedBox(width: 14),
                Icon(CupertinoIcons.arrowshape_turn_up_right, size: 16, color: Colors.white60),
                SizedBox(width: 16),
                Icon(CupertinoIcons.trash, size: 16, color: Colors.white60),
                SizedBox(width: 14),
                Icon(CupertinoIcons.flag, size: 16, color: Colors.white60),
                Spacer(),
                Icon(CupertinoIcons.square_pencil, size: 16, color: Color(0xFF38BDF8)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text('메일 상자', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      _buildMailboxItem(CupertinoIcons.tray_arrow_down_fill, '받은 편지함', count: 3, isSelected: true),
                      _buildMailboxItem(CupertinoIcons.flag_fill, '깃발 표시', count: 0),
                      _buildMailboxItem(CupertinoIcons.paperplane_fill, '보낸 편지함', count: 12),
                      _buildMailboxItem(CupertinoIcons.doc_fill, '임시 보관함', count: 1),
                      _buildMailboxItem(CupertinoIcons.trash_fill, '휴지통', count: 0),
                    ],
                  ),
                ),
                Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.01),
                    border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                  ),
                  child: ListView.builder(
                    itemCount: _emails.length,
                    itemBuilder: (context, index) {
                      final item = _emails[index];
                      final isSelected = _selectedMailIndex == index;

                      return InkWell(
                        onTap: () => setState(() => _selectedMailIndex = index),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF3B82F6).withValues(alpha: 0.25) : Colors.transparent,
                            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['sender'] as String,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    item['date'] as String,
                                    style: const TextStyle(color: Colors.white38, fontSize: 10),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item['subject'] as String,
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.87), fontSize: 11, fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item['preview'] as String,
                                style: const TextStyle(color: Colors.white54, fontSize: 10),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xFF161820),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFF3B82F6),
                              child: Text(
                                (mail['sender'] as String)[0],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(mail['sender'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text(mail['email'] as String, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                                ],
                              ),
                            ),
                            Text(mail['date'] as String, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          mail['subject'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Divider(color: Colors.white12, height: 28),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              mail['body'] as String,
                              style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
                            ),
                          ),
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
    );
  }

  Widget _buildMailboxItem(IconData icon, String title, {int count = 0, bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isSelected ? const Color(0xFF38BDF8) : Colors.white60),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 11))),
          if (count > 0)
            Text('$count', style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
