import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YanoljaBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const YanoljaBottomNav({
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
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(0, '카테고리', CupertinoIcons.square_grid_2x2),
          _buildItem(1, '내주변', CupertinoIcons.location_north_fill),
          _buildItem(2, '홈', CupertinoIcons.house_fill),
          _buildItem(3, '찜', CupertinoIcons.heart),
          _buildItem(4, '마이', CupertinoIcons.person),
        ],
      ),
    );
  }

  Widget _buildItem(int index, String label, IconData icon) {
    final isSel = activeIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSel ? const Color(0xFFFF3478) : Colors.black54,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSel ? const Color(0xFFFF3478) : Colors.black87,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
