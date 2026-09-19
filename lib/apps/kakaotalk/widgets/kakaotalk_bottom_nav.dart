import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KakaoTalkBottomNav extends StatelessWidget {
  final int activeIndex;
  final Function(int) onTabSelected;
  final int totalUnreadChats;

  const KakaoTalkBottomNav({
    super.key,
    required this.activeIndex,
    required this.onTabSelected,
    this.totalUnreadChats = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, CupertinoIcons.person_fill, CupertinoIcons.person, '친구'),
          _buildChatItem(1, CupertinoIcons.chat_bubble_2_fill, CupertinoIcons.chat_bubble_2, '채팅'),
          _buildNavItem(2, CupertinoIcons.compass_fill, CupertinoIcons.compass, '오픈채팅'),
          _buildNavItem(3, CupertinoIcons.bag_fill, CupertinoIcons.bag, '쇼핑'),
          _buildNavItem(4, CupertinoIcons.ellipsis, CupertinoIcons.ellipsis, '더보기'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = activeIndex == index;
    final color = isSelected ? Colors.black : const Color(0xFF9E9E9E);

    return InkWell(
      onTap: () => onTabSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isSelected ? activeIcon : inactiveIcon, size: 22, color: color),
        ],
      ),
    );
  }

  Widget _buildChatItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = activeIndex == index;
    final color = isSelected ? Colors.black : const Color(0xFF9E9E9E);

    return InkWell(
      onTap: () => onTabSelected(index),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(isSelected ? activeIcon : inactiveIcon, size: 22, color: color),
          if (totalUnreadChats > 0)
            Positioned(
              top: -4,
              right: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  '$totalUnreadChats',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
