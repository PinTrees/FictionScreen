import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/os_app_item.dart';
import 'windows_start_menu.dart';
import 'windows_taskbar.dart';

/// Windows 7 / 10 / 11 데스크톱 뷰 레이아웃
class WindowsView extends StatelessWidget {
  final String windowsVersion;
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
    this.windowsVersion = '10',
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
        // 1. 배경화면 (WebP 이미지 또는 그라데이션)
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
                  title: windowsVersion == '7' ? '컴퓨터' : '내 PC',
                  icon: CupertinoIcons.device_desktop,
                  iconColor: const Color(0xFF60A5FA),
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                OsAppItem(
                  title: '카카오톡',
                  imageAsset: 'assets/images/kakaotalk_icon.webp',
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
                  imageAsset: 'assets/images/instagram_icon.webp',
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
                  title: '휴지통',
                  icon: CupertinoIcons.trash_fill,
                  iconColor: Colors.white70,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),

        // 3. 시작 메뉴 팝업 (버전별 위치 및 UI 분기)
        if (isStartMenuOpen)
          Positioned(
            bottom: windowsVersion == '11' ? 60 : (windowsVersion == '10' ? 44 : 42),
            left: windowsVersion == '11' ? 0 : 0,
            right: windowsVersion == '11' ? 0 : null,
            child: windowsVersion == '11'
                ? Center(
                    child: WindowsStartMenu(
                      windowsVersion: windowsVersion,
                      user: user,
                      onOpenTemplate: onOpenTemplate,
                      onOpenSettings: onOpenSettings,
                      onSignOut: onSignOut,
                      onGoHome: onGoHome,
                    ),
                  )
                : WindowsStartMenu(
                    windowsVersion: windowsVersion,
                    user: user,
                    onOpenTemplate: onOpenTemplate,
                    onOpenSettings: onOpenSettings,
                    onSignOut: onSignOut,
                    onGoHome: onGoHome,
                  ),
          ),

        // 4. 하단 작업표시줄
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: WindowsTaskbar(
            windowsVersion: windowsVersion,
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
    // 1. WebP 이미지 배경화면 분기
    if (currentWallpaper == 'win10_hero') {
      return Image.asset(
        'assets/images/win10_hero.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
      );
    } else if (currentWallpaper == 'win11_bloom') {
      return Image.asset(
        'assets/images/win11_bloom.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
      );
    } else if (currentWallpaper == 'win7_harmony') {
      return Image.asset(
        'assets/images/win7_harmony.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
      );
    }

    // 2. 그라데이션 테마 분기
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
      default:
        // 기본 윈도우 배경: 사용자가 업로드한 2K win10_hero.webp
        return Image.asset(
          'assets/images/win10_hero.webp',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          filterQuality: FilterQuality.high,
        );
    }
  }
}