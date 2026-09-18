import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/pinterest_model.dart';

class PinterestScreen extends StatelessWidget {
  final PinterestConfig config;
  final VoidCallback? onTapPin;

  const PinterestScreen({
    super.key,
    required this.config,
    this.onTapPin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 1. 상단 바
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 36, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(CupertinoIcons.back, size: 22, color: Colors.black87),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE60023),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(CupertinoIcons.sparkles, color: Colors.white, size: 14),
                ),
                const Icon(CupertinoIcons.ellipsis, size: 22, color: Colors.black87),
              ],
            ),
          ),

          // 2. 핀 메인 영역
          Expanded(
            child: GestureDetector(
              onTap: onTapPin,
              behavior: HitTestBehavior.opaque,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 이미지 카드
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      height: 340,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(CupertinoIcons.photo, size: 80, color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 저장 및 링크 버튼 바
                  Row(
                    children: [
                      const Icon(CupertinoIcons.heart_fill, color: Colors.black87, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        config.savedCount,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE60023),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        onPressed: onTapPin,
                        child: const Text('저장', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 핀 제목
                  Text(
                    config.pinTitle,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 설명글
                  Text(
                    config.description,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 크리에이터 바
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.red.shade100,
                        child: Text(
                          config.creatorName.isNotEmpty ? config.creatorName[0] : 'P',
                          style: const TextStyle(color: Color(0xFFE60023), fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              config.creatorName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                            ),
                            Text(
                              '팔로워 ${config.followerCount}',
                              style: const TextStyle(color: Colors.black54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: const BorderSide(color: Colors.black26),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {},
                        child: const Text('팔로우', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
