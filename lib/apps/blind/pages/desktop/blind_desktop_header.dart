import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlindDesktopHeader extends StatelessWidget {
  final int selectedNavIndex;
  final ValueChanged<int> onNavTap;
  final VoidCallback onEditStory;
  final VoidCallback onWritePost;

  const BlindDesktopHeader({
    super.key,
    required this.selectedNavIndex,
    required this.onNavTap,
    required this.onEditStory,
    required this.onWritePost,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = ['홈', '토픽 채널', '기업 정보', '채용'];

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE9ECEF), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          // Blind Logo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDA3238),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'blind',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'KR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8A8F98),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 32),

          // Nav tabs
          Row(
            children: List.generate(navItems.length, (idx) {
              final isSelected = idx == selectedNavIndex;
              return InkWell(
                onTap: () => onNavTap(idx),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Text(
                    navItems[idx],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? const Color(0xFFDA3238) : const Color(0xFF495057),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(width: 24),

          // Search input box
          Expanded(
            child: Container(
              height: 38,
              constraints: const BoxConstraints(maxWidth: 380),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F7),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Row(
                children: [
                  Icon(CupertinoIcons.search, size: 16, color: Color(0xFF8A8F98)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '관심 있는 글, 회사, 키워드를 검색해보세요',
                      style: TextStyle(fontSize: 12.5, color: Color(0xFFADB5BD)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Scenario Edit button
          OutlinedButton.icon(
            onPressed: onEditStory,
            icon: const Icon(CupertinoIcons.pencil_circle, size: 16, color: Color(0xFFDA3238)),
            label: const Text(
              '게시글/투표 편집',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDA3238),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFDA3238)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
          ),
          const SizedBox(width: 10),

          // Write Post button
          ElevatedButton.icon(
            onPressed: onWritePost,
            icon: const Icon(CupertinoIcons.pencil, size: 14, color: Colors.white),
            label: const Text(
              '글쓰기',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDA3238),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 0,
            ),
          ),
          const SizedBox(width: 14),

          // User Profile avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFF1F3F5),
            child: const Icon(CupertinoIcons.person_fill, size: 16, color: Color(0xFF8A8F98)),
          ),
        ],
      ),
    );
  }
}
