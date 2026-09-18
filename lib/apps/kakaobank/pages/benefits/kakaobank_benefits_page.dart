import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KakaoBankBenefitsPage extends StatelessWidget {
  const KakaoBankBenefitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xFF16161A),
              child: const Row(
                children: [
                  Text('혜택', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. 이번 달 받은 혜택 배너
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('이번 달 내가 받은 혜택', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 6),
                        Text('총 18,650원', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. 매일 용돈 받기 럭키 드로우 카드
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C22),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text('🎁', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('매일매일 용돈 받기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                              SizedBox(height: 2),
                              Text('오늘의 행운 캐시백을 탭해서 확인하세요', style: TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEE500),
                            foregroundColor: const Color(0xFF111111),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {},
                          child: const Text('받기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. 혜택 미션 리스트
                  _buildBenefitTile('친구에게 카뱅 소문내고 5,000원', '무제한 적립 가능', '👥'),
                  _buildBenefitTile('쿠팡에서 프렌즈 카드로 결제 시 3% 캐시백', '10월 한정 이벤트', '🛍️'),
                  _buildBenefitTile('금융 퀴즈 맞히고 보너스 포인트', '매일 오전 10시 오픈', '💡'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitTile(String title, String desc, String emoji) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          const Icon(CupertinoIcons.chevron_right, color: Colors.white24, size: 14),
        ],
      ),
    );
  }
}
