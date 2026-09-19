import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/youtube_model.dart';

class YouTubeDesktopSidebar extends StatelessWidget {
  final bool isExpanded;
  final int selectedIndex;
  final ValueChanged<int> onSelectIndex;
  final List<YoutubeChannelItem> channels;

  const YouTubeDesktopSidebar({
    super.key,
    required this.isExpanded,
    required this.selectedIndex,
    required this.onSelectIndex,
    required this.channels,
  });

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) {
      return _buildMiniSidebar();
    }

    return Container(
      width: 220,
      color: const Color(0xFF0F0F0F),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        children: [
          // Section 1: Main
          _buildItem(0, Icons.home_filled, '홈'),
          _buildItem(1, CupertinoIcons.bolt_fill, 'Shorts'),
          _buildItem(2, CupertinoIcons.play_rectangle, '구독'),

          _buildDivider(),

          // Section 2: Library
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4, bottom: 6),
            child: Row(
              children: const [
                Text(
                  '나',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Icon(CupertinoIcons.chevron_right, color: Colors.white, size: 12),
              ],
            ),
          ),
          _buildItem(3, Icons.history, '시청 기록'),
          _buildItem(4, Icons.smart_display_outlined, '내 동영상'),
          _buildItem(5, Icons.watch_later_outlined, '나중에 볼 동영상'),
          _buildItem(6, CupertinoIcons.hand_thumbsup, '좋아요 표시한 동영상'),

          _buildDivider(),

          // Section 3: Subscribed channels
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 4, bottom: 6),
            child: Text(
              '구독',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...channels.map((channel) => _buildChannelItem(channel)),

          _buildDivider(),

          // Section 4: Explore
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 4, bottom: 6),
            child: Text(
              '탐색',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildItem(7, Icons.local_fire_department_outlined, '인기 급상승'),
          _buildItem(8, Icons.music_note_outlined, '음악'),
          _buildItem(9, Icons.sports_esports_outlined, '게임'),
          _buildItem(10, Icons.emoji_events_outlined, '스포츠'),
        ],
      ),
    );
  }

  Widget _buildMiniSidebar() {
    return Container(
      width: 72,
      color: const Color(0xFF0F0F0F),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildMiniItem(0, Icons.home_filled, '홈'),
          _buildMiniItem(1, CupertinoIcons.bolt_fill, 'Shorts'),
          _buildMiniItem(2, CupertinoIcons.play_rectangle, '구독'),
          _buildMiniItem(3, Icons.video_library_outlined, '나'),
        ],
      ),
    );
  }

  Widget _buildMiniItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onSelectIndex(index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 14),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF272727) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFFF0000) : Colors.white,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFAAAAAA),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onSelectIndex(index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF272727) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFFF0000) : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFF1F1F1),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelItem(YoutubeChannelItem channel) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: channel.avatarBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  channel.avatarLetter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                channel.name,
                style: const TextStyle(
                  color: Color(0xFFF1F1F1),
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (channel.isLive)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF0000),
                  shape: BoxShape.circle,
                ),
              )
            else if (channel.hasUnseen)
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF3EA6FF),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      color: const Color(0xFF272727),
    );
  }
}
