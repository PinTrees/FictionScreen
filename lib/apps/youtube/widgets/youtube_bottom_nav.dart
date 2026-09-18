import 'package:flutter/cupertino.dart';
import 'youtube_icons.dart';

class YouTubeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String? profileAvatarUrl;

  const YouTubeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.profileAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        border: Border(
          top: BorderSide(
            color: Color(0xFF272727),
            width: 0.8,
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 6, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, '홈', (filled) => YouTubeIcons.home(filled: filled, color: const Color(0xFFFFFFFF))),
          _buildNavItem(1, 'Shorts', (filled) => YouTubeIcons.shorts(filled: filled, color: const Color(0xFFFFFFFF))),
          _buildCreateButton(2),
          _buildNavItem(3, '구독', (filled) => YouTubeIcons.subscriptions(filled: filled, color: const Color(0xFFFFFFFF))),
          _buildLibraryItem(4),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, Widget Function(bool filled) iconBuilder) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: iconBuilder(isSelected),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFFAAAAAA),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: SizedBox(
        width: 38,
        height: 38,
        child: Center(
          child: YouTubeIcons.create(color: const Color(0xFFFFFFFF), size: 34),
        ),
      ),
    );
  }

  Widget _buildLibraryItem(int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: const Color(0xFFFFFFFF), width: 1.8)
                  : null,
            ),
            child: ClipOval(
              child: (profileAvatarUrl != null && profileAvatarUrl!.isNotEmpty)
                  ? Image.network(
                      profileAvatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '나',
            style: TextStyle(
              color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFFAAAAAA),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFF2BA640),
      child: const Center(
        child: Text(
          'F',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
