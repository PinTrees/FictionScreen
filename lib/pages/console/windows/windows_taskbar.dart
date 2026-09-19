import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/scale_button.dart';

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
    if (windowsVersion == 'xp') {
      return _buildWinXpTaskbar();
    } else if (windowsVersion == '7') {
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
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleButton(
                          pressedScale: 0.86,
                          onTap: onToggleStartMenu,
                          child: IconButton(
                            tooltip: '시작 (Windows 11)',
                            icon: Icon(
                              CupertinoIcons.square_grid_2x2_fill,
                              color: isStartMenuOpen ? const Color(0xFF60A5FA) : Colors.white,
                              size: 22,
                            ),
                            onPressed: onToggleStartMenu,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Windows 11 순정 핵심 기본 앱
                        _buildTaskbarIcon(null, Colors.transparent, '파일 탐색기', () => onOpenWinApp?.call('file_explorer'), imageAsset: 'assets/images/windows/explorer.png'),
                        _buildTaskbarIcon(null, Colors.transparent, '설정', () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings()), imageAsset: 'assets/images/windows/settings/System.webp'),
                        _buildTaskbarIcon(null, Colors.transparent, 'Edge', () => onOpenWinApp?.call('edge'), imageAsset: 'assets/images/windows/edge.png'),
                        _buildTaskbarIcon(null, Colors.transparent, 'Chrome', () => onOpenWinApp?.call('chrome'), imageAsset: 'assets/images/windows/chrome.png'),
                        _buildTaskbarIcon(null, Colors.transparent, '직방', () => onOpenWinApp?.call('zigbang'), imageAsset: 'assets/images/zigbang_icon.webp'),
                        _buildTaskbarIcon(null, Colors.transparent, '네이버', () => onOpenWinApp?.call('naver'), imageAsset: 'assets/images/naver_icon.webp'),
                        _buildTaskbarIcon(null, Colors.transparent, '메모장', () => onOpenWinApp?.call('notepad'), imageAsset: 'assets/images/windows/notepad.png'),
                        _buildTaskbarIcon(null, Colors.transparent, '계산기', () => onOpenWinApp?.call('calculator'), imageAsset: 'assets/images/windows/calc.png'),
                        // 프로 크리에이티브 & 개발 툴
                        _buildTaskbarIcon(null, const Color(0xFFE53935), 'DaVinci Resolve', () => onOpenTemplate('davinci_resolve'), imageAsset: 'assets/images/davinci_resolve_icon.webp'),
                        _buildTaskbarIcon(null, const Color(0xFF68217A), 'Visual Studio 2026', () => onOpenTemplate('visual_studio'), imageAsset: 'assets/images/visual_studio_icon.webp'),
                        _buildTaskbarIcon(null, const Color(0xFF31A8FF), 'Photoshop 2026', () => onOpenTemplate('photoshop'), imageAsset: 'assets/images/photoshop_icon.webp'),
                        _buildTaskbarIcon(null, const Color(0xFF5865F2), 'Discord', () => onOpenTemplate('discord'), imageAsset: 'assets/images/discord_icon.webp'),
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
                  ),
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
                Icon(CupertinoIcons.search, color: Colors.white60, size: 16),
                SizedBox(width: 8),
                Text(
                  '검색하려면 여기에 입력하십시오.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTaskbarIcon(null, Colors.transparent, 'Edge', () => onOpenWinApp?.call('edge'), imageAsset: 'assets/images/windows/edge.png'),
                  _buildTaskbarIcon(null, Colors.transparent, 'Chrome', () => onOpenWinApp?.call('chrome'), imageAsset: 'assets/images/windows/chrome.png'),
                  _buildTaskbarIcon(null, Colors.transparent, '직방', () => onOpenWinApp?.call('zigbang'), imageAsset: 'assets/images/zigbang_icon.webp'),
                  _buildTaskbarIcon(null, Colors.transparent, '네이버', () => onOpenWinApp?.call('naver'), imageAsset: 'assets/images/naver_icon.webp'),
                  _buildTaskbarIcon(null, const Color(0xFFFEE500), '카카오톡', () => onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
                  _buildTaskbarIcon(null, const Color(0xFFE53935), 'DaVinci Resolve', () => onOpenTemplate('davinci_resolve'), imageAsset: 'assets/images/davinci_resolve_icon.webp'),
                  _buildTaskbarIcon(null, const Color(0xFF68217A), 'Visual Studio 2026', () => onOpenTemplate('visual_studio'), imageAsset: 'assets/images/visual_studio_icon.webp'),
                  _buildTaskbarIcon(null, const Color(0xFF31A8FF), 'Photoshop 2026', () => onOpenTemplate('photoshop'), imageAsset: 'assets/images/photoshop_icon.webp'),
                  _buildTaskbarIcon(null, const Color(0xFF5865F2), 'Discord', () => onOpenTemplate('discord'), imageAsset: 'assets/images/discord_icon.webp'),
                  _buildTaskbarIcon(CupertinoIcons.device_desktop, const Color(0xFF0078D7), '블루스크린', () => onOpenTemplate('windows_bsod')),
                  _buildTaskbarIcon(CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), 'YouTube', () => onOpenTemplate('youtube')),
                  _buildTaskbarIcon(null, const Color(0xFFE1306C), 'Instagram', () => onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
                  _buildTaskbarIcon(null, const Color(0xFFC72424), '쿠팡', () => onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
                  _buildTaskbarIcon(null, const Color(0xFFE50914), 'Netflix', () => onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
                  _buildTaskbarIcon(null, const Color(0xFF0066B3), '동행복권', () => onOpenTemplate('lottery'), imageAsset: 'assets/images/lottery_icon.webp'),
                  _buildTaskbarIcon(CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), '배달의민족', () => onOpenTemplate('delivery')),
                  _buildTaskbarIcon(CupertinoIcons.gear_alt_fill, const Color(0xFF94A3B8), '설정', () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings())),
                ],
              ),
            ),
          ),
          _buildSystemTray(),
        ],
      ),
    );
  }

  // Windows 7: 클래식 에어로 글래스
  Widget _buildWin7Taskbar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2B5885).withValues(alpha: 0.85),
            const Color(0xFF1B3A5A).withValues(alpha: 0.75),
          ],
        ),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.45), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Row(
            children: [
              // 시작 구슬(3D Start Orb)
              _Win7StartOrbWidget(
                isStartMenuOpen: isStartMenuOpen,
                onTap: onToggleStartMenu,
              ),
              const SizedBox(width: 6),

              // 작업표시줄 아이콘들
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTaskbarIcon(null, const Color(0xFF0078D7), '파일 탐색기', () => onOpenWinApp?.call('file_explorer'), imageAsset: 'assets/images/windows/explorer.png'),
                      _buildTaskbarIcon(null, const Color(0xFF0078D7), 'Internet Explorer', () => onOpenWinApp?.call('edge'), imageAsset: 'assets/images/windows/edge.png'),
                      _buildTaskbarIcon(null, const Color(0xFF4285F4), 'Chrome', () => onOpenWinApp?.call('chrome'), imageAsset: 'assets/images/windows/chrome.png'),
                      _buildTaskbarIcon(null, Colors.transparent, '직방', () => onOpenWinApp?.call('zigbang'), imageAsset: 'assets/images/zigbang_icon.webp'),
                      _buildTaskbarIcon(null, Colors.transparent, '네이버', () => onOpenWinApp?.call('naver'), imageAsset: 'assets/images/naver_icon.webp'),
                      _buildTaskbarIcon(null, const Color(0xFFE53935), 'Windows Media Player', () => onOpenTemplate('youtube'), imageAsset: 'assets/images/windows/vid.png'),
                      _buildTaskbarIcon(null, const Color(0xFFFEE500), '카카오톡', () => onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
                      _buildTaskbarIcon(null, const Color(0xFFE53935), 'DaVinci Resolve', () => onOpenTemplate('davinci_resolve'), imageAsset: 'assets/images/davinci_resolve_icon.webp'),
                      _buildTaskbarIcon(null, const Color(0xFF68217A), 'Visual Studio 2026', () => onOpenTemplate('visual_studio'), imageAsset: 'assets/images/visual_studio_icon.webp'),
                      _buildTaskbarIcon(null, const Color(0xFF31A8FF), 'Photoshop 2026', () => onOpenTemplate('photoshop'), imageAsset: 'assets/images/photoshop_icon.webp'),
                      _buildTaskbarIcon(null, const Color(0xFF5865F2), 'Discord', () => onOpenTemplate('discord'), imageAsset: 'assets/images/discord_icon.webp'),
                      _buildTaskbarIcon(CupertinoIcons.device_desktop, const Color(0xFF0078D7), '블루스크린', () => onOpenTemplate('windows_bsod')),
                      _buildTaskbarIcon(CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), 'YouTube', () => onOpenTemplate('youtube')),
                      _buildTaskbarIcon(null, const Color(0xFFE1306C), 'Instagram', () => onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
                      _buildTaskbarIcon(null, const Color(0xFFC72424), '쿠팡', () => onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
                      _buildTaskbarIcon(null, const Color(0xFFE50914), 'Netflix', () => onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
                      _buildTaskbarIcon(null, const Color(0xFF0066B3), '동행복권', () => onOpenTemplate('lottery'), imageAsset: 'assets/images/lottery_icon.webp'),
                      _buildTaskbarIcon(CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), '배달의민족', () => onOpenTemplate('delivery')),
                      _buildTaskbarIcon(CupertinoIcons.gear_alt_fill, const Color(0xFF94A3B8), '설정', () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings())),
                    ],
                  ),
                ),
              ),

              // 시스템 트레이
              _buildSystemTray(),

              // Windows 7 시그니처 Aero Peek (바탕 화면 보기) 바
              Tooltip(
                message: '바탕 화면 보기 (Aero Peek)',
                child: Container(
                  width: 14,
                  height: 40,
                  margin: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.white.withValues(alpha: 0.35))),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white.withValues(alpha: 0.25), Colors.white.withValues(alpha: 0.05)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Windows XP: 루나 블루 & 그린 스타트 버튼 작업표시줄
  Widget _buildWinXpTaskbar() {
    return Container(
      height: 30,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF245DDA),
            Color(0xFF3F8CFF),
            Color(0xFF245DDA),
            Color(0xFF0038A8),
          ],
          stops: [0.0, 0.08, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. 시그니처 초록색 시작(start) 단추
          InkWell(
            onTap: onToggleStartMenu,
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isStartMenuOpen
                      ? const [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)]
                      : const [Color(0xFF4CAF50), Color(0xFF43A047), Color(0xFF2E7D32), Color(0xFF1B5E20)],
                  stops: isStartMenuOpen ? null : const [0.0, 0.15, 0.85, 1.0],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF1B5E20),
                    blurRadius: 2,
                    offset: Offset(1, 0),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(CupertinoIcons.flag_fill, size: 14, color: Color(0xFFFFD54F)),
                  SizedBox(width: 6),
                  Text(
                    '시작',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      color: Colors.white,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.black87, blurRadius: 3, offset: Offset(1, 1)),
                      ],
                    ),
                  ),
                  SizedBox(width: 4),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),

          // 2. 빠른 실행 (Quick Launch)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                _buildXpQuickIcon('assets/images/windows/desk.png', '바탕 화면 보기', () {}),
                _buildXpQuickIcon('assets/images/windows/edge.png', 'Internet Explorer', () => onOpenWinApp?.call('edge')),
                _buildXpQuickIcon('assets/images/windows/chrome.png', 'Chrome', () => onOpenWinApp?.call('chrome')),
                _buildXpQuickIcon('assets/images/windows/vid.png', 'Windows Media Player', () => onOpenTemplate('youtube')),
              ],
            ),
          ),

          // 3. 실행 중인 작업 표시줄 탭 목록
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildXpTaskbarTab('내 컴퓨터', 'assets/images/windows/this_pc.png', () => onOpenWinApp?.call('file_explorer')),
                  _buildXpTaskbarTab('3D 핀볼', 'assets/images/windows/desk.png', () => onOpenWinApp?.call('pinball')),
                  _buildXpTaskbarTab('지뢰찾기', 'assets/images/windows/desk.png', () => onOpenWinApp?.call('minesweeper')),
                  _buildXpTaskbarTab('그림판', 'assets/images/windows/mspaint.png', () => onOpenWinApp?.call('paint')),
                  _buildXpTaskbarTab('메모장', 'assets/images/windows/notepad.png', () => onOpenWinApp?.call('notepad')),
                  _buildXpTaskbarTab('계산기', 'assets/images/windows/calc.png', () => onOpenWinApp?.call('calculator')),
                  _buildXpTaskbarTab('PDF 서식 스튜디오', 'assets/images/windows/docs.png', () => onOpenWinApp?.call('pdf_viewer')),
                  _buildXpTaskbarTab('Telegram', 'assets/images/windows/desk.png', () => onOpenWinApp?.call('telegram')),
                  _buildXpTaskbarTab('직방', 'assets/images/zigbang_icon.webp', () => onOpenWinApp?.call('zigbang')),
                  _buildXpTaskbarTab('네이버', 'assets/images/naver_icon.webp', () => onOpenWinApp?.call('naver')),
                  _buildXpTaskbarTab('카카오톡', 'assets/images/kakaotalk_icon.webp', () => onOpenTemplate('kakaotalk')),
                  _buildXpTaskbarTab('DaVinci Resolve', 'assets/images/davinci_resolve_icon.webp', () => onOpenTemplate('davinci_resolve')),
                ],
              ),
            ),
          ),

          // 4. Windows XP 스카이블루 알림 영역 (트레이)
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F88EA),
                  Color(0xFF1E9BFF),
                  Color(0xFF0F88EA),
                  Color(0xFF0C62B0),
                ],
                stops: [0.0, 0.1, 0.5, 1.0],
              ),
              border: Border(
                left: BorderSide(color: Color(0xFF175DB8), width: 1.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.speaker_2_fill, size: 13, color: Colors.white),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.wifi, size: 13, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  timeString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpQuickIcon(String asset, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Image.asset(asset, width: 16, height: 16, errorBuilder: (c, e, s) => const Icon(CupertinoIcons.app, size: 16, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildXpTaskbarTab(String title, String asset, VoidCallback onTap) {
    return Container(
      width: 130,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF3886DF),
        borderRadius: BorderRadius.circular(2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3886DF), Color(0xFF1E52BA), Color(0xFF174298)],
        ),
        border: Border.all(color: const Color(0xFF153B8C)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 1),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Image.asset(asset, width: 14, height: 14, errorBuilder: (c, e, s) => const Icon(CupertinoIcons.app, size: 14, color: Colors.white)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
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
    return ScaleButton(
      pressedScale: 0.86,
      onTap: onTap,
      child: Tooltip(
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

/// Windows 7 시그니처 3D 에어로 시작 구슬 (Start Orb)
class _Win7StartOrbWidget extends StatefulWidget {
  final bool isStartMenuOpen;
  final VoidCallback onTap;

  const _Win7StartOrbWidget({
    required this.isStartMenuOpen,
    required this.onTap,
  });

  @override
  State<_Win7StartOrbWidget> createState() => _Win7StartOrbWidgetState();
}

class _Win7StartOrbWidgetState extends State<_Win7StartOrbWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.isStartMenuOpen || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 42,
          height: 40,
          margin: const EdgeInsets.only(left: 4),
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                // 외부 청백색 에어로 발광 헤일로
                BoxShadow(
                  color: isActive
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.85)
                      : const Color(0xFF1E3A5F).withValues(alpha: 0.4),
                  blurRadius: isActive ? 12 : 5,
                  spreadRadius: isActive ? 2 : 0,
                ),
                if (isActive)
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.7),
                    blurRadius: 6,
                  ),
              ],
              border: Border.all(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.9)
                    : const Color(0xFF90C4EC).withValues(alpha: 0.6),
                width: 1.5,
              ),
              gradient: RadialGradient(
                center: const Alignment(-0.25, -0.35),
                radius: 0.85,
                colors: isActive
                    ? [
                        const Color(0xFF5DB8FF),
                        const Color(0xFF2879C5),
                        const Color(0xFF0F3B6E),
                        const Color(0xFF071E3A),
                      ]
                    : [
                        const Color(0xFF4A9CD9),
                        const Color(0xFF1F5C98),
                        const Color(0xFF0E2C52),
                        const Color(0xFF051428),
                      ],
                stops: const [0.0, 0.45, 0.8, 1.0],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 상단 반사광 (Specular reflection)
                Positioned(
                  top: 2,
                  child: Container(
                    width: 22,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.75),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ),

                // 중앙 Windows 4색 깃발 (Windows 7 Pearl Flag Emblem)
                Transform.rotate(
                  angle: -0.12,
                  child: SizedBox(
                    width: 17,
                    height: 17,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFlagQuarter(const Color(0xFFF25022), const Radius.circular(3), const Radius.circular(1)),
                            const SizedBox(width: 1.5),
                            _buildFlagQuarter(const Color(0xFF7FBA00), const Radius.circular(1), const Radius.circular(3)),
                          ],
                        ),
                        const SizedBox(height: 1.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFlagQuarter(const Color(0xFF00A4EF), const Radius.circular(1), const Radius.circular(3)),
                            const SizedBox(width: 1.5),
                            _buildFlagQuarter(const Color(0xFFFFB900), const Radius.circular(3), const Radius.circular(1)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlagQuarter(Color color, Radius topLeft, Radius bottomRight) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.95),
            color,
            color.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: topLeft,
          bottomRight: bottomRight,
          topRight: const Radius.circular(1),
          bottomLeft: const Radius.circular(1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 1,
            offset: const Offset(0.5, 0.5),
          ),
        ],
      ),
    );
  }
}
