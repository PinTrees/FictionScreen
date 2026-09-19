import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win10_window_frame.dart';

/// Windows 10 순정 계산기 (Calculator) - 플랫 그리드, 직각 0px 디자인
class Win10CalculatorWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const Win10CalculatorWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 340,
    this.height = 500,
    this.isMaximized = false,
  });

  @override
  State<Win10CalculatorWindow> createState() => _Win10CalculatorWindowState();
}

class _Win10CalculatorWindowState extends State<Win10CalculatorWindow> {
  String _display = '0';
  String _history = '';
  double? _firstOperand;
  String? _operator;
  bool _shouldResetDisplay = false;

  void _onDigit(String digit) {
    setState(() {
      if (_display == '0' || _shouldResetDisplay) {
        _display = digit;
        _shouldResetDisplay = false;
      } else {
        _display += digit;
      }
    });
  }

  void _onDot() {
    setState(() {
      if (_shouldResetDisplay) {
        _display = '0.';
        _shouldResetDisplay = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onOp(String op) {
    setState(() {
      final current = double.tryParse(_display) ?? 0.0;
      if (_firstOperand != null && _operator != null && !_shouldResetDisplay) {
        _calculate();
      } else {
        _firstOperand = current;
      }
      _operator = op;
      _history = '$_display $op';
      _shouldResetDisplay = true;
    });
  }

  void _calculate() {
    if (_firstOperand == null || _operator == null) return;
    final second = double.tryParse(_display) ?? 0.0;
    double result = 0.0;
    switch (_operator) {
      case '+': result = _firstOperand! + second; break;
      case '-': result = _firstOperand! - second; break;
      case '×': result = _firstOperand! * second; break;
      case '÷': result = second != 0 ? _firstOperand! / second : 0; break;
    }
    setState(() {
      _history = '$_firstOperand $_operator $second =';
      _display = result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);
      _firstOperand = null;
      _operator = null;
      _shouldResetDisplay = true;
    });
  }

  void _clearAll() {
    setState(() {
      _display = '0';
      _history = '';
      _firstOperand = null;
      _operator = null;
      _shouldResetDisplay = false;
    });
  }

  void _backspace() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Win10WindowFrame(
      title: '계산기',
      iconAsset: 'assets/images/windows/calc.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: const Color(0xFF1F1F1F),
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        child: Column(
          children: [
            // 모드 헤더 (햄버거 + '표준')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.bars, size: 16, color: Colors.white70),
                  const SizedBox(width: 12),
                  const Text('표준', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(CupertinoIcons.clock, size: 14, color: Colors.white54),
                ],
              ),
            ),

            // 계산 히스토리 및 결과 표시 영역
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _history.isEmpty ? ' ' : _history,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _display,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Segoe UI',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 메모리 바 (MC, MR, M+, M-, MS)
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('MC', style: TextStyle(color: Colors.white24, fontSize: 11)),
                  Text('MR', style: TextStyle(color: Colors.white24, fontSize: 11)),
                  Text('M+', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  Text('M-', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  Text('MS', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  Text('M▾', style: TextStyle(color: Colors.white24, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // 플랫 직각 키패드 그리드
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _buildRow(['%', 'CE', 'C', '⌫'])),
                  Expanded(child: _buildRow(['1/x', 'x²', '√x', '÷'])),
                  Expanded(child: _buildRow(['7', '8', '9', '×'])),
                  Expanded(child: _buildRow(['4', '5', '6', '-'])),
                  Expanded(child: _buildRow(['1', '2', '3', '+'])),
                  Expanded(child: _buildRow(['±', '0', '.', '='])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> labels) {
    return Row(
      children: labels.map((label) {
        final isNum = '0123456789'.contains(label);
        final isEqual = label == '=';
        Color bgColor = isNum ? const Color(0xFF0C0C0C) : const Color(0xFF161616);
        if (isEqual) bgColor = const Color(0xFF0078D7);

        return Expanded(
          child: Container(
            margin: const EdgeInsets.all(1.5),
            child: InkWell(
              onTap: () {
                if (isNum) {
                  _onDigit(label);
                } else if (label == '.') {
                  _onDot();
                } else if (label == 'C' || label == 'CE') {
                  _clearAll();
                } else if (label == '⌫') {
                  _backspace();
                } else if (label == '=') {
                  _calculate();
                } else if (['+', '-', '×', '÷'].contains(label)) {
                  _onOp(label);
                }
              },
              child: Container(
                color: bgColor,
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isNum ? 16 : 13,
                    fontWeight: isNum ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
