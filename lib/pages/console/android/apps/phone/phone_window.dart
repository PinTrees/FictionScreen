import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 전화 앱 (키패드, 최근 기록, 연락처)
class SamsungPhoneWindow extends StatefulWidget {
  final VoidCallback onClose;

  const SamsungPhoneWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<SamsungPhoneWindow> createState() => _SamsungPhoneWindowState();
}

class _SamsungPhoneWindowState extends State<SamsungPhoneWindow> {
  int _activeTab = 0; // 0: 키패드, 1: 최근 기록, 2: 연락처
  String _dialNumber = '';

  final List<Map<String, String>> _recentCalls = [
    {'name': '김철수', 'number': '010-1234-5678', 'time': '오후 4:20', 'type': 'incoming'},
    {'name': 'FictionScreen support', 'number': '1588-0000', 'time': '어제', 'type': 'outgoing'},
    {'name': '이영희', 'number': '010-9876-5432', 'time': '9월 15일', 'type': 'missed'},
  ];

  void _onKeyPress(String key) {
    setState(() {
      if (_dialNumber.length < 13) {
        _dialNumber += key;
      }
    });
  }

  void _onBackspace() {
    if (_dialNumber.isNotEmpty) {
      setState(() {
        _dialNumber = _dialNumber.substring(0, _dialNumber.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 닫기 헤더
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: widget.onClose,
                    child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('전화', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(CupertinoIcons.search, color: Colors.white70, size: 18),
                ],
              ),
            ),

            // 탭 본문
            Expanded(
              child: _activeTab == 0
                  ? _buildKeypadView()
                  : (_activeTab == 1 ? _buildRecentsView() : _buildContactsView()),
            ),

            // 하단 3개 탭 바 (키패드, 최근기록, 연락처)
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF181A24),
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabButton(0, '키패드', CupertinoIcons.circle_grid_3x3_fill),
                  _buildTabButton(1, '최근 기록', CupertinoIcons.clock_fill),
                  _buildTabButton(2, '연락처', CupertinoIcons.person_2_fill),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadView() {
    return Column(
      children: [
        const Spacer(),
        // 입력 번호 표시
        Text(
          _dialNumber.isEmpty ? '전화번호 입력' : _dialNumber,
          style: TextStyle(
            color: _dialNumber.isEmpty ? Colors.white38 : Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // 다이얼 키패드 (1~9, *, 0, #)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialButton('1', ''),
                  _buildDialButton('2', 'ABC'),
                  _buildDialButton('3', 'DEF'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialButton('4', 'GHI'),
                  _buildDialButton('5', 'JKL'),
                  _buildDialButton('6', 'MNO'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialButton('7', 'PQRS'),
                  _buildDialButton('8', 'TUV'),
                  _buildDialButton('9', 'WXYZ'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialButton('*', ''),
                  _buildDialButton('0', '+'),
                  _buildDialButton('#', ''),
                ],
              ),
              const SizedBox(height: 24),

              // 통화 버튼 & 지우기 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 48),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.phone_fill, color: Colors.white, size: 28),
                  ),
                  SizedBox(
                    width: 48,
                    child: _dialNumber.isNotEmpty
                        ? IconButton(
                            icon: const Icon(CupertinoIcons.delete_left_fill, color: Colors.white54, size: 22),
                            onPressed: _onBackspace,
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDialButton(String number, String sub) {
    return InkWell(
      onTap: () => _onKeyPress(number),
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(number, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            if (sub.isNotEmpty)
              Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentsView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recentCalls.length,
      itemBuilder: (context, index) {
        final item = _recentCalls[index];
        final isMissed = item['type'] == 'missed';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                isMissed ? CupertinoIcons.phone_down_fill : CupertinoIcons.phone_fill,
                color: isMissed ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                size: 20,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name']!, style: TextStyle(color: isMissed ? const Color(0xFFEF4444) : Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(item['number']!, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ),
              Text(item['time']!, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: CircleAvatar(backgroundColor: Color(0xFF3B82F6), child: Text('김', style: TextStyle(color: Colors.white))),
          title: Text('김철수', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text('010-1234-5678', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
        ListTile(
          leading: CircleAvatar(backgroundColor: Color(0xFF10B981), child: Text('이', style: TextStyle(color: Colors.white))),
          title: Text('이영희', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text('010-9876-5432', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    final isSelected = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: isSelected ? const Color(0xFF10B981) : Colors.white38),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: isSelected ? const Color(0xFF10B981) : Colors.white38, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
