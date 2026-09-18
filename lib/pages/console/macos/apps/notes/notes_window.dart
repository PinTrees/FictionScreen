import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// macOS Notes (메모) 창
class NotesWindow extends StatefulWidget {
  final VoidCallback onClose;

  const NotesWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<NotesWindow> createState() => _NotesWindowState();
}

class _NotesWindowState extends State<NotesWindow> {
  int _selectedNoteIndex = 0;

  final List<Map<String, dynamic>> _notes = [
    {
      'title': 'FictionScreen 창작 아이디어',
      'date': '오늘 오후 5:15',
      'folder': 'Fiction Ideas',
      'content': '1. 가상 OS 콘솔에 macOS Sequoia 기본 앱 완벽 지원\n'
          '2. 카카오톡/인스타그램/유튜브 2K 고해상도 WebP 지원 완료\n'
          '3. 사용자 경험 극대화를 위한 부드러운 글래스모피즘 인터페이스 적용',
    },
    {
      'title': '숏폼 영상 스토리보드',
      'date': '어제 오후 2:40',
      'folder': 'Quick Notes',
      'content': '씬 1: 스마트폰에서 갑자기 울리는 카카오톡 알림 소리\n'
          '씬 2: 친구와의 대화 속 충격적인 반전 내용 공개\n'
          '씬 3: FictionScreen 워터마크 엔딩 컷 연출',
    },
    {
      'title': 'macOS 골든 게이트 테마 메모',
      'date': '9월 16일',
      'folder': 'All iCloud',
      'content': '골든 게이트 브리지의 석양 그라데이션과 딥 네이비 글래스 독이 완벽한 조화를 이룸.\n'
          '레티나 디스플레이 최적화 2K 해상도 렌더링 유지 필수.',
    },
  ];

  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: _notes[_selectedNoteIndex]['content']);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _selectNote(int index) {
    setState(() {
      _notes[_selectedNoteIndex]['content'] = _contentController.text;
      _selectedNoteIndex = index;
      _contentController.text = _notes[index]['content'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final note = _notes[_selectedNoteIndex];

    return OsWindowFrame(
      title: '메모 - ${note['title']}',
      style: WindowStyle.macos,
      width: 780,
      height: 500,
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
            child: Row(
              children: [
                const Icon(CupertinoIcons.sidebar_left, size: 16, color: Colors.white54),
                const SizedBox(width: 14),
                const Icon(CupertinoIcons.square_grid_2x2, size: 16, color: Colors.white54),
                const SizedBox(width: 14),
                const Icon(CupertinoIcons.trash, size: 16, color: Colors.white54),
                const Spacer(),
                Row(
                  children: [
                    _buildToolIcon(CupertinoIcons.checkmark_circle),
                    const SizedBox(width: 12),
                    _buildToolIcon(CupertinoIcons.table),
                    const SizedBox(width: 12),
                    _buildToolIcon(CupertinoIcons.textformat),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(CupertinoIcons.square_pencil, size: 15, color: Color(0xFFFBBF24)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final item = _notes[index];
                      final isSelected = _selectedNoteIndex == index;

                      return InkWell(
                        onTap: () => _selectNote(index),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFBBF24).withValues(alpha: 0.2) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFFBBF24).withValues(alpha: 0.5) : Colors.transparent,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                style: TextStyle(
                                  color: isSelected ? const Color(0xFFFCD34D) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    item['date'] as String,
                                    style: const TextStyle(color: Colors.white38, fontSize: 10),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      (item['content'] as String).replaceAll('\n', ' '),
                                      style: const TextStyle(color: Colors.white54, fontSize: 10),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
                    color: const Color(0xFF1E2028),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            note['date'] as String,
                            style: const TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          note['title'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        Expanded(
                          child: TextField(
                            controller: _contentController,
                            maxLines: null,
                            expands: true,
                            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
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

  Widget _buildToolIcon(IconData icon) {
    return Icon(icon, size: 16, color: Colors.white60);
  }
}
