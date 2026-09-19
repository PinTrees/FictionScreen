import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlatformAssetItem {
  final String id;
  final String name;
  final String imageAsset;
  final bool isConsole;

  const PlatformAssetItem({
    required this.id,
    required this.name,
    required this.imageAsset,
    this.isConsole = false,
  });
}

class HomeIconCloud extends StatelessWidget {
  final bool isMobile;
  final bool isDarkMode;

  const HomeIconCloud({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
  });

  static const List<PlatformAssetItem> _osList = [
    PlatformAssetItem(id: 'windows_11', name: 'Windows 11', imageAsset: 'assets/images/win11_logo.png', isConsole: true),
    PlatformAssetItem(id: 'windows_10', name: 'Windows 10', imageAsset: 'assets/images/win10_logo.png', isConsole: true),
    PlatformAssetItem(id: 'windows_7', name: 'Windows 7', imageAsset: 'assets/images/win7_logo.png', isConsole: true),
    PlatformAssetItem(id: 'windows_xp', name: 'Windows XP', imageAsset: 'assets/images/winxp_logo.png', isConsole: true),
    PlatformAssetItem(id: 'macos', name: 'macOS Sonoma', imageAsset: 'assets/images/macos/finder.webp', isConsole: true),
    PlatformAssetItem(id: 'windows_bsod', name: '블루스크린 (BSOD)', imageAsset: 'assets/images/win11_logo.png'),
    PlatformAssetItem(id: 'windows_update', name: '가짜 윈도우 업데이트', imageAsset: 'assets/images/windows/settings.png'),
  ];

  static const List<PlatformAssetItem> _appList = [
    PlatformAssetItem(id: 'kakaotalk', name: '카카오톡', imageAsset: 'assets/images/kakaotalk_icon.webp'),
    PlatformAssetItem(id: 'daangn', name: '당근마켓', imageAsset: 'assets/images/daangn_icon.webp'),
    PlatformAssetItem(id: 'toss', name: '토스 송금', imageAsset: 'assets/images/toss_icon.png'),
    PlatformAssetItem(id: 'kakaobank', name: '카카오뱅크', imageAsset: 'assets/images/kakaobank_icon.webp'),
    PlatformAssetItem(id: 'upbit', name: '업비트 코인', imageAsset: 'assets/images/upbit_icon.webp'),
    PlatformAssetItem(id: 'instagram', name: '인스타그램', imageAsset: 'assets/images/instagram_icon.webp'),
    PlatformAssetItem(id: 'delivery', name: '배달 플랫폼', imageAsset: 'assets/images/delivery_icon.webp'),
    PlatformAssetItem(id: 'lottery', name: '동행복권 1등', imageAsset: 'assets/images/lottery_icon.webp'),
    PlatformAssetItem(id: 'yanolja', name: '야놀자 여행', imageAsset: 'assets/images/yanolja_icon.webp'),
  ];

  static const List<PlatformAssetItem> _siteList = [
    PlatformAssetItem(id: 'blind', name: '블라인드', imageAsset: 'assets/images/blind_icon.webp'),
    PlatformAssetItem(id: 'dcinside', name: '디시인사이드', imageAsset: 'assets/images/dcinside_icon.webp'),
    PlatformAssetItem(id: 'news', name: '뉴스 속보 TV', imageAsset: 'assets/images/windows/news.png'),
    PlatformAssetItem(id: 'youtube', name: '유튜브', imageAsset: 'assets/images/youtube_icon.webp'),
    PlatformAssetItem(id: 'netflix', name: '넷플릭스', imageAsset: 'assets/images/netflix_icon.webp'),
    PlatformAssetItem(id: 'excel', name: 'Microsoft Excel', imageAsset: 'assets/images/excel_icon.webp'),
    PlatformAssetItem(id: 'powerpoint', name: 'PowerPoint (PPT)', imageAsset: 'assets/images/powerpoint_icon.webp'),
    PlatformAssetItem(id: 'word', name: 'Word 기밀문서', imageAsset: 'assets/images/word_icon.webp'),
    PlatformAssetItem(id: 'steam', name: 'Steam 게임', imageAsset: 'assets/images/steam_icon.webp'),
    PlatformAssetItem(id: 'naver', name: '네이버 포털', imageAsset: 'assets/images/naver_icon.webp'),
    PlatformAssetItem(id: 'coupang', name: '쿠팡 쇼핑몰', imageAsset: 'assets/images/coupang_icon.webp'),
    PlatformAssetItem(id: 'davinci_resolve', name: '다빈치 리졸브', imageAsset: 'assets/images/davinci_resolve_icon.webp'),
    PlatformAssetItem(id: 'photoshop', name: '포토샵 에디터', imageAsset: 'assets/images/photoshop_icon.webp'),
    PlatformAssetItem(id: 'visual_studio', name: '비주얼 스튜디오', imageAsset: 'assets/images/visual_studio_icon.webp'),
    PlatformAssetItem(id: 'chrome', name: '구글 크롬', imageAsset: 'assets/images/windows/chrome.png'),
    PlatformAssetItem(id: 'edge', name: '마이크로소프트 엣지', imageAsset: 'assets/images/windows/edge.png'),
    PlatformAssetItem(id: 'discord', name: '디스코드', imageAsset: 'assets/images/discord_icon.webp'),
    PlatformAssetItem(id: 'telegram', name: '텔레그램', imageAsset: 'assets/images/telegram_icon.webp'),
    PlatformAssetItem(id: 'x_twitter', name: 'X (트위터)', imageAsset: 'assets/images/x_twitter_icon.webp'),
    PlatformAssetItem(id: 'pinterest', name: '핀터레스트', imageAsset: 'assets/images/pinterest_icon.webp'),
    PlatformAssetItem(id: 'zigbang', name: '직방 부동산', imageAsset: 'assets/images/zigbang_icon.webp'),
  ];

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF475569);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1140),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 48,
          vertical: isMobile ? 64 : 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E1F30) : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'SUPPORTED ECOSYSTEM',
                      style: TextStyle(
                        color: isDarkMode ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '지원하는 모든 가상 OS, 어플, 웹사이트',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: isMobile ? 28 : 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '실제 공식 앱 아이콘을 클릭하면 해당 스튜디오 또는 가상 OS 콘솔로 즉시 이동합니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: isMobile ? 14.5 : 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),

            // Category 1: 가상 OS
            _buildCategoryHeader('🖥️ 가상 데스크톱 OS', '${_osList.length}종', titleColor),
            const SizedBox(height: 18),
            _buildIconGrid(context, _osList),

            const SizedBox(height: 52),

            // Category 2: 모바일 어플리케이션
            _buildCategoryHeader('📱 모바일 어플리케이션', '${_appList.length}종', titleColor),
            const SizedBox(height: 18),
            _buildIconGrid(context, _appList),

            const SizedBox(height: 52),

            // Category 3: 웹사이트 & 전문 툴
            _buildCategoryHeader('🌐 웹사이트 & 비즈니스 툴', '${_siteList.length}종', titleColor),
            const SizedBox(height: 18),
            _buildIconGrid(context, _siteList),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title, String countBadge, Color titleColor) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: isDarkMode ? 0.2 : 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            countBadge,
            style: const TextStyle(
              color: Color(0xFF6366F1),
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconGrid(BuildContext context, List<PlatformAssetItem> items) {
    final tileBg = isDarkMode ? const Color(0xFF111422) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: items.map((item) {
        return InkWell(
          onTap: () {
            if (item.isConsole) {
              context.go('/console');
            } else {
              context.go('/studio/${item.id}');
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: tileBg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? Colors.black.withValues(alpha: 0.3) : const Color(0x0C000000),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Real Official App/OS Logo!
                Container(
                  width: 32,
                  height: 32,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        item.imageAsset,
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(CupertinoIcons.app, size: 22),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  item.name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 11,
                  color: isDarkMode ? Colors.white38 : Colors.black26,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
