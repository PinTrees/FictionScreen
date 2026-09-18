import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/netflix_model.dart';

/// 넷플릭스 모바일 하단 3탭 네비게이션 바
class MobileBottomNav extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onSelectTab;
  final NetflixProfile activeProfile;

  const MobileBottomNav({
    super.key,
    required this.selectedTab,
    required this.onSelectTab,
    required this.activeProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: const Color(0xFF121212),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, CupertinoIcons.house_fill, '홈'),
          _buildNavItem(1, CupertinoIcons.flame_fill, 'NEW & HOT'),
          InkWell(
            onTap: () => onSelectTab(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: activeProfile.avatarBgColor,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: selectedTab == 2 ? Colors.white : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      activeProfile.isKids ? CupertinoIcons.sparkles : CupertinoIcons.smiley_fill,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '내 넷플릭스',
                  style: TextStyle(
                    color: selectedTab == 2 ? Colors.white : Colors.white54,
                    fontSize: 10,
                    fontWeight: selectedTab == 2 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedTab == index;
    return InkWell(
      onTap: () => onSelectTab(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.white54, size: 20),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
