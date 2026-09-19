import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SteamosDesktopMode extends StatefulWidget {
  final User? user;
  final String timeString;
  final String dateString;
  final VoidCallback onReturnToGamingMode;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final Function(String osKey)? onSelectOs;

  const SteamosDesktopMode({
    super.key,
    required this.user,
    required this.timeString,
    required this.dateString,
    required this.onReturnToGamingMode,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
    this.onSelectOs,
  });

  @override
  State<SteamosDesktopMode> createState() => _SteamosDesktopModeState();
}

class _SteamosDesktopModeState extends State<SteamosDesktopMode> {
  bool _isKickoffOpen = false;
  String? _selectedIconId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isKickoffOpen) setState(() => _isKickoffOpen = false);
        if (_selectedIconId != null) setState(() => _selectedIconId = null);
      },
      child: Container(
        // Authentic SteamOS KDE Plasma Desktop Wallpaper
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF1B263B),
              Color(0xFF0F172A),
              Color(0xFF030712),
            ],
            stops: [0.0, 0.4, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Center Ambient SteamOS Neon Geometric Watermark
            Center(
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  'assets/images/steamos_logo.png',
                  width: 480,
                  height: 480,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // 1. Desktop Icons Column (Top-Left)
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Return to Gaming Mode Shortcut
                  _buildDesktopIcon(
                    id: 'return_gaming',
                    title: 'Return to\nGaming Mode',
                    icon: CupertinoIcons.gamecontroller_fill,
                    iconColor: const Color(0xFF1A9FFF),
                    isHighlight: true,
                    onTap: widget.onReturnToGamingMode,
                  ),
                  const SizedBox(height: 18),

                  // Steam Client
                  _buildDesktopIcon(
                    id: 'steam_client',
                    title: 'Steam',
                    icon: CupertinoIcons.app_badge_fill,
                    iconColor: const Color(0xFF67C1F5),
                    onTap: () => widget.onOpenTemplate('steam'),
                  ),
                  const SizedBox(height: 18),

                  // Dolphin File Manager
                  _buildDesktopIcon(
                    id: 'dolphin',
                    title: 'Dolphin\n(파일 탐색기)',
                    icon: CupertinoIcons.folder_fill,
                    iconColor: const Color(0xFF38BDF8),
                    onTap: () => widget.onOpenTemplate('excel'),
                  ),
                  const SizedBox(height: 18),

                  // Konsole Terminal
                  _buildDesktopIcon(
                    id: 'konsole',
                    title: 'Konsole\n(터미널)',
                    icon: CupertinoIcons.chevron_left_slash_chevron_right,
                    iconColor: const Color(0xFF10B981),
                    onTap: () => widget.onOpenTemplate('dcinside'),
                  ),
                  const SizedBox(height: 18),

                  // Chrome Web Browser
                  _buildDesktopIcon(
                    id: 'browser',
                    title: 'Google Chrome',
                    icon: CupertinoIcons.globe,
                    iconColor: const Color(0xFFF59E0B),
                    onTap: () => widget.onOpenTemplate('youtube'),
                  ),
                  const SizedBox(height: 18),

                  // Trash
                  _buildDesktopIcon(
                    id: 'trash',
                    title: 'Trash (휴지통)',
                    icon: CupertinoIcons.trash_fill,
                    iconColor: Colors.white70,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // 2. KDE Plasma Kickoff Start Menu (if open)
            if (_isKickoffOpen)
              Positioned(
                bottom: 48,
                left: 0,
                child: _buildKickoffMenu(),
              ),

            // 3. Bottom KDE Plasma Panel / Taskbar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 44,
              child: _buildKdeTaskbar(),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Desktop Icon Widget
  // ==========================================
  Widget _buildDesktopIcon({
    required String id,
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    final isSelected = _selectedIconId == id;

    return InkWell(
      onTap: () {
        setState(() => _selectedIconId = id);
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 84,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1A9FFF).withValues(alpha: 0.3)
              : (isHighlight ? const Color(0xFF1A9FFF).withValues(alpha: 0.1) : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: const Color(0xFF1A9FFF).withValues(alpha: 0.6))
              : (isHighlight ? Border.all(color: const Color(0xFF1A9FFF).withValues(alpha: 0.3)) : null),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF111722).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // KDE Plasma Bottom Taskbar Panel
  // ==========================================
  Widget _buildKdeTaskbar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141923).withValues(alpha: 0.95),
        border: const Border(top: BorderSide(color: Colors.white12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Kickoff Application Launcher button
          InkWell(
            onTap: () => setState(() => _isKickoffOpen = !_isKickoffOpen),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _isKickoffOpen ? const Color(0xFF1A9FFF).withValues(alpha: 0.3) : Colors.transparent,
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/steamos_logo.png', width: 22, height: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'SteamOS',
                    style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          const VerticalDivider(color: Colors.white12, width: 1, indent: 8, endIndent: 8),

          // Pinned App Taskbar Icons
          _buildTaskbarPinnedIcon(CupertinoIcons.gamecontroller_fill, const Color(0xFF1A9FFF), 'Gaming Mode', widget.onReturnToGamingMode),
          _buildTaskbarPinnedIcon(CupertinoIcons.app_badge_fill, const Color(0xFF67C1F5), 'Steam', () => widget.onOpenTemplate('steam')),
          _buildTaskbarPinnedIcon(CupertinoIcons.folder_fill, const Color(0xFF38BDF8), 'Dolphin', () => widget.onOpenTemplate('excel')),
          _buildTaskbarPinnedIcon(CupertinoIcons.chevron_left_slash_chevron_right, const Color(0xFF10B981), 'Konsole', () => widget.onOpenTemplate('dcinside')),

          const Spacer(),

          // System Tray
          InkWell(
            onTap: widget.onReturnToGamingMode,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A9FFF).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF1A9FFF).withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  Icon(CupertinoIcons.gamecontroller, size: 14, color: Color(0xFF1A9FFF)),
                  SizedBox(width: 6),
                  Text('게임 모드로 복귀', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          const SizedBox(width: 6),
          const Icon(CupertinoIcons.speaker_2_fill, color: Colors.white70, size: 16),
          const SizedBox(width: 10),
          const Icon(CupertinoIcons.wifi, color: Colors.white70, size: 16),
          const SizedBox(width: 10),
          const Icon(CupertinoIcons.battery_100, color: Color(0xFF22C55E), size: 16),
          const SizedBox(width: 14),

          // Clock
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.timeString,
                  style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.dateString,
                  style: const TextStyle(color: Colors.white54, fontSize: 9.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskbarPinnedIcon(IconData icon, Color color, String tooltip, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 44,
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 19),
      ),
    );
  }

  // ==========================================
  // KDE Plasma Kickoff Start Menu
  // ==========================================
  Widget _buildKickoffMenu() {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: 420,
            height: 480,
            decoration: BoxDecoration(
              color: const Color(0xFF101520).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
              border: Border.all(color: Colors.white12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 24,
                  offset: const Offset(4, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Search Bar
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.search, color: Colors.white54, size: 16),
                        SizedBox(width: 8),
                        Text('애플리케이션 검색...', style: TextStyle(color: Colors.white54, fontSize: 12.5)),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.white10, height: 1),

                // Application List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      _buildKickoffItem(
                        icon: CupertinoIcons.gamecontroller_fill,
                        iconColor: const Color(0xFF1A9FFF),
                        title: 'Steam Deck Gaming Mode',
                        desc: '콘솔 및 휴대용 게임 모드로 즉시 전환',
                        onTap: () {
                          setState(() => _isKickoffOpen = false);
                          widget.onReturnToGamingMode();
                        },
                      ),
                      _buildKickoffItem(
                        icon: CupertinoIcons.app_badge_fill,
                        iconColor: const Color(0xFF67C1F5),
                        title: 'Steam (스팀 클라이언트)',
                        desc: '게임 상점, 커뮤니티, 라이브러리 실행',
                        onTap: () {
                          setState(() => _isKickoffOpen = false);
                          widget.onOpenTemplate('steam');
                        },
                      ),
                      _buildKickoffItem(
                        icon: CupertinoIcons.gear_alt_fill,
                        iconColor: Colors.white70,
                        title: '시스템 설정 (System Settings)',
                        desc: '화면, 사운드, 네트워크 및 OS 환경설정',
                        onTap: () {
                          setState(() => _isKickoffOpen = false);
                          widget.onOpenSettings();
                        },
                      ),
                      if (widget.onSelectOs != null) ...[
                        _buildKickoffItem(
                          icon: CupertinoIcons.device_desktop,
                          iconColor: const Color(0xFF0078D7),
                          title: 'Windows 11로 전환',
                          desc: 'Windows 11 가상 데스크톱 환경으로 이동',
                          onTap: () {
                            setState(() => _isKickoffOpen = false);
                            widget.onSelectOs!('windows_11');
                          },
                        ),
                        _buildKickoffItem(
                          icon: CupertinoIcons.device_laptop,
                          iconColor: const Color(0xFFA855F7),
                          title: 'macOS로 전환',
                          desc: 'macOS Sequoia 가상 데스크톱 환경으로 이동',
                          onTap: () {
                            setState(() => _isKickoffOpen = false);
                            widget.onSelectOs!('macos');
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                // Bottom Power Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0C0F17),
                    border: Border(top: BorderSide(color: Colors.white10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => _isKickoffOpen = false);
                          widget.onGoHome();
                        },
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.house_fill, color: Colors.white70, size: 15),
                            SizedBox(width: 6),
                            Text('메인 홈', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() => _isKickoffOpen = false);
                          widget.onSignOut();
                        },
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.square_arrow_left, color: Colors.white70, size: 15),
                            SizedBox(width: 6),
                            Text('로그아웃', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKickoffItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      hoverColor: const Color(0xFF1A9FFF).withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
