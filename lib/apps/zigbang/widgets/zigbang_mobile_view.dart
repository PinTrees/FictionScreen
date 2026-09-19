import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/zigbang_model.dart';
import 'zigbang_edit_dialog.dart';

/// 직방 (Zigbang) 모바일 앱 뷰
class ZigbangMobileView extends StatefulWidget {
  final ZigbangConfig config;
  final ValueChanged<ZigbangConfig> onConfigChanged;

  const ZigbangMobileView({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<ZigbangMobileView> createState() => _ZigbangMobileViewState();
}

class _ZigbangMobileViewState extends State<ZigbangMobileView> {
  int _activeNavIndex = 0;
  String? _viewingPropertyId;

  @override
  Widget build(BuildContext context) {
    final activeProperty = widget.config.properties.firstWhere(
      (p) => p.id == (_viewingPropertyId ?? widget.config.selectedPropertyId),
      orElse: () => widget.config.properties.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // 1. 직방 시그니처 오렌지 검색 상단바
            _buildTopSearchBar(),

            // 2. 메인 스크롤 콘텐츠
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // 카테고리 퀵 선택 칩
                  _buildCategoryQuickBar(),
                  const SizedBox(height: 14),

                  // 배너 카드
                  _buildPromotionBanner(),
                  const SizedBox(height: 16),

                  // 매물 리스트 헤더
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '추천 매물 ${widget.config.properties.length}개',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E212B)),
                      ),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.slider_horizontal_3, size: 14, color: Color(0xFFFF7800)),
                          const SizedBox(width: 4),
                          Text(
                            widget.config.selectedCategory,
                            style: const TextStyle(fontSize: 12, color: Color(0xFFFF7800), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 매물 카드 목록
                  ...widget.config.properties.map((prop) {
                    final isSelected = prop.id == activeProperty.id;
                    return _buildPropertyCard(prop, isSelected);
                  }),
                ],
              ),
            ),

            // 3. 하단 탭 네비게이션 바
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSearchBar() {
    return Container(
      color: const Color(0xFFFF7800), // 직방 오렌지
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '직방',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.search, size: 16, color: Color(0xFFFF7800)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.config.searchQuery,
                          style: const TextStyle(color: Color(0xFF2B2B2B), fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ZigbangEditDialog(
                      config: widget.config,
                      onConfigChanged: widget.onConfigChanged,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.pencil_circle, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text('매물편집', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryQuickBar() {
    final categories = ['전체', '원·투룸', '아파트', '오피스텔', '빌라'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = widget.config.selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                widget.onConfigChanged(widget.config.copyWith(selectedCategory: cat));
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF7800) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFFF7800) : Colors.black12,
                  ),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF333333),
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3E8), Color(0xFFFFE6D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD5B3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7800),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(CupertinoIcons.shield_lefthalf_fill, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '직방 안심중개 & 100% 실매물 보증',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFB44B00)),
                ),
                SizedBox(height: 2),
                Text(
                  '허위매물 시 100% 보상금 지급! VR로 방 구경하세요',
                  style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(ZigbangProperty prop, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() => _viewingPropertyId = prop.id);
        widget.onConfigChanged(widget.config.copyWith(selectedPropertyId: prop.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF7800) : Colors.black12,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 매물 이미지 썸네일 & 뱃지
            Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: prop.imageType == 'luxury'
                      ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                      : (prop.imageType == 'apartment'
                          ? [const Color(0xFF0284C7), const Color(0xFF0369A1)]
                          : (prop.imageType == 'terrace'
                              ? [const Color(0xFF059669), const Color(0xFF047857)]
                              : [const Color(0xFFD97706), const Color(0xFFB45309)])),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7800),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          prop.roomType,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          prop.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                          color: prop.isLiked ? const Color(0xFFEF4444) : Colors.white70,
                          size: 20,
                        ),
                        onPressed: () {
                          final updated = widget.config.properties.map((p) {
                            if (p.id == prop.id) return p.copyWith(isLiked: !p.isLiked);
                            return p;
                          }).toList();
                          widget.onConfigChanged(widget.config.copyWith(properties: updated));
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(CupertinoIcons.location_solid, color: Colors.white70, size: 12),
                          const SizedBox(width: 4),
                          Text(prop.location, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        prop.priceDisplay,
                        style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 매물 정보 본문
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prop.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E212B)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${prop.area} · ${prop.floor} · 관리비 ${prop.maintenanceCost}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
                  ),
                  const SizedBox(height: 8),

                  // 태그 칩
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: prop.tags.map((tag) {
                      final isSpecial = tag.contains('직방') || tag.contains('VR');
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSpecial ? const Color(0xFFFFF0E6) : const Color(0xFFF1F3F5),
                          borderRadius: BorderRadius.circular(4),
                          border: isSpecial ? Border.all(color: const Color(0xFFFFD1B3), width: 0.6) : null,
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSpecial ? const Color(0xFFD95A00) : const Color(0xFF666666),
                            fontWeight: isSpecial ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: Colors.black12),
                  const SizedBox(height: 8),

                  // 중개사 정보
                  Row(
                    children: [
                      const Icon(CupertinoIcons.person_crop_circle_badge_checkmark, size: 14, color: Color(0xFFFF7800)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          prop.agentName,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF777777)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7800),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('문의하기', style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    final items = [
      {'icon': CupertinoIcons.house_fill, 'label': '홈'},
      {'icon': CupertinoIcons.map_fill, 'label': '지도'},
      {'icon': CupertinoIcons.heart_fill, 'label': '관심목록'},
      {'icon': CupertinoIcons.building_2_fill, 'label': '분양'},
      {'icon': CupertinoIcons.person_fill, 'label': '내방'},
    ];

    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 0.8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isSelected = _activeNavIndex == i;
          return InkWell(
            onTap: () => setState(() => _activeNavIndex = i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  items[i]['icon'] as IconData,
                  size: 20,
                  color: isSelected ? const Color(0xFFFF7800) : const Color(0xFF888888),
                ),
                const SizedBox(height: 2),
                Text(
                  items[i]['label'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xFFFF7800) : const Color(0xFF888888),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
