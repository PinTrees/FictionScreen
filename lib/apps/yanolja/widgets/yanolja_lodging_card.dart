import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/yanolja_model.dart';

class YanoljaLodgingCard extends StatelessWidget {
  final YanoljaLodgingItem item;
  final VoidCallback onTap;

  const YanoljaLodgingCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  String _formatPrice(int price) {
    return '${NumberFormat('#,###').format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 이미지 & 뱃지
            Container(
              height: 160,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1E2024),
                          Colors.blueGrey.shade800,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        item.type.contains('풀빌라') ? CupertinoIcons.sparkles : CupertinoIcons.building_2_fill,
                        size: 48,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3478),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.badge,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(CupertinoIcons.heart, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // 숙소 상세 정보
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${item.type} · ${item.location}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.name,
                    style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.star_fill, color: Color(0xFFFFB800), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${item.rating}',
                        style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${NumberFormat('#,###').format(item.reviewCount)})',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: Color(0xFFEEEEEE)),

                  // 가격 블록 (대실 / 숙박)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (item.minRentPrice > 0) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('대실', style: TextStyle(color: Colors.black54, fontSize: 11)),
                            Text(_formatPrice(item.minRentPrice), style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (item.minStayPrice > 0) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('숙박', style: TextStyle(color: Colors.black54, fontSize: 11)),
                            Text(_formatPrice(item.minStayPrice), style: const TextStyle(color: Color(0xFFFF3478), fontWeight: FontWeight.bold, fontSize: 17)),
                          ],
                        ),
                      ],
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
}
