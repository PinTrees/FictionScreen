import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 18 계산기 앱 (원형 오렌지 키패드)
class IosCalculatorWindow extends StatefulWidget {
  final VoidCallback onClose;

  const IosCalculatorWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<IosCalculatorWindow> createState() => _IosCalculatorWindowState();
}

class _IosCalculatorWindowState extends State<IosCalculatorWindow> {
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: widget.onClose,
                    child: const Icon(CupertinoIcons.chevron_left, color: Color(0xFFFF9500), size: 22),
                  ),
                  const Spacer(),
                  const Text('계산기', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const SizedBox(width: 22),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Text(_display, style: const TextStyle(color: Colors.white, fontSize: 54, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalcBtn('AC', bg: const Color(0xFFA5A5A5), textCol: Colors.black, onTap: _onClear),
                      _buildCalcBtn('+/-', bg: const Color(0xFFA5A5A5), textCol: Colors.black),
                      _buildCalcBtn('%', bg: const Color(0xFFA5A5A5), textCol: Colors.black),
                      _buildCalcBtn('÷', bg: const Color(0xFFFF9500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalcBtn('7', onTap: () => _onNum('7')),
                      _buildCalcBtn('8', onTap: () => _onNum('8')),
                      _buildCalcBtn('9', onTap: () => _onNum('9')),
                      _buildCalcBtn('×', bg: const Color(0xFFFF9500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalcBtn('4', onTap: () => _onNum('4')),
                      _buildCalcBtn('5', onTap: () => _onNum('5')),
                      _buildCalcBtn('6', onTap: () => _onNum('6')),
                      _buildCalcBtn('-', bg: const Color(0xFFFF9500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalcBtn('1', onTap: () => _onNum('1')),
                      _buildCalcBtn('2', onTap: () => _onNum('2')),
                      _buildCalcBtn('3', onTap: () => _onNum('3')),
                      _buildCalcBtn('+', bg: const Color(0xFFFF9500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalcBtn('0', width: 140, onTap: () => _onNum('0')),
                      _buildCalcBtn('.'),
                      _buildCalcBtn('=', bg: const Color(0xFFFF9500)),
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

  Widget _buildCalcBtn(String label, {Color bg = const Color(0xFF333333), Color textCol = Colors.white, double width = 64, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: width,
        height: 64,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(32)),
        child: Center(
          child: Text(label, style: TextStyle(color: textCol, fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
