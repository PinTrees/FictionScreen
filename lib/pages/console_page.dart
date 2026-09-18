import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';

class ConsolePage extends StatefulWidget {
  const ConsolePage({super.key});

  @override
  State<ConsolePage> createState() => _ConsolePageState();
}

class _ConsolePageState extends State<ConsolePage> {
  // PC OS 테마: 'windows' vs 'macos'
  String _pcTheme = 'windows';
  // 모바일 OS 테마: 'ios' vs 'galaxy'
  String _mobileTheme = 'ios';

  bool _isStartMenuOpen = false;
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _openTemplate(String templateId) {
    setState(() => _isStartMenuOpen = false);
    context.push('/studio/$templateId');
  }

  Future<void> _handleSignOut() async {
    await AuthService.signOut();
    if (mounted) {
      context.go('/');
    }
  }

  String _formatDate(String pattern, [String? locale]) {
    try {
      return DateFormat(pattern, locale).format(_now);
    } catch (_) {
      try {
        return DateFormat(pattern).format(_now);
      } catch (_) {
        return '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768;

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: AuthService.authStateChanges,
        builder: (context, snapshot) {
          final user = snapshot.data ?? AuthService.currentUser;

          if (isDesktop) {
            return _buildDesktopOS(user);
          } else {
            return _buildMobileOS(user);
          }
        },
      ),
    );
  }

  // =========================================================
  // 1. 데스크톱 OS 뷰 (Windows 11 / macOS)
  // =========================================================
  Widget _buildDesktopOS(User? user) {
    return Stack(
      children: [
        // 1-1. 배경화면
        Positioned.fill(
          child: _pcTheme == 'windows'
              ? _buildWindowsWallpaper()
              : _buildMacWallpaper(),
        ),

        // 1-2. macOS 전용 상단 메뉴바
        if (_pcTheme == 'macos')
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildMacMenuBar(user),
          ),

        // 1-3. 바탕화면 아이콘 그리드
        Positioned(
          top: _pcTheme == 'macos' ? 44 : 24,
          left: 24,
          bottom: 72,
          width: 90,
          child: _buildDesktopIconGrid(),
        ),

        // 1-4. OS 전환 스위치 (우측 상단 플로팅)
        Positioned(
          top: _pcTheme == 'macos' ? 40 : 20,
          right: 20,
          child: _buildOsThemeSwitcher(
            currentTheme: _pcTheme,
            options: const [
              {'id': 'windows', 'label': 'Windows 11'},
              {'id': 'macos', 'label': 'macOS Sequoia'},
            ],
            onChanged: (val) => setState(() => _pcTheme = val),
          ),
        ),

        // 1-5. Windows 시작 메뉴 팝업
        if (_pcTheme == 'windows' && _isStartMenuOpen)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: _buildWindowsStartMenu(user),
            ),
          ),

        // 1-6. 하단 독 / 작업표시줄
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _pcTheme == 'windows'
              ? _buildWindowsTaskbar(user)
              : _buildMacDock(),
        ),
      ],
    );
  }

  // Windows 11 시그니처 블룸 배경
  Widget _buildWindowsWallpaper() {
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

  // macOS 시그니처 오로라 배경
  Widget _buildMacWallpaper() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1B4B),
            Color(0xFF311042),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 100,
            left: 200,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFF43F5E).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 바탕화면 앱 아이콘들
  Widget _buildDesktopIconGrid() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDesktopIcon(
            title: '카카오톡',
            icon: CupertinoIcons.chat_bubble_2_fill,
            color: const Color(0xFFFEE500),
            onTap: () => _openTemplate('kakaotalk'),
          ),
          const SizedBox(height: 18),
          _buildDesktopIcon(
            title: '블루스크린',
            icon: CupertinoIcons.device_desktop,
            color: const Color(0xFF0078D7),
            onTap: () => _openTemplate('windows_bsod'),
          ),
          const SizedBox(height: 18),
          _buildDesktopIcon(
            title: 'YouTube',
            icon: CupertinoIcons.play_arrow_solid,
            color: const Color(0xFFFF0000),
            onTap: () => _openTemplate('youtube'),
          ),
          const SizedBox(height: 18),
          _buildDesktopIcon(
            title: 'Instagram',
            icon: CupertinoIcons.camera_fill,
            color: const Color(0xFFE1306C),
            onTap: () => _openTemplate('instagram'),
          ),
          const SizedBox(height: 18),
          _buildDesktopIcon(
            title: '배달의민족',
            icon: CupertinoIcons.bag_fill,
            color: const Color(0xFF2AC1BC),
            onTap: () => _openTemplate('delivery'),
          ),
          const SizedBox(height: 18),
          _buildDesktopIcon(
            title: '랜딩 홈',
            icon: CupertinoIcons.house_fill,
            color: Colors.white70,
            onTap: () => context.go('/'),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopIcon({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onDoubleTap: onTap,
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      hoverColor: Colors.white.withValues(alpha: 0.1),
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 1)),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Windows 11 하단 작업표시줄
  Widget _buildWindowsTaskbar(User? user) {
    final timeStr = _formatDate('a h:mm', 'ko_KR');
    final dateStr = _formatDate('yyyy-MM-dd');

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF1E212B).withValues(alpha: 0.85),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
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

                // 중앙 정렬된 앱 런처 아이콘들
                Row(
                  children: [
                    // Windows 시작 로고 버튼
                    IconButton(
                      tooltip: '시작',
                      icon: Icon(
                        CupertinoIcons.square_grid_2x2_fill,
                        color: _isStartMenuOpen ? const Color(0xFF60A5FA) : Colors.white,
                        size: 22,
                      ),
                      onPressed: () => setState(() => _isStartMenuOpen = !_isStartMenuOpen),
                    ),
                    const SizedBox(width: 4),
                    _buildTaskbarAppIcon(CupertinoIcons.chat_bubble_2_fill, const Color(0xFFFEE500), () => _openTemplate('kakaotalk')),
                    _buildTaskbarAppIcon(CupertinoIcons.device_desktop, const Color(0xFF0078D7), () => _openTemplate('windows_bsod')),
                    _buildTaskbarAppIcon(CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => _openTemplate('youtube')),
                    _buildTaskbarAppIcon(CupertinoIcons.camera_fill, const Color(0xFFE1306C), () => _openTemplate('instagram')),
                    _buildTaskbarAppIcon(CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), () => _openTemplate('delivery')),
                  ],
                ),

                const Spacer(),

                // 우측 시스템 트레이
                Row(
                  children: [
                    const Icon(CupertinoIcons.wifi, size: 16, color: Colors.white70),
                    const SizedBox(width: 8),
                    const Icon(CupertinoIcons.volume_up, size: 16, color: Colors.white70),
                    const SizedBox(width: 8),
                    const Icon(CupertinoIcons.battery_charging, size: 16, color: Colors.white70),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(timeStr, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                        Text(dateStr, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // 사용자 프로필 & 로그아웃 메뉴
                    _buildUserAvatarMenu(user),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskbarAppIcon(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20),
      hoverColor: Colors.white.withValues(alpha: 0.15),
      onPressed: onTap,
    );
  }

  // Windows 11 시작 메뉴
  Widget _buildWindowsStartMenu(User? user) {
    return Container(
      width: 520,
      height: 480,
      decoration: BoxDecoration(
        color: const Color(0xFF1C202C).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 36, offset: const Offset(0, 10)),
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
                // 검색바
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.search, size: 18, color: Colors.white60),
                      SizedBox(width: 10),
                      Text('앱, 가상 템플릿 검색...', style: TextStyle(color: Colors.white54, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text('고정됨 (Pinned Apps)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 16),

                // 고정된 앱 목록
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1.4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _buildStartMenuAppItem('카카오톡 채팅', CupertinoIcons.chat_bubble_2_fill, const Color(0xFFFEE500), () => _openTemplate('kakaotalk')),
                      _buildStartMenuAppItem('Windows 블루스크린', CupertinoIcons.device_desktop, const Color(0xFF0078D7), () => _openTemplate('windows_bsod')),
                      _buildStartMenuAppItem('유튜브 비디오/댓글', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => _openTemplate('youtube')),
                      _buildStartMenuAppItem('인스타그램 피드', CupertinoIcons.camera_fill, const Color(0xFFE1306C), () => _openTemplate('instagram')),
                      _buildStartMenuAppItem('배달의민족 배송', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), () => _openTemplate('delivery')),
                      _buildStartMenuAppItem('홈 랜딩 페이지', CupertinoIcons.house_fill, Colors.white70, () => context.go('/')),
                    ],
                  ),
                ),

                const Divider(color: Colors.white12),
                const SizedBox(height: 8),

                // 하단 프로필 바
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                      backgroundColor: const Color(0xFF6366F1),
                      child: user?.photoURL == null
                          ? Text(user?.displayName?[0] ?? 'U', style: const TextStyle(color: Colors.white, fontSize: 12))
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.displayName ?? '게스트 크리에이터', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(user?.email ?? '오프라인 모드', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: '로그아웃',
                      icon: const Icon(CupertinoIcons.power, color: Colors.white70, size: 20),
                      onPressed: _handleSignOut,
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

  Widget _buildStartMenuAppItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      hoverColor: Colors.white.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // macOS 상단 메뉴바
  Widget _buildMacMenuBar(User? user) {
    final timeStr = _formatDate('E a h:mm', 'ko_KR');

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E).withValues(alpha: 0.75),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Row(
            children: [
              const Text('', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 14),
              const Text('FictionScreen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(width: 16),
              const Text('파일', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 14),
              const Text('편집', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 14),
              const Text('보기', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 14),
              const Text('도움말', style: TextStyle(color: Colors.white70, fontSize: 12)),

              const Spacer(),

              const Icon(CupertinoIcons.battery_full, color: Colors.white70, size: 16),
              const SizedBox(width: 10),
              const Icon(CupertinoIcons.wifi, color: Colors.white70, size: 14),
              const SizedBox(width: 10),
              const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white70, size: 14),
              const SizedBox(width: 12),
              Text(timeStr, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(width: 12),
              _buildUserAvatarMenu(user),
            ],
          ),
        ),
      ),
    );
  }

  // macOS 하단 플로팅 독 (Dock)
  Widget _buildMacDock() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1D2A).withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 28, offset: const Offset(0, 10)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDockItem(CupertinoIcons.chat_bubble_2_fill, const Color(0xFFFEE500), '카카오톡', () => _openTemplate('kakaotalk')),
                _buildDockItem(CupertinoIcons.device_desktop, const Color(0xFF0078D7), '블루스크린', () => _openTemplate('windows_bsod')),
                _buildDockItem(CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), 'YouTube', () => _openTemplate('youtube')),
                _buildDockItem(CupertinoIcons.camera_fill, const Color(0xFFE1306C), 'Instagram', () => _openTemplate('instagram')),
                _buildDockItem(CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), '배달의민족', () => _openTemplate('delivery')),
                Container(
                  width: 1,
                  height: 32,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                _buildDockItem(CupertinoIcons.house_fill, Colors.white70, '홈', () => context.go('/')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDockItem(IconData icon, Color color, String tooltip, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          hoverColor: Colors.white.withValues(alpha: 0.1),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // 2. 모바일 OS 뷰 (iPhone iOS / Galaxy OneUI)
  // =========================================================
  Widget _buildMobileOS(User? user) {
    return Stack(
      children: [
        // 2-1. 모바일 배경화면
        Positioned.fill(
          child: _mobileTheme == 'ios'
              ? _buildIosWallpaper()
              : _buildGalaxyWallpaper(),
        ),

        // 2-2. 상단 상태바 & 노치
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildMobileStatusBar(),
        ),

        // 2-3. 모바일 테마 스위처 (우측 상단)
        Positioned(
          top: 44,
          right: 16,
          child: _buildOsThemeSwitcher(
            currentTheme: _mobileTheme,
            options: const [
              {'id': 'ios', 'label': 'iPhone (iOS)'},
              {'id': 'galaxy', 'label': 'Galaxy (OneUI)'},
            ],
            onChanged: (val) => setState(() => _mobileTheme = val),
          ),
        ),

        // 2-4. 홈 화면 콘텐츠 (시계 위젯 + 앱 아이콘 그리드)
        Positioned.fill(
          top: 80,
          bottom: 110,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // 시계 위젯
                _buildMobileClockWidget(),
                const SizedBox(height: 36),

                // 앱 아이콘 그리드
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    children: [
                      _buildMobileAppIcon('카카오톡', CupertinoIcons.chat_bubble_2_fill, const Color(0xFFFEE500), Colors.black, () => _openTemplate('kakaotalk')),
                      _buildMobileAppIcon('블루스크린', CupertinoIcons.device_desktop, const Color(0xFF0078D7), Colors.white, () => _openTemplate('windows_bsod')),
                      _buildMobileAppIcon('YouTube', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), Colors.white, () => _openTemplate('youtube')),
                      _buildMobileAppIcon('Instagram', CupertinoIcons.camera_fill, const Color(0xFFE1306C), Colors.white, () => _openTemplate('instagram')),
                      _buildMobileAppIcon('배달의민족', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), Colors.white, () => _openTemplate('delivery')),
                      _buildMobileAppIcon('랜딩 홈', CupertinoIcons.house_fill, const Color(0xFF334155), Colors.white, () => context.go('/')),
                      _buildMobileAppIcon('로그아웃', CupertinoIcons.square_arrow_right, const Color(0xFFEF4444), Colors.white, _handleSignOut),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2-5. 하단 독 (Dock) 및 홈 바
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildMobileBottomDock(),
        ),
      ],
    );
  }

  Widget _buildIosWallpaper() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E2640),
            Color(0xFF2E1C38),
            Color(0xFF10121C),
          ],
        ),
      ),
    );
  }

  Widget _buildGalaxyWallpaper() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.4, -0.4),
          radius: 1.4,
          colors: [
            Color(0xFF1E3A5F),
            Color(0xFF0F172A),
            Color(0xFF08090E),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileStatusBar() {
    final timeStr = _formatDate('H:mm');

    return SafeArea(
      bottom: false,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(timeStr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            // Dynamic Island Pill
            if (_mobileTheme == 'ios')
              Container(
                width: 90,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            const Row(
              children: [
                Icon(CupertinoIcons.antenna_radiowaves_left_right, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Icon(CupertinoIcons.wifi, color: Colors.white, size: 15),
                SizedBox(width: 4),
                Icon(CupertinoIcons.battery_full, color: Colors.white, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileClockWidget() {
    final timeStr = _formatDate('h:mm');
    final dateStr = _formatDate('M월 d일 EEEE', 'ko_KR');

    return Column(
      children: [
        Text(
          dateStr,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          timeStr,
          style: TextStyle(
            color: Colors.white,
            fontSize: _mobileTheme == 'ios' ? 68 : 56,
            fontWeight: FontWeight.w800,
            letterSpacing: -2,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileAppIcon(String label, IconData icon, Color bg, Color fg, VoidCallback onTap) {
    final isIos = _mobileTheme == 'ios';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isIos ? 16 : 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(isIos ? 14 : 22),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Icon(icon, color: fg, size: 30),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 1)),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBottomDock() {
    final isIos = _mobileTheme == 'ios';
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(isIos ? 30 : 20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isIos ? 30 : 20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDockIconButton(CupertinoIcons.phone_fill, const Color(0xFF10B981), () {}),
                    _buildDockIconButton(CupertinoIcons.chat_bubble_2_fill, const Color(0xFFFEE500), () => _openTemplate('kakaotalk')),
                    _buildDockIconButton(CupertinoIcons.camera_fill, const Color(0xFFE1306C), () => _openTemplate('instagram')),
                    _buildDockIconButton(CupertinoIcons.compass, const Color(0xFF38BDF8), () => context.go('/')),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // iOS 홈 인디케이터 바
          Container(
            width: 120,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDockIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color == const Color(0xFFFEE500) ? Colors.black : Colors.white, size: 24),
      ),
    );
  }

  // OS 테마 전환 스위치 (Windows ↔ Mac / iPhone ↔ Galaxy)
  Widget _buildOsThemeSwitcher({
    required String currentTheme,
    required List<Map<String, String>> options,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF131520).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isSelected = currentTheme == opt['id'];
          return InkWell(
            onTap: () => onChanged(opt['id']!),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                opt['label']!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 사용자 아바타 팝업 메뉴
  Widget _buildUserAvatarMenu(User? user) {
    return PopupMenuButton<String>(
      color: const Color(0xFF1E212B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white12),
      ),
      offset: const Offset(0, 36),
      child: CircleAvatar(
        radius: 13,
        backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
        backgroundColor: const Color(0xFF6366F1),
        child: user?.photoURL == null
            ? Text(user?.displayName?[0] ?? 'U', style: const TextStyle(color: Colors.white, fontSize: 10))
            : null,
      ),
      onSelected: (val) {
        if (val == 'signout') {
          _handleSignOut();
        } else if (val == 'home') {
          context.go('/');
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.displayName ?? '사용자', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(user?.email ?? '', style: const TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'home',
          child: Row(
            children: [
              Icon(CupertinoIcons.house_fill, size: 16, color: Colors.white70),
              SizedBox(width: 8),
              Text('랜딩 홈으로 이동', style: TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'signout',
          child: Row(
            children: [
              Icon(CupertinoIcons.square_arrow_right, size: 16, color: Color(0xFFEF4444)),
              SizedBox(width: 8),
              Text('로그아웃', style: TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

// Windows 11 꽃잎(Petal) 그래픽 페인터
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
