import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows 11 하단 테스크바 (Fluent Taskbar)
class WindowsTaskbar extends StatelessWidget {
  final User? user;
  final String timeString;
  final String dateString;
  final bool isStartMenuOpen;
  final VoidCallback onToggleStartMenu;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const WindowsTaskbar({
    super.key,
    required this.user,
    required this.timeString,
    required this.dateString,
    required this.isStartMenuOpen,
    required this.onToggleStartMenu,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
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
                // 좌측: 날씨 위젯
                const Row(
                  children: [
                    Icon(CupertinoIcons.sun_max_fill, color: Colors.amber, size: 18),
                    SizedBox(width: 8),
                    Text('24°C 맑음', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),

                const Spacer(),

                // 중앙 정렬: 시작 메뉴 및 앱 런처
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 시작 버튼
                    IconButton(
                      tooltip: '시작',
                      icon: Icon(
                        CupertinoIcons.square_grid_2x2_fill,
                        color: isStartMenuOpen ? const Color(0xFF60A5FA) : Colors.white,
                        size: 22,
                      ),
                      onPressed: onToggleStartMenu,
                    ),
                    const SizedBox(width: 4),

                    // 스튜디오 템플릿 앱들
                    _buildTaskbarIcon(CupertinoIcons.chat_bubble_2_fill, const Color(0xFFFEE500), '카카오톡', () => onOpenTemplate('kakaotalk')),
                    _buildTaskbarIcon(CupertinoIcons.device_desktop, const Color(0xFF0078D7), '블루스크린', () => onOpenTemplate('windows_bsod')),
                    _buildTaskbarIcon(CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), 'YouTube', () => onOpenTemplate('youtube')),
                    _buildTaskbarIcon(CupertinoIcons.camera_fill, const Color(0xFFE1306C), 'Instagram', () => onOpenTemplate('instagram')),
                    _buildTaskbarIcon(CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), '배달의민족', () => onOpenTemplate('delivery')),
                    _buildTaskbarIcon(CupertinoIcons.gear_alt_fill, const Color(0xFF94A3B8), '설정 (OS 변경 / 배경화면)', onOpenSettings),
                  ],
                ),

                const Spacer(),

                // 우측: 시스템 트레이 & 시계
                Row(
                  children: [
                    const Icon(CupertinoIcons.wifi, size: 16, color: Colors.white70),
                    const SizedBox(width: 8),
                    const Icon(CupertinoIcons.volume_up, size: 16, color: Colors.white70),
                    const SizedBox(width: 8),
                    const Icon(CupertinoIcons.battery_charging, size: 16, color: Colors.white70),
                    const SizedBox(width: 12),

                    // 시간 & 날짜
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(timeString, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                        Text(dateString, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // 프로필 팝업 메뉴
                    _buildUserMenu(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskbarIcon(IconData icon, Color color, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        hoverColor: Colors.white.withValues(alpha: 0.15),
        onPressed: onTap,
      ),
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