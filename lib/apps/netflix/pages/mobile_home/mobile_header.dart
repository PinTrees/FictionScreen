import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/netflix_icons.dart';
import '../../data/netflix_model.dart';

/// 넷플릭스 모바일 상단 헤더 & 카테고리 칩
class MobileHeader extends StatelessWidget {
  final NetflixProfile activeProfile;
  final VoidCallback onOpenProfileSelector;

  const MobileHeader({
    super.key,
    required this.activeProfile,
    required this.onOpenProfileSelector,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.85),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const NetflixWordmark(fontSize: 22, isNOnly: true),
              const Spacer(),
              const Icon(CupertinoIcons.tv, color: Colors.white, size: 20),
              const SizedBox(width: 16),
              const Icon(CupertinoIcons.search, color: Colors.white, size: 20),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onOpenProfileSelector,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: activeProfile.avatarBgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Icon(
                      activeProfile.isKids ? CupertinoIcons.sparkles : CupertinoIcons.smiley_fill,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 서브 카테고리 필터 칩
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryChip('시리즈'),
              _buildCategoryChip('영화'),
              _buildCategoryChip('카테고리 ▼'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
