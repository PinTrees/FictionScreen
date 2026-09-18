import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// macOS Terminal zsh 콘솔 창
class TerminalWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const TerminalWindow({
    super.key,
    required this.onClose,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 700,
    this.height = 460,
  });

  @override
  State<TerminalWindow> createState() => _TerminalWindowState();
}

class _TerminalWindowState extends State<TerminalWindow> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, String>> _history = [
    {'type': 'system', 'text': 'Last login: Fri Sep 18 17:40:12 on ttys001'},
    {'type': 'system', 'text': 'FictionScreen OS [Version 2.0.0 (macOS Sequoia Engine)]'},
    {'type': 'output', 'text': "Type 'help' for a list of available commands.\n"},
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit(String command) {
    final cmd = command.trim();
    if (cmd.isEmpty) return;

    setState(() {
      _history.add({'type': 'input', 'text': cmd});
      _executeCommand(cmd);
      _inputController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
      _focusNode.requestFocus();
    });
  }

  void _executeCommand(String rawCmd) {
    final parts = rawCmd.split(' ');
    final cmd = parts[0].toLowerCase();

    switch (cmd) {
      case 'help':
        _history.add({
          'type': 'output',
          'text': 'FictionScreen macOS Terminal Commands:\n'
              '  help         - Print this command summary\n'
              '  ls           - List directory contents\n'
              '  uname -a     - Display operating system release info\n'
              '  whoami       - Print current logged-in user\n'
              '  date         - Print current system date and time\n'
              '  clear        - Clear the terminal screen\n'
              '  echo [text]  - Print arguments to terminal\n'
              '  version      - Show FictionScreen Studio version\n'
        });
        break;
      case 'ls':
        _history.add({
          'type': 'output',
          'text': 'Applications/  Desktop/  Documents/  Downloads/  Movies/  Music/  Pictures/  Templates/'
        });
        break;
      case 'uname':
        _history.add({
          'type': 'output',
          'text': 'Darwin Fiction-MacBook-Pro.local 24.1.0 Darwin Kernel Version 24.1.0: arm64'
        });
        break;
      case 'whoami':
        _history.add({'type': 'output', 'text': 'fiction_creator'});
        break;
      case 'date':
        _history.add({'type': 'output', 'text': DateTime.now().toString()});
        break;
      case 'version':
        _history.add({'type': 'output', 'text': 'FictionScreen v1.0.0 (Web Build)'});
        break;
      case 'clear':
        _history.clear();
        break;
      default:
        if (cmd == 'echo') {
          final echoText = parts.length > 1 ? parts.sublist(1).join(' ') : '';
          _history.add({'type': 'output', 'text': echoText});
        } else {
          _history.add({'type': 'output', 'text': 'zsh: command not found: $cmd'});
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: 'fiction@MacBook-Pro: ~ (zsh)',
      style: WindowStyle.macos,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: const Color(0xFF14151B),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final item = _history[index];
                  final type = item['type'];
                  final text = item['text']!;

                  if (type == 'input') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'fiction@MacBook-Pro ~ % ',
                            style: TextStyle(
                              color: Color(0xFF34D399),
                              fontFamily: 'monospace',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: type == 'system' ? Colors.white54 : Colors.white70,
                          fontFamily: 'monospace',
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                const Text(
                  'fiction@MacBook-Pro ~ % ',
                  style: TextStyle(
                    color: Color(0xFF34D399),
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    focusNode: _focusNode,
                    autofocus: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
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
