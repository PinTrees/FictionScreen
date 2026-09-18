import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/os_app_item.dart';
import 'windows_start_menu.dart';
import 'windows_taskbar.dart';

/// Windows 11 전용 데스크톱 뷰 레이아웃
class WindowsView extends StatelessWidget {
  final User? user;
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final bool isStartMenuOpen;
  final VoidCallback onToggleStartMenu;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const WindowsView({
    super.key,
    required this.user,
    required this.timeString,
    required this.dateString,
    required this.currentWallpaper,
    required this.isStartMenuOpen,
    required this.onToggleStartMenu,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 배경화면
        Positioned.fill(
          child: _buildWindowsWallpaper(),
        ),

        // 2. 바탕화면 앱 아이콘 그리드 (좌측 정렬)
        Positioned(
          top: 24,
          left: 24,
          bottom: 72,
          width: 90,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsAppItem(
                  title: '내 PC',
                  icon: CupertinoIcons.device_desktop,
                  iconColor: const Color(0xFF60A5FA),
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                OsAppItem(
                  title: '카카오톡',
                  icon: CupertinoIcons.chat_bubble_2_fill,
                  iconColor: const Color(0xFFFEE500),
                  onTap: () => onOpenTemplate('kakaotalk'),
                ),
                const SizedBox(height: 12),
                OsAppItem(
                  title: '블루스크린',
                  icon: CupertinoIcons.device_desktop,
                  iconColor: const Color(0xFF0078D7),
                  onTap: () => onOpenTemplate('windows_bsod'),
                ),
                const SizedBox(height: 12),
                OsAppItem(
                  title: 'YouTube',
                  icon: CupertinoIcons.play_arrow_solid,
                  iconColor: const Color(0xFFFF0000),
                  onTap: () => onOpenTemplate('youtube'),
                ),
                const SizedBox(height: 12),
                OsAppItem(
                  title: 'Instagram',
                  icon: CupertinoIcons.camera_fill,
                  iconColor: const Color(0xFFE1306C),
                  onTap: () => onOpenTemplate('instagram'),
                ),
                const SizedBox(height: 12),
                OsAppItem(
                  title: '배달의민족',
                  icon: CupertinoIcons.bag_fill,
                  iconColor: const Color(0xFF2AC1BC),
                  onTap: () => onOpenTemplate('delivery'),
                ),
                const SizedBox(height: 12),
                OsAppItem(
                  title: '설정',
                  icon: CupertinoIcons.gear_alt_fill,
                  iconColor: Colors.white70,
                  onTap: onOpenSettings,
                ),
                const SizedBox(height: 12),
                OsAppItem(
                  title: '랜딩 홈',
                  icon: CupertinoIcons.house_fill,
                  iconColor: Colors.white70,
                  onTap: onGoHome,
                ),
              ],
            ),
          ),
        ),

        // 3. 시작 메뉴 팝업
        if (isStartMenuOpen)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: WindowsStartMenu(
                user: user,
                onOpenTemplate: onOpenTemplate,
                onOpenSettings: onOpenSettings,
                onSignOut: onSignOut,
                onGoHome: onGoHome,
              ),
            ),
          ),

        // 4. 하단 작업표시줄
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: WindowsTaskbar(
            user: user,
            timeString: timeString,
            dateString: dateString,
            isStartMenuOpen: isStartMenuOpen,
            onToggleStartMenu: onToggleStartMenu,
            onOpenTemplate: onOpenTemplate,
            onOpenSettings: onOpenSettings,
            onSignOut: onSignOut,
            onGoHome: onGoHome,
          ),
        ),
      ],
    );
  }

  Widget _buildWindowsWallpaper() {
    switch (currentWallpaper) {
      case 'aurora':
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1B4B), Color(0xFF701A75), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      case 'minimal_dark':
        return Container(color: const Color(0xFF0C0E14));
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
      case 'bloom':
      default:
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.2),
              radius: 1.2,
              colors: [
                Color(0xFF193256),
                Color(0xFF0F1E38),
                Color(0xFF090E1A),
              ],
            ),
          ),
          child: CustomPaint(
            painter: _BloomPetalPainter(),
          ),
        );
    }
  }
}

class _BloomPetalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.45);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF60A5FA).withValues(alpha: 0.22),
          const Color(0xFF3B82F6).withValues(alpha: 0.10),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 260));

    canvas.drawCircle(center, 260, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}