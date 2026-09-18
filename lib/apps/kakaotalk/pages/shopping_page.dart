import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text('쇼핑', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
              const Spacer(),
              const Icon(CupertinoIcons.search, size: 20, color: Colors.black87),
              const SizedBox(width: 16),
              const Icon(CupertinoIcons.gift, size: 20, color: Colors.black87),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 선물하기 메인 배너
              Container(
                height: 140,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFEE500), Color(0xFFFFB700)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🎁 마음을 전하는 가장 쉬운 방법', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                    SizedBox(height: 6),
                    Text('카카오톡 선물하기 인기 아이템', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(height: 4),
                    Text('생일, 축하, 응원 메세지와 함께 보내세요', style: TextStyle(fontSize: 11, color: Colors.black87)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('실시간 인기 선물 랭킹 🏆', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 12),

              _buildProductRow('1', '스타벅스 달콤한 한끼 세트', '14,200원', '스타벅스'),
              _buildProductRow('2', '배달의민족 모바일 상품권 3만원권', '30,000원', '배달의민족'),
              _buildProductRow('3', '올리브영 기프트카드 2만원권', '20,000원', '올리브영'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductRow(String rank, String title, String price, String brand) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(rank, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFEE500))),
          const SizedBox(width: 16),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(CupertinoIcons.gift_fill, color: Colors.amber, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(brand, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                Text(price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
