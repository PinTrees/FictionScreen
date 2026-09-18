import 'package:flutter/material.dart';
import '../../data/netflix_model.dart';
import 'mobile_bottom_nav.dart';
import 'mobile_carousel.dart';
import 'mobile_header.dart';
import 'mobile_hero_banner.dart';
import 'mobile_top10_section.dart';

/// 넷플릭스 모바일 메인 홈 페이지
class MobileHomePage extends StatefulWidget {
  final NetflixConfig config;
  final ValueChanged<NetflixMediaItem> onSelectMedia;
  final VoidCallback onOpenProfileSelector;

  const MobileHomePage({
    super.key,
    required this.config,
    required this.onSelectMedia,
    required this.onOpenProfileSelector,
  });

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF141414),
      child: Column(
        children: [
          // 스크롤 메인 콘텐츠
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // 1. 모바일 세로형 히어로 포스터
                      MobileHeroBanner(
                        hero: widget.config.heroMedia,
                        onSelectMedia: widget.onSelectMedia,
                      ),

                      // 2. 오늘 대한민국 TOP 10 시리즈
                      MobileTop10Section(
                        items: widget.config.top10Series,
                        onSelectMedia: widget.onSelectMedia,
                      ),

                      // 3. 지금 뜨는 콘텐츠
                      MobileCarousel(
                        title: '지금 뜨는 콘텐츠',
                        items: widget.config.trendingList,
                        onSelectMedia: widget.onSelectMedia,
                      ),

                      // 4. 넷플릭스 오리지널
                      MobileCarousel(
                        title: '넷플릭스 오리지널',
                        items: widget.config.originalsList,
                        isOriginal: true,
                        onSelectMedia: widget.onSelectMedia,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // 상단 투명 헤더 & 카테고리 칩
                MobileHeader(
                  activeProfile: widget.config.activeProfile,
                  onOpenProfileSelector: widget.onOpenProfileSelector,
                ),
              ],
            ),
          ),

          // 하단 3탭 네비게이션
          MobileBottomNav(
            selectedTab: _selectedTab,
            onSelectTab: (idx) => setState(() => _selectedTab = idx),
            activeProfile: widget.config.activeProfile,
          ),
        ],
      ),
    );
  }
}
