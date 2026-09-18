import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win11_window_frame.dart';

/// Windows 11 순정 메모장 (Notepad) 창
class Win11NotepadWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const Win11NotepadWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 720,
    this.height = 480,
  });

  @override
  State<Win11NotepadWindow> createState() => _Win11NotepadWindowState();
}

class _Win11NotepadWindowState extends State<Win11NotepadWindow> {
  late TextEditingController _textController;
  int _activeTabIndex = 0;
  final List<String> _tabs = ['제목 없음.txt'];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: 'Windows 11 메모장에 오신 것을 환영합니다.\n\n'
          '이 화면은 크리에이터 상황극, 유튜브 쇼츠, 웹툰 작화용으로\n'
          '자유롭게 텍스트를 작성하고 캡처할 수 있는 순정 모의 화면입니다.\n\n'
          '- 단축키: Ctrl + S (저장), Ctrl + Z (실행 취소)\n'
          '- UTF-8 / Windows (CRLF) 인코딩 지원\n',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Win11WindowFrame(
      title: '메모장',
      iconAsset: 'assets/images/windows/notepad.png',
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      customTitleWidget: Row(
        children: [
          const SizedBox(width: 8),
          ..._tabs.asMap().entries.map((entry) {
            final idx = entry.key;
            final tabTitle = entry.value;
            final isSelected = _activeTabIndex == idx;
            return InkWell(
              onTap: () => setState(() => _activeTabIndex = idx),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF282B35) : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/windows/notepad.png', width: 14, height: 14),
                    const SizedBox(width: 6),
                    Text(
                      tabTitle,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white60,
                        fontSize: 11.5,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (_tabs.length > 1) {
                          setState(() {
                            _tabs.removeAt(idx);
                            if (_activeTabIndex >= _tabs.length) {
                              _activeTabIndex = _tabs.length - 1;
                            }
                          });
                        }
                      },
                      child: const Icon(CupertinoIcons.xmark, size: 9, color: Colors.white38),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(width: 4),
          InkWell(
            onTap: () => setState(() => _tabs.add('새 텍스트 문서 (${_tabs.length + 1}).txt')),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              child: const Icon(CupertinoIcons.plus, size: 12, color: Colors.white70),
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          // 메뉴 바 (파일, 편집, 보기)
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: Row(
              children: [
                _buildMenuItem('파일'),
                _buildMenuItem('편집'),
                _buildMenuItem('보기'),
                const Spacer(),
                const Icon(CupertinoIcons.gear, size: 13, color: Colors.white54),
              ],
            ),
          ),

          // 텍스트 에디터 본문
          Expanded(
            child: Container(
              color: const Color(0xFF1B1D24),
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          // 하단 상태 표시줄
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: const Row(
              children: [
                Text('Ln 1, Col 1', style: TextStyle(color: Colors.white38, fontSize: 11)),
                SizedBox(width: 16),
                Text('100%', style: TextStyle(color: Colors.white38, fontSize: 11)),
                SizedBox(width: 16),
                Text('Windows (CRLF)', style: TextStyle(color: Colors.white38, fontSize: 11)),
                SizedBox(width: 16),
                Text('UTF-8', style: TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 11.5),
      ),
    );
  }
}
