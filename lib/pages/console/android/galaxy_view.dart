import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/os_app_item.dart';
import 'android_statusbar.dart';

/// Samsung Galaxy OneUI 전용 모바일 홈스크린 뷰
class GalaxyView extends StatelessWidget {
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const GalaxyView({
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
        // 1. OneUI 배경화면
        Positioned.fill(
          child: _buildGalaxyWallpaper(),
        ),

        // 2. 상단 상태바
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AndroidStatusBar(timeString: timeString),
        ),

        // 3. 홈 화면 콘텐츠 (위젯 + 검색창 + 앱 그리드)
        Positioned.fill(
          top: 48,
          bottom: 24,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                // OneUI 날씨 & 시계 위젯
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timeString,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            dateString,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(CupertinoIcons.sun_max_fill, color: Colors.amber, size: 26),
                          SizedBox(width: 8),
                          Text('25°', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Google 검색 위젯 바
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: const Row(
                    children: [
                      Text('G', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text('Google 검색 또는 URL 입력', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      ),
                      Icon(CupertinoIcons.mic_fill, color: Colors.white70, size: 16),
                      SizedBox(width: 10),
                      Icon(CupertinoIcons.camera_fill, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 앱 아이콘 그리드
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                    children: [
                      OsAppItem(
                        title: '카카오톡',
                        imageAsset: 'assets/images/kakaotalk_icon.webp',
                        backgroundColor: const Color(0xFFFEE500),
                        isDesktop: false,
                        onTap: () => onOpenTemplate('kakaotalk'),
                      ),
                      OsAppItem(
                        title: '토스 (Toss)',
                        icon: CupertinoIcons.money_dollar_circle_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF0050FF),
                        isDesktop: false,
                        onTap: () => onOpenTemplate('toss'),
                      ),
                      OsAppItem(
                        title: 'Instagram',
                        imageAsset: 'assets/images/instagram_icon.webp',
                        isDesktop: false,
                        onTap: () => onOpenTemplate('instagram'),
                      ),
                      OsAppItem(
                        title: 'X (Twitter)',
                        icon: CupertinoIcons.conversation_bubble,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF1D9BF0),
                        isDesktop: false,
                        onTap: () => onOpenTemplate('x_twitter'),
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
                        title: '배달의민족',
                        icon: CupertinoIcons.bag_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF2AC1BC),
                        isDesktop: false,
                        onTap: () => onOpenTemplate('delivery'),
                      ),
                      OsAppItem(
                        title: '설정',
                        icon: CupertinoIcons.gear_alt_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF475569),
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

                // 하단 원UI 제스처 네비게이션 인디케이터
                Container(
                  width: 110,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGalaxyWallpaper() {
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A2540), Color(0xFF0D3B66), Color(0xFF101820)],
            ),
          ),
        );
    }
  }
}