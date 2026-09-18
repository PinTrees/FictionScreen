import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/netflix_icons.dart';
import '../../data/netflix_model.dart';

/// 넷플릭스 데스크탑 상단 플로팅 GNB 헤더
class DesktopHeader extends StatelessWidget {
  final NetflixProfile activeProfile;
  final int activeNavIndex;
  final ValueChanged<int> onSelectNav;
  final VoidCallback onOpenProfileSelector;

  const DesktopHeader({
    super.key,
    required this.activeProfile,
    required this.activeNavIndex,
    required this.onSelectNav,
    required this.onOpenProfileSelector,
  });

  static const _navItems = ['홈', '시리즈', '영화', 'NEW! 요즘 대세', '내가 찜한 리스트'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.9),
            Colors.black.withValues(alpha: 0.6),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // 넷플릭스 시그니처 레드 로고
          const NetflixWordmark(fontSize: 24),
          const SizedBox(width: 32),

          // 메뉴 카테고리 탭
          ..._navItems.asMap().entries.map((entry) {
            final idx = entry.key;
            final title = entry.value;
            final isSelected = activeNavIndex == idx;
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () => onSelectNav(idx),
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // 우측 도구: 검색, 알림, 프로필 아바타
          const Icon(CupertinoIcons.search, color: Colors.white, size: 20),
          const SizedBox(width: 20),
          const Icon(CupertinoIcons.bell_fill, color: Colors.white, size: 18),
          const SizedBox(width: 20),

          // 활성 프로필 칩
          GestureDetector(
            onTap: onOpenProfileSelector,
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: activeProfile.avatarBgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Icon(
                      activeProfile.isKids ? CupertinoIcons.sparkles : CupertinoIcons.smiley_fill,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(CupertinoIcons.chevron_down, color: Colors.white, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
