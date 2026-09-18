import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win11_window_frame.dart';

/// Windows 11 순정 계산기 (Calculator) 창
class Win11CalculatorWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const Win11CalculatorWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 340,
    this.height = 520,
  });

  @override
  State<Win11CalculatorWindow> createState() => _Win11CalculatorWindowState();
}

class _Win11CalculatorWindowState extends State<Win11CalculatorWindow> {
  String _display = '0';
  String _history = '';
  double? _firstOperand;
  String? _operator;
  bool _shouldResetDisplay = false;
  double? _memory;

  void _onDigit(String digit) {
    setState(() {
      if (_display == '0' || _shouldResetDisplay) {
        _display = digit;
        _shouldResetDisplay = false;
      } else {
        if (_display.length < 16) {
          _display += digit;
        }
      }
    });
  }

  void _onDecimal() {
    setState(() {
      if (_shouldResetDisplay) {
        _display = '0.';
        _shouldResetDisplay = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onClear() {
    setState(() {
      _display = '0';
      _history = '';
      _firstOperand = null;
      _operator = null;
      _shouldResetDisplay = false;
    });
  }

  void _onClearEntry() {
    setState(() {
      _display = '0';
    });
  }

  void _onBackspace() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _onToggleSign() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      }
    });
  }

  void _onOperator(String op) {
    final current = double.tryParse(_display) ?? 0.0;
    setState(() {
      if (_firstOperand != null && _operator != null && !_shouldResetDisplay) {
        _calculate();
      } else {
        _firstOperand = current;
      }
      _operator = op;
      _history = '${_formatNum(_firstOperand ?? current)} $op';
      _shouldResetDisplay = true;
    });
  }

  void _calculate() {
    if (_firstOperand == null || _operator == null) return;
    final secondOperand = double.tryParse(_display) ?? 0.0;
    double result = 0.0;

    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '×':
        result = _firstOperand! * secondOperand;
        break;
      case '÷':
        if (secondOperand == 0) {
          _display = '0으로 나눌 수 없습니다';
          _history = '';
          _firstOperand = null;
          _operator = null;
          _shouldResetDisplay = true;
          return;
        }
        result = _firstOperand! / secondOperand;
        break;
    }

    _history = '${_formatNum(_firstOperand!)} $_operator ${_formatNum(secondOperand)} =';
    _display = _formatNum(result);
    _firstOperand = result;
    _operator = null;
    _shouldResetDisplay = true;
  }

  void _onPercent() {
    final current = double.tryParse(_display) ?? 0.0;
    setState(() {
      if (_firstOperand != null) {
        final pct = _firstOperand! * (current / 100.0);
        _display = _formatNum(pct);
      } else {
        _display = _formatNum(current / 100.0);
      }
    });
  }

  void _onReciprocal() {
    final current = double.tryParse(_display) ?? 0.0;
    if (current == 0) return;
    setState(() {
      _history = '1/(${_formatNum(current)})';
      _display = _formatNum(1.0 / current);
      _shouldResetDisplay = true;
    });
  }

  void _onSquare() {
    final current = double.tryParse(_display) ?? 0.0;
    setState(() {
      _history = 'sqr(${_formatNum(current)})';
      _display = _formatNum(current * current);
      _shouldResetDisplay = true;
    });
  }

  void _onSqrt() {
    final current = double.tryParse(_display) ?? 0.0;
    if (current < 0) return;
    setState(() {
      _history = '√(${_formatNum(current)})';
      _display = _formatNum(math.sqrt(current));
      _shouldResetDisplay = true;
    });
  }

  String _formatNum(double n) {
    if (n.isNaN || n.isInfinite) return '오류';
    if (n == n.roundToDouble()) {
      return n.toInt().toString();
    }
    String s = n.toStringAsFixed(8);
    while (s.endsWith('0')) {
      s = s.substring(0, s.length - 1);
    }
    if (s.endsWith('.')) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  // Memory functions
  void _memoryClear() => setState(() => _memory = null);
  void _memoryRecall() {
    if (_memory != null) {
      setState(() {
        _display = _formatNum(_memory!);
        _shouldResetDisplay = true;
      });
    }
  }
  void _memoryAdd() {
    final current = double.tryParse(_display) ?? 0.0;
    setState(() => _memory = (_memory ?? 0.0) + current);
  }
  void _memorySub() {
    final current = double.tryParse(_display) ?? 0.0;
    setState(() => _memory = (_memory ?? 0.0) - current);
  }
  void _memoryStore() {
    final current = double.tryParse(_display) ?? 0.0;
    setState(() => _memory = current);
  }

  @override
  Widget build(BuildContext context) {
    return Win11WindowFrame(
      title: '계산기',
      iconAsset: 'assets/images/windows/calc.png',
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: const Color(0xFF202020),
        child: Column(
          children: [
            _buildModeHeader(),
            _buildDisplayArea(),
            _buildMemoryBar(),
            Expanded(child: _buildKeypad()),
          ],
        ),
      ),
    );
  }

  Widget _buildModeHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          const Icon(CupertinoIcons.bars, color: Colors.white70, size: 16),
          const SizedBox(width: 10),
          const Text(
            '표준',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(CupertinoIcons.chevron_down, color: Colors.white54, size: 12),
          const Spacer(),
          const Icon(CupertinoIcons.clock, color: Colors.white54, size: 15),
        ],
      ),
    );
  }

  Widget _buildDisplayArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.centerRight,
            height: 20,
            child: Text(
              _history,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                _display,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryBar() {
    final hasMem = _memory != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMemoryBtn('MC', enabled: hasMem, onTap: _memoryClear),
          _buildMemoryBtn('MR', enabled: hasMem, onTap: _memoryRecall),
          _buildMemoryBtn('M+', enabled: true, onTap: _memoryAdd),
          _buildMemoryBtn('M-', enabled: true, onTap: _memorySub),
          _buildMemoryBtn('MS', enabled: true, onTap: _memoryStore),
          _buildMemoryBtn('M▾', enabled: hasMem, onTap: null),
        ],
      ),
    );
  }

  Widget _buildMemoryBtn(String label, {required bool enabled, VoidCallback? onTap}) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? Colors.white70 : Colors.white24,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 8),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildKey('%', isFunction: true, onTap: _onPercent),
                _buildKey('CE', isFunction: true, onTap: _onClearEntry),
                _buildKey('C', isFunction: true, onTap: _onClear),
                _buildKey('⌫', isFunction: true, onTap: _onBackspace),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildKey('¹/x', isFunction: true, onTap: _onReciprocal),
                _buildKey('x²', isFunction: true, onTap: _onSquare),
                _buildKey('√x', isFunction: true, onTap: _onSqrt),
                _buildKey('÷', isOperator: true, onTap: () => _onOperator('÷')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildKey('7', onTap: () => _onDigit('7')),
                _buildKey('8', onTap: () => _onDigit('8')),
                _buildKey('9', onTap: () => _onDigit('9')),
                _buildKey('×', isOperator: true, onTap: () => _onOperator('×')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildKey('4', onTap: () => _onDigit('4')),
                _buildKey('5', onTap: () => _onDigit('5')),
                _buildKey('6', onTap: () => _onDigit('6')),
                _buildKey('-', isOperator: true, onTap: () => _onOperator('-')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildKey('1', onTap: () => _onDigit('1')),
                _buildKey('2', onTap: () => _onDigit('2')),
                _buildKey('3', onTap: () => _onDigit('3')),
                _buildKey('+', isOperator: true, onTap: () => _onOperator('+')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildKey('+/-', onTap: _onToggleSign),
                _buildKey('0', onTap: () => _onDigit('0')),
                _buildKey('.', onTap: _onDecimal),
                _buildKey('=', isAccent: true, onTap: () => setState(_calculate)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(
    String label, {
    bool isOperator = false,
    bool isFunction = false,
    bool isAccent = false,
    VoidCallback? onTap,
  }) {
    Color bg = const Color(0xFF3B3B3B);
    Color text = Colors.white;

    if (isAccent) {
      bg = const Color(0xFF0067C0);
      text = Colors.white;
    } else if (isOperator || isFunction) {
      bg = const Color(0xFF323232);
      text = Colors.white70;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            hoverColor: isAccent
                ? const Color(0xFF1877CD)
                : Colors.white.withValues(alpha: 0.08),
            splashColor: Colors.white.withValues(alpha: 0.14),
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: text,
                  fontSize: isFunction ? 14 : 16,
                  fontWeight: (isAccent || !isFunction) ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
