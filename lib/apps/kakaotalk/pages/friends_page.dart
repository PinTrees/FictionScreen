import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/friend_item_model.dart';

class FriendsPage extends StatelessWidget {
  final List<KakaoFriend> friends;
  final VoidCallback? onTapMyProfile;
  final Function(KakaoFriend)? onTapFriend;

  const FriendsPage({
    super.key,
    required this.friends,
    this.onTapMyProfile,
    this.onTapFriend,
  });

  @override
  Widget build(BuildContext context) {
    final me = friends.firstWhere((f) => f.isMe, orElse: () => friends.first);
    final favorites = friends.where((f) => !f.isMe && f.isFavorite).toList();
    final birthdays = friends.where((f) => !f.isMe && f.isBirthday).toList();
    final others = friends.where((f) => !f.isMe && !f.isFavorite && !f.isBirthday).toList();

    return Column(
      children: [
        // 상단 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text('친구', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
              const Spacer(),
              const Icon(CupertinoIcons.search, size: 20, color: Colors.black87),
              const SizedBox(width: 16),
              const Icon(CupertinoIcons.person_badge_plus, size: 20, color: Colors.black87),
              const SizedBox(width: 16),
              const Icon(CupertinoIcons.gear, size: 20, color: Colors.black87),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // 내 프로필
              GestureDetector(
                onTap: onTapMyProfile,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            me.name[0],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF555555)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(me.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                            if (me.statusMessage.isNotEmpty)
                              Text(me.statusMessage, style: const TextStyle(fontSize: 12, color: Color(0xFF757575))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(height: 24, thickness: 0.8),

              // 생일인 친구
              if (birthdays.isNotEmpty) ...[
                const Text('생일인 친구', style: TextStyle(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...birthdays.map((f) => _buildFriendRow(f)),
                const Divider(height: 24, thickness: 0.8),
              ],

              // 즐겨찾기
              if (favorites.isNotEmpty) ...[
                const Text('즐겨찾기', style: TextStyle(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...favorites.map((f) => _buildFriendRow(f)),
                const Divider(height: 24, thickness: 0.8),
              ],

              // 친구 목록
              Row(
                children: [
                  const Text('친구', style: TextStyle(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  Text('${others.length}', style: const TextStyle(fontSize: 12, color: Color(0xFF757575))),
                ],
              ),
              const SizedBox(height: 8),
              ...others.map((f) => _buildFriendRow(f)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFriendRow(KakaoFriend friend) {
    return GestureDetector(
      onTap: () => onTapFriend?.call(friend),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  friend.name[0],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF555555)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(friend.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black)),
                  if (friend.statusMessage.isNotEmpty)
                    Text(friend.statusMessage, style: const TextStyle(fontSize: 12, color: Color(0xFF757575))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
