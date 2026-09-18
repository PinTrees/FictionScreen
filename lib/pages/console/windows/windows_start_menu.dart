import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows 11 중앙 시작 메뉴 팝업
class WindowsStartMenu extends StatelessWidget {
  final User? user;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const WindowsStartMenu({
    super.key,
    required this.user,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 520,
      height: 500,
      decoration: BoxDecoration(
        color: const Color(0xFF1C202C).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 36,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 검색창
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.search, size: 16, color: Colors.white60),
                      SizedBox(width: 8),
                      Text(
                        '앱, 설정 및 템플릿 검색',
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. 고정된 앱 목록
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '고정됨',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('모든 앱 >', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      _buildAppItem('카카오톡', CupertinoIcons.chat_bubble_2_fill, const Color(0xFFFEE500), () => onOpenTemplate('kakaotalk')),
                      _buildAppItem('블루스크린', CupertinoIcons.device_desktop, const Color(0xFF0078D7), () => onOpenTemplate('windows_bsod')),
                      _buildAppItem('YouTube', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => onOpenTemplate('youtube')),
                      _buildAppItem('Instagram', CupertinoIcons.camera_fill, const Color(0xFFE1306C), () => onOpenTemplate('instagram')),
                      _buildAppItem('배달의민족', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), () => onOpenTemplate('delivery')),
                      _buildAppItem('시스템 설정', CupertinoIcons.gear_alt_fill, const Color(0xFF94A3B8), onOpenSettings),
                    ],
                  ),
                ),

                const Divider(color: Colors.white12, height: 24),

                // 3. 하단 사용자 프로필 & 전원 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFF6366F1),
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          child: user?.photoURL == null
                              ? const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 16)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? 'Fiction 창작자',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              user?.email ?? 'Google 계정',
                              style: const TextStyle(color: Colors.white54, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          tooltip: '랜딩 홈',
                          icon: const Icon(CupertinoIcons.house_fill, color: Colors.white70, size: 18),
                          onPressed: onGoHome,
                        ),
                        IconButton(
                          tooltip: '로그아웃',
                          icon: const Icon(CupertinoIcons.power, color: Color(0xFFEF4444), size: 18),
                          onPressed: onSignOut,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.white.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}