import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows 7 / 10 / 11 시작 메뉴 팝업
class WindowsStartMenu extends StatelessWidget {
  final String windowsVersion;
  final User? user;
  final Function(String templateId) onOpenTemplate;
  final Function(String appId)? onOpenWinApp;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const WindowsStartMenu({
    super.key,
    this.windowsVersion = '10',
    required this.user,
    required this.onOpenTemplate,
    this.onOpenWinApp,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    if (windowsVersion == '7') {
      return _buildWin7StartMenu();
    } else if (windowsVersion == '10') {
      return _buildWin10StartMenu();
    } else {
      return _buildWin11StartMenu();
    }
  }

  // Windows 11 시작 메뉴 (중앙 플로팅)
  Widget _buildWin11StartMenu() {
    return Container(
      width: 520,
      height: 500,
      decoration: BoxDecoration(
        color: const Color(0xFF1C202C).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 36,
            offset: const Offset(0, 10),
          ),
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
                _buildSearchInput('앱, 설정 및 템플릿 검색'),
                const SizedBox(height: 20),
                const Text('고정됨', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Expanded(child: _buildAppGrid()),
                const Divider(color: Colors.white12, height: 24),
                _buildBottomUserProfile(),
              ],
            ),
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
                IconButton(icon: const Icon(CupertinoIcons.gear_alt_fill, size: 18, color: Colors.white70), onPressed: () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings())),
                IconButton(icon: const Icon(CupertinoIcons.power, size: 18, color: Color(0xFFEF4444)), onPressed: onSignOut),
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
                        _buildListTile('카카오톡 채팅', null, const Color(0xFFFEE500), () => onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
                        _buildListTile('블루스크린 (BSOD)', CupertinoIcons.device_desktop, const Color(0xFF0078D7), () => onOpenTemplate('windows_bsod')),
                        _buildListTile('YouTube 스튜디오', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => onOpenTemplate('youtube')),
                        _buildListTile('Instagram 피드', null, const Color(0xFFE1306C), () => onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
                        _buildListTile('쿠팡 쇼핑몰', null, const Color(0xFFC72424), () => onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
                        _buildListTile('Netflix', null, const Color(0xFFE50914), () => onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
                        _buildListTile('동행복권 (로또 6/45)', null, const Color(0xFF0066B3), () => onOpenTemplate('lottery'), imageAsset: 'assets/images/lottery_icon.webp'),
                        _buildListTile('배달의민족', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), () => onOpenTemplate('delivery')),
                        _buildListTile('시스템 설정', CupertinoIcons.gear_alt_fill, const Color(0xFF94A3B8), () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings())),
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
                        _buildTileBox('카톡 캡처', null, const Color(0xFFFEE500), () => onOpenTemplate('kakaotalk'), iconColor: Colors.black87, imageAsset: 'assets/images/kakaotalk_icon.webp'),
                        _buildTileBox('Netflix', null, const Color(0xFFE50914), () => onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
                        _buildTileBox('YouTube', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => onOpenTemplate('youtube')),
                        _buildTileBox('Instagram', null, const Color(0xFFE1306C), () => onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
                        _buildTileBox('쿠팡', null, const Color(0xFFC72424), () => onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
                        _buildTileBox('배달의민족', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), () => onOpenTemplate('delivery')),
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
                            _buildWin7ProgramItem('카카오톡 채팅방', null, const Color(0xFFFEE500), () => onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
                            _buildWin7ProgramItem('Windows 블루스크린', CupertinoIcons.device_desktop, const Color(0xFF0078D7), () => onOpenTemplate('windows_bsod')),
                            _buildWin7ProgramItem('YouTube 비디오 에디터', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => onOpenTemplate('youtube')),
                            _buildWin7ProgramItem('Instagram 소셜 피드', null, const Color(0xFFE1306C), () => onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
                            _buildWin7ProgramItem('쿠팡 로켓쇼핑', null, const Color(0xFFC72424), () => onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
                            _buildWin7ProgramItem('Netflix 오리지널', null, const Color(0xFFE50914), () => onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
                            _buildWin7ProgramItem('동행복권 로또 6/45', null, const Color(0xFF0066B3), () => onOpenTemplate('lottery'), imageAsset: 'assets/images/lottery_icon.webp'),
                            _buildWin7ProgramItem('배달의민족 배송 현황', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), () => onOpenTemplate('delivery')),
                            _buildWin7ProgramItem('시스템 설정 (제어판)', CupertinoIcons.gear_alt_fill, const Color(0xFF475569), () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings())),
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
                              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                              child: user?.photoURL == null ? const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 20) : null,
                            ),
                            const SizedBox(height: 12),
                            _buildWin7SystemLink('컴퓨터', () => onOpenWinApp?.call('file_explorer')),
                            _buildWin7SystemLink('문서', () => onOpenWinApp?.call('file_explorer')),
                            _buildWin7SystemLink('사진', () => onOpenWinApp?.call('file_explorer')),
                            _buildWin7SystemLink('제어판 (설정)', () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings())),
                            _buildWin7SystemLink('랜딩 홈', onGoHome),
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
                                onTap: onSignOut,
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

  Widget _buildSearchInput(String placeholder) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.search, size: 16, color: Colors.white60),
          const SizedBox(width: 8),
          Text(placeholder, style: const TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildAppGrid() {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 2.2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        _buildAppItem('설정', null, const Color(0xFF0078D7), () => (onOpenWinApp != null ? onOpenWinApp!('settings') : onOpenSettings()), imageAsset: 'assets/images/windows/settings/System.webp'),
        _buildAppItem('파일 탐색기', null, const Color(0xFFF59E0B), () => onOpenWinApp?.call('file_explorer'), imageAsset: 'assets/images/windows/explorer.png'),
        _buildAppItem('Edge', null, const Color(0xFF0284C7), () => onOpenWinApp?.call('edge'), imageAsset: 'assets/images/windows/edge.png'),
        _buildAppItem('Chrome', null, const Color(0xFFEA4335), () => onOpenWinApp?.call('chrome'), imageAsset: 'assets/images/windows/chrome.png'),
        _buildAppItem('메모장', null, const Color(0xFF10B981), () => onOpenWinApp?.call('notepad'), imageAsset: 'assets/images/windows/notepad.png'),
        _buildAppItem('계산기', null, const Color(0xFF3B82F6), () => onOpenWinApp?.call('calculator'), imageAsset: 'assets/images/windows/calc.png'),
        _buildAppItem('카카오톡', null, const Color(0xFFFEE500), () => onOpenTemplate('kakaotalk'), imageAsset: 'assets/images/kakaotalk_icon.webp'),
        _buildAppItem('쿠팡', null, const Color(0xFFC72424), () => onOpenTemplate('coupang'), imageAsset: 'assets/images/coupang_icon.webp'),
        _buildAppItem('Netflix', null, const Color(0xFFE50914), () => onOpenTemplate('netflix'), imageAsset: 'assets/images/netflix_icon.webp'),
        _buildAppItem('YouTube', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => onOpenTemplate('youtube')),
        _buildAppItem('Instagram', null, const Color(0xFFE1306C), () => onOpenTemplate('instagram'), imageAsset: 'assets/images/instagram_icon.webp'),
        _buildAppItem('동행복권', null, const Color(0xFF0066B3), () => onOpenTemplate('lottery'), imageAsset: 'assets/images/lottery_icon.webp'),
        _buildAppItem('배달의민족', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), () => onOpenTemplate('delivery')),
        _buildAppItem('블루스크린', CupertinoIcons.device_desktop, const Color(0xFF0078D7), () => onOpenTemplate('windows_bsod')),
      ],
    );
  }

  Widget _buildAppItem(String title, IconData? icon, Color color, VoidCallback onTap, {String? imageAsset}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.white.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageAsset != null
                    ? Image.asset(imageAsset, fit: BoxFit.cover)
                    : (icon != null ? Icon(icon, color: color, size: 18) : const SizedBox()),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildBottomUserProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF6366F1),
              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null
                  ? const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'Fiction 창작자',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  user?.email ?? 'Google 계정',
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              tooltip: '랜딩 홈',
              icon: const Icon(CupertinoIcons.house_fill, color: Colors.white70, size: 18),
              onPressed: onGoHome,
            ),
            IconButton(
              tooltip: '로그아웃',
              icon: const Icon(CupertinoIcons.power, color: Color(0xFFEF4444), size: 18),
              onPressed: onSignOut,
            ),
          ],
        ),
      ],
    );
  }
}