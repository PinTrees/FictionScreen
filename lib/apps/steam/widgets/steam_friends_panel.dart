import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/steam_model.dart';

class SteamFriendsPanel extends StatelessWidget {
  final List<SteamFriend> friends;
  final VoidCallback onClose;
  final ValueChanged<String>? onFriendTap;

  const SteamFriendsPanel({
    super.key,
    required this.friends,
    required this.onClose,
    this.onFriendTap,
  });

  @override
  Widget build(BuildContext context) {
    final inGameFriends = friends.where((f) => f.status == SteamFriendStatus.inGame).toList();
    final onlineFriends = friends.where((f) => f.status == SteamFriendStatus.online).toList();
    final awayFriends = friends.where((f) => f.status == SteamFriendStatus.away).toList();
    final offlineFriends = friends.where((f) => f.status == SteamFriendStatus.offline).toList();

    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: Color(0xFF1E2633),
        border: Border(left: BorderSide(color: Color(0xFF2A384A))),
      ),
      child: Column(
        children: [
          // 1. 헤더 (친구 및 대화)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: const Color(0xFF161C26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(CupertinoIcons.person_2_fill, color: Color(0xFF66C0F4), size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '친구 (${friends.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, size: 14, color: Colors.white60),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
              ],
            ),
          ),

          // 2. 친구 목록 (상태별 그룹)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 6),
              children: [
                if (inGameFriends.isNotEmpty) ...[
                  _buildSectionHeader('게임 중', inGameFriends.length, const Color(0xFF90BA3C)),
                  ...inGameFriends.map((f) => _buildFriendTile(f)),
                  const SizedBox(height: 8),
                ],
                if (onlineFriends.isNotEmpty) ...[
                  _buildSectionHeader('온라인', onlineFriends.length, const Color(0xFF57CBDE)),
                  ...onlineFriends.map((f) => _buildFriendTile(f)),
                  const SizedBox(height: 8),
                ],
                if (awayFriends.isNotEmpty) ...[
                  _buildSectionHeader('자리 비움', awayFriends.length, const Color(0xFFFFB84D)),
                  ...awayFriends.map((f) => _buildFriendTile(f)),
                  const SizedBox(height: 8),
                ],
                if (offlineFriends.isNotEmpty) ...[
                  _buildSectionHeader('오프라인', offlineFriends.length, const Color(0xFF898989)),
                  ...offlineFriends.map((f) => _buildFriendTile(f)),
                ],
              ],
            ),
          ),

          // 3. 하단 '+ 친구 추가' 바
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: const Color(0xFF161C26),
            child: Row(
              children: const [
                Icon(CupertinoIcons.person_badge_plus_fill, color: Colors.white54, size: 14),
                SizedBox(width: 8),
                Text(
                  '+ 친구 추가',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            '$title ($count)',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendTile(SteamFriend friend) {
    return InkWell(
      onTap: () => onFriendTap?.call(friend.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            // 프로필 아바타 + 상태 테두리
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: friend.avatarColor,
                border: Border.all(color: friend.status.color, width: 1.5),
              ),
              child: Center(
                child: Text(
                  friend.name.isNotEmpty ? friend.name.characters.first : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // 이름 및 상태
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: TextStyle(
                      color: friend.status == SteamFriendStatus.inGame
                          ? const Color(0xFF90BA3C)
                          : friend.status == SteamFriendStatus.online
                              ? const Color(0xFF57CBDE)
                              : Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    friend.status == SteamFriendStatus.inGame
                        ? '${friend.gameTitle ?? "게임"} 플레이 중'
                        : friend.lastSeenText ?? friend.status.label,
                    style: TextStyle(
                      color: friend.status == SteamFriendStatus.inGame
                          ? const Color(0xFF90BA3C).withValues(alpha: 0.8)
                          : Colors.white38,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
