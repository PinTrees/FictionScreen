import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 18 전화 앱
class IosPhoneWindow extends StatefulWidget {
  final VoidCallback onClose;

  const IosPhoneWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<IosPhoneWindow> createState() => _IosPhoneWindowState();
}

class _IosPhoneWindowState extends State<IosPhoneWindow> {
  int _activeTab = 2; // 2: 키패드
  String _dialNumber = '';

  final List<Map<String, dynamic>> _recentCalls = [
    {'name': '김철수', 'type': 'iMessage 통화', 'time': '오후 4:20', 'isMissed': false},
    {'name': 'FictionSupport', 'type': '휴대폰', 'time': '어제', 'isMissed': false},
    {'name': '이영희', 'type': '부재중 전화', 'time': '9월 15일', 'isMissed': true},
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 닫기 헤더
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: widget.onClose,
                    child: const Icon(CupertinoIcons.chevron_left, color: Color(0xFF007AFF), size: 22),
                  ),
                  const Spacer(),
                  const Text('전화', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const SizedBox(width: 22),
                ],
              ),
            ),

            // 탭 본문
            Expanded(
              child: _activeTab == 2
                  ? _buildKeypadView()
                  : (_activeTab == 1 ? _buildRecentsView() : _buildContactsView()),
            ),

            // iOS 하단 5개 탭 바 (즐겨찾기, 최근통화, 키패드, 연락처, 음성메모)
            Container(
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF161618),
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabBtn(0, '즐겨찾기', CupertinoIcons.star_fill),
                  _buildTabBtn(1, '최근 통화', CupertinoIcons.clock_fill),
                  _buildTabBtn(2, '키패드', CupertinoIcons.circle_grid_3x3_fill),
                  _buildTabBtn(3, '연락처', CupertinoIcons.person_crop_circle_fill),
                  _buildTabBtn(4, '음성 메모', CupertinoIcons.recordingtape),
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
        Text(
          _dialNumber.isEmpty ? '' : _dialNumber,
          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        const SizedBox(height: 24),

        // iOS 원형 키패드
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 44),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIosDialBtn('1', ''),
                  _buildIosDialBtn('2', 'A B C'),
                  _buildIosDialBtn('3', 'D E F'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIosDialBtn('4', 'G H I'),
                  _buildIosDialBtn('5', 'J K L'),
                  _buildIosDialBtn('6', 'M N O'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIosDialBtn('7', 'P Q R S'),
                  _buildIosDialBtn('8', 'T U V'),
                  _buildIosDialBtn('9', 'W X Y Z'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIosDialBtn('*', ''),
                  _buildIosDialBtn('0', '+'),
                  _buildIosDialBtn('#', ''),
                ],
              ),
              const SizedBox(height: 24),

              // 통화 녹색 버튼 & 지우기
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 48),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFF34C759),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.phone_fill, color: Colors.white, size: 30),
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
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildIosDialBtn(String number, String sub) {
    return InkWell(
      onTap: () => _onKeyPress(number),
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(number, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            if (sub.isNotEmpty)
              Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
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
        final call = _recentCalls[index];
        final isMissed = call['isMissed'] as bool;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white12))),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(call['name']!, style: TextStyle(color: isMissed ? const Color(0xFFFF3B30) : Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(call['type']!, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              Text(call['time']!, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(width: 8),
              const Icon(CupertinoIcons.info_circle, color: Color(0xFF007AFF), size: 20),
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
          title: Text('김철수', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text('010-1234-5678', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
        ListTile(
          title: Text('이영희', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text('010-9876-5432', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildTabBtn(int index, String label, IconData icon) {
    final isSelected = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: isSelected ? const Color(0xFF007AFF) : Colors.white38),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: isSelected ? const Color(0xFF007AFF) : Colors.white38, fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
