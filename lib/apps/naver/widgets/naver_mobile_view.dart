import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/naver_model.dart';
import 'naver_edit_dialog.dart';

/// 네이버 (Naver) 모바일 앱 뷰 (그린닷, 실시간 검색어 롤링, 뉴스스탠드 피드)
class NaverMobileView extends StatefulWidget {
  final NaverConfig config;
  final ValueChanged<NaverConfig> onConfigChanged;

  const NaverMobileView({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<NaverMobileView> createState() => _NaverMobileViewState();
}

class _NaverMobileViewState extends State<NaverMobileView> {
  int _activeTab = 1; // 0: 쇼핑, 1: 홈, 2: 콘텐츠

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. 네이버 그린 검색 헤더
                _buildGreenSearchHeader(),

                // 2. 홈 탭 네비게이션 (쇼핑/마이, 홈, 콘텐츠)
                _buildTabNav(),

                // 3. 메인 콘텐츠 스크롤
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 70),
                    children: [
                      // 실시간 날씨 & 미세먼지 위젯
                      _buildWeatherWidget(),

                      // 실시간 급상승 검색어 롤링 티커
                      _buildTrendingKeywordsWidget(),

                      // 주요 언론사 뉴스 피드
                      _buildNewsFeedWidget(),

                      // 오늘의 추천 쇼핑 특가
                      _buildShoppingWidget(),
                    ],
                  ),
                ),
              ],
            ),

            // 4. 네이버 시그니처 '그린닷 (Green Dot)' 인터랙티브 플로팅 버튼
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => NaverEditDialog(
                        config: widget.config,
                        onConfigChanged: widget.onConfigChanged,
                      ),
                    );
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFF03C75A), Color(0xFF00A844)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF03C75A).withValues(alpha: 0.45),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreenSearchHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'NAVER',
                style: TextStyle(
                  color: Color(0xFF03C75A),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              // 네이버페이 아이콘
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF03C75A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('N Pay', style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              // 편집 버튼
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => NaverEditDialog(
                      config: widget.config,
                      onConfigChanged: widget.onConfigChanged,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.pencil_circle, size: 14, color: Color(0xFF03C75A)),
                      SizedBox(width: 4),
                      Text('이슈편집', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF03C75A))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 녹색 테두리 검색바
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(21),
              border: Border.all(color: const Color(0xFF03C75A), width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.config.searchTerm,
                    style: const TextStyle(fontSize: 13.5, color: Color(0xFF1F2937), fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(CupertinoIcons.mic_fill, size: 16, color: Color(0xFF03C75A)),
                const SizedBox(width: 10),
                const Icon(CupertinoIcons.camera_fill, size: 16, color: Color(0xFF03C75A)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNav() {
    final tabs = ['쇼핑·MY', '홈', '콘텐츠'];
    return Container(
      color: Colors.white,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (i) {
          final isSelected = _activeTab == i;
          return InkWell(
            onTap: () => setState(() => _activeTab = i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                border: isSelected
                    ? const Border(bottom: BorderSide(color: Color(0xFF03C75A), width: 2.5))
                    : null,
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF03C75A) : const Color(0xFF4B5563),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.sun_max_fill, color: Color(0xFFF59E0B), size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.config.weatherTemp,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
                  ),
                  const SizedBox(width: 6),
                  Text(widget.config.weatherStatus, style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
                ],
              ),
              const SizedBox(height: 2),
              Text('미세먼지 ${widget.config.fineDust}', style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('코스피 ${widget.config.kospi}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
              Text(widget.config.kospiChange, style: const TextStyle(fontSize: 10, color: Color(0xFFDC2626))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingKeywordsWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(CupertinoIcons.flame_fill, size: 15, color: Color(0xFFEF4444)),
                  SizedBox(width: 4),
                  Text('실시간 급상승 검색 트렌드', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                ],
              ),
              Text('${DateTime.now().hour}:00 기준', style: const TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF))),
            ],
          ),
          const SizedBox(height: 10),
          ...widget.config.trendingList.take(5).map((trend) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      '${trend.rank}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: trend.rank <= 3 ? const Color(0xFF03C75A) : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      trend.keyword,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF1F2937), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: trend.isNew ? const Color(0xFFFEF2F2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      trend.change,
                      style: TextStyle(
                        fontSize: 10,
                        color: trend.isNew ? const Color(0xFFEF4444) : const Color(0xFF9CA3AF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNewsFeedWidget() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('주요 언론사 헤드라인 뉴스', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
              Row(
                children: [
                  const Icon(CupertinoIcons.circle_grid_hex_fill, size: 13, color: Color(0xFF03C75A)),
                  const SizedBox(width: 4),
                  const Text('뉴스스탠드', style: TextStyle(fontSize: 11, color: Color(0xFF03C75A), fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...widget.config.newsList.map((news) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF111827), fontWeight: FontWeight.w600, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(news.press, style: const TextStyle(fontSize: 11, color: Color(0xFF03C75A), fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      Text('· ${news.time}', style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildShoppingWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('오늘의 네이버 쇼핑 HOT 트렌드', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.config.shoppingList.map((shop) {
                return Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Icon(CupertinoIcons.bag_fill, color: Color(0xFF03C75A), size: 24),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(shop.title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(shop.price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                      Text(shop.mall, style: const TextStyle(fontSize: 9.5, color: Color(0xFF6B7280))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
