import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows 7 / 10 / 11 하단 테스크바
class WindowsTaskbar extends StatelessWidget {
  final String windowsVersion;
  final User? user;
  final String timeString;
  final String dateString;
  final bool isStartMenuOpen;
  final VoidCallback onToggleStartMenu;
  final VoidCallback? onToggleQuickSettings;
  final Function(String templateId) onOpenTemplate;
  final Function(String appId)? onOpenWinApp;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const WindowsTaskbar({
    super.key,
    this.windowsVersion = '10',
    required this.user,
    required this.timeString,
    required this.dateString,
    required this.isStartMenuOpen,
    required this.onToggleStartMenu,
    this.onToggleQuickSettings,
    required this.onOpenTemplate,
    this.onOpenWinApp,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    if (windowsVersion == '7') {
      return _buildWin7Taskbar();
    } else if (windowsVersion == '10') {
      return _buildWin10Taskbar();
    } else {
      return _buildWin11Taskbar();
    }
  }

  // Windows 11: 중앙 정렬 Fluent 테스크바
  Widget _buildWin11Taskbar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF1E212B).withValues(alpha: 0.85),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                // 좌측 날씨 위젯
                const Row(
                  children: [
                    Icon(CupertinoIcons.sun_max_fill, color: Colors.amber, size: 18),
                    SizedBox(width: 8),
                    Text('24°C 맑음', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                // 중앙 정렬 앱 아이콘들
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: '시작 (Windows 11)',
                      icon: Icon(
                        CupertinoIcons.square_grid_2x2_fill,
                        color: isStartMenuOpen ? const Color(0xFF60A5FA) : Colors.white,
                        size: 22,
                      ),
                      onPressed: onToggleStartMenu,
                    ),
                    const SizedBox(width: 4),
                    // Windows 11 순정 핵심 기본 앱
                    _buildTaskbarIcon(null, Colors.transparent, '파일 탐색기', () => onOpenWinApp?.call('file_explorer'), imageAsset: 'assets/images/windows/explorer.png'),
                    _buildTaskbarIcon(null, Colors.transparent, '설정', () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings()), imageAsset: 'assets/images/windows/settings/System.webp'),
                    _buildTaskbarIcon(null, Colors.transparent, 'Edge', () => onOpenWinApp?.call('edge'), imageAsset: 'assets/images/windows/edge.png'),
                    _buildTaskbarIcon(null, Colors.transparent, 'Chrome', () => onOpenWinApp?.call('chrome'), imageAsset: 'assets/images/windows/chrome.png'),
                    _buildTaskbarIcon(null, Colors.transparent, '메모장', () => onOpenWinApp?.call('notepad'), imageAsset: 'assets/images/windows/notepad.png'),
                    _buildTaskbarIcon(null, Colors.transparent, '계산기', () => onOpenWinApp?.call('calculator'), imageAsset: 'assets/images/windows/calc.png'),
                    // 사용자 창작 템플릿 앱
                    _buildTaskbarIcon(null, const Color(0xFFFEE500), '카카오톡', () => onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
                    _buildTaskbarIcon(null, const Color(0xFFC72424), '쿠팡', () => onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
                    _buildTaskbarIcon(null, const Color(0xFFE50914), 'Netflix', () => onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
                    _buildTaskbarIcon(CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), 'YouTube', () => onOpenTemplate('youtube')),
                    _buildTaskbarIcon(null, const Color(0xFFE1306C), 'Instagram', () => onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
                    _buildTaskbarIcon(null, const Color(0xFF0066B3), '동행복권', () => onOpenTemplate('lottery'), imageAsset: 'assets/images/lottery_icon.webp'),
                    _buildTaskbarIcon(CupertinoIcons.device_desktop, const Color(0xFF0078D7), '블루스크린', () => onOpenTemplate('windows_bsod')),
                  ],
                ),
                const Spacer(),
                _buildSystemTray(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Windows 10: 좌측 정렬 어두운 테스크바 + 코타나/검색창
  Widget _buildWin10Taskbar() {
    return Container(
      height: 44,
      color: const Color(0xFF101216),
      child: Row(
        children: [
          InkWell(
            onTap: onToggleStartMenu,
            hoverColor: const Color(0xFF1E212B),
            child: Container(
              width: 48,
              height: 44,
              alignment: Alignment.center,
              child: Icon(
                CupertinoIcons.square_grid_2x2_fill,
                color: isStartMenuOpen ? const Color(0xFF0078D7) : Colors.white,
                size: 20,
              ),
            ),
          ),
          Container(
            width: 200,
            height: 32,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: const Color(0xFF1F222A),
            child: const Row(
              children: [
                Icon(CupertinoIcons.search, color: Colors.white54, size: 14),
                SizedBox(width: 8),
                Text('검색하려면 여기에 입력하십시오.', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 4),
          _buildTaskbarIcon(null, const Color(0xFFFEE500), '카카오톡', () => onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
          _buildTaskbarIcon(CupertinoIcons.device_desktop, const Color(0xFF0078D7), '블루스크린', () => onOpenTemplate('windows_bsod')),
          _buildTaskbarIcon(CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), 'YouTube', () => onOpenTemplate('youtube')),
          _buildTaskbarIcon(null, const Color(0xFFE1306C), 'Instagram', () => onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
          _buildTaskbarIcon(null, const Color(0xFFC72424), '쿠팡', () => onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
          _buildTaskbarIcon(null, const Color(0xFFE50914), 'Netflix', () => onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
          _buildTaskbarIcon(null, const Color(0xFF0066B3), '동행복권', () => onOpenTemplate('lottery'), imageAsset: 'assets/images/lottery_icon.webp'),
          _buildTaskbarIcon(CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), '배달의민족', () => onOpenTemplate('delivery')),
          _buildTaskbarIcon(CupertinoIcons.gear_alt_fill, const Color(0xFF94A3B8), '설정', () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings())),
          const Spacer(),
          _buildSystemTray(),
        ],
      ),
    );
  }

  // Windows 7: 클래식 에어로 글래스
  Widget _buildWin7Taskbar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF0E2F54).withValues(alpha: 0.7),
        border: Border(
          top: BorderSide(color: const Color(0xFF67B5FA).withValues(alpha: 0.4), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Row(
            children: [
              // 시작 구슬(Orb)
              InkWell(
                onTap: onToggleStartMenu,
                child: Container(
                  width: 52,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [Color(0xFF67B5FA), Color(0xFF1E528E)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.6),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(CupertinoIcons.circle_grid_hex, color: Colors.white, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildTaskbarIcon(null, const Color(0xFFFEE500), '카카오톡', () => onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
              _buildTaskbarIcon(CupertinoIcons.device_desktop, const Color(0xFF0078D7), '블루스크린', () => onOpenTemplate('windows_bsod')),
              _buildTaskbarIcon(CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), 'YouTube', () => onOpenTemplate('youtube')),
              _buildTaskbarIcon(null, const Color(0xFFE1306C), 'Instagram', () => onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
              _buildTaskbarIcon(null, const Color(0xFFC72424), '쿠팡', () => onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
              _buildTaskbarIcon(null, const Color(0xFFE50914), 'Netflix', () => onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
              _buildTaskbarIcon(null, const Color(0xFF0066B3), '동행복권', () => onOpenTemplate('lottery'), imageAsset: 'assets/images/lottery_icon.webp'),
              _buildTaskbarIcon(CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), '배달의민족', () => onOpenTemplate('delivery')),
              _buildTaskbarIcon(CupertinoIcons.gear_alt_fill, const Color(0xFF94A3B8), '설정', () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings())),
              const Spacer(),
              _buildSystemTray(),
              Container(
                width: 14,
                height: 42,
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskbarIcon(
    IconData? icon,
    Color color,
    String tooltip,
    VoidCallback onTap, {
    String? imageAsset,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: imageAsset != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(imageAsset, width: 20, height: 20, fit: BoxFit.contain),
              )
            : Icon(icon ?? CupertinoIcons.circle_fill, color: color, size: 20),
        hoverColor: Colors.white.withValues(alpha: 0.15),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildSystemTray() {
    return Row(
      children: [
        InkWell(
          onTap: onToggleQuickSettings,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                const Icon(CupertinoIcons.wifi, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.volume_up, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.battery_charging, size: 16, color: Colors.white70),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onToggleQuickSettings,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(timeString, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              Text(dateString, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildUserMenu(),
      ],
    );
  }

  Widget _buildUserMenu() {
    return PopupMenuButton<String>(
      color: const Color(0xFF1E212B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.white12),
      ),
      offset: const Offset(0, -130),
      child: CircleAvatar(
        radius: 13,
        backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
        backgroundColor: const Color(0xFF6366F1),
        child: user?.photoURL == null
            ? const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 14)
            : null,
      ),
      onSelected: (val) {
        if (val == 'settings') onOpenSettings();
        if (val == 'signout') onSignOut();
        if (val == 'home') onGoHome();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.displayName ?? 'Fiction 창작자', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(user?.email ?? '', style: const TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(CupertinoIcons.gear_alt_fill, size: 14, color: Colors.white70),
              SizedBox(width: 8),
              Text('시스템 설정', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'home',
          child: Row(
            children: [
              Icon(CupertinoIcons.house_fill, size: 14, color: Colors.white70),
              SizedBox(width: 8),
              Text('랜딩 홈으로 이동', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'signout',
          child: Row(
            children: [
              Icon(CupertinoIcons.square_arrow_right, size: 14, color: Color(0xFFEF4444)),
              SizedBox(width: 8),
              Text('로그아웃', style: TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
