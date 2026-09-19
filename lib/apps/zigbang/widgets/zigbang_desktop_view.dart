import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/zigbang_model.dart';
import 'zigbang_edit_dialog.dart';

/// 직방 (Zigbang) 데스크톱 웹 포털 뷰 (2단 분할 레이아웃 & 가상 지도 캔버스)
class ZigbangDesktopView extends StatefulWidget {
  final ZigbangConfig config;
  final ValueChanged<ZigbangConfig> onConfigChanged;

  const ZigbangDesktopView({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<ZigbangDesktopView> createState() => _ZigbangDesktopViewState();
}

class _ZigbangDesktopViewState extends State<ZigbangDesktopView> {
  String? _hoveredPropertyId;

  @override
  Widget build(BuildContext context) {
    final activeProperty = widget.config.selectedProperty;

    return Container(
      color: const Color(0xFFF7F8FA),
      child: Column(
        children: [
          // 1. 직방 데스크톱 최상단 헤더
          _buildDesktopHeader(),

          // 2. 메인 2단 분할 포털 본문
          Expanded(
            child: Row(
              children: [
                // 좌측: 검색 필터 & 매물 리스트
                SizedBox(
                  width: 390,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(right: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFilterBar(),
                        const Divider(height: 1, color: Color(0xFFE5E7EB)),
                        Expanded(child: _buildPropertyList(activeProperty)),
                      ],
                    ),
                  ),
                ),

                // 우측: 가상 지도 & 선택 매물 상세 캔버스
                Expanded(
                  child: Stack(
                    children: [
                      _buildVirtualMapCanvas(activeProperty),
                      Positioned(
                        right: 20,
                        top: 20,
                        bottom: 20,
                        width: 360,
                        child: _buildDetailCard(activeProperty),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader() {
    final navItems = ['원·투룸', '아파트', '오피스텔', '빌라', '중개의뢰', '공인중개사'];

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          // 직방 로고
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7800),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(CupertinoIcons.house_alt_fill, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                '직방',
                style: TextStyle(
                  color: Color(0xFFFF7800),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 32),

          // 상단 네비게이션 탭
          ...navItems.map((item) {
            final isSelected = widget.config.selectedCategory == item ||
                (widget.config.selectedCategory == '전체' && item == '원·투룸');
            return InkWell(
              onTap: () {
                widget.onConfigChanged(widget.config.copyWith(selectedCategory: item));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  border: isSelected
                      ? const Border(bottom: BorderSide(color: Color(0xFFFF7800), width: 2.5))
                      : null,
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFFFF7800) : const Color(0xFF333333),
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // 검색 인풋창
          Container(
            width: 240,
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.search, size: 14, color: Color(0xFFFF7800)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.config.searchQuery,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // 매물/스토리 편집 모달 버튼
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7800),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(CupertinoIcons.pencil_circle_fill, size: 14),
            label: const Text('매물 편집', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ZigbangEditDialog(
                  config: widget.config,
                  onConfigChanged: widget.onConfigChanged,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = ['전체', '월세', '전세', '매매'];
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '매물 목록 (${widget.config.properties.length})',
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E212B)),
              ),
              const Row(
                children: [
                  Icon(CupertinoIcons.arrow_up_arrow_down, size: 12, color: Color(0xFF6B7280)),
                  SizedBox(width: 4),
                  Text('추천순', style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((f) {
                final isSelected = f == '전체';
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFF3E8) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF7800) : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? const Color(0xFFFF7800) : const Color(0xFF4B5563),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList(ZigbangProperty activeProperty) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: widget.config.properties.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        final prop = widget.config.properties[idx];
        final isSelected = prop.id == activeProperty.id;

        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredPropertyId = prop.id),
          onExit: (_) => setState(() => _hoveredPropertyId = null),
          child: InkWell(
            onTap: () {
              widget.onConfigChanged(widget.config.copyWith(selectedPropertyId: prop.id));
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFF7F0)
                    : (_hoveredPropertyId == prop.id ? const Color(0xFFF9FAFB) : Colors.white),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF7800) : const Color(0xFFE5E7EB),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 썸네일 박스
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: prop.imageType == 'luxury'
                            ? [const Color(0xFF1E293B), const Color(0xFF475569)]
                            : (prop.imageType == 'apartment'
                                ? [const Color(0xFF0369A1), const Color(0xFF38BDF8)]
                                : (prop.imageType == 'terrace'
                                    ? [const Color(0xFF047857), const Color(0xFF34D399)]
                                    : [const Color(0xFFB45309), const Color(0xFFFBBF24)])),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        prop.roomType,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 매물 내용
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prop.priceDisplay,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          prop.title,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF374151), fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${prop.area} · ${prop.floor}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          children: prop.tags.take(2).map((t) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(t, style: const TextStyle(fontSize: 9.5, color: Color(0xFF6B7280))),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVirtualMapCanvas(ZigbangProperty activeProperty) {
    return Container(
      color: const Color(0xFFE8ECEF),
      child: CustomPaint(
        painter: _ZigbangMapGridPainter(),
        child: Stack(
          children: [
            // 지도 컨트롤 (줌 등)
            Positioned(
              left: 20,
              top: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    IconButton(icon: const Icon(CupertinoIcons.plus, size: 16), onPressed: () {}),
                    const Divider(height: 1),
                    IconButton(icon: const Icon(CupertinoIcons.minus, size: 16), onPressed: () {}),
                  ],
                ),
              ),
            ),

            // 각 매물 위치 핀 마커들
            _buildMapMarker(180, 140, '루카831\n5000/280', true),
            _buildMapMarker(320, 240, '마포래미안\n18.5억', false),
            _buildMapMarker(120, 310, '연남테라스\n1000/75', false),
            _buildMapMarker(270, 390, '판교투룸\n전세 4.8억', false),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMarker(double x, double y, String label, bool isPrimary) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFFF7800) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPrimary ? Colors.white : const Color(0xFFFF7800),
            width: 1.5,
          ),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isPrimary ? Colors.white : const Color(0xFF1E212B),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(ZigbangProperty prop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 사진 배너
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: prop.imageType == 'luxury'
                    ? [const Color(0xFF0F172A), const Color(0xFF334155)]
                    : [const Color(0xFF0284C7), const Color(0xFF075985)],
              ),
            ),
            padding: const EdgeInsets.all(14),
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
                      child: Text(prop.roomType, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const Icon(CupertinoIcons.viewfinder_circle_fill, color: Colors.white, size: 24),
                  ],
                ),
                Text(
                  prop.priceDisplay,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),

          // 상세 스펙
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(prop.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(height: 8),
                Text(prop.description, style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.4)),
                const SizedBox(height: 14),

                _buildSpecRow('전용면적', prop.area),
                _buildSpecRow('해당층/총층', prop.floor),
                _buildSpecRow('관리비', prop.maintenanceCost),
                _buildSpecRow('위치', prop.location),
                const SizedBox(height: 14),

                const Text('매물 특징 및 옵션', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E212B))),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: prop.tags.map((t) {
                    return Chip(
                      label: Text(t, style: const TextStyle(fontSize: 10, color: Color(0xFFD95A00))),
                      backgroundColor: const Color(0xFFFFF3E8),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.building_2_fill, color: Color(0xFFFF7800), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prop.agentName,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 하단 전화/상담 버튼
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7800),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: const Text('중개사에게 문의하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
        ],
      ),
    );
  }
}

class _ZigbangMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 1.5;

    // 가상 도로망 그리드
    for (double x = 40; x < size.width; x += 120) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 40; y < size.height; y += 120) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // 가상 하천 / 공원 (연한 하늘색 & 녹색)
    final riverPaint = Paint()
      ..color = const Color(0xFFBAE6FD).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.3, size.width, size.height * 0.7);
    canvas.drawPath(path, riverPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
