import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/naver_model.dart';
import 'naver_edit_dialog.dart';

/// 네이버 (Naver) 데스크톱 웹 포털 뷰 (정통 PC 포털 2단 레이아웃, 뉴스스탠드, 증시, 실시간 검색어)
class NaverDesktopView extends StatefulWidget {
  final NaverConfig config;
  final ValueChanged<NaverConfig> onConfigChanged;

  const NaverDesktopView({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<NaverDesktopView> createState() => _NaverDesktopViewState();
}

class _NaverDesktopViewState extends State<NaverDesktopView> {
  int _activePressIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6F8),
      child: Column(
        children: [
          // 1. 데스크톱 최상단 헤더 & 네이버 그린 검색창
          _buildDesktopTopHeader(),

          // 2. 서비스 메뉴 바 (메일, 카페, 블로그, 쇼핑 등)
          _buildServiceMenuBar(),

          // 3. 메인 포털 2-Column 레이아웃
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1040),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 좌측 메인: 뉴스스탠드 & 증시 & 트렌드 쇼핑 (약 680px)
                      Expanded(
                        child: Column(
                          children: [
                            _buildNewsstandCard(),
                            const SizedBox(height: 14),
                            _buildStockExchangeBanner(),
                            const SizedBox(height: 14),
                            _buildShoppingMallGrid(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // 우측 사이드바: 로그인 프로필 & 날씨 & 실시간 검색어 1~10위 (320px)
                      SizedBox(
                        width: 330,
                        child: Column(
                          children: [
                            _buildLoginProfileBox(),
                            const SizedBox(height: 14),
                            _buildWeatherWidget(),
                            const SizedBox(height: 14),
                            _buildTrendingRankingWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTopHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Row(
            children: [
              // NAVER 대형 녹색 로고
              const Text(
                'NAVER',
                style: TextStyle(
                  color: Color(0xFF03C75A),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(width: 24),

              // 대형 검색창
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF03C75A), width: 2.5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          widget.config.searchTerm,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(CupertinoIcons.keyboard, size: 20, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 8),
                      // 녹색 검색 버튼
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFF03C75A),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(2),
                            bottomRight: Radius.circular(2),
                          ),
                        ),
                        child: const Icon(CupertinoIcons.search, color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 이슈/뉴스 편집 버튼
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF03C75A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                icon: const Icon(CupertinoIcons.pencil_circle_fill, size: 16),
                label: const Text('포털 이슈 편집', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => NaverEditDialog(
                      config: widget.config,
                      onConfigChanged: widget.onConfigChanged,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceMenuBar() {
    final services = [
      {'name': '메일', 'color': Color(0xFF03C75A)},
      {'name': '카페', 'color': Color(0xFF03C75A)},
      {'name': '블로그', 'color': Color(0xFF03C75A)},
      {'name': '지식iN', 'color': Color(0xFF03C75A)},
      {'name': '쇼핑', 'color': Color(0xFF03C75A)},
      {'name': 'Pay', 'color': Color(0xFF03C75A)},
      {'name': 'TV', 'color': Color(0xFF4B5563)},
      {'name': '사전', 'color': Color(0xFF4B5563)},
      {'name': '뉴스', 'color': Color(0xFF4B5563)},
      {'name': '증권', 'color': Color(0xFF4B5563)},
      {'name': '부동산', 'color': Color(0xFF4B5563)},
      {'name': '지도', 'color': Color(0xFF4B5563)},
      {'name': '웹툰', 'color': Color(0xFF03C75A)},
    ];

    return Container(
      color: Colors.white,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFF3F4F6)),
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Row(
            children: services.map((s) {
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                  child: Text(
                    s['name'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: s['color'] as Color,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsstandCard() {
    final pressList = ['연합뉴스', '조선일보', '중앙일보', '동아일보', 'KBS', 'MBC'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 뉴스스탠드 상단 바
          Row(
            children: [
              const Text(
                '뉴스스탠드',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              const SizedBox(width: 12),
              ...List.generate(pressList.length, (i) {
                final isSelected = _activePressIndex == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => setState(() => _activePressIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE8F8EE) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                        border: isSelected ? Border.all(color: const Color(0xFF03C75A)) : null,
                      ),
                      child: Text(
                        pressList[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? const Color(0xFF03C75A) : const Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 14),

          // 메인 헤드라인 기사
          ...widget.config.newsList.map((news) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Text(
                        news.press,
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      news.title,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937), fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(news.time, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStockExchangeBanner() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIndexItem('코스피', widget.config.kospi, widget.config.kospiChange, true),
          const VerticalDivider(width: 1),
          _buildIndexItem('코스닥', widget.config.kosdaq, widget.config.kosdaqChange, true),
          const VerticalDivider(width: 1),
          _buildIndexItem('원/달러', widget.config.usdRate, '-2.30 (-0.17%)', false),
        ],
      ),
    );
  }

  Widget _buildIndexItem(String title, String val, String change, bool isUp) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4B5563))),
        const SizedBox(width: 8),
        Text(val, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: isUp ? const Color(0xFFDC2626) : const Color(0xFF2563EB))),
        const SizedBox(width: 6),
        Text(change, style: TextStyle(fontSize: 11, color: isUp ? const Color(0xFFDC2626) : const Color(0xFF2563EB))),
      ],
    );
  }

  Widget _buildShoppingMallGrid() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('오늘의 쇼핑 & 트렌드 핫딜', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              const Row(
                children: [
                  Text('1 / 12', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  SizedBox(width: 6),
                  Icon(CupertinoIcons.chevron_left, size: 12, color: Color(0xFF6B7280)),
                  Icon(CupertinoIcons.chevron_right, size: 12, color: Color(0xFF6B7280)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: widget.config.shoppingList.map((item) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Icon(CupertinoIcons.bag_fill, color: Color(0xFF03C75A), size: 24),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(item.title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(item.discount, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(item.price, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF111827)), maxLines: 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginProfileBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF03C75A),
                ),
                child: const Center(
                  child: Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('픽션크리에이터님', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  SizedBox(height: 2),
                  Text('fiction@naver.com', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _UserQuickStat('알림', '3'),
              _UserQuickStat('메일', '12'),
              _UserQuickStat('쪽지', '1'),
              _UserQuickStat('Pay포인트', '24,500원'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(CupertinoIcons.sun_max_fill, color: Color(0xFFF59E0B), size: 26),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('서울 ${widget.config.weatherTemp}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              Text(widget.config.weatherStatus, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            ],
          ),
          const Spacer(),
          Text('미세먼지 ${widget.config.fineDust}', style: const TextStyle(fontSize: 11, color: Color(0xFF03C75A), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTrendingRankingWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('급상승 검색 트렌드 1~10위', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              Text('${DateTime.now().hour}:00 기준', style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
            ],
          ),
          const SizedBox(height: 10),
          ...widget.config.trendingList.map((trend) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Text(
                      '${trend.rank}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: trend.rank <= 3 ? const Color(0xFF03C75A) : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      trend.keyword,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    trend.change,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: trend.isNew ? const Color(0xFFEF4444) : const Color(0xFF9CA3AF),
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
}

class _UserQuickStat extends StatelessWidget {
  final String label;
  final String val;
  const _UserQuickStat(this.label, this.val);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10.5, color: Color(0xFF6B7280))),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
      ],
    );
  }
}
