import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/yanolja_model.dart';
import '../../widgets/yanolja_lodging_card.dart';

class YanoljaMobileHomePage extends StatelessWidget {
  final YanoljaConfig config;
  final Function(YanoljaLodgingItem) onSelectLodging;
  final VoidCallback onOpenEditDialog;

  const YanoljaMobileHomePage({
    super.key,
    required this.config,
    required this.onSelectLodging,
    required this.onOpenEditDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Column(
          children: [
            // 1. 상단 핑크 헤더 & 검색 바
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      // NOL / 야놀자 로고
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3478),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('NOL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: -0.5)),
                          ),
                          const SizedBox(width: 6),
                          const Text('야놀자', style: TextStyle(color: Color(0xFFFF3478), fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(CupertinoIcons.bell, size: 20, color: Colors.black87),
                        onPressed: onOpenEditDialog,
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 18, color: Colors.black87),
                        onPressed: onOpenEditDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 검색바
                  GestureDetector(
                    onTap: onOpenEditDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.search, size: 18, color: Color(0xFFFF3478)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              config.selectedRegion,
                              style: const TextStyle(color: Color(0xFF191919), fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Icon(CupertinoIcons.calendar, size: 16, color: Colors.black45),
                          const SizedBox(width: 4),
                          Text(config.dateRangeText.split('·')[0].trim(), style: const TextStyle(color: Colors.black54, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. 스크롤 메인 콘텐츠
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // 카테고리 퀵 그리드 (10개)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildCategoryItem('호텔·리조트', CupertinoIcons.building_2_fill, const Color(0xFF3B82F6)),
                            _buildCategoryItem('펜션·풀빌라', CupertinoIcons.sparkles, const Color(0xFF10B981)),
                            _buildCategoryItem('모텔', CupertinoIcons.bed_double_fill, const Color(0xFFFF3478)),
                            _buildCategoryItem('캠핑·글램핑', CupertinoIcons.tree, const Color(0xFFF59E0B)),
                            _buildCategoryItem('게스트하우스', CupertinoIcons.house_alt, const Color(0xFF8B5CF6)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildCategoryItem('해외항공', CupertinoIcons.airplane, const Color(0xFF0284C7)),
                            _buildCategoryItem('해외숙소', CupertinoIcons.globe, const Color(0xFF6366F1)),
                            _buildCategoryItem('레저·티켓', CupertinoIcons.ticket_fill, const Color(0xFFEC4899)),
                            _buildCategoryItem('KTX·교통', CupertinoIcons.train_style_one, const Color(0xFF14B8A6)),
                            _buildCategoryItem('공연·전시', CupertinoIcons.music_mic, const Color(0xFFF97316)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 프로모션 배너
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF3478), Color(0xFFFF6584)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF3478).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('NOL 단독 특가 위크', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                              SizedBox(height: 4),
                              Text('전국 인기 호텔/풀빌라 최대 65% + 10만원 쿠폰팩', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                        ),
                        Text('🔥', style: TextStyle(fontSize: 28)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 추천 숙소 리스트 헤더
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '지금 인기 있는 숙소 특가',
                          style: TextStyle(color: Color(0xFF191919), fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '총 ${config.lodgings.length}개',
                          style: const TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 숙소 카드 리스트
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: config.lodgings.map((lodging) {
                        return YanoljaLodgingCard(
                          item: lodging,
                          onTap: () => onSelectLodging(lodging),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF333333), fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
