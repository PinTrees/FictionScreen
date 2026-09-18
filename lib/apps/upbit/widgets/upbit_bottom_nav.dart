import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpbitBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const UpbitBottomNav({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(0, '거래소', CupertinoIcons.chart_bar_alt_fill),
          _buildItem(1, '코인정보', CupertinoIcons.info_circle),
          _buildItem(2, '투자내역', CupertinoIcons.chart_pie_fill),
          _buildItem(3, '입출금', CupertinoIcons.arrow_right_arrow_left),
          _buildItem(4, '더보기', CupertinoIcons.ellipsis),
        ],
      ),
    );
  }

  Widget _buildItem(int index, String label, IconData icon) {
    final isActive = activeIndex == index;
    final color = isActive ? const Color(0xFF093687) : Colors.grey.shade400;

    return InkWell(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }
}
