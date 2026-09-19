import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows 7 / 10 / 11 시작 메뉴 팝업 (사용자 스크린샷 100% 1:1 완벽 구현)
class WindowsStartMenu extends StatefulWidget {
  final String windowsVersion;
  final User? user;
  final Function(String templateId) onOpenTemplate;
  final Function(String appId)? onOpenWinApp;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const WindowsStartMenu({
    super.key,
    this.windowsVersion = '11',
    required this.user,
    required this.onOpenTemplate,
    this.onOpenWinApp,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  State<WindowsStartMenu> createState() => _WindowsStartMenuState();
}

class _WindowsStartMenuState extends State<WindowsStartMenu> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.windowsVersion == 'xp') {
      return _buildWinXpStartMenu();
    } else if (widget.windowsVersion == '7') {
      return _buildWin7StartMenu();
    } else if (widget.windowsVersion == '10') {
      return _buildWin10StartMenu();
    } else {
      return _buildWin11StartMenu();
    }
  }

  // ==========================================
  // Windows 11 시작 메뉴 (중앙 플로팅, 스크린샷 1:1 완벽 구현)
  // ==========================================
  Widget _buildWin11StartMenu() {
    return Container(
      width: 640,
      height: 690,
      decoration: BoxDecoration(
        color: const Color(0xFF1E212B).withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 40,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Column(
            children: [
              // 1. 상단 검색창
              _buildWin11TopSearch(),

              // 2. 중앙 메인 스크롤 콘텐츠 (고정됨 + 맞춤 + 모두)
              Expanded(
                child: RawScrollbar(
                  thumbColor: Colors.white.withValues(alpha: 0.28),
                  thickness: 3,
                  radius: const Radius.circular(2),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: _searchQuery.isNotEmpty
                        ? _buildWin11SearchResults()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 섹션 1: 고정됨
                              _buildWin11PinnedSection(),
                              const SizedBox(height: 22),

                              // 섹션 2: 맞춤
                              _buildWin11RecommendedSection(),
                              const SizedBox(height: 22),

                              // 섹션 3: 모두 (범주 폴더 그룹)
                              _buildWin11AllSection(),
                              const SizedBox(height: 18),
                            ],
                          ),
                  ),
                ),
              ),

              // 3. 하단 계정 프로필 & 전원 버튼 바
              _buildWin11BottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // Windows 10 시작 메뉴 (좌측 고정, 타일 스타일)
  Widget _buildWin10StartMenu() {
    return Container(
      width: 560,
      height: 480,
      decoration: BoxDecoration(
        color: const Color(0xFF101216).withValues(alpha: 0.96),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 24),
        ],
      ),
      child: Row(
        children: [
          // 좌측 좁은 시스템 아이콘 바
          Container(
            width: 44,
            color: Colors.black38,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                IconButton(icon: const Icon(CupertinoIcons.bars, size: 18, color: Colors.white70), onPressed: () {}),
                const Spacer(),
                IconButton(icon: const Icon(CupertinoIcons.person_fill, size: 18, color: Colors.white70), onPressed: () {}),
                IconButton(icon: const Icon(CupertinoIcons.gear_alt_fill, size: 18, color: Colors.white70), onPressed: () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())),
                IconButton(icon: const Icon(CupertinoIcons.power, size: 18, color: Color(0xFFEF4444)), onPressed: widget.onSignOut),
              ],
            ),
          ),
          // 중앙 앱 목록
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('모든 앱', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildListTile('카카오톡 채팅', null, const Color(0xFFFEE500), () => widget.onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
                        _buildListTile('DaVinci Resolve Studio', CupertinoIcons.videocam_circle_fill, const Color(0xFFE53935), () => widget.onOpenTemplate('davinci_resolve'), imageAsset: 'assets/images/davinci_resolve_icon.webp'),
                        _buildListTile('Visual Studio 2026', CupertinoIcons.chevron_left_slash_chevron_right, const Color(0xFF68217A), () => widget.onOpenTemplate('visual_studio'), imageAsset: 'assets/images/visual_studio_icon.webp'),
                        _buildListTile('Adobe Photoshop 2026', CupertinoIcons.paintbrush_fill, const Color(0xFF31A8FF), () => widget.onOpenTemplate('photoshop'), imageAsset: 'assets/images/photoshop_icon.webp'),
                        _buildListTile('Discord 커뮤니티', CupertinoIcons.game_controller_solid, const Color(0xFF5865F2), () => widget.onOpenTemplate('discord'), imageAsset: 'assets/images/discord_icon.webp'),
                        _buildListTile('블라인드 익명 커뮤니티', CupertinoIcons.building_2_fill, const Color(0xFFDA3238), () => widget.onOpenTemplate('blind'), imageAsset: 'assets/images/blind_icon.webp'),
                        _buildListTile('업비트 가상자산', CupertinoIcons.chart_bar_alt_fill, const Color(0xFF093687), () => widget.onOpenTemplate('upbit'), imageAsset: 'assets/images/upbit_icon.webp'),
                        _buildListTile('야놀자 숙소 & 여행', CupertinoIcons.bed_double_fill, const Color(0xFFFF3478), () => widget.onOpenTemplate('yanolja'), imageAsset: 'assets/images/yanolja_icon.webp'),
                        _buildListTile('카카오뱅크 통장', CupertinoIcons.creditcard_fill, const Color(0xFFFEE500), () => widget.onOpenTemplate('kakaobank'), imageAsset: 'assets/images/kakaobank_icon.webp'),
                        _buildListTile('당근마켓 중고거래', CupertinoIcons.cart_fill, const Color(0xFFFF6F0F), () => widget.onOpenTemplate('daangn'), imageAsset: 'assets/images/daangn_icon.webp'),
                        _buildListTile('토스 (Toss)', CupertinoIcons.money_dollar_circle_fill, const Color(0xFF0050FF), () => widget.onOpenTemplate('toss')),
                        _buildListTile('X (Twitter)', CupertinoIcons.conversation_bubble, const Color(0xFF1D9BF0), () => widget.onOpenTemplate('x_twitter')),
                        _buildListTile('블루스크린 (BSOD)', CupertinoIcons.device_desktop, const Color(0xFF0078D7), () => widget.onOpenTemplate('windows_bsod')),
                        _buildListTile('YouTube 스튜디오', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => widget.onOpenTemplate('youtube')),
                        _buildListTile('Instagram 피드', null, const Color(0xFFE1306C), () => widget.onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
                        _buildListTile('쿠팡 쇼핑몰', null, const Color(0xFFC72424), () => widget.onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
                        _buildListTile('Netflix', null, const Color(0xFFE50914), () => widget.onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
                        _buildListTile('동행복권 (로또 6/45)', null, const Color(0xFF0066B3), () => widget.onOpenTemplate('lottery'), imageAsset: 'assets/images/lottery_icon.webp'),
                        _buildListTile('배달의민족', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), () => widget.onOpenTemplate('delivery')),
                        _buildListTile('PDF 서식 스튜디오', CupertinoIcons.doc_text_fill, const Color(0xFFEF4444), () => widget.onOpenWinApp?.call('pdf_viewer')),
                        _buildListTile('Telegram (텔레그램)', CupertinoIcons.paperplane_fill, const Color(0xFF5288C1), () => widget.onOpenWinApp?.call('telegram')),
                        _buildListTile('직방 (부동산 플랫폼)', null, const Color(0xFFFF7800), () => widget.onOpenWinApp?.call('zigbang'), imageAsset: 'assets/images/zigbang_icon.webp'),
                        _buildListTile('네이버 (NAVER 포털)', null, const Color(0xFF03C75A), () => widget.onOpenWinApp?.call('naver'), imageAsset: 'assets/images/naver_icon.webp'),
                        _buildListTile('보안 관제 (CCTV 시스템)', CupertinoIcons.videocam_fill, const Color(0xFFE53935), () => widget.onOpenWinApp?.call('cctv')),
                        _buildListTile('Steam (스팀 게임 라이브러리)', null, const Color(0xFF1B2838), () => widget.onOpenWinApp?.call('steam'), imageAsset: 'assets/images/steam_icon.webp'),
                        _buildListTile('뉴스 속보 (Breaking News TV)', CupertinoIcons.tv_fill, const Color(0xFFD32F2F), () => widget.onOpenWinApp?.call('news')),
                        _buildListTile('디시인사이드 (DC Inside 갤러리)', null, const Color(0xFF3B4890), () => widget.onOpenWinApp?.call('dcinside'), imageAsset: 'assets/images/dcinside_icon.webp'),
                        _buildListTile('Chrome (크롬 브라우저)', null, const Color(0xFF4285F4), () => widget.onOpenWinApp?.call('chrome'), imageAsset: 'assets/images/windows/chrome.png'),
                        _buildListTile('Microsoft Edge', null, const Color(0xFF0078D7), () => widget.onOpenWinApp?.call('edge'), imageAsset: 'assets/images/windows/edge.png'),
                        _buildListTile('시스템 설정', CupertinoIcons.gear_alt_fill, const Color(0xFF94A3B8), () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 우측 라이브 타일
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white.withValues(alpha: 0.03),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('생산성 & 창작 템플릿', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.2,
                      children: [
                        _buildTileBox('DaVinci Resolve', null, const Color(0xFF1E212B), () => widget.onOpenTemplate('davinci_resolve'), imageAsset: 'assets/images/davinci_resolve_icon.webp'),
                        _buildTileBox('VS 2026', null, const Color(0xFF2E124D), () => widget.onOpenTemplate('visual_studio'), imageAsset: 'assets/images/visual_studio_icon.webp'),
                        _buildTileBox('Photoshop', null, const Color(0xFF001E36), () => widget.onOpenTemplate('photoshop'), imageAsset: 'assets/images/photoshop_icon.webp'),
                        _buildTileBox('Discord', null, const Color(0xFF5865F2), () => widget.onOpenTemplate('discord'), imageAsset: 'assets/images/discord_icon.webp'),
                        _buildTileBox('카톡 캡처', null, const Color(0xFFFEE500), () => widget.onOpenTemplate('kakaotalk'), iconColor: Colors.black87, imageAsset: 'assets/images/kakaotalk_icon.webp'),
                        _buildTileBox('Netflix', null, const Color(0xFFE50914), () => widget.onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
                        _buildTileBox('YouTube', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => widget.onOpenTemplate('youtube')),
                        _buildTileBox('Instagram', null, const Color(0xFFE1306C), () => widget.onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Windows XP: 루나 듀얼 컬럼 시작 메뉴 (1:1 클래식 순정 디자인)
  Widget _buildWinXpStartMenu() {
    final String displayName = widget.user?.displayName ?? 'Fiction 창작자';

    return Container(
      width: 400,
      height: 520,
      decoration: BoxDecoration(
        color: const Color(0xFF0055EA),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 18,
            offset: Offset(2, -2),
          ),
        ],
        border: Border.all(color: const Color(0xFF0038A8), width: 1.5),
      ),
      child: Column(
        children: [
          // 1. 상단 프로필 헤더 (블루 그라데이션 + 오렌지 하단 바)
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0058EE), Color(0xFF1B6AE8), Color(0xFF0040C8)],
              ),
            ),
            child: Row(
              children: [
                // 사용자 액자 (흰색 사각 테두리)
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(1, 1))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: widget.user?.photoURL != null
                        ? Image.network(widget.user!.photoURL!, fit: BoxFit.cover)
                        : Container(
                            color: const Color(0xFFEAB308),
                            child: const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 24),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    displayName,
                    style: const TextStyle(
                      fontFamily: 'Segoe UI',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Color(0xFF002266), blurRadius: 2, offset: Offset(1, 1))],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 오렌지 액센트 구분선
          Container(
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706), Color(0xFFB45309)],
              ),
            ),
          ),

          // 2. 중앙 듀얼 패널 (좌측 화이트 + 우측 소프트 블루)
          Expanded(
            child: Row(
              children: [
                // 좌측 흰색 프로그램 패널
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                            children: [
                              _buildXpProgramTile('인터넷', 'Internet Explorer', 'assets/images/windows/edge.png', () => widget.onOpenWinApp?.call('edge')),
                              _buildXpProgramTile('전자 메일', 'Outlook Express', 'assets/images/windows/desk.png', () => widget.onOpenTemplate('kakaotalk')),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                              ),
                              _buildXpProgramTile('3D 핀볼', 'Space Cadet', 'assets/images/windows/desk.png', () => widget.onOpenWinApp?.call('pinball')),
                              _buildXpProgramTile('지뢰찾기', 'Minesweeper', 'assets/images/windows/desk.png', () => widget.onOpenWinApp?.call('minesweeper')),
                              _buildXpProgramTile('Windows Media Player', '', 'assets/images/windows/vid.png', () => widget.onOpenTemplate('youtube')),
                              _buildXpProgramTile('그림판', '', 'assets/images/windows/mspaint.png', () => widget.onOpenWinApp?.call('paint')),
                              _buildXpProgramTile('메모장', '', 'assets/images/windows/notepad.png', () => widget.onOpenWinApp?.call('notepad')),
                              _buildXpProgramTile('계산기', '', 'assets/images/windows/calc.png', () => widget.onOpenWinApp?.call('calculator')),
                              _buildXpProgramTile('PDF 서식 스튜디오', '공문서 & 계약서 폼', 'assets/images/windows/docs.png', () => widget.onOpenWinApp?.call('pdf_viewer')),
                              _buildXpProgramTile('Telegram', '메신저 & 채널', 'assets/images/windows/desk.png', () => widget.onOpenWinApp?.call('telegram')),
                              _buildXpProgramTile('Chrome', '웹 브라우저', 'assets/images/windows/chrome.png', () => widget.onOpenWinApp?.call('chrome')),
                              _buildXpProgramTile('직방 (Zigbang)', '부동산 & 원룸', 'assets/images/zigbang_icon.webp', () => widget.onOpenWinApp?.call('zigbang')),
                              _buildXpProgramTile('네이버 (NAVER)', '포털 & 뉴스', 'assets/images/naver_icon.webp', () => widget.onOpenWinApp?.call('naver')),
                              _buildXpProgramTile('보안 관제 (CCTV)', 'NVR 감시 모니터링', 'assets/images/windows/desk.png', () => widget.onOpenWinApp?.call('cctv')),
                              _buildXpProgramTile('Steam (스팀)', '게임 라이브러리', 'assets/images/steam_icon.webp', () => widget.onOpenWinApp?.call('steam')),
                              _buildXpProgramTile('뉴스 속보 (TV)', '속보 데스크 & 생중계', 'assets/images/windows/desk.png', () => widget.onOpenWinApp?.call('news')),
                              _buildXpProgramTile('디시인사이드', '커뮤니티 갤러리', 'assets/images/dcinside_icon.webp', () => widget.onOpenWinApp?.call('dcinside')),
                              _buildXpProgramTile('DaVinci Resolve', '', 'assets/images/davinci_resolve_icon.webp', () => widget.onOpenTemplate('davinci_resolve')),
                              _buildXpProgramTile('카카오톡', '', 'assets/images/kakaotalk_icon.webp', () => widget.onOpenTemplate('kakaotalk')),
                            ],
                          ),
                        ),
                        // 좌측 하단 "모든 프로그램(P) ▶"
                        Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                          child: InkWell(
                            onTap: () {},
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '모든 프로그램(P)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(CupertinoIcons.arrowtriangle_right_circle_fill, size: 16, color: Color(0xFF16A34A)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 우측 소프트 스카이블루 시스템 패널
                Expanded(
                  flex: 5,
                  child: Container(
                    color: const Color(0xFFD3E5FA),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildXpSystemTile('내 문서', 'assets/images/windows/docs.png', () => widget.onOpenWinApp?.call('file_explorer'), isBold: true),
                        _buildXpSystemTile('내 최근 문서', 'assets/images/windows/folder.png', () => widget.onOpenWinApp?.call('file_explorer')),
                        _buildXpSystemTile('내 그림', 'assets/images/windows/pics.png', () => widget.onOpenWinApp?.call('file_explorer'), isBold: true),
                        _buildXpSystemTile('내 음악', 'assets/images/windows/music.png', () => widget.onOpenWinApp?.call('file_explorer'), isBold: true),
                        _buildXpSystemTile('내 컴퓨터', 'assets/images/windows/this_pc.png', () => widget.onOpenWinApp?.call('file_explorer'), isBold: true),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Divider(height: 1, color: Color(0xFF90AFC5)),
                        ),
                        _buildXpSystemTile('제어판', 'assets/images/windows/settings.png', () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())),
                        _buildXpSystemTile('프린터 및 팩스', 'assets/images/windows/desk.png', () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Divider(height: 1, color: Color(0xFF90AFC5)),
                        ),
                        _buildXpSystemTile('도움말 및 지원', 'assets/images/windows/desk.png', widget.onGoHome),
                        _buildXpSystemTile('검색', 'assets/images/windows/desk.png', () => widget.onOpenWinApp?.call('file_explorer')),
                        _buildXpSystemTile('실행(R)...', 'assets/images/windows/cmd.png', () => widget.onOpenWinApp?.call('cmd')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 오렌지 액센트 구분선
          Container(
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706), Color(0xFFB45309)],
              ),
            ),
          ),

          // 3. 하단 시스템 전원 바 (로그오프 / 컴퓨터 끄기)
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0058EE), Color(0xFF0038A8)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 로그오프
                InkWell(
                  onTap: widget.onSignOut,
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.lock_shield_fill, size: 16, color: Color(0xFFFBBF24)),
                      SizedBox(width: 6),
                      Text(
                        '로그오프(L)',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // 컴퓨터 끄기
                InkWell(
                  onTap: widget.onSignOut,
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.power, size: 16, color: Color(0xFFEF4444)),
                      SizedBox(width: 6),
                      Text(
                        '컴퓨터 끄기(U)',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpProgramTile(String title, String subtitle, String iconAsset, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3),
      hoverColor: const Color(0xFFDCEBFC),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
        child: Row(
          children: [
            Image.asset(
              iconAsset,
              width: 24,
              height: 24,
              errorBuilder: (c, e, s) => const Icon(CupertinoIcons.app, size: 24, color: Color(0xFF0284C7)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 11.5, color: Colors.black87, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 9.5, color: Colors.black45),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildXpSystemTile(String title, String iconAsset, VoidCallback onTap, {bool isBold = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3),
      hoverColor: const Color(0xFFC0D5EC),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: Row(
          children: [
            Image.asset(
              iconAsset,
              width: 18,
              height: 18,
              errorBuilder: (c, e, s) => const Icon(CupertinoIcons.folder_fill, size: 18, color: Color(0xFF0284C7)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF0C2442),
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Windows 7 시작 메뉴 (에어로 글래스 듀얼 패널 1:1 완벽 구현)
  Widget _buildWin7StartMenu() {
    final String displayName = widget.user?.displayName ?? 'Fiction 창작자';

    return Container(
      width: 440,
      height: 520,
      decoration: BoxDecoration(
        color: const Color(0xFF0C2442).withValues(alpha: 0.88),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border.all(
          color: const Color(0xFF88C8F7).withValues(alpha: 0.7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
            blurRadius: 18,
            spreadRadius: 1,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.7),
            blurRadius: 36,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Column(
            children: [
              // 메인 듀얼 패널 영역
              Expanded(
                child: Row(
                  children: [
                    // 좌측 흰색 프로그램 패널
                    Expanded(
                      flex: 6,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(6, 6, 0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFF90AFC5).withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          children: [
                            // 프로그램 스크롤 목록
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                children: [
                                  _buildWin7ProgramItem('Internet Explorer', null, const Color(0xFF0078D7), () => widget.onOpenWinApp?.call('edge'), imageAsset: 'assets/images/windows/edge.png'),
                                  _buildWin7ProgramItem('Windows Media Player', null, const Color(0xFFE53935), () => widget.onOpenTemplate('youtube'), imageAsset: 'assets/images/windows/vid.png'),
                                  _buildWin7ProgramItem('그림판 (Paint)', null, const Color(0xFF107C41), () => widget.onOpenWinApp?.call('paint'), imageAsset: 'assets/images/windows/mspaint.png'),
                                  _buildWin7ProgramItem('메모장 (Notepad)', null, const Color(0xFF0078D7), () => widget.onOpenWinApp?.call('notepad'), imageAsset: 'assets/images/windows/notepad.png'),
                                  _buildWin7ProgramItem('계산기 (Calculator)', null, const Color(0xFF0063B1), () => widget.onOpenWinApp?.call('calculator'), imageAsset: 'assets/images/windows/calc.png'),
                                  _buildWin7ProgramItem('캡처 도구 (Snipping)', null, const Color(0xFFD83B01), () => widget.onOpenWinApp?.call('snip'), imageAsset: 'assets/images/windows/snip.png'),
                                  _buildWin7ProgramItem('PDF 서식 스튜디오', CupertinoIcons.doc_text_fill, const Color(0xFFEF4444), () => widget.onOpenWinApp?.call('pdf_viewer')),
                                  _buildWin7ProgramItem('Telegram (텔레그램)', CupertinoIcons.paperplane_fill, const Color(0xFF5288C1), () => widget.onOpenWinApp?.call('telegram')),
                                  _buildWin7ProgramItem('Google Chrome', null, const Color(0xFF4285F4), () => widget.onOpenWinApp?.call('chrome'), imageAsset: 'assets/images/windows/chrome.png'),
                                  _buildWin7ProgramItem('직방 (부동산)', null, const Color(0xFFFF7800), () => widget.onOpenWinApp?.call('zigbang'), imageAsset: 'assets/images/zigbang_icon.webp'),
                                  _buildWin7ProgramItem('네이버 (NAVER)', null, const Color(0xFF03C75A), () => widget.onOpenWinApp?.call('naver'), imageAsset: 'assets/images/naver_icon.webp'),
                                  _buildWin7ProgramItem('보안 관제 (CCTV)', CupertinoIcons.videocam_fill, const Color(0xFFE53935), () => widget.onOpenWinApp?.call('cctv')),
                                  _buildWin7ProgramItem('Steam (스팀)', null, const Color(0xFF1B2838), () => widget.onOpenWinApp?.call('steam'), imageAsset: 'assets/images/steam_icon.webp'),
                                  _buildWin7ProgramItem('뉴스 속보 (Breaking News)', CupertinoIcons.tv_fill, const Color(0xFFD32F2F), () => widget.onOpenWinApp?.call('news')),
                                  _buildWin7ProgramItem('디시인사이드 (DC Inside)', null, const Color(0xFF3B4890), () => widget.onOpenWinApp?.call('dcinside'), imageAsset: 'assets/images/dcinside_icon.webp'),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                                  ),
                                  _buildWin7ProgramItem('DaVinci Resolve Studio', null, const Color(0xFFE53935), () => widget.onOpenTemplate('davinci_resolve'), imageAsset: 'assets/images/davinci_resolve_icon.webp'),
                                  _buildWin7ProgramItem('Visual Studio 2026', null, const Color(0xFF68217A), () => widget.onOpenTemplate('visual_studio'), imageAsset: 'assets/images/visual_studio_icon.webp'),
                                  _buildWin7ProgramItem('Adobe Photoshop 2026', null, const Color(0xFF31A8FF), () => widget.onOpenTemplate('photoshop'), imageAsset: 'assets/images/photoshop_icon.webp'),
                                  _buildWin7ProgramItem('Discord 커뮤니티', null, const Color(0xFF5865F2), () => widget.onOpenTemplate('discord'), imageAsset: 'assets/images/discord_icon.webp'),
                                  _buildWin7ProgramItem('카카오톡', null, const Color(0xFFFEE500), () => widget.onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
                                  _buildWin7ProgramItem('블라인드 익명 커뮤니티', null, const Color(0xFFDA3238), () => widget.onOpenTemplate('blind'), imageAsset: 'assets/images/blind_icon.webp'),
                                  _buildWin7ProgramItem('업비트 가상자산', null, const Color(0xFF093687), () => widget.onOpenTemplate('upbit'), imageAsset: 'assets/images/upbit_icon.webp'),
                                  _buildWin7ProgramItem('야놀자 숙소/여행', null, const Color(0xFFFF3478), () => widget.onOpenTemplate('yanolja'), imageAsset: 'assets/images/yanolja_icon.webp'),
                                  _buildWin7ProgramItem('카카오뱅크', null, const Color(0xFFFEE500), () => widget.onOpenTemplate('kakaobank'), imageAsset: 'assets/images/kakaobank_icon.webp'),
                                  _buildWin7ProgramItem('당근마켓', null, const Color(0xFFFF6F0F), () => widget.onOpenTemplate('daangn'), imageAsset: 'assets/images/daangn_icon.webp'),
                                  _buildWin7ProgramItem('명령 프롬프트 (CMD)', null, const Color(0xFF1E293B), () => widget.onOpenWinApp?.call('cmd'), imageAsset: 'assets/images/windows/cmd.png'),
                                ],
                              ),
                            ),
                            // 좌측 하단 "모든 프로그램 ▶" 버튼
                            Container(
                              height: 34,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                              child: InkWell(
                                onTap: () {},
                                hoverColor: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(4),
                                child: const Row(
                                  children: [
                                    Text(
                                      '모든 프로그램',
                                      style: TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(CupertinoIcons.play_arrow_solid, size: 10, color: Color(0xFF0284C7)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 우측 짙은 네이비 시스템 링크 패널 (Aero Glass)
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 사용자 액자 프레임 (Windows 7 시그니처 액자 프레임)
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 52,
                                height: 52,
                                margin: const EdgeInsets.only(bottom: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.white, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.45),
                                      blurRadius: 6,
                                      offset: const Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: widget.user?.photoURL != null
                                      ? Image.network(widget.user!.photoURL!, fit: BoxFit.cover)
                                      : Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 28),
                                        ),
                                ),
                              ),
                            ),

                            // 내비게이션 링크들
                            _buildWin7SystemLink(displayName, widget.onGoHome, isBold: true),
                            _buildWin7SystemLink('문서', () => widget.onOpenWinApp?.call('file_explorer'), isBold: true),
                            _buildWin7SystemLink('사진', () => widget.onOpenWinApp?.call('file_explorer'), isBold: true),
                            _buildWin7SystemLink('음악', () => widget.onOpenWinApp?.call('file_explorer'), isBold: true),
                            _buildWin7Divider(),
                            _buildWin7SystemLink('컴퓨터 (탐색기)', () => widget.onOpenWinApp?.call('file_explorer'), isBold: true),
                            _buildWin7SystemLink('네트워크', () => widget.onOpenWinApp?.call('file_explorer')),
                            _buildWin7Divider(),
                            _buildWin7SystemLink('제어판 (설정)', () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())),
                            _buildWin7SystemLink('장치 및 프린터', () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())),
                            _buildWin7SystemLink('기본 프로그램', () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())),
                            _buildWin7SystemLink('도움말 및 지원', widget.onGoHome),
                            const Spacer(),

                            // 시스템 종료 버튼 (Windows 7 시그니처 듀얼 스플릿 버튼)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 28,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0xFF4A9CD9), Color(0xFF1D5DAE)],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFF90C4EC), width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.35),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: widget.onSignOut,
                                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.power, color: Colors.white, size: 13),
                                            SizedBox(width: 6),
                                            Text(
                                              '시스템 종료',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(color: Colors.black45, blurRadius: 2, offset: Offset(0, 1)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(width: 1, height: 20, color: Colors.white24),
                                    InkWell(
                                      onTap: widget.onSignOut,
                                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                                        child: Icon(CupertinoIcons.play_arrow_solid, color: Colors.white, size: 9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 하단 에어로 검색창 ("프로그램 및 파일 검색")
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFF67B5FA)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.search, size: 14, color: Colors.black54),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(color: Colors.black87, fontSize: 11),
                                decoration: const InputDecoration(
                                  hintText: '프로그램 및 파일 검색',
                                  hintStyle: TextStyle(color: Colors.black38, fontSize: 11, fontStyle: FontStyle.italic),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (val) => setState(() => _searchQuery = val),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 4,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWin7Divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.25),
            Colors.white.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  Widget _buildWin7ProgramItem(String title, IconData? icon, Color color, VoidCallback onTap, {String? imageAsset}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      hoverColor: const Color(0xFFE0F2FE),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: imageAsset != null
                    ? Image.asset(imageAsset, fit: BoxFit.cover)
                    : (icon != null ? Icon(icon, color: Colors.white, size: 15) : const SizedBox()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWin7SystemLink(String text, VoidCallback onTap, {bool isBold = false}) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 4),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            shadows: const [
              Shadow(color: Colors.black45, blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Windows 11 세부 구현 (스크린샷 100% 1:1 일치)
  // ==========================================

  // 1. 상단 검색창 (하늘색 돋보기 + 순정 통합 둥근 필 형태)
  Widget _buildWin11TopSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
      child: SizedBox(
        height: 38,
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val.trim()),
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF262B37).withValues(alpha: 0.95),
            hoverColor: const Color(0xFF2E3444).withValues(alpha: 0.95),
            hintText: '앱, 설정 및 문서 검색',
            hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 14, right: 10),
              child: Icon(CupertinoIcons.search, size: 16, color: Color(0xFF38BDF8)),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 38),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(CupertinoIcons.clear_circled_solid, size: 14, color: Colors.white54),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF60CDFF), width: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  // 2. 고정됨 섹션 (헤더: '고정됨' & '모두 >', 8열 2행 앱 그리드)
  Widget _buildWin11PinnedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '고정됨',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('모두', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    SizedBox(width: 4),
                    Icon(CupertinoIcons.chevron_right, size: 10, color: Colors.white70),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Row 1 (8 apps)
        Row(
          children: [
            _buildWin11AppItem('Microsoft Edge', 'assets/images/windows/edge.png', () => widget.onOpenWinApp?.call('edge')),
            _buildWin11AppItem('Outlook', 'assets/images/windows/outlook.png', () => widget.onOpenWinApp?.call('outlook')),
            _buildWin11AppItem('Microsoft Store', 'assets/images/windows/store.png', () => widget.onOpenWinApp?.call('store')),
            _buildWin11AppItem('사진', 'assets/images/windows/photos.png', () => widget.onOpenWinApp?.call('photos')),
            _buildWin11AppItem('설정', 'assets/images/windows/settings.png', () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())),
            _buildWin11AppItem('Xbox', 'assets/images/windows/xbox.png', () => widget.onOpenWinApp?.call('xbox')),
            _buildWin11AppItem('Solitaire &...', 'assets/images/windows/soltaire.png', () => widget.onOpenWinApp?.call('solitaire')),
            _buildWin11AppItem('그림판', 'assets/images/windows/paint.png', () => widget.onOpenWinApp?.call('paint')),
          ],
        ),
        const SizedBox(height: 8),

        // Row 2 (6 apps + 2 empty placeholders for exact 8-column alignment)
        Row(
          children: [
            _buildWin11AppItem(
              'Telegram',
              null,
              () => widget.onOpenWinApp?.call('telegram'),
              customIcon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: const Color(0xFF5288C1), borderRadius: BorderRadius.circular(6)),
                child: const Icon(CupertinoIcons.paperplane_fill, color: Colors.white, size: 18),
              ),
            ),
            _buildWin11AppItem('계산기', 'assets/images/windows/calculator.png', () => widget.onOpenWinApp?.call('calculator')),
            _buildWin11AppItem('시계', 'assets/images/windows/alarm.png', () => widget.onOpenWinApp?.call('alarm')),
            _buildWin11AppItem('메모장', 'assets/images/windows/notepad.png', () => widget.onOpenWinApp?.call('notepad')),
            _buildWin11AppItem('캡처 도구', 'assets/images/windows/snip.png', () => widget.onOpenWinApp?.call('snip')),
            _buildWin11AppItem('파일 탐색기', 'assets/images/windows/explorer.png', () => widget.onOpenWinApp?.call('file_explorer')),
            _buildWin11AppItem('그림판 3D', 'assets/images/windows/paint.png', () => widget.onOpenWinApp?.call('paint_3d')),
            _buildWin11AppItem(
              'PDF 서식',
              null,
              () => widget.onOpenWinApp?.call('pdf_viewer'),
              customIcon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(6)),
                child: const Icon(CupertinoIcons.doc_text_fill, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Row 3 (Chrome, 직방, 네이버 및 주요 앱)
        Row(
          children: [
            _buildWin11AppItem('Chrome', 'assets/images/windows/chrome.png', () => widget.onOpenWinApp?.call('chrome')),
            _buildWin11AppItem('직방', 'assets/images/zigbang_icon.webp', () => widget.onOpenWinApp?.call('zigbang')),
            _buildWin11AppItem('네이버', 'assets/images/naver_icon.webp', () => widget.onOpenWinApp?.call('naver')),
            _buildWin11AppItem('명령 프롬프트', 'assets/images/windows/cmd.png', () => widget.onOpenWinApp?.call('cmd')),
            _buildWin11AppItem(
              'YouTube',
              null,
              () => widget.onOpenTemplate('youtube'),
              customIcon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: const Color(0xFFFF0000), borderRadius: BorderRadius.circular(6)),
                child: const Icon(CupertinoIcons.play_arrow_solid, color: Colors.white, size: 18),
              ),
            ),
            _buildWin11AppItem('카카오톡', 'assets/images/kakaotalk_icon.webp', () => widget.onOpenTemplate('kakaotalk')),
            _buildWin11AppItem('쿠팡', 'assets/images/coupang_icon.webp', () => widget.onOpenTemplate('coupang')),
            _buildWin11AppItem('동행복권', 'assets/images/lottery_icon.webp', () => widget.onOpenTemplate('lottery')),
          ],
        ),
        const SizedBox(height: 8),

        // Row 4 (CCTV, DaVinci Resolve, Visual Studio, Photoshop, Discord, 배달의민족, Instagram, Netflix)
        Row(
          children: [
            _buildWin11AppItem(
              '보안 관제',
              null,
              () => widget.onOpenWinApp?.call('cctv'),
              customIcon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: const Color(0xFFE53935), borderRadius: BorderRadius.circular(6)),
                child: const Icon(CupertinoIcons.videocam_fill, color: Colors.white, size: 18),
              ),
            ),
            _buildWin11AppItem('DaVinci', 'assets/images/davinci_resolve_icon.webp', () => widget.onOpenTemplate('davinci_resolve')),
            _buildWin11AppItem('VS 2026', 'assets/images/visual_studio_icon.webp', () => widget.onOpenTemplate('visual_studio')),
            _buildWin11AppItem('Photoshop', 'assets/images/photoshop_icon.webp', () => widget.onOpenTemplate('photoshop')),
            _buildWin11AppItem('Discord', 'assets/images/discord_icon.webp', () => widget.onOpenTemplate('discord')),
            _buildWin11AppItem(
              '배달의민족',
              null,
              () => widget.onOpenTemplate('delivery'),
              customIcon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: const Color(0xFF2AC1BC), borderRadius: BorderRadius.circular(6)),
                child: const Icon(CupertinoIcons.bag_fill, color: Colors.white, size: 18),
              ),
            ),
            _buildWin11AppItem('Steam', 'assets/images/steam_icon.webp', () => widget.onOpenWinApp?.call('steam')),
            _buildWin11AppItem(
              '뉴스 속보',
              null,
              () => widget.onOpenWinApp?.call('news'),
              customIcon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: const Color(0xFFD32F2F), borderRadius: BorderRadius.circular(6)),
                child: const Icon(CupertinoIcons.tv_fill, color: Colors.white, size: 18),
              ),
            ),
            _buildWin11AppItem('디시인사이드', 'assets/images/dcinside_icon.webp', () => widget.onOpenWinApp?.call('dcinside')),
          ],
        ),
      ],
    );
  }

  // 3. 맞춤 섹션 (헤더: '맞춤' & '자세히 >', 시작 Windows 시작 아이템)
  Widget _buildWin11RecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '맞춤',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('자세히', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    SizedBox(width: 4),
                    Icon(CupertinoIcons.chevron_right, size: 10, color: Colors.white70),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(6),
          hoverColor: Colors.white.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/windows/getstarted.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '시작',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Windows 시작',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 4. 모두 섹션 (헤더: '모두' & '보기: 범주 ⌵', 범주 카드 그리드)
  Widget _buildWin11AllSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '모두',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text('보기: 범주', style: TextStyle(color: Colors.white70, fontSize: 11)),
                SizedBox(width: 4),
                Icon(CupertinoIcons.chevron_down, size: 10, color: Colors.white70),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Row 1: 4개 범주 폴더 카드
        Row(
          children: [
            Expanded(
              child: _buildCategoryFolderCard(
                '유틸리티 및 도구',
                [
                  'assets/images/windows/calculator.png',
                  'assets/images/windows/alarm.png',
                  'assets/images/windows/notepad.png',
                  'assets/images/windows/snip.png',
                ],
                () => widget.onOpenWinApp?.call('calculator'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCategoryFolderCard(
                '생산성',
                [
                  'assets/images/windows/edge.png',
                  'assets/images/windows/outlook.png',
                  'assets/images/windows/store.png',
                  'assets/images/windows/settings.png',
                ],
                () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCategoryFolderCard(
                '독창성',
                [
                  'assets/images/windows/paint.png',
                  'assets/images/windows/photos.png',
                  'assets/images/windows/camera.png',
                  'assets/images/windows/soltaire.png',
                ],
                () => widget.onOpenWinApp?.call('paint'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCategoryFolderCard(
                'Fiction 템플릿',
                [
                  'assets/images/kakaotalk_icon.webp',
                  'assets/images/netflix_icon.webp',
                  'assets/images/coupang_icon.webp',
                  'assets/images/lottery_icon.webp',
                ],
                () => widget.onOpenTemplate('kakaotalk'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Row 2: 미니 폴더 카드 2개
        Row(
          children: [
            Expanded(
              child: _buildCategoryFolderCard(
                '문서',
                ['assets/images/windows/docs.png'],
                () => widget.onOpenWinApp?.call('file_explorer'),
                isSingleIcon: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCategoryFolderCard(
                '다운로드',
                ['assets/images/windows/down.png'],
                () => widget.onOpenWinApp?.call('file_explorer'),
                isSingleIcon: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCategoryFolderCard(
                '전문가 도구',
                [
                  'assets/images/davinci_resolve_icon.webp',
                  'assets/images/visual_studio_icon.webp',
                  'assets/images/photoshop_icon.webp',
                  'assets/images/discord_icon.webp',
                ],
                () => widget.onOpenTemplate('davinci_resolve'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCategoryFolderCard(
                '라이프 & 금융',
                [
                  'assets/images/blind_icon.webp',
                  'assets/images/upbit_icon.webp',
                  'assets/images/yanolja_icon.webp',
                  'assets/images/kakaobank_icon.webp',
                ],
                () => widget.onOpenTemplate('blind'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 5. 하단 계정 프로필 & 전원 버튼 바
  Widget _buildWin11BottomBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF141720).withValues(alpha: 0.92),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽: 흰색 동그라미 아바타 + Admin 텍스트
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            hoverColor: Colors.white.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFFE2E8F0),
                    backgroundImage: widget.user?.photoURL != null ? NetworkImage(widget.user!.photoURL!) : null,
                    child: widget.user?.photoURL == null
                        ? const Icon(CupertinoIcons.person_fill, color: Color(0xFF475569), size: 18)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.user?.displayName ?? 'Admin',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 오른쪽: 전원 버튼 (클릭 시 절전 / 시스템 종료 / 다시 시작 팝업 메뉴)
          Theme(
            data: Theme.of(context).copyWith(
              cardColor: const Color(0xFF262B37),
            ),
            child: PopupMenuButton<String>(
              tooltip: '전원',
              offset: const Offset(0, -140),
              color: const Color(0xFF262B37),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              ),
              icon: Icon(CupertinoIcons.power, color: Colors.white.withValues(alpha: 0.85), size: 18),
              onSelected: (val) {
                if (val == 'sign_out') {
                  widget.onSignOut();
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(
                  value: 'sleep',
                  height: 34,
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.moon_fill, color: Colors.white70, size: 15),
                      SizedBox(width: 10),
                      Text('절전', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'sign_out',
                  height: 34,
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.power, color: Color(0xFFEF4444), size: 15),
                      SizedBox(width: 10),
                      Text('시스템 종료 / 로그아웃', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'restart',
                  height: 34,
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.arrow_counterclockwise, color: Colors.white70, size: 15),
                      SizedBox(width: 10),
                      Text('다시 시작', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Windows 11 단일 앱 아이템 (아이콘 위, 레이블 아래)
  Widget _buildWin11AppItem(String title, String? assetPath, VoidCallback onTap, {Widget? customIcon}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        hoverColor: Colors.white.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: Center(
                  child: customIcon ??
                      (assetPath != null
                          ? Image.asset(assetPath, width: 32, height: 32, fit: BoxFit.contain)
                          : const SizedBox()),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // 범주 폴더 카드 (2x2 미니 아이콘 클러스터 + 이름)
  Widget _buildCategoryFolderCard(String title, List<String> iconAssets, VoidCallback onTap, {bool isSingleIcon = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      hoverColor: Colors.white.withValues(alpha: 0.08),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            // 미니 아이콘 컨테이너
            Container(
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSingleIcon
                  ? Image.asset(iconAssets.first, fit: BoxFit.contain)
                  : Wrap(
                      spacing: 2,
                      runSpacing: 2,
                      alignment: WrapAlignment.center,
                      children: iconAssets.take(4).map((asset) {
                        return Image.asset(asset, width: 12, height: 12, fit: BoxFit.contain);
                      }).toList(),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 검색 결과 뷰
  Widget _buildWin11SearchResults() {
    final allApps = [
      {'name': 'Microsoft Edge', 'icon': 'assets/images/windows/edge.png', 'action': () => widget.onOpenWinApp?.call('edge')},
      {'name': 'Outlook', 'icon': 'assets/images/windows/outlook.png', 'action': () => widget.onOpenWinApp?.call('outlook')},
      {'name': 'Microsoft Store', 'icon': 'assets/images/windows/store.png', 'action': () => widget.onOpenWinApp?.call('store')},
      {'name': '사진', 'icon': 'assets/images/windows/photos.png', 'action': () => widget.onOpenWinApp?.call('photos')},
      {'name': '설정', 'icon': 'assets/images/windows/settings.png', 'action': () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())},
      {'name': 'Xbox', 'icon': 'assets/images/windows/xbox.png', 'action': () => widget.onOpenWinApp?.call('xbox')},
      {'name': 'Solitaire & Casual Games', 'icon': 'assets/images/windows/soltaire.png', 'action': () => widget.onOpenWinApp?.call('solitaire')},
      {'name': '그림판', 'icon': 'assets/images/windows/paint.png', 'action': () => widget.onOpenWinApp?.call('paint')},
      {'name': '그림판 3D', 'icon': 'assets/images/windows/paint.png', 'action': () => widget.onOpenWinApp?.call('paint_3d')},
      {'name': '계산기', 'icon': 'assets/images/windows/calculator.png', 'action': () => widget.onOpenWinApp?.call('calculator')},
      {'name': '시계', 'icon': 'assets/images/windows/alarm.png', 'action': () => widget.onOpenWinApp?.call('alarm')},
      {'name': '메모장', 'icon': 'assets/images/windows/notepad.png', 'action': () => widget.onOpenWinApp?.call('notepad')},
      {'name': '캡처 도구', 'icon': 'assets/images/windows/snip.png', 'action': () => widget.onOpenWinApp?.call('snip')},
      {'name': '파일 탐색기', 'icon': 'assets/images/windows/explorer.png', 'action': () => widget.onOpenWinApp?.call('file_explorer')},
      {'name': '휴지통', 'icon': 'assets/images/windows/recycle_bin.png', 'action': () => widget.onOpenWinApp?.call('recycle_bin')},
      {'name': 'DaVinci Resolve Studio (다빈치 리졸브 영상 편집)', 'icon': 'assets/images/davinci_resolve_icon.webp', 'action': () => widget.onOpenTemplate('davinci_resolve')},
      {'name': 'Visual Studio 2026 Professional (비주얼 스튜디오)', 'icon': 'assets/images/visual_studio_icon.webp', 'action': () => widget.onOpenTemplate('visual_studio')},
      {'name': 'Adobe Photoshop 2026 (포토샵 그래픽 에디터)', 'icon': 'assets/images/photoshop_icon.webp', 'action': () => widget.onOpenTemplate('photoshop')},
      {'name': 'Discord (디스코드 커뮤니티)', 'icon': 'assets/images/discord_icon.webp', 'action': () => widget.onOpenTemplate('discord')},
      {'name': '블라인드 (Blind 직장인 커뮤니티)', 'icon': 'assets/images/blind_icon.webp', 'action': () => widget.onOpenTemplate('blind')},
      {'name': '업비트 (Upbit 가상자산 거래소)', 'icon': 'assets/images/upbit_icon.webp', 'action': () => widget.onOpenTemplate('upbit')},
      {'name': '야놀자 (Yanolja 숙소 및 여행)', 'icon': 'assets/images/yanolja_icon.webp', 'action': () => widget.onOpenTemplate('yanolja')},
      {'name': '카카오뱅크 (KakaoBank 통장 및 이체)', 'icon': 'assets/images/kakaobank_icon.webp', 'action': () => widget.onOpenTemplate('kakaobank')},
      {'name': '당근마켓 (Daangn 중고거래)', 'icon': 'assets/images/daangn_icon.webp', 'action': () => widget.onOpenTemplate('daangn')},
      {'name': '토스 (Toss 송금 및 계좌)', 'icon': null, 'action': () => widget.onOpenTemplate('toss')},
      {'name': 'X (Twitter 트위터 소셜)', 'icon': null, 'action': () => widget.onOpenTemplate('x_twitter')},
      {'name': '카카오톡 채팅방', 'icon': 'assets/images/kakaotalk_icon.webp', 'action': () => widget.onOpenTemplate('kakaotalk')},
      {'name': '쿠팡 로켓쇼핑', 'icon': 'assets/images/coupang_icon.webp', 'action': () => widget.onOpenTemplate('coupang')},
      {'name': 'Netflix 오리지널', 'icon': 'assets/images/netflix_icon.webp', 'action': () => widget.onOpenTemplate('netflix')},
      {'name': 'YouTube 비디오 에디터', 'icon': null, 'action': () => widget.onOpenTemplate('youtube')},
      {'name': 'Instagram 피드', 'icon': 'assets/images/instagram_icon.webp', 'action': () => widget.onOpenTemplate('instagram')},
      {'name': '동행복권 (로또 6/45)', 'icon': 'assets/images/lottery_icon.webp', 'action': () => widget.onOpenTemplate('lottery')},
      {'name': '배달의민족', 'icon': null, 'action': () => widget.onOpenTemplate('delivery')},
      {'name': 'Windows 블루스크린 (BSOD)', 'icon': null, 'action': () => widget.onOpenTemplate('windows_bsod')},
    ];

    final filtered = allApps.where((app) {
      final name = app['name'] as String;
      return name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            '"$_searchQuery"에 일치하는 결과가 없습니다.',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최고 일치 (${filtered.length})',
          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...filtered.map((item) {
          final icon = item['icon'] as String?;
          final name = item['name'] as String;
          final action = item['action'] as VoidCallback;
          return InkWell(
            onTap: action,
            borderRadius: BorderRadius.circular(6),
            hoverColor: Colors.white.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    child: icon != null
                        ? Image.asset(icon, width: 24, height: 24, fit: BoxFit.contain)
                        : const Icon(CupertinoIcons.app_fill, color: Colors.white70, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_right, size: 12, color: Colors.white38),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildListTile(String title, IconData? icon, Color color, VoidCallback onTap, {String? imageAsset}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      hoverColor: Colors.white.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: imageAsset != null
                    ? Image.asset(imageAsset, fit: BoxFit.cover)
                    : (icon != null ? Icon(icon, color: color, size: 18) : const SizedBox()),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTileBox(String title, IconData? icon, Color color, VoidCallback onTap, {Color iconColor = Colors.white, String? imageAsset}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: color,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: imageAsset != null
                    ? Image.asset(imageAsset, fit: BoxFit.cover)
                    : (icon != null ? Icon(icon, color: iconColor, size: 24) : const SizedBox()),
              ),
            ),
            Text(title, style: TextStyle(color: iconColor, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}