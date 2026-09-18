import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final inactiveColor = isDark ? Colors.white60 : Colors.black54;
    final borderColor = isDark ? Colors.white12 : const Color(0xFFE5E7EB);

    return Container(
      height: 52,
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
            icon: currentIndex == 0 ? CupertinoIcons.house_fill : CupertinoIcons.house,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            index: 1,
            icon: currentIndex == 1 ? CupertinoIcons.search : CupertinoIcons.search,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            index: 2,
            icon: CupertinoIcons.plus_app,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            index: 3,
            icon: currentIndex == 3 ? CupertinoIcons.play_rectangle_fill : CupertinoIcons.play_rectangle,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildProfileNavItem(
            index: 4,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(index),
      child: SizedBox(
        width: 54,
        height: 50,
        child: Center(
          child: Icon(
            icon,
            size: 26,
            color: isSelected ? activeColor : inactiveColor,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileNavItem({
    required int index,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(index),
      child: SizedBox(
        width: 54,
        height: 50,
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
