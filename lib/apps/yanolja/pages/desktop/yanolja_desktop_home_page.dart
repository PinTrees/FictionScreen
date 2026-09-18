import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/yanolja_model.dart';
import '../../widgets/yanolja_lodging_card.dart';
import 'yanolja_desktop_header.dart';

class YanoljaDesktopHomePage extends StatelessWidget {
  final YanoljaConfig config;
  final Function(YanoljaLodgingItem) onSelectLodging;
  final VoidCallback onEdit;

  const YanoljaDesktopHomePage({
    super.key,
    required this.config,
    required this.onSelectLodging,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          // 1. 데스크탑 GNB 헤더
          YanoljaDesktopHeader(
            region: config.region,
            dateText: config.dateText,
            onSearchTap: onEdit,
            onEdit: onEdit,
          ),

          // 2. 데스크탑 스크롤 메인 바디
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 대형 프로모션 히어로 배너
                      _buildDesktopHeroBanner(),
                      const SizedBox(height: 32),

                      // 10구 카테고리 아이콘 그리드
                      _buildCategoryRow(),
                      const SizedBox(height: 40),

                      // 추천 숙소 섹션 헤더
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${config.region} 인기 추천 숙소',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1E2024)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '검색 일정: ${config.dateText} (${config.guestCount}명)',
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          OutlinedButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 16, color: Color(0xFFFF3478)),
                            label: const Text('조건 변경', style: TextStyle(color: Color(0xFFFF3478), fontWeight: FontWeight.bold, fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFF3478)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 숙소 목록 (2열 반응형 그리드)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 18,
                              childAspectRatio: 0.86,
                            ),
                            itemCount: config.lodgings.length,
                            itemBuilder: (context, index) {
                              final lodging = config.lodgings[index];
                              return YanoljaLodgingCard(
                                item: lodging,
                                onTap: () => onSelectLodging(lodging),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 48),

                      // 하단 야놀자 데스크탑 공식 푸터
                      _buildDesktopFooter(),
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

  Widget _buildDesktopHeroBanner() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF3478), Color(0xFFFF6584), Color(0xFF7A42F4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3478).withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: const Text('NOL 야놀자 단독 특가', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Text(
                '놀라운 숙박 & 레저 최대 70% 쿠폰팩 증정!',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              const Text('국내 전 지역 호텔·리조트·풀빌라 즉시 할인 혜택', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            onPressed: onEdit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFF3478),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
            ),
            child: const Text('쿠폰받기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    final categories = [
      {'icon': CupertinoIcons.bed_double_fill, 'label': '모텔', 'color': const Color(0xFFFF3478)},
      {'icon': CupertinoIcons.building_2_fill, 'label': '호텔·리조트', 'color': const Color(0xFF3282F6)},
      {'icon': CupertinoIcons.house_alt_fill, 'label': '펜션·풀빌라', 'color': const Color(0xFF00B06B)},
      {'icon': CupertinoIcons.sun_haze_fill, 'label': '게하·한옥', 'color': const Color(0xFFFF8A00)},
      {'icon': CupertinoIcons.airplane, 'label': '항공', 'color': const Color(0xFF6C5CE7)},
      {'icon': CupertinoIcons.ticket_fill, 'label': '레저·티켓', 'color': const Color(0xFFE84393)},
      {'icon': CupertinoIcons.car_detailed, 'label': '렌터카', 'color': const Color(0xFF0984E3)},
      {'icon': CupertinoIcons.compass_fill, 'label': '해외여행', 'color': const Color(0xFF00CEC9)},
      {'icon': CupertinoIcons.calendar_badge_plus, 'label': '공간대여', 'color': const Color(0xFFE17055)},
      {'icon': CupertinoIcons.gift_fill, 'label': '혜택·이벤트', 'color': const Color(0xFFD63031)},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((cat) {
          return InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: (cat['color'] as Color).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(cat['label'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFFF3478), borderRadius: BorderRadius.circular(4)),
                child: const Text('NOL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              const SizedBox(width: 8),
              const Text('야놀자 서비스 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2024))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '(주)야놀자 | 대표이사 이수진, 배보찬, 김종윤 | 사업자등록번호: 220-87-42885 | 통신판매업신고: 2014-서울강남-01451호\n'
            '주소: 서울특별시 강남구 테헤란로 108길 42 (대치동) | 고객행복센터 1644-1346 (연중무휴 09:00~03:00)\n'
            '(주)야놀자는 통신판매중개자로서 통신판매의 당사자가 아니며 상품의 예약, 이용 및 환불 등과 관련한 의무와 책임은 각 판매자에게 있습니다.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.6),
          ),
          const SizedBox(height: 16),
          Text('Copyright YANOLJA Co., Ltd. All rights reserved.', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
