import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YanoljaDesktopHeader extends StatelessWidget {
  final String region;
  final String dateText;
  final VoidCallback onSearchTap;
  final VoidCallback onEdit;

  const YanoljaDesktopHeader({
    super.key,
    required this.region,
    required this.dateText,
    required this.onSearchTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // 1. 최상단 GNB 유틸리티 바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                // NOL 야놀자 로고
                InkWell(
                  onTap: onSearchTap,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3478),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('NOL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                      ),
                      const SizedBox(width: 8),
                      const Text('야놀자', style: TextStyle(color: Color(0xFFFF3478), fontWeight: FontWeight.bold, fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(width: 32),

                // 중앙 대형 검색바
                Expanded(
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7F9),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.search, color: Color(0xFFFF3478), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '$region · $dateText',
                              style: const TextStyle(color: Color(0xFF191919), fontSize: 13, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3478),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text('검색', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // 우측 메뉴 (마이, 찜, 장바구니, 설정)
                _buildHeaderIcon(CupertinoIcons.person, '마이', onEdit),
                const SizedBox(width: 16),
                _buildHeaderIcon(CupertinoIcons.heart, '찜', onEdit),
                const SizedBox(width: 16),
                _buildHeaderIcon(CupertinoIcons.cart, '장바구니', onEdit),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.black87, size: 20),
                  onPressed: onEdit,
                ),
              ],
            ),
          ),

          // 2. 하단 카테고리 탭 목록
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildCategoryTab('전체 카테고리', isHighlighted: true),
                const SizedBox(width: 20),
                _buildCategoryTab('국내숙소', isActive: true),
                const SizedBox(width: 20),
                _buildCategoryTab('항공'),
                const SizedBox(width: 20),
                _buildCategoryTab('레저·티켓'),
                const SizedBox(width: 20),
                _buildCategoryTab('해외여행'),
                const SizedBox(width: 20),
                _buildCategoryTab('교통·렌터카'),
                const SizedBox(width: 20),
                _buildCategoryTab('공연·전시'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title, {bool isActive = false, bool isHighlighted = false}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: isActive ? const Border(bottom: BorderSide(color: Color(0xFFFF3478), width: 2.5)) : null,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive
              ? const Color(0xFFFF3478)
              : (isHighlighted ? Colors.black87 : Colors.black54),
          fontWeight: (isActive || isHighlighted) ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
