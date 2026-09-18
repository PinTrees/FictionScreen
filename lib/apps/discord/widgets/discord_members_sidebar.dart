import 'package:flutter/material.dart';
import '../data/discord_model.dart';

class DiscordMembersSidebar extends StatelessWidget {
  final List<DiscordUser> members;

  const DiscordMembersSidebar({
    super.key,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final admins = members.where((m) => m.roleName.contains('Admin')).toList();
    final bots = members.where((m) => m.isBot).toList();
    final onlines = members.where((m) => !m.roleName.contains('Admin') && !m.isBot && m.status != DiscordUserStatus.offline).toList();
    final offlines = members.where((m) => !m.isBot && m.status == DiscordUserStatus.offline).toList();

    return Container(
      width: 240,
      color: const Color(0xFF2B2D31),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        children: [
          if (admins.isNotEmpty) ...[
            _buildRoleHeader('서버 관리자', admins.length),
            ...admins.map((m) => _buildMemberTile(m)),
            const SizedBox(height: 12),
          ],
          if (bots.isNotEmpty) ...[
            _buildRoleHeader('봇', bots.length),
            ...bots.map((m) => _buildMemberTile(m)),
            const SizedBox(height: 12),
          ],
          if (onlines.isNotEmpty) ...[
            _buildRoleHeader('온라인', onlines.length),
            ...onlines.map((m) => _buildMemberTile(m)),
            const SizedBox(height: 12),
          ],
          if (offlines.isNotEmpty) ...[
            _buildRoleHeader('오프라인', offlines.length),
            ...offlines.map((m) => _buildMemberTile(m)),
          ],
        ],
      ),
    );
  }

  Widget _buildRoleHeader(String role, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        '${role.toUpperCase()} — $count',
        style: const TextStyle(
          color: Color(0xFF949BA4),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildMemberTile(DiscordUser user) {
    final isOffline = user.status == DiscordUserStatus.offline;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            // Avatar + Status Dot
            Stack(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: isOffline ? user.avatarColor.withValues(alpha: 0.4) : user.avatarColor,
                  child: Text(
                    user.name.isNotEmpty ? user.name.characters.first : 'U',
                    style: TextStyle(
                      color: isOffline ? Colors.white.withValues(alpha: 0.6) : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _buildStatusDot(user.status),
                ),
              ],
            ),
            const SizedBox(width: 10),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.name,
                          style: TextStyle(
                            color: isOffline ? const Color(0xFF80848E) : user.roleColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.isBot) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5865F2),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            '봇',
                            style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (user.statusText != null && !isOffline)
                    Text(
                      user.statusText!,
                      style: const TextStyle(
                        color: Color(0xFF949BA4),
                        fontSize: 10.5,
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

  Widget _buildStatusDot(DiscordUserStatus status) {
    Color color;
    switch (status) {
      case DiscordUserStatus.online:
        color = const Color(0xFF23A55A);
        break;
      case DiscordUserStatus.idle:
        color = const Color(0xFFF0B232);
        break;
      case DiscordUserStatus.dnd:
        color = const Color(0xFFF23F43);
        break;
      case DiscordUserStatus.offline:
        color = const Color(0xFF80848E);
        break;
    }

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2B2D31), width: 2),
      ),
    );
  }
}
