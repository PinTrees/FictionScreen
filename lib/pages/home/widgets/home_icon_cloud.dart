import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlatformIconItem {
  final String id;
  final String name;
  final IconData icon;
  final Color brandColor;
  final bool isConsole;

  const PlatformIconItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.brandColor,
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

  static const List<PlatformIconItem> _osList = [
    PlatformIconItem(id: 'windows_11', name: 'Windows 11', icon: CupertinoIcons.device_desktop, brandColor: Color(0xFF0078D7), isConsole: true),
    PlatformIconItem(id: 'windows_10', name: 'Windows 10', icon: CupertinoIcons.device_desktop, brandColor: Color(0xFF0078D7), isConsole: true),
    PlatformIconItem(id: 'windows_7', name: 'Windows 7', icon: CupertinoIcons.device_desktop, brandColor: Color(0xFF00A4EF), isConsole: true),
    PlatformIconItem(id: 'windows_xp', name: 'Windows XP', icon: CupertinoIcons.device_desktop, brandColor: Color(0xFF2E6DA4), isConsole: true),
    PlatformIconItem(id: 'macos', name: 'macOS Sonoma', icon: CupertinoIcons.desktopcomputer, brandColor: Color(0xFFA3AAAE), isConsole: true),
    PlatformIconItem(id: 'windows_bsod', name: '블루스크린 (BSOD)', icon: CupertinoIcons.exclamationmark_triangle_fill, brandColor: Color(0xFF0078D7)),
    PlatformIconItem(id: 'windows_update', name: '가짜 윈도우 업데이트', icon: CupertinoIcons.arrow_clockwise, brandColor: Color(0xFF0078D7)),
  ];

  static const List<PlatformIconItem> _appList = [
    PlatformIconItem(id: 'kakaotalk', name: '카카오톡', icon: CupertinoIcons.chat_bubble_2_fill, brandColor: Color(0xFFFEE500)),
    PlatformIconItem(id: 'daangn', name: '당근마켓', icon: CupertinoIcons.cart_fill, brandColor: Color(0xFFFF6F0F)),
    PlatformIconItem(id: 'toss', name: '토스 송금', icon: CupertinoIcons.money_dollar_circle_fill, brandColor: Color(0xFF0050FF)),
    PlatformIconItem(id: 'kakaobank', name: '카카오뱅크', icon: CupertinoIcons.creditcard_fill, brandColor: Color(0xFFFEE500)),
    PlatformIconItem(id: 'upbit', name: '업비트 코인', icon: CupertinoIcons.chart_bar_alt_fill, brandColor: Color(0xFF093687)),
    PlatformIconItem(id: 'instagram', name: '인스타그램', icon: CupertinoIcons.camera_fill, brandColor: Color(0xFFE1306C)),
    PlatformIconItem(id: 'delivery', name: '배달 플랫폼', icon: CupertinoIcons.bag_fill, brandColor: Color(0xFF2AC1BC)),
    PlatformIconItem(id: 'lottery', name: '동행복권 1등', icon: CupertinoIcons.tickets_fill, brandColor: Color(0xFF0066B3)),
    PlatformIconItem(id: 'yanolja', name: '야놀자 여행', icon: CupertinoIcons.bed_double_fill, brandColor: Color(0xFFFF3478)),
  ];

  static const List<PlatformIconItem> _siteList = [
    PlatformIconItem(id: 'blind', name: '블라인드', icon: CupertinoIcons.building_2_fill, brandColor: Color(0xFFDA3238)),
    PlatformIconItem(id: 'dcinside', name: '디시인사이드', icon: CupertinoIcons.chat_bubble_2_fill, brandColor: Color(0xFF3B4890)),
    PlatformIconItem(id: 'news', name: '뉴스 속보 TV', icon: CupertinoIcons.tv_fill, brandColor: Color(0xFFD32F2F)),
    PlatformIconItem(id: 'youtube', name: '유튜브', icon: CupertinoIcons.play_circle_fill, brandColor: Color(0xFFFF0000)),
    PlatformIconItem(id: 'netflix', name: '넷플릭스', icon: CupertinoIcons.tv_fill, brandColor: Color(0xFFE50914)),
    PlatformIconItem(id: 'excel', name: 'Microsoft Excel', icon: CupertinoIcons.table_fill, brandColor: Color(0xFF107C41)),
    PlatformIconItem(id: 'powerpoint', name: 'PowerPoint (PPT)', icon: CupertinoIcons.tv_fill, brandColor: Color(0xFFD83B01)),
    PlatformIconItem(id: 'word', name: 'Word 기밀문서', icon: CupertinoIcons.doc_text_fill, brandColor: Color(0xFF185ABD)),
    PlatformIconItem(id: 'steam', name: 'Steam 게임', icon: CupertinoIcons.game_controller_solid, brandColor: Color(0xFF1B2838)),
    PlatformIconItem(id: 'naver', name: '네이버 포털', icon: CupertinoIcons.search_circle_fill, brandColor: Color(0xFF03C75A)),
    PlatformIconItem(id: 'coupang', name: '쿠팡 쇼핑몰', icon: CupertinoIcons.cart_fill, brandColor: Color(0xFFC72424)),
    PlatformIconItem(id: 'davinci_resolve', name: '다빈치 리졸브', icon: CupertinoIcons.videocam_circle_fill, brandColor: Color(0xFFE53935)),
    PlatformIconItem(id: 'photoshop', name: '포토샵 에디터', icon: CupertinoIcons.paintbrush_fill, brandColor: Color(0xFF31A8FF)),
    PlatformIconItem(id: 'visual_studio', name: '비주얼 스튜디오', icon: CupertinoIcons.chevron_left_slash_chevron_right, brandColor: Color(0xFF68217A)),
    PlatformIconItem(id: 'chrome', name: '구글 크롬', icon: CupertinoIcons.globe, brandColor: Color(0xFF4285F4)),
    PlatformIconItem(id: 'edge', name: '마이크로소프트 엣지', icon: CupertinoIcons.globe, brandColor: Color(0xFF0078D7)),
    PlatformIconItem(id: 'discord', name: '디스코드', icon: CupertinoIcons.game_controller_solid, brandColor: Color(0xFF5865F2)),
    PlatformIconItem(id: 'telegram', name: '텔레그램', icon: CupertinoIcons.paperplane_fill, brandColor: Color(0xFF2B5278)),
    PlatformIconItem(id: 'x_twitter', name: 'X (트위터)', icon: CupertinoIcons.conversation_bubble, brandColor: Color(0xFF1D9BF0)),
    PlatformIconItem(id: 'pinterest', name: '핀터레스트', icon: CupertinoIcons.sparkles, brandColor: Color(0xFFE60023)),
    PlatformIconItem(id: 'zigbang', name: '직방 부동산', icon: CupertinoIcons.house_alt_fill, brandColor: Color(0xFFFF7800)),
  ];

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0xFF475569);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1F30) : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'SUPPORTED ECOSYSTEM',
                    style: TextStyle(
                      color: isDarkMode ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '지원하는 모든 가상 OS, 어플, 웹사이트',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: isMobile ? 26 : 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '원하는 플랫폼 아이콘을 클릭하면 해당 스튜디오 또는 가상 OS 콘솔로 즉시 이동합니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Category 1: 가상 OS
          _buildCategoryHeader('🖥️ 가상 데스크톱 OS', '${_osList.length}종 지원', titleColor),
          const SizedBox(height: 14),
          _buildIconGrid(context, _osList),

          const SizedBox(height: 40),

          // Category 2: 모바일 어플리케이션
          _buildCategoryHeader('📱 모바일 어플리케이션', '${_appList.length}종 지원', titleColor),
          const SizedBox(height: 14),
          _buildIconGrid(context, _appList),

          const SizedBox(height: 40),

          // Category 3: 웹사이트 & 전문 툴
          _buildCategoryHeader('🌐 웹사이트 & 비즈니스 툴', '${_siteList.length}종 지원', titleColor),
          const SizedBox(height: 14),
          _buildIconGrid(context, _siteList),
        ],
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
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: isDarkMode ? 0.18 : 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            countBadge,
            style: const TextStyle(
              color: Color(0xFF6366F1),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconGrid(BuildContext context, List<PlatformIconItem> items) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((item) {
        final isYellow = item.brandColor == const Color(0xFFFEE500);

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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF10121C)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? Colors.black.withValues(alpha: 0.25) : const Color(0x0C000000),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: item.brandColor.withValues(alpha: isDarkMode ? 0.18 : 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      color: isYellow ? (isDarkMode ? const Color(0xFFFEE500) : const Color(0xFFD97706)) : item.brandColor,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  item.name,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 11,
                  color: isDarkMode ? Colors.white30 : Colors.black26,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
