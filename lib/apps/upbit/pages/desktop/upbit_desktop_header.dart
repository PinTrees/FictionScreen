import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpbitDesktopHeader extends StatelessWidget {
  final String activeTab;
  final Function(String tab) onSelectTab;
  final VoidCallback onEdit;

  const UpbitDesktopHeader({
    super.key,
    required this.activeTab,
    required this.onSelectTab,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: const Color(0xFF093687),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // 1. UPbit 공식 로고
          InkWell(
            onTap: () => onSelectTab('거래소'),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('UP', style: TextStyle(color: Color(0xFF093687), fontWeight: FontWeight.w900, fontSize: 13)),
                ),
                const SizedBox(width: 6),
                const Text('bit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.5)),
              ],
            ),
          ),
          const SizedBox(width: 36),

          // 2. GNB 탭 네비게이션
          _buildGnbItem('거래소'),
          _buildGnbItem('입출금'),
          _buildGnbItem('투자내역'),
          _buildGnbItem('코인동향'),
          _buildGnbItem('스테이킹'),
          _buildGnbItem('고객센터'),

          const Spacer(),

          // 3. 우측 유틸리티
          TextButton(
            onPressed: onEdit,
            child: const Text('로그인', style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onEdit,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text('회원가입', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white, size: 18),
            tooltip: '시세 및 자산 연출 설정',
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _buildGnbItem(String title) {
    final isActive = activeTab == title;
    return InkWell(
      onTap: () => onSelectTab(title),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: isActive ? const Border(bottom: BorderSide(color: Colors.white, width: 3)) : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
