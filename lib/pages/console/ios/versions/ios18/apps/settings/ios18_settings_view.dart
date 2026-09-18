import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 18 순정 설정 앱 (배경화면 실시간 교체 + Apple 계정 프로필 + 시스템 제어)
class Ios18SettingsView extends StatelessWidget {
  final User? user;
  final String currentWallpaper;
  final Function(String wallpaperKey) onSelectWallpaper;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final VoidCallback onClose;

  const Ios18SettingsView({
    super.key,
    required this.user,
    required this.currentWallpaper,
    required this.onSelectWallpaper,
    required this.onSignOut,
    required this.onGoHome,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 상단 네비게이션 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.chevron_left, color: Color(0xFF0A84FF), size: 24),
                    onPressed: onClose,
                  ),
                  const Text(
                    '설정',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 48), // 균형용 여백
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // 1. Apple 계정 프로필 카드
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFF6366F1),
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          child: user?.photoURL == null
                              ? const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 28)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? 'Admin',
                                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user?.email ?? 'Apple 계정, iCloud 등',
                                style: const TextStyle(color: Colors.white54, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const Icon(CupertinoIcons.chevron_right, color: Colors.white30, size: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 2. iOS 18 공식 배경화면 선택 섹션
                  const Padding(
                    padding: EdgeInsets.only(left: 6, bottom: 8),
                    child: Text(
                      'iOS 18 공식 배경화면 (실시간 변경)',
                      style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 130,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildWallpaperCard('다크', 'ios18_dark', 'assets/images/ios/wallpapers/ios18_dark.png'),
                              const SizedBox(width: 12),
                              _buildWallpaperCard('라이트', 'ios18_light', 'assets/images/ios/wallpapers/ios18_light.png'),
                              const SizedBox(width: 12),
                              _buildWallpaperCard('아주르 블루', 'ios18_blue', 'assets/images/ios/wallpapers/ios18_blue.jpg'),
                              const SizedBox(width: 12),
                              _buildWallpaperCard('딥 퍼플', 'ios18_purple', 'assets/images/ios/wallpapers/ios18_purple.jpg'),
                              const SizedBox(width: 12),
                              _buildWallpaperCard('앰버 옐로우', 'ios18_yellow', 'assets/images/ios/wallpapers/ios18_yellow.jpg'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 3. 바로가기 & 계정 관리
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSettingTile(
                          icon: CupertinoIcons.house_fill,
                          iconBg: const Color(0xFF0A84FF),
                          title: 'FictionScreen 홈으로 이동',
                          onTap: onGoHome,
                        ),
                        const Divider(color: Colors.white10, height: 1, indent: 56),
                        _buildSettingTile(
                          icon: CupertinoIcons.square_arrow_right,
                          iconBg: const Color(0xFFFF453A),
                          title: '로그아웃',
                          titleColor: const Color(0xFFFF453A),
                          onTap: onSignOut,
                          showChevron: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWallpaperCard(String title, String key, String imageAsset) {
    final bool isSelected = currentWallpaper == key;

    return GestureDetector(
      onTap: () => onSelectWallpaper(key),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? const Color(0xFF0A84FF) : Colors.white12,
                width: isSelected ? 2.5 : 1,
              ),
              image: DecorationImage(
                image: AssetImage(imageAsset),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xFF0A84FF).withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF0A84FF) : Colors.white70,
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconBg,
    required String title,
    Color titleColor = Colors.white,
    bool showChevron = true,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            if (showChevron)
              const Icon(CupertinoIcons.chevron_right, color: Colors.white30, size: 14),
          ],
        ),
      ),
    );
  }
}
