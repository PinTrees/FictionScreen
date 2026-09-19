import 'package:flutter/material.dart';
import '../../widgets/win10_window_frame.dart';

/// Windows 10 순정 메모장 (Notepad) - 클래식 메뉴바, 상태표시줄, 직각 0px 디자인
class Win10NotepadWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const Win10NotepadWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 680,
    this.height = 460,
    this.isMaximized = false,
  });

  @override
  State<Win10NotepadWindow> createState() => _Win10NotepadWindowState();
}

class _Win10NotepadWindowState extends State<Win10NotepadWindow> {
  final TextEditingController _controller = TextEditingController(
    text: 'FictionScreen - Windows 10 순정 메모장\n\n'
        '1. 각진 0px 직각 모서리와 1px 전용 테두리 적용\n'
        '2. 상단 31px 풀-하이트 직사각형 캡션 버튼 (#E81123 닫기 호버)\n'
        '3. 클래식 메뉴 모음 및 하단 상태 표시줄 (줄 1, 열 1 | UTF-8)',
  );

  int _cursorLine = 1;
  int _cursorCol = 1;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateCursorPosition);
  }

  void _updateCursorPosition() {
    final text = _controller.text;
    final selection = _controller.selection;
    if (selection.baseOffset >= 0 && selection.baseOffset <= text.length) {
      final textBeforeCursor = text.substring(0, selection.baseOffset);
      final lines = textBeforeCursor.split('\n');
      setState(() {
        _cursorLine = lines.length;
        _cursorCol = lines.last.length + 1;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCursorPosition);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Win10WindowFrame(
      title: '제목 없음 - 메모장',
      iconAsset: 'assets/images/windows/notepad.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          // 1. Windows 10 클래식 메뉴 바 (파일, 편집, 서식, 보기, 도움말)
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: const Color(0xFF2B2B2B),
            child: Row(
              children: [
                _buildMenuItem('파일(F)'),
                _buildMenuItem('편집(E)'),
                _buildMenuItem('서식(O)'),
                _buildMenuItem('보기(V)'),
                _buildMenuItem('도움말(H)'),
              ],
            ),
          ),
          Container(height: 1, color: const Color(0xFF383838)),

          // 2. 텍스트 에디터 본문
          Expanded(
            child: Container(
              color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Consolas',
                  height: 1.5,
                ),
                cursorColor: const Color(0xFF0078D7),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          // 3. Windows 10 하단 상태 표시줄
          Container(
            height: 22,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF242424),
              border: Border(top: BorderSide(color: Color(0xFF333333))),
            ),
            child: Row(
              children: [
                const Spacer(),
                Text('줄 $_cursorLine, 열 $_cursorCol', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                _buildStatusDivider(),
                const Text('100%', style: TextStyle(color: Colors.white54, fontSize: 11)),
                _buildStatusDivider(),
                const Text('Windows (CRLF)', style: TextStyle(color: Colors.white54, fontSize: 11)),
                _buildStatusDivider(),
                const Text('UTF-8', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Segoe UI'),
        ),
      ),
    );
  }

  Widget _buildStatusDivider() {
    return Container(
      width: 1,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white24,
    );
  }
}
