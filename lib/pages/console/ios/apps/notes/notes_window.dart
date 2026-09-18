import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 18 Notes (메모) 앱
class IosNotesWindow extends StatefulWidget {
  final VoidCallback onClose;

  const IosNotesWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<IosNotesWindow> createState() => _IosNotesWindowState();
}

class _IosNotesWindowState extends State<IosNotesWindow> {
  final List<Map<String, String>> _notes = [
    {'title': 'FictionScreen 아이디어', 'date': '오후 5:15', 'body': 'iOS 18 최신 스타일 기본 앱 완벽 지원'},
    {'title': '숏폼 영상 시나리오', 'date': '어제', 'body': '카카오톡 대화 애니메이션 스크린샷 컷 연출'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: widget.onClose,
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.chevron_left, color: Color(0xFFEAB308), size: 20),
                        SizedBox(width: 4),
                        Text('폴더', style: TextStyle(color: Color(0xFFEAB308), fontSize: 16)),
                      ],
                    ),
                  ),
                  const Text('메모', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Icon(CupertinoIcons.square_pencil, color: Color(0xFFEAB308), size: 22),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(note['date']!, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(note['body']!, style: const TextStyle(color: Colors.white54, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ],
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
