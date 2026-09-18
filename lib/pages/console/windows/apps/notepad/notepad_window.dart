import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// Windows 11 메모장 (Notepad)
class WindowsNotepadWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const WindowsNotepadWindow({
    super.key,
    required this.onClose,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 680,
    this.height = 460,
  });

  @override
  State<WindowsNotepadWindow> createState() => _WindowsNotepadWindowState();
}

class _WindowsNotepadWindowState extends State<WindowsNotepadWindow> {
  final TextEditingController _controller = TextEditingController(
    text: 'FictionScreen - Windows 11 스튜디오 메모장\n\n'
        '1. 카카오톡, 인스타그램, 토스, 유튜브, 블루스크린 템플릿 제작 가능\n'
        '2. MDI 창 드래그 및 리사이즈 지원\n'
        '3. 파이어스토어 사용자 환경 설정 자동 저장',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '제목 없음 - 메모장',
      icon: CupertinoIcons.doc_plaintext,
      style: WindowStyle.windows,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          // 메뉴바
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white.withValues(alpha: 0.04),
            child: const Row(
              children: [
                Text('파일', style: TextStyle(color: Colors.white70, fontSize: 11)),
                SizedBox(width: 14),
                Text('편집', style: TextStyle(color: Colors.white70, fontSize: 11)),
                SizedBox(width: 14),
                Text('보기', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          // 에디터
          Expanded(
            child: Container(
              color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
