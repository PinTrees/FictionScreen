import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../common/os_window_frame.dart';

/// Windows 명령 프롬프트 (cmd / PowerShell)
class WindowsCmdWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const WindowsCmdWindow({
    super.key,
    required this.onClose,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 680,
    this.height = 440,
  });

  @override
  State<WindowsCmdWindow> createState() => _WindowsCmdWindowState();
}

class _WindowsCmdWindowState extends State<WindowsCmdWindow> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _history = [
    'Microsoft Windows [Version 10.0.22631.3007]',
    '(c) Microsoft Corporation. All rights reserved.',
    '',
    'C:\\Users\\FictionCreator> help',
    'Available commands: dir, cls, echo, ver, help',
    '',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmit(String cmd) {
    final text = cmd.trim();
    if (text.isEmpty) return;

    setState(() {
      _history.add('C:\\Users\\FictionCreator> $text');
      if (text.toLowerCase() == 'cls') {
        _history.clear();
      } else if (text.toLowerCase() == 'dir') {
        _history.add(' Directory of C:\\Users\\FictionCreator\n\n09/18/2024  05:30 PM    <DIR>          Desktop\n09/18/2024  05:30 PM    <DIR>          Documents\n09/18/2024  05:30 PM    <DIR>          Downloads');
      } else if (text.toLowerCase() == 'ver') {
        _history.add('Microsoft Windows [Version 10.0.22631.3007]');
      } else {
        _history.add("'$text'은(는) 내부 또는 외부 명령, 실행할 수 있는 프로그램, 또는 배치 파일이 아닙니다.");
      }
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '명령 프롬프트',
      icon: CupertinoIcons.terminal,
      style: WindowStyle.windows,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return Text(_history[index], style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12));
                },
              ),
            ),
            Row(
              children: [
                const Text('C:\\Users\\FictionCreator> ', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12),
                    decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                    onSubmitted: _handleSubmit,
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
