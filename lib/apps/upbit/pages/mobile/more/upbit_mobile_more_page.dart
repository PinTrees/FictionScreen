import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/upbit_model.dart';

class UpbitMobileMorePage extends StatelessWidget {
  final UpbitConfig config;
  final VoidCallback onOpenEditDialog;

  const UpbitMobileMorePage({
    super.key,
    required this.config,
    required this.onOpenEditDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F8),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 바
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('더보기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E2024))),
                  IconButton(
                    icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 18, color: Colors.black87),
                    onPressed: onOpenEditDialog,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  // 프로필 및 보안등급 카드
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: const Color(0xFF093687).withValues(alpha: 0.1), shape: BoxShape.circle),
                              child: const Icon(CupertinoIcons.person_fill, color: Color(0xFF093687), size: 24),
                            ),
                            const SizedBox(width: 14),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('김*준', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E2024))),
                                    SizedBox(width: 8),
                                    Text('보안 레벨 4', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Text('케이뱅크 실명인증 완료 (원화 입출금 가능)', style: TextStyle(fontSize: 11, color: Colors.black54)),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildProfileBadge(CupertinoIcons.mail, '이메일', true),
                            _buildProfileBadge(CupertinoIcons.device_phone_portrait, '휴대폰', true),
                            _buildProfileBadge(CupertinoIcons.building_2_fill, '케이뱅크', true),
                            _buildProfileBadge(CupertinoIcons.lock_shield_fill, '2채널인증', true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 메뉴 리스트
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(CupertinoIcons.shield_lefthalf_fill, '인증센터 (입출금 한도 관리)', onOpenEditDialog),
                        _buildMenuItem(CupertinoIcons.sparkles, '스테이킹 내역 및 신청', onOpenEditDialog),
                        _buildMenuItem(CupertinoIcons.bell, '시세 알림 및 체결 알림 설정', onOpenEditDialog),
                        _buildMenuItem(CupertinoIcons.question_circle, '고객센터 (1588-5682 / 24시간)', onOpenEditDialog),
                        _buildMenuItem(CupertinoIcons.doc_text, '가상자산이용자보호법 및 공지사항', onOpenEditDialog),
                        _buildMenuItem(CupertinoIcons.settings, '화면 설정 및 오픈소스 라이선스', onOpenEditDialog),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBadge(IconData icon, String label, bool isDone) {
    return Column(
      children: [
        Icon(icon, size: 20, color: isDone ? const Color(0xFF093687) : Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isDone ? const Color(0xFF1E2024) : Colors.grey)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF093687)),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF222222), fontWeight: FontWeight.w500))),
            const Icon(CupertinoIcons.right_chevron, size: 14, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
