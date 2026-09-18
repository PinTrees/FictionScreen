import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlindBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BlindBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: CupertinoIcons.house, activeIcon: CupertinoIcons.house_fill, label: '홈'),
      _NavItem(icon: CupertinoIcons.square_grid_2x2, activeIcon: CupertinoIcons.square_grid_2x2_fill, label: '토픽'),
      _NavItem(icon: CupertinoIcons.chat_bubble_text, activeIcon: CupertinoIcons.chat_bubble_text_fill, label: '채널'),
      _NavItem(icon: CupertinoIcons.bell, activeIcon: CupertinoIcons.bell_fill, label: '알림', badge: '3'),
      _NavItem(icon: CupertinoIcons.person, activeIcon: CupertinoIcons.person_fill, label: '마이'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE9ECEF), width: 0.8)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 54,
          child: Row(
            children: List.generate(items.length, (idx) {
              final item = items[idx];
              final isSelected = idx == currentIndex;
              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(idx),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              isSelected ? item.activeIcon : item.icon,
                              size: 21,
                              color: isSelected ? const Color(0xFFDA3238) : const Color(0xFF9EA3AA),
                            ),
                            if (item.badge != null)
                              Positioned(
                                right: -7,
                                top: -3,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDA3238),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                                  child: Center(
                                    child: Text(
                                      item.badge!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w700,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? const Color(0xFFDA3238) : const Color(0xFF8A8F98),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String? badge;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badge,
  });
}
