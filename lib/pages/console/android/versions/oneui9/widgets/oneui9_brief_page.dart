import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 9 좌측 스와이프 페이지: Now Brief & Galaxy AI 보드
class OneUi9BriefPage extends StatelessWidget {
  final String dateString;
  final VoidCallback onOpenTemplate;

  const OneUi9BriefPage({
    super.key,
    required this.dateString,
    required this.onOpenTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더: Now Brief & Galaxy AI
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFA855F7)]),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text('Now Brief', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                child: const Text('Galaxy AI', style: TextStyle(color: Color(0xFF93C5FD), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1. AI 데일리 요약 카드
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('오늘의 AI 브리핑', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(dateString, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '오전에는 대체로 맑고 포근한 날씨(24°)가 이어집니다. 오늘 오후 3시 팀 미팅과 저녁 약속 일정이 등록되어 있습니다.',
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildBriefPill(Icons.wb_sunny, '대체로 맑음 24°', const Color(0xFFF59E0B)),
                    const SizedBox(width: 8),
                    _buildBriefPill(CupertinoIcons.calendar, '일정 2건', const Color(0xFF3B82F6)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. SmartThings 빠른 기기 제어 카드
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(CupertinoIcons.house_alt_fill, color: Color(0xFF60A5FA), size: 16),
                    SizedBox(width: 6),
                    Text('SmartThings 우리 집', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildDeviceCard('거실 조명', '켜짐 · 80%', CupertinoIcons.lightbulb_fill, true)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildDeviceCard('무풍 에어컨', '24°C 가동 중', CupertinoIcons.wind, true)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3. Galaxy AI 생성형 도구 퀵 카드
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Galaxy AI 추천 기능', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildAiFeatureTile('생성형 사진 편집', '사진 속 불필요한 물체를 자연스럽게 지우거나 이동', Icons.auto_fix_high),
                const SizedBox(height: 8),
                _buildAiFeatureTile('실시간 통역 (Interpreter)', '언어 장벽 없는 실시간 양방향 대화 번역', CupertinoIcons.chat_bubble_2_fill),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildBriefPill(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(String title, String status, IconData icon, bool isOn) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOn ? const Color(0xFF2563EB).withValues(alpha: 0.35) : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isOn ? const Color(0xFF3B82F6).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isOn ? const Color(0xFF60A5FA) : Colors.white60, size: 20),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          Text(status, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildAiFeatureTile(String title, String desc, IconData icon) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFFA78BFA), size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              Text(desc, style: const TextStyle(color: Colors.white54, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}
