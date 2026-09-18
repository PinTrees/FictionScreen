import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// Windows 11 계산기
class WindowsCalculatorWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const WindowsCalculatorWindow({
    super.key,
    required this.onClose,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 340,
    this.height = 480,
  });

  @override
  State<WindowsCalculatorWindow> createState() => _WindowsCalculatorWindowState();
}

class _WindowsCalculatorWindowState extends State<WindowsCalculatorWindow> {
  String _display = '0';

  void _onNum(String num) {
    setState(() {
      if (_display == '0') {
        _display = num;
      } else {
        _display += num;
      }
    });
  }

  void _onClear() {
    setState(() {
      _display = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '계산기',
      icon: CupertinoIcons.number,
      style: WindowStyle.windows,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: const Color(0xFF202020),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(12),
                child: Text(_display, style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold)),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBtn('C', onTap: _onClear),
                    _buildBtn('( )'),
                    _buildBtn('%'),
                    _buildBtn('÷', isAccent: true),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBtn('7', onTap: () => _onNum('7')),
                    _buildBtn('8', onTap: () => _onNum('8')),
                    _buildBtn('9', onTap: () => _onNum('9')),
                    _buildBtn('×', isAccent: true),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBtn('4', onTap: () => _onNum('4')),
                    _buildBtn('5', onTap: () => _onNum('5')),
                    _buildBtn('6', onTap: () => _onNum('6')),
                    _buildBtn('-', isAccent: true),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBtn('1', onTap: () => _onNum('1')),
                    _buildBtn('2', onTap: () => _onNum('2')),
                    _buildBtn('3', onTap: () => _onNum('3')),
                    _buildBtn('+', isAccent: true),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBtn('+/-'),
                    _buildBtn('0', onTap: () => _onNum('0')),
                    _buildBtn('.'),
                    _buildBtn('=', isAccent: true, accentColor: const Color(0xFF0078D7)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBtn(String label, {bool isAccent = false, Color? accentColor, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          color: accentColor ?? (isAccent ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.06)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
