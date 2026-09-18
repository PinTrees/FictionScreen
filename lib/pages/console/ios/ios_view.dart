import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/os_app_item.dart';
import 'ios_dock.dart';
import 'ios_statusbar.dart';

/// iPhone iOS 전용 모바일 홈스크린 뷰
class IosView extends StatelessWidget {
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const IosView({
    super.key,
    required this.timeString,
    required this.dateString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. iOS 배경화면
        Positioned.fill(
          child: _buildIosWallpaper(),
        ),

        // 2. 상단 상태바 & 다이내믹 아일랜드
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IosStatusBar(timeString: timeString),
        ),

        // 3. 홈 화면 콘텐츠 (시계 위젯 + 앱 그리드)
        Positioned.fill(
          top: 70,
          bottom: 110,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // 시계 위젯
                Column(
                  children: [
                    Text(
                      dateString,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // 앱 아이콘 그리드
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      OsAppItem(
                        title: '카카오톡',
                        icon: CupertinoIcons.chat_bubble_2_fill,
                        iconColor: Colors.black,
                        backgroundColor: const Color(0xFFFEE500),
                        isDesktop: false,
                        onTap: () => onOpenTemplate('kakaotalk'),
                      ),
                      OsAppItem(
                        title: '블루스크린',
                        icon: CupertinoIcons.device_desktop,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF0078D7),
                        isDesktop: false,
                        onTap: () => onOpenTemplate('windows_bsod'),
                      ),
                      OsAppItem(
                        title: 'YouTube',
                        icon: CupertinoIcons.play_arrow_solid,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFFF0000),
                        isDesktop: false,
                        onTap: () => onOpenTemplate('youtube'),
                      ),
                      OsAppItem(
                        title: 'Instagram',
                        icon: CupertinoIcons.camera_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFE1306C),
                        isDesktop: false,
                        onTap: () => onOpenTemplate('instagram'),
                      ),
                      OsAppItem(
                        title: '배달의민족',
                        icon: CupertinoIcons.bag_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF2AC1BC),
                        isDesktop: false,
                        onTap: () => onOpenTemplate('delivery'),
                      ),
                      OsAppItem(
                        title: '시스템 설정',
                        icon: CupertinoIcons.gear_alt_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF64748B),
                        isDesktop: false,
                        onTap: onOpenSettings,
                      ),
                      OsAppItem(
                        title: '랜딩 홈',
                        icon: CupertinoIcons.house_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF334155),
                        isDesktop: false,
                        onTap: onGoHome,
                      ),
                      OsAppItem(
                        title: '로그아웃',
                        icon: CupertinoIcons.square_arrow_right,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFEF4444),
                        isDesktop: false,
                        onTap: onSignOut,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 4. 하단 독 & 홈 바
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IosDock(
            onOpenTemplate: onOpenTemplate,
            onOpenSettings: onOpenSettings,
          ),
        ),
      ],
    );
  }

  Widget _buildIosWallpaper() {
    switch (currentWallpaper) {
      case 'bloom':
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.2),
              radius: 1.2,
              colors: [Color(0xFF193256), Color(0xFF0F1E38), Color(0xFF090E1A)],
            ),
          ),
        );
      case 'minimal_dark':
        return Container(color: const Color(0xFF0A0B10));
      case 'cyberpunk':
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF020617), Color(0xFF4C1D95), Color(0xFFBE185D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      case 'aurora':
      default:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F172A), Color(0xFF311042), Color(0xFF1E1B4B)],
            ),
          ),
        );
    }
  }
}