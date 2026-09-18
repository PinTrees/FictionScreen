import 'package:flutter/material.dart';
import '../../data/netflix_model.dart';
import 'desktop_carousel.dart';
import 'desktop_footer.dart';
import 'desktop_header.dart';
import 'desktop_hero_banner.dart';
import 'desktop_top10_section.dart';

/// 넷플릭스 데스크탑 와이드 TV/Web 메인 페이지
class DesktopHomePage extends StatefulWidget {
  final NetflixConfig config;
  final ValueChanged<NetflixMediaItem> onSelectMedia;
  final VoidCallback onOpenProfileSelector;

  const DesktopHomePage({
    super.key,
    required this.config,
    required this.onSelectMedia,
    required this.onOpenProfileSelector,
  });

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  int _activeNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF141414),
      child: Stack(
        children: [
          // 스크롤 메인 콘텐츠
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 대형 히어로 배너
                DesktopHeroBanner(
                  hero: widget.config.heroMedia,
                  onSelectMedia: widget.onSelectMedia,
                ),

                // 2. 오늘 대한민국의 TOP 10 시리즈
                DesktopTop10Section(
                  items: widget.config.top10Series,
                  onSelectMedia: widget.onSelectMedia,
                ),

                // 3. 지금 뜨는 콘텐츠
                DesktopCarousel(
                  title: '지금 뜨는 콘텐츠',
                  items: widget.config.trendingList,
                  onSelectMedia: widget.onSelectMedia,
                ),

                // 4. 넷플릭스 오리지널
                DesktopCarousel(
                  title: '넷플릭스 오리지널',
                  items: widget.config.originalsList,
                  isOriginal: true,
                  onSelectMedia: widget.onSelectMedia,
                ),

                // 5. 내가 찜한 리스트
                if (widget.config.myList.isNotEmpty)
                  DesktopCarousel(
                    title: '내가 찜한 리스트',
                    items: widget.config.myList,
                    onSelectMedia: widget.onSelectMedia,
                  ),

                // 6. 푸터
                const DesktopFooter(),
              ],
            ),
          ),

          // 상단 플로팅 GNB 헤더
          DesktopHeader(
            activeProfile: widget.config.activeProfile,
            activeNavIndex: _activeNavIndex,
            onSelectNav: (idx) => setState(() => _activeNavIndex = idx),
            onOpenProfileSelector: widget.onOpenProfileSelector,
          ),
        ],
      ),
    );
  }
}
