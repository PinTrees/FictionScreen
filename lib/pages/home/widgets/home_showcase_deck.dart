import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../apps/blind/blind_screen.dart';
import '../../../apps/blind/data/blind_model.dart';
import '../../../apps/daangn/daangn_screen.dart';
import '../../../apps/daangn/data/daangn_model.dart';
import '../../../apps/dcinside/dcinside_screen.dart';
import '../../../apps/dcinside/data/dcinside_model.dart';
import '../../../apps/excel/excel_screen.dart';
import '../../../apps/excel/data/excel_model.dart';
import '../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../apps/kakaotalk/kakaotalk_screen.dart';
import '../../../apps/news/data/news_model.dart';
import '../../../apps/news/news_screen.dart';
import '../../../apps/toss/data/toss_model.dart';
import '../../../apps/toss/toss_screen.dart';
import '../../../apps/upbit/data/upbit_model.dart';
import '../../../apps/upbit/upbit_screen.dart';
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
  final bool isDarkMode;
  final String activeTab;
  final ValueChanged<String> onTabChanged;

  const HomeShowcaseDeck({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  State<HomeShowcaseDeck> createState() => _HomeShowcaseDeckState();
}

class _HomeShowcaseDeckState extends State<HomeShowcaseDeck> {
  static const List<ShowcaseItem> _items = [
    ShowcaseItem(
      id: 'kakaotalk',
      label: '카카오톡',
      icon: CupertinoIcons.chat_bubble_2_fill,
      themeColor: Color(0xFFFEE500),
      badge: '대표',
    ),
    ShowcaseItem(
      id: 'daangn',
      label: '당근마켓',
      icon: CupertinoIcons.cart_fill,
      themeColor: Color(0xFFFF6F0F),
      badge: '인기',
    ),
    ShowcaseItem(
      id: 'blind',
      label: '블라인드',
      icon: CupertinoIcons.building_2_fill,
      themeColor: Color(0xFFDA3238),
      badge: 'HOT',
      isDesktop: true,
    ),
    ShowcaseItem(
      id: 'news',
      label: '뉴스 속보 TV',
      icon: CupertinoIcons.tv_fill,
      themeColor: Color(0xFFD32F2F),
      badge: 'HOT',
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
      id: 'dcinside',
      label: '디시인사이드',
      icon: CupertinoIcons.chat_bubble_2_fill,
      themeColor: Color(0xFF3B4890),
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
      label: '토스 송금',
      icon: CupertinoIcons.money_dollar_circle_fill,
      themeColor: Color(0xFF0050FF),
    ),
    ShowcaseItem(
      id: 'upbit',
      label: '업비트 코인',
      icon: CupertinoIcons.chart_bar_alt_fill,
      themeColor: Color(0xFF093687),
      isDesktop: true,
    ),
    ShowcaseItem(
      id: 'windows_bsod',
      label: 'Windows 오류',
      icon: CupertinoIcons.device_desktop,
      themeColor: Color(0xFF0078D7),
      isDesktop: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentItem = _items.firstWhere(
      (item) => item.id == widget.activeTab,
      orElse: () => _items[0],
    );

    final cardBg = widget.isDarkMode ? const Color(0xFF0F111A) : Colors.white;
    final titleColor = widget.isDarkMode ? Colors.white : const Color(0xFF0F172A);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 16 : 40,
        vertical: 24,
      ),
      padding: EdgeInsets.all(widget.isMobile ? 16 : 28),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode
                ? Colors.black.withValues(alpha: 0.45)
                : const Color(0x14000000),
            blurRadius: 30,
            offset: const Offset(0, 10),
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
                        Text(
                          '실시간 가상 화면 체험',
                          style: TextStyle(
                            color: titleColor,
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
                      '원하는 플랫폼 탭을 누르면 실제 앱과 100% 동일하게 렌더링되는 화면을 확인할 수 있습니다.',
                      style: TextStyle(
                        color: widget.isDarkMode
                            ? Colors.white.withValues(alpha: 0.5)
                            : const Color(0xFF64748B),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Scrollable App Tabs (Clean, NO OUTLINES)
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
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isYellow ? item.themeColor : item.themeColor)
                            : (widget.isDarkMode ? const Color(0xFF161824) : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: item.themeColor.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
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
                                  : (widget.isDarkMode ? Colors.white70 : const Color(0xFF334155)),
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
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
                                    : item.themeColor.withValues(alpha: 0.15),
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
              color: widget.isDarkMode ? const Color(0xFF090A0F) : const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 22),

          // Bottom Action Bar (Brand Gradient Primary, Soft Filled Secondary - NO OUTLINES)
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
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
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                      ),
                      const SizedBox(width: 6),
                      const Icon(CupertinoIcons.arrow_right, size: 14),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isDarkMode
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE2E8F0),
                  foregroundColor: widget.isDarkMode ? Colors.white : const Color(0xFF0F172A),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.go('/console'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.device_desktop, size: 16),
                    SizedBox(width: 6),
                    Text('가상 OS 바탕화면에서 열기', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
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
      case 'kakaotalk':
        return KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset());
      case 'daangn':
        return DaangnScreen(config: DaangnConfig.defaultPreset());
      case 'blind':
        return BlindScreen(config: BlindConfig.defaultPreset());
      case 'news':
        return NewsScreen(config: NewsConfig.defaultPreset());
      case 'excel':
        return ExcelScreen(config: ExcelConfig.defaultPreset());
      case 'dcinside':
        return DcinsideScreen(config: DcinsideConfig.defaultPreset());
      case 'youtube':
        return YoutubeScreen(config: YoutubeConfig.defaultPreset());
      case 'toss':
        return TossScreen(config: TossConfig.defaultPreset());
      case 'upbit':
        return UpbitScreen(config: UpbitConfig.defaultPreset());
      case 'windows_bsod':
        return WindowsBsodScreen(config: WindowsBsodConfig.defaultPreset());
      default:
        return KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset());
    }
  }
}
