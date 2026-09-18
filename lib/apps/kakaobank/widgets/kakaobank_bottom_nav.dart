import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 카카오뱅크 하단 내비게이션 바 (홈, 상품몰, 알림, 전체메뉴)
class KakaoBankBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const KakaoBankBottomNav({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E22),
        border: Border(top: BorderSide(color: Color(0xFF2C2C30))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, '홈', CupertinoIcons.house_fill),
          _buildNavItem(1, '상품몰', CupertinoIcons.square_grid_2x2_fill),
          _buildNavItem(2, '알림', CupertinoIcons.bell_fill),
          _buildNavItem(3, '전체', CupertinoIcons.ellipsis_circle_fill),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSelected = activeIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? const Color(0xFFFEE500) : Colors.white38,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white38,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
