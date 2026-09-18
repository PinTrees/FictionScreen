import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/yanolja_model.dart';

class YanoljaMobileDetailPage extends StatelessWidget {
  final YanoljaLodgingItem lodging;
  final VoidCallback onBack;
  final Function(YanoljaRoomItem room, bool isRent) onBook;

  const YanoljaMobileDetailPage({
    super.key,
    required this.lodging,
    required this.onBack,
    required this.onBook,
  });

  String _formatPrice(int price) {
    return '${NumberFormat('#,###').format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 탑바
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.left_chevron, color: Colors.black87, size: 20),
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: Text(
                      lodging.name,
                      style: const TextStyle(color: Color(0xFF191919), fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.share, color: Colors.black87, size: 18),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.heart, color: Colors.black87, size: 18),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // 스크롤 영역
            Expanded(
              child: ListView(
                children: [
                  // 상단 메인 이미지 갤러리 뷰
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1E2024),
                          Colors.blueGrey.shade900,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            lodging.type.contains('풀빌라') ? CupertinoIcons.sparkles : CupertinoIcons.building_2_fill,
                            size: 56,
                            color: Colors.white30,
                          ),
                          const SizedBox(height: 8),
                          Text(lodging.name, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),

                  // 호텔 정보 헤더
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF3478).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(lodging.badge, style: const TextStyle(color: Color(0xFFFF3478), fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Text(lodging.type, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(lodging.name, style: const TextStyle(color: Color(0xFF191919), fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.star_fill, color: Color(0xFFFFB800), size: 15),
                            const SizedBox(width: 4),
                            Text('${lodging.rating}', style: const TextStyle(color: Color(0xFF191919), fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(width: 4),
                            Text('리뷰 ${NumberFormat('#,###').format(lodging.reviewCount)}개', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.location_solid, color: Colors.black45, size: 14),
                            const SizedBox(width: 4),
                            Expanded(child: Text(lodging.location, style: const TextStyle(color: Colors.black54, fontSize: 12))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 객실 목록 섹션
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text('객실 선택', style: TextStyle(color: Color(0xFF191919), fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),

                  ...lodging.rooms.map((room) => _buildRoomCard(room)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(YanoljaRoomItem room) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(room.name, style: const TextStyle(color: Color(0xFF191919), fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('남은 객실 ${room.availableCount}개', style: const TextStyle(color: Color(0xFFFF3478), fontSize: 12, fontWeight: FontWeight.w600)),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),

          // 대실 옵션 (있는 경우)
          if (room.rentPrice > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('대실', style: TextStyle(color: Color(0xFF191919), fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(room.rentTime, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                  ],
                ),
                Row(
                  children: [
                    Text(_formatPrice(room.rentPrice), style: const TextStyle(color: Color(0xFF191919), fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF3478),
                        side: const BorderSide(color: Color(0xFFFF3478)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => onBook(room, true),
                      child: const Text('대실 예약', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20, color: Color(0xFFEEEEEE)),
          ],

          // 숙박 옵션
          if (room.stayPrice > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('숙박', style: TextStyle(color: Color(0xFF191919), fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(room.stayCheckIn, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                  ],
                ),
                Row(
                  children: [
                    Text(_formatPrice(room.stayPrice), style: const TextStyle(color: Color(0xFFFF3478), fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3478),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => onBook(room, false),
                      child: const Text('숙박 예약', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
