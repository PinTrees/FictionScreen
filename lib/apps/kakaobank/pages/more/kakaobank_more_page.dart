import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/kakaobank_model.dart';

class KakaoBankMorePage extends StatelessWidget {
  final KakaoBankConfig config;
  final VoidCallback onEditProfile;

  const KakaoBankMorePage({
    super.key,
    required this.config,
    required this.onEditProfile,
  });

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
                  Text('전체', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 프로필 카드
                  GestureDetector(
                    onTap: onEditProfile,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C22),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFFEE500),
                            child: Text('🦁', style: TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(config.userName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 6),
                                    const Icon(CupertinoIcons.pencil_circle, color: Color(0xFFFEE500), size: 16),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text('인증/보안 최고 등급 · 프로필 수정', style: TextStyle(color: Colors.white38, fontSize: 11)),
                              ],
                            ),
                          ),
                          const Icon(CupertinoIcons.chevron_right, color: Colors.white24, size: 14),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildMenuGroup('나의 카카오뱅크', [
                    '내 계좌 한눈에 보기',
                    '모임통장 관리',
                    '프렌즈 체크카드 관리',
                    '휴면예금/보험금 찾기',
                  ]),

                  _buildMenuGroup('조회 / 이체', [
                    '이체 내역 관리',
                    '자동이체 설정',
                    'ATM 스마트출금',
                    '이체한도 변경',
                  ]),

                  _buildMenuGroup('고객지원 및 설정', [
                    '자주 묻는 질문 (FAQ)',
                    '카카오뱅크 챗봇 상담',
                    '고객센터 (1599-3333)',
                    '앱 설정 및 화면 테마',
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGroup(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item, style: const TextStyle(color: Colors.white, fontSize: 13)),
                const Icon(CupertinoIcons.chevron_right, color: Colors.white24, size: 12),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
