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
  Offset? _contextMenuPosition;
  bool _isOsSubmenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isKickoffOpen) setState(() => _isKickoffOpen = false);
        if (_selectedIconId != null) setState(() => _selectedIconId = null);
        if (_contextMenuPosition != null) {
          setState(() {
            _contextMenuPosition = null;
            _isOsSubmenuOpen = false;
          });
        }
      },
      onSecondaryTapDown: (details) {
        setState(() {
          _contextMenuPosition = details.localPosition;
          _isOsSubmenuOpen = false;
          _isKickoffOpen = false;
        });
      },
      child: Container(
        // Authentic Valve SteamOS KDE Plasma Official Wallpaper
        decoration: const BoxDecoration(
          color: Color(0xFF090D14),
          image: DecorationImage(
            image: AssetImage('assets/images/steamos_desktop.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
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
                    imageAsset: 'assets/images/steamdeck_return.png',
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
                    imageAsset: 'assets/images/steamos_logo.png',
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

            // 4. KDE Plasma Desktop Context Menu (Right Click)
            if (_contextMenuPosition != null)
              Positioned.fill(
                child: _buildDesktopContextMenu(context),
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
    String? imageAsset,
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
              padding: const EdgeInsets.all(6),
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
                child: imageAsset != null
                    ? Image.asset(imageAsset, width: 30, height: 30, fit: BoxFit.contain)
                    : Icon(icon, color: iconColor, size: 24),
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
                  Image.asset('assets/images/steamdeck_icon.png', width: 22, height: 22),
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
          _buildTaskbarPinnedIcon(
            imageAsset: 'assets/images/steamdeck_return.png',
            tooltip: 'Return to Gaming Mode',
            onTap: widget.onReturnToGamingMode,
          ),
          _buildTaskbarPinnedIcon(
            imageAsset: 'assets/images/steamos_logo.png',
            tooltip: 'Steam',
            onTap: () => widget.onOpenTemplate('steam'),
          ),
          _buildTaskbarPinnedIcon(
            icon: CupertinoIcons.folder_fill,
            iconColor: const Color(0xFF38BDF8),
            tooltip: 'Dolphin File Manager',
            onTap: () => widget.onOpenTemplate('excel'),
          ),
          _buildTaskbarPinnedIcon(
            icon: CupertinoIcons.chevron_left_slash_chevron_right,
            iconColor: const Color(0xFF10B981),
            tooltip: 'Konsole Terminal',
            onTap: () => widget.onOpenTemplate('dcinside'),
          ),

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

  Widget _buildTaskbarPinnedIcon({
    IconData? icon,
    String? imageAsset,
    Color iconColor = Colors.white,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 44,
          alignment: Alignment.center,
          child: imageAsset != null
              ? Image.asset(imageAsset, width: 20, height: 20, fit: BoxFit.contain)
              : Icon(icon, color: iconColor, size: 19),
        ),
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

  // ==========================================
  // KDE Plasma Desktop Context Menu
  // ==========================================
  Widget _buildDesktopContextMenu(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double menuLeft = (_contextMenuPosition?.dx ?? 100).clamp(10.0, screenSize.width - 240.0);
    final double menuTop = (_contextMenuPosition?.dy ?? 100).clamp(10.0, screenSize.height - 360.0);

    final bool openOsSubmenuRight = (menuLeft + 230 + 220) < screenSize.width;
    final double osSubmenuLeft = openOsSubmenuRight ? (menuLeft + 224) : (menuLeft - 215);
    final double osSubmenuTop = (menuTop + 40).clamp(10.0, screenSize.height - 380.0);

    return Stack(
      children: [
        // External tap dismiss
        Positioned.fill(
          child: GestureDetector(
            onTap: () => setState(() {
              _contextMenuPosition = null;
              _isOsSubmenuOpen = false;
            }),
            onSecondaryTap: () => setState(() {
              _contextMenuPosition = null;
              _isOsSubmenuOpen = false;
            }),
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),

        // Context Menu Main Body
        Positioned(
          left: menuLeft,
          top: menuTop,
          child: Container(
            width: 230,
            decoration: BoxDecoration(
              color: const Color(0xFF141923).withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Return to Gaming Mode
                      _buildContextMenuItem(
                        label: '게임 모드로 복귀',
                        imageAsset: 'assets/images/steamdeck_return.png',
                        isHighlight: true,
                        onTap: () {
                          setState(() {
                            _contextMenuPosition = null;
                            _isOsSubmenuOpen = false;
                          });
                          widget.onReturnToGamingMode();
                        },
                      ),
                      const Divider(color: Colors.white12, height: 8),

                      // Switch OS submenu trigger
                      MouseRegion(
                        onEnter: (_) => setState(() => _isOsSubmenuOpen = true),
                        child: _buildContextMenuItem(
                          label: '운영체제 전환 (OS)',
                          icon: CupertinoIcons.device_desktop,
                          trailing: '›',
                          onTap: () => setState(() => _isOsSubmenuOpen = !_isOsSubmenuOpen),
                        ),
                      ),
                      const Divider(color: Colors.white12, height: 8),

                      // Refresh
                      _buildContextMenuItem(
                        label: '새로 고침',
                        icon: CupertinoIcons.arrow_clockwise,
                        onTap: () {
                          setState(() {
                            _contextMenuPosition = null;
                            _isOsSubmenuOpen = false;
                          });
                        },
                      ),

                      // Open Konsole
                      _buildContextMenuItem(
                        label: '터미널 열기 (Konsole)',
                        icon: CupertinoIcons.chevron_left_slash_chevron_right,
                        iconColor: const Color(0xFF10B981),
                        onTap: () {
                          setState(() {
                            _contextMenuPosition = null;
                            _isOsSubmenuOpen = false;
                          });
                          widget.onOpenTemplate('dcinside');
                        },
                      ),

                      // Desktop Settings
                      _buildContextMenuItem(
                        label: '바탕화면 및 환경설정',
                        icon: CupertinoIcons.slider_horizontal_3,
                        onTap: () {
                          setState(() {
                            _contextMenuPosition = null;
                            _isOsSubmenuOpen = false;
                          });
                          widget.onOpenSettings();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Submenu: OS Switcher
        if (_isOsSubmenuOpen)
          Positioned(
            left: osSubmenuLeft,
            top: osSubmenuTop,
            child: Container(
              width: 215,
              decoration: BoxDecoration(
                color: const Color(0xFF121620).withValues(alpha: 0.98),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 20,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildOsSubmenuItem(
                          label: '콘솔 에디터 스튜디오',
                          icon: CupertinoIcons.slider_horizontal_3,
                          iconColor: const Color(0xFF818CF8),
                          onTap: () {
                            setState(() {
                              _contextMenuPosition = null;
                              _isOsSubmenuOpen = false;
                            });
                            widget.onSelectOs?.call('workspace');
                          },
                        ),
                        const Divider(color: Colors.white10, height: 8),
                        _buildOsSubmenuItem(
                          label: 'Windows 11',
                          imageAsset: 'assets/images/win11_logo.png',
                          onTap: () {
                            setState(() {
                              _contextMenuPosition = null;
                              _isOsSubmenuOpen = false;
                            });
                            widget.onSelectOs?.call('windows_11');
                          },
                        ),
                        _buildOsSubmenuItem(
                          label: 'Windows 10',
                          imageAsset: 'assets/images/win10_logo.png',
                          onTap: () {
                            setState(() {
                              _contextMenuPosition = null;
                              _isOsSubmenuOpen = false;
                            });
                            widget.onSelectOs?.call('windows_10');
                          },
                        ),
                        _buildOsSubmenuItem(
                          label: 'Windows 7',
                          imageAsset: 'assets/images/win7_logo.png',
                          onTap: () {
                            setState(() {
                              _contextMenuPosition = null;
                              _isOsSubmenuOpen = false;
                            });
                            widget.onSelectOs?.call('windows_7');
                          },
                        ),
                        _buildOsSubmenuItem(
                          label: 'Windows XP',
                          imageAsset: 'assets/images/winxp_logo.png',
                          onTap: () {
                            setState(() {
                              _contextMenuPosition = null;
                              _isOsSubmenuOpen = false;
                            });
                            widget.onSelectOs?.call('windows_xp');
                          },
                        ),
                        const Divider(color: Colors.white10, height: 8),
                        _buildOsSubmenuItem(
                          label: 'macOS Sequoia',
                          imageAsset: 'assets/images/apple_logo.png',
                          imageColor: Colors.white,
                          onTap: () {
                            setState(() {
                              _contextMenuPosition = null;
                              _isOsSubmenuOpen = false;
                            });
                            widget.onSelectOs?.call('macos_15');
                          },
                        ),
                        _buildOsSubmenuItem(
                          label: 'SteamOS (Steam Deck)',
                          imageAsset: 'assets/images/steamdeck_icon.png',
                          badge: '현재',
                          onTap: () {
                            setState(() {
                              _contextMenuPosition = null;
                              _isOsSubmenuOpen = false;
                            });
                          },
                        ),
                        const Divider(color: Colors.white10, height: 8),
                        _buildOsSubmenuItem(
                          label: 'Galaxy (One UI)',
                          icon: Icons.android_rounded,
                          iconColor: const Color(0xFF3DDC84),
                          onTap: () {
                            setState(() {
                              _contextMenuPosition = null;
                              _isOsSubmenuOpen = false;
                            });
                            widget.onSelectOs?.call('galaxy');
                          },
                        ),
                        _buildOsSubmenuItem(
                          label: 'iOS (iPhone 18)',
                          icon: CupertinoIcons.device_phone_portrait,
                          iconColor: Colors.white70,
                          onTap: () {
                            setState(() {
                              _contextMenuPosition = null;
                              _isOsSubmenuOpen = false;
                            });
                            widget.onSelectOs?.call('ios');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContextMenuItem({
    required String label,
    IconData? icon,
    String? imageAsset,
    Color iconColor = Colors.white70,
    String? trailing,
    bool isHighlight = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: const Color(0xFF1A9FFF).withValues(alpha: 0.18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Row(
          children: [
            if (imageAsset != null)
              Image.asset(imageAsset, width: 16, height: 16, fit: BoxFit.contain)
            else if (icon != null)
              Icon(icon, color: isHighlight ? const Color(0xFF1A9FFF) : iconColor, size: 16)
            else
              const SizedBox(width: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isHighlight ? const Color(0xFF38BDF8) : Colors.white,
                  fontSize: 12,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOsSubmenuItem({
    required String label,
    IconData? icon,
    String? imageAsset,
    Color? imageColor,
    Color iconColor = Colors.white70,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: const Color(0xFF1A9FFF).withValues(alpha: 0.18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
        child: Row(
          children: [
            if (imageAsset != null)
              Image.asset(imageAsset, width: 16, height: 16, color: imageColor, fit: BoxFit.contain)
            else if (icon != null)
              Icon(icon, color: iconColor, size: 16)
            else
              const SizedBox(width: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w500),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9FFF).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF1A9FFF).withValues(alpha: 0.6)),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Color(0xFF67C1F5), fontSize: 9.5, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
