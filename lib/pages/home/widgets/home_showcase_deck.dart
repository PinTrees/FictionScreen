import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../apps/cctv/cctv_screen.dart';
import '../../../apps/cctv/data/cctv_model.dart';
import '../../../apps/coupang/coupang_screen.dart';
import '../../../apps/coupang/data/coupang_model.dart';
import '../../../apps/dcinside/dcinside_screen.dart';
import '../../../apps/dcinside/data/dcinside_model.dart';
import '../../../apps/excel/excel_screen.dart';
import '../../../apps/excel/data/excel_model.dart';
import '../../../apps/instagram/data/instagram_model.dart';
import '../../../apps/instagram/instagram_screen.dart';
import '../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../apps/kakaotalk/kakaotalk_screen.dart';
import '../../../apps/netflix/data/netflix_model.dart';
import '../../../apps/netflix/netflix_screen.dart';
import '../../../apps/news/data/news_model.dart';
import '../../../apps/news/news_screen.dart';
import '../../../apps/steam/data/steam_model.dart';
import '../../../apps/steam/steam_screen.dart';
import '../../../apps/toss/data/toss_model.dart';
import '../../../apps/toss/toss_screen.dart';
import '../../../apps/windows_bsod/data/windows_bsod_model.dart';
import '../../../apps/windows_bsod/windows_bsod_screen.dart';
import '../../../apps/youtube/data/youtube_model.dart';
import '../../../apps/youtube/youtube_screen.dart';
import '../../../widgets/common/device_frame_preview.dart';

class ShowcaseItem {
  final String id;
  final String label;
  final IconData icon;
  final Color themeColor;
  final String? badge;
  final bool isDesktop;

  const ShowcaseItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.themeColor,
    this.badge,
    this.isDesktop = false,
  });
}

class HomeShowcaseDeck extends StatefulWidget {
  final bool isMobile;
  final String activeTab;
  final ValueChanged<String> onTabChanged;

  const HomeShowcaseDeck({
    super.key,
    required this.isMobile,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  State<HomeShowcaseDeck> createState() => _HomeShowcaseDeckState();
}

class _HomeShowcaseDeckState extends State<HomeShowcaseDeck> {
  static const List<ShowcaseItem> _items = [
    ShowcaseItem(
      id: 'news',
      label: '뉴스 속보 TV',
      icon: CupertinoIcons.tv_fill,
      themeColor: Color(0xFFD32F2F),
      badge: 'HOT',
      isDesktop: true,
    ),
    ShowcaseItem(
      id: 'kakaotalk',
      label: '카카오톡',
      icon: CupertinoIcons.chat_bubble_2_fill,
      themeColor: Color(0xFFFEE500),
      badge: '대표',
    ),
    ShowcaseItem(
      id: 'dcinside',
      label: '디시인사이드',
      icon: CupertinoIcons.chat_bubble_2_fill,
      themeColor: Color(0xFF3B4890),
      badge: 'NEW',
      isDesktop: true,
    ),
    ShowcaseItem(
      id: 'excel',
      label: 'Microsoft Excel',
      icon: CupertinoIcons.table_fill,
      themeColor: Color(0xFF107C41),
      badge: 'NEW',
      isDesktop: true,
    ),
    ShowcaseItem(
      id: 'cctv',
      label: 'CCTV 보안 관제',
      icon: CupertinoIcons.videocam_fill,
      themeColor: Color(0xFFE53935),
      badge: '실감형',
      isDesktop: true,
    ),
    ShowcaseItem(
      id: 'steam',
      label: 'Steam 라이브러리',
      icon: CupertinoIcons.game_controller_solid,
      themeColor: Color(0xFF1B2838),
      badge: 'NEW',
      isDesktop: true,
    ),
    ShowcaseItem(
      id: 'youtube',
      label: '유튜브',
      icon: CupertinoIcons.play_circle_fill,
      themeColor: Color(0xFFFF0000),
      isDesktop: true,
    ),
    ShowcaseItem(
      id: 'toss',
      label: '토스',
      icon: CupertinoIcons.money_dollar_circle_fill,
      themeColor: Color(0xFF0050FF),
    ),
    ShowcaseItem(
      id: 'instagram',
      label: '인스타그램',
      icon: CupertinoIcons.camera_fill,
      themeColor: Color(0xFFE1306C),
    ),
    ShowcaseItem(
      id: 'netflix',
      label: '넷플릭스',
      icon: CupertinoIcons.tv_fill,
      themeColor: Color(0xFFE50914),
      isDesktop: true,
    ),
    ShowcaseItem(
      id: 'windows_bsod',
      label: 'Windows BSOD',
      icon: CupertinoIcons.device_desktop,
      themeColor: Color(0xFF0078D7),
      isDesktop: true,
    ),
    ShowcaseItem(
      id: 'coupang',
      label: '쿠팡',
      icon: CupertinoIcons.cart_fill,
      themeColor: Color(0xFFC72424),
      isDesktop: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentItem = _items.firstWhere(
      (item) => item.id == widget.activeTab,
      orElse: () => _items[0],
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 16 : 40,
        vertical: 24,
      ),
      padding: EdgeInsets.all(widget.isMobile ? 16 : 28),
      decoration: BoxDecoration(
        color: const Color(0xFF0F111A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: currentItem.themeColor.withValues(alpha: 0.08),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Bar
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: currentItem.themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: currentItem.themeColor.withValues(alpha: 0.3)),
                ),
                child: Icon(currentItem.icon, color: currentItem.themeColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '인터랙티브 라이브 쇼케이스',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.circle_fill, color: Colors.greenAccent, size: 6),
                              SizedBox(width: 4),
                              Text(
                                'LIVE RENDERING',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '탭을 클릭하면 실제 앱과 똑같이 작동하는 모의 화면을 즉시 확인할 수 있습니다.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Scrollable App Tabs with modern styling
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _items.map((item) {
                final isSelected = widget.activeTab == item.id;
                final isYellow = item.themeColor == const Color(0xFFFEE500);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => widget.onTabChanged(item.id),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isYellow ? item.themeColor : item.themeColor.withValues(alpha: 0.2))
                            : const Color(0xFF161824),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? item.themeColor
                              : Colors.white.withValues(alpha: 0.08),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: item.themeColor.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            size: 15,
                            color: isSelected
                                ? (isYellow ? Colors.black : Colors.white)
                                : item.themeColor,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected
                                  ? (isYellow ? Colors.black : Colors.white)
                                  : Colors.white.withValues(alpha: 0.75),
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          if (item.badge != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isYellow ? Colors.black.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.2))
                                    : item.themeColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.badge!,
                                style: TextStyle(
                                  color: isSelected
                                      ? (isYellow ? Colors.black : Colors.white)
                                      : item.themeColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Live Device Frame Container
          Container(
            height: widget.isMobile ? 480 : 540,
            decoration: BoxDecoration(
              color: const Color(0xFF090A0F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: DeviceFramePreview(
                  isDesktop: currentItem.isDesktop,
                  child: _buildActiveScreenWidget(widget.activeTab),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Bottom Action Bar
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.go('/studio/${widget.activeTab}'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.slider_horizontal_3, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${currentItem.label} 스튜디오에서 직접 편집하기',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                    ),
                    const SizedBox(width: 4),
                    const Icon(CupertinoIcons.arrow_right, size: 14),
                  ],
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.04),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.go('/console'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.device_desktop, size: 16),
                    SizedBox(width: 6),
                    Text('가상 OS 바탕화면에서 열기', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveScreenWidget(String id) {
    switch (id) {
      case 'news':
        return NewsScreen(config: NewsConfig.defaultPreset());
      case 'kakaotalk':
        return KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset());
      case 'dcinside':
        return DcinsideScreen(config: DcinsideConfig.defaultPreset());
      case 'excel':
        return ExcelScreen(config: ExcelConfig.defaultPreset());
      case 'cctv':
        return CctvScreen(config: CctvConfig.defaultPreset());
      case 'steam':
        return SteamScreen(config: SteamConfig.defaultPreset());
      case 'youtube':
        return YoutubeScreen(config: YoutubeConfig.defaultPreset());
      case 'toss':
        return TossScreen(config: TossConfig.defaultPreset());
      case 'instagram':
        return InstagramScreen(config: InstagramConfig.defaultPreset());
      case 'netflix':
        return NetflixScreen(config: NetflixConfig.defaultPreset());
      case 'windows_bsod':
        return WindowsBsodScreen(config: WindowsBsodConfig.defaultPreset());
      case 'coupang':
        return CoupangScreen(config: CoupangConfig.defaultPreset());
      default:
        return KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset());
    }
  }
}
