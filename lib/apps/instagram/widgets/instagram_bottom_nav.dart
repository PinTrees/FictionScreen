import 'package:flutter/material.dart';
import 'instagram_icons.dart';

class InstagramBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final String userAvatarLetter;

  const InstagramBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.userAvatarLetter = 'S',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = currentIndex == 3; // Reels tab is dark theme
    final bgColor = isDark ? Colors.black : Colors.white;
    final activeColor = isDark ? Colors.white : Colors.black;
    final inactiveColor = isDark ? Colors.white60 : Colors.black;
    final borderColor = isDark ? Colors.white12 : const Color(0xFFE5E7EB);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 0.8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            iconWidget: InstagramIcons.home(
              filled: currentIndex == 0,
              color: currentIndex == 0 ? activeColor : inactiveColor,
              size: 24,
            ),
          ),
          _buildNavItem(
            index: 1,
            iconWidget: InstagramIcons.search(
              filled: currentIndex == 1,
              color: currentIndex == 1 ? activeColor : inactiveColor,
              size: 24,
            ),
          ),
          _buildNavItem(
            index: 2,
            iconWidget: InstagramIcons.create(
              filled: currentIndex == 2,
              color: currentIndex == 2 ? activeColor : inactiveColor,
              size: 24,
            ),
          ),
          _buildNavItem(
            index: 3,
            iconWidget: InstagramIcons.reels(
              filled: currentIndex == 3,
              color: currentIndex == 3 ? activeColor : inactiveColor,
              size: 24,
            ),
          ),
          _buildProfileNavItem(
            index: 4,
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required Widget iconWidget,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(index),
      child: SizedBox(
        width: 50,
        height: 46,
        child: Center(child: iconWidget),
      ),
    );
  }

  Widget _buildProfileNavItem({
    required int index,
    required Color activeColor,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(index),
      child: SizedBox(
        width: 50,
        height: 46,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? activeColor : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: const Color(0xFFF97316),
              child: Text(
                userAvatarLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
