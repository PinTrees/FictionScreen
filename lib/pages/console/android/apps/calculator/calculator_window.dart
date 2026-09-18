import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 계산기 앱
class SamsungCalculatorWindow extends StatefulWidget {
  final VoidCallback onClose;

  const SamsungCalculatorWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<SamsungCalculatorWindow> createState() => _SamsungCalculatorWindowState();
}

class _SamsungCalculatorWindowState extends State<SamsungCalculatorWindow> {
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
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: widget.onClose,
                    child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('계산기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // 디스플레이
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Text(
                  _display,
                  style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // 버튼 그리드
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalcBtn('C', color: const Color(0xFFEF4444), onTap: _onClear),
                      _buildCalcBtn('( )', color: const Color(0xFF10B981)),
                      _buildCalcBtn('%', color: const Color(0xFF10B981)),
                      _buildCalcBtn('÷', color: const Color(0xFF10B981)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalcBtn('7', onTap: () => _onNum('7')),
                      _buildCalcBtn('8', onTap: () => _onNum('8')),
                      _buildCalcBtn('9', onTap: () => _onNum('9')),
                      _buildCalcBtn('×', color: const Color(0xFF10B981)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalcBtn('4', onTap: () => _onNum('4')),
                      _buildCalcBtn('5', onTap: () => _onNum('5')),
                      _buildCalcBtn('6', onTap: () => _onNum('6')),
                      _buildCalcBtn('-', color: const Color(0xFF10B981)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalcBtn('1', onTap: () => _onNum('1')),
                      _buildCalcBtn('2', onTap: () => _onNum('2')),
                      _buildCalcBtn('3', onTap: () => _onNum('3')),
                      _buildCalcBtn('+', color: const Color(0xFF10B981)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalcBtn('+/-'),
                      _buildCalcBtn('0', onTap: () => _onNum('0')),
                      _buildCalcBtn('.'),
                      _buildCalcBtn('=', color: const Color(0xFF10B981), isAccent: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalcBtn(String label, {Color? color, bool isAccent = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isAccent ? const Color(0xFF10B981) : Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isAccent ? Colors.white : (color ?? Colors.white),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
