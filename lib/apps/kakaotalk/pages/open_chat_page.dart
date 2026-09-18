import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpenChatPage extends StatelessWidget {
  const OpenChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text('오픈채팅', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
              const Spacer(),
              const Icon(CupertinoIcons.search, size: 20, color: Colors.black87),
              const SizedBox(width: 16),
              const Icon(CupertinoIcons.plus_app, size: 20, color: Colors.black87),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 추천 관심사 칩
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTagChip('🔥 실시간 인기'),
                    _buildTagChip('💻 개발/IT'),
                    _buildTagChip('🎨 디자인'),
                    _buildTagChip('📈 재테크'),
                    _buildTagChip('🎮 게임'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 카드 1
              _buildOpenChatCard(
                title: '프론트엔드/플러터 실무자 정보 공유방',
                category: 'IT / 개발',
                members: '1,420명',
                tags: '#플러터 #Flutter #앱개발',
              ),
              const SizedBox(height: 12),

              // 카드 2
              _buildOpenChatCard(
                title: '디자이너 모여라🎨 UI/UX 피드백 토론방',
                category: '디자인',
                members: '890명',
                tags: '#피그마 #UI #디자인',
              ),
              const SizedBox(height: 12),

              // 카드 3
              _buildOpenChatCard(
                title: '직장인 소소한 주식 & 부동산 재테크 수다방',
                category: '재테크',
                members: '2,100명',
                tags: '#재테크 #주식 #직장인',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }

  Widget _buildOpenChatCard({
    required String title,
    required String category,
    required String members,
    required String tags,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE500),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
              const Spacer(),
              const Icon(CupertinoIcons.person_2_fill, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(members, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 6),
          Text(tags, style: const TextStyle(fontSize: 12, color: Color(0xFF3182F6))),
        ],
      ),
    );
  }
}
