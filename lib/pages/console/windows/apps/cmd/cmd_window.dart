import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// Windows 명령 프롬프트 (cmd / PowerShell)
class WindowsCmdWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;
  final WindowStyle style;
  final String windowsVersion;

  const WindowsCmdWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 680,
    this.height = 440,
    this.isMaximized = false,
    this.style = WindowStyle.windows10,
    this.windowsVersion = '11',
  });

  @override
  State<WindowsCmdWindow> createState() => _WindowsCmdWindowState();
}

class _WindowsCmdWindowState extends State<WindowsCmdWindow> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final List<String> _history;

  @override
  void initState() {
    super.initState();
    final verString = widget.windowsVersion == 'xp'
        ? 'Microsoft Windows XP [Version 5.1.2600]'
        : (widget.windowsVersion == '7'
            ? 'Microsoft Windows [Version 6.1.7601]'
            : (widget.windowsVersion == '10'
                ? 'Microsoft Windows [Version 10.0.19045.3803]'
                : 'Microsoft Windows [Version 10.0.22631.3007]'));

    _history = [
      verString,
      '(c) Microsoft Corporation. All rights reserved.',
      '',
      'C:\\Users\\FictionCreator> help',
      'Available commands: dir, cls, echo, ver, help',
      '',
    ];
  }

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
        final verString = widget.windowsVersion == 'xp'
            ? 'Microsoft Windows XP [Version 5.1.2600]'
            : (widget.windowsVersion == '7'
                ? 'Microsoft Windows [Version 6.1.7601]'
                : (widget.windowsVersion == '10'
                    ? 'Microsoft Windows [Version 10.0.19045.3803]'
                    : 'Microsoft Windows [Version 10.0.22631.3007]'));
        _history.add(verString);
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
      iconAsset: 'assets/images/windows/cmd.png',
      icon: CupertinoIcons.device_desktop,
      style: widget.style,
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
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
