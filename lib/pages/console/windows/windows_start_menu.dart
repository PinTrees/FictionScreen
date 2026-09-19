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
    if (widget.windowsVersion == '7') {
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

  // Windows 7 시작 메뉴 (에어로 글래스 듀얼 패널)
  Widget _buildWin7StartMenu() {
    return Container(
      width: 440,
      height: 460,
      decoration: BoxDecoration(
        color: const Color(0xFF0A223E).withValues(alpha: 0.92),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        border: Border.all(color: const Color(0xFF67B5FA).withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 30),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // 좌측 흰색/밝은 프로그램 패널
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: ListView(
                          children: [
                            _buildWin7ProgramItem('DaVinci Resolve Studio', null, const Color(0xFFE53935), () => widget.onOpenTemplate('davinci_resolve'), imageAsset: 'assets/images/davinci_resolve_icon.webp'),
                            _buildWin7ProgramItem('Visual Studio 2026', null, const Color(0xFF68217A), () => widget.onOpenTemplate('visual_studio'), imageAsset: 'assets/images/visual_studio_icon.webp'),
                            _buildWin7ProgramItem('Adobe Photoshop 2026', null, const Color(0xFF31A8FF), () => widget.onOpenTemplate('photoshop'), imageAsset: 'assets/images/photoshop_icon.webp'),
                            _buildWin7ProgramItem('Discord 커뮤니티', null, const Color(0xFF5865F2), () => widget.onOpenTemplate('discord'), imageAsset: 'assets/images/discord_icon.webp'),
                            _buildWin7ProgramItem('카카오톡 채팅방', null, const Color(0xFFFEE500), () => widget.onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
                            _buildWin7ProgramItem('블라인드 익명 게시판', null, const Color(0xFFDA3238), () => widget.onOpenTemplate('blind'), imageAsset: 'assets/images/blind_icon.webp'),
                            _buildWin7ProgramItem('업비트 가상자산 시세', null, const Color(0xFF093687), () => widget.onOpenTemplate('upbit'), imageAsset: 'assets/images/upbit_icon.webp'),
                            _buildWin7ProgramItem('야놀자 숙소/여행', null, const Color(0xFFFF3478), () => widget.onOpenTemplate('yanolja'), imageAsset: 'assets/images/yanolja_icon.webp'),
                            _buildWin7ProgramItem('카카오뱅크 통장/이체', null, const Color(0xFFFEE500), () => widget.onOpenTemplate('kakaobank'), imageAsset: 'assets/images/kakaobank_icon.webp'),
                            _buildWin7ProgramItem('당근마켓 중고거래', null, const Color(0xFFFF6F0F), () => widget.onOpenTemplate('daangn'), imageAsset: 'assets/images/daangn_icon.webp'),
                            _buildWin7ProgramItem('Windows 블루스크린', CupertinoIcons.device_desktop, const Color(0xFF0078D7), () => widget.onOpenTemplate('windows_bsod')),
                            _buildWin7ProgramItem('YouTube 비디오 에디터', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => widget.onOpenTemplate('youtube')),
                            _buildWin7ProgramItem('Instagram 소셜 피드', null, const Color(0xFFE1306C), () => widget.onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
                            _buildWin7ProgramItem('쿠팡 로켓쇼핑', null, const Color(0xFFC72424), () => widget.onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
                            _buildWin7ProgramItem('Netflix 오리지널', null, const Color(0xFFE50914), () => widget.onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
                            _buildWin7ProgramItem('동행복권 로또 6/45', null, const Color(0xFF0066B3), () => widget.onOpenTemplate('lottery'), imageAsset: 'assets/images/lottery_icon.webp'),
                            _buildWin7ProgramItem('배달의민족 배송 현황', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), () => widget.onOpenTemplate('delivery')),
                            _buildWin7ProgramItem('시스템 설정 (제어판)', CupertinoIcons.gear_alt_fill, const Color(0xFF475569), () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())),
                          ],
                        ),
                      ),
                    ),
                    // 우측 짙은 네이비 시스템 링크 패널
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFF38BDF8),
                              backgroundImage: widget.user?.photoURL != null ? NetworkImage(widget.user!.photoURL!) : null,
                              child: widget.user?.photoURL == null ? const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 20) : null,
                            ),
                            const SizedBox(height: 12),
                            _buildWin7SystemLink('컴퓨터', () => widget.onOpenWinApp?.call('file_explorer')),
                            _buildWin7SystemLink('문서', () => widget.onOpenWinApp?.call('file_explorer')),
                            _buildWin7SystemLink('사진', () => widget.onOpenWinApp?.call('file_explorer')),
                            _buildWin7SystemLink('제어판 (설정)', () => (widget.onOpenWinApp != null ? widget.onOpenWinApp!('settings') : widget.onOpenSettings())),
                            _buildWin7SystemLink('랜딩 홈', widget.onGoHome),
                            const Spacer(),
                            // 시스템 종료 버튼
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white38),
                              ),
                              child: InkWell(
                                onTap: widget.onSignOut,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(CupertinoIcons.power, color: Colors.white, size: 14),
                                    SizedBox(width: 6),
                                    Text('로그아웃(종료)', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
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
              // 하단 검색 바
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                color: Colors.black.withValues(alpha: 0.3),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFF67B5FA)),
                        ),
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.search, size: 14, color: Colors.black54),
                            SizedBox(width: 6),
                            Text('프로그램 및 파일 검색', style: TextStyle(color: Colors.black45, fontSize: 11)),
                          ],
                        ),
                      ),
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

  Widget _buildWin7ProgramItem(String title, IconData? icon, Color color, VoidCallback onTap, {String? imageAsset}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      hoverColor: const Color(0xFFE0F2FE),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: imageAsset != null
                    ? Image.asset(imageAsset, fit: BoxFit.cover)
                    : (icon != null ? Icon(icon, color: Colors.white, size: 16) : const SizedBox()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWin7SystemLink(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
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
            _buildWin11AppItem('LinkedIn', null, () {}, customIcon: _buildLinkedInIcon()),
            _buildWin11AppItem('계산기', 'assets/images/windows/calculator.png', () => widget.onOpenWinApp?.call('calculator')),
            _buildWin11AppItem('시계', 'assets/images/windows/alarm.png', () => widget.onOpenWinApp?.call('alarm')),
            _buildWin11AppItem('메모장', 'assets/images/windows/notepad.png', () => widget.onOpenWinApp?.call('notepad')),
            _buildWin11AppItem('캡처 도구', 'assets/images/windows/snip.png', () => widget.onOpenWinApp?.call('snip')),
            _buildWin11AppItem('파일 탐색기', 'assets/images/windows/explorer.png', () => widget.onOpenWinApp?.call('file_explorer')),
            _buildWin11AppItem('그림판 3D', 'assets/images/windows/paint.png', () => widget.onOpenWinApp?.call('paint_3d')),
            const Expanded(child: SizedBox()),
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

  // LinkedIn 아이콘 (파란 배경 + 흰색 "in")
  Widget _buildLinkedInIcon() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF0077B5),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: const Text(
        'in',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w900,
          fontFamily: 'sans-serif',
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