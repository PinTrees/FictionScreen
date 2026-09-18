import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/upbit_model.dart';

class UpbitDesktopSupportPage extends StatelessWidget {
  final UpbitConfig config;
  final VoidCallback onEdit;

  const UpbitDesktopSupportPage({
    super.key,
    required this.config,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 고객센터 상단 검색 배너
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      const Text('업비트 고객센터', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF093687))),
                      const SizedBox(height: 8),
                      const Text('궁금하신 점을 검색하거나 카테고리별 FAQ를 확인해보세요.', style: TextStyle(color: Colors.black54, fontSize: 13)),
                      const SizedBox(height: 20),

                      // 검색 입력창
                      Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '자주 묻는 질문 검색 (예: 케이뱅크 계좌 연동, 입출금 한도 등)',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                            prefixIcon: const Icon(CupertinoIcons.search, color: Color(0xFF093687)),
                            filled: true,
                            fillColor: const Color(0xFFF6F7F9),
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. 빠른 지원 4구 카드
                Row(
                  children: [
                    _buildHelpTile(CupertinoIcons.person_crop_circle_badge_checkmark, '계정 및 인증', '실명인증/보안등급'),
                    const SizedBox(width: 12),
                    _buildHelpTile(CupertinoIcons.money_dollar_circle, '원화 입출금', '케이뱅크 연동 안내'),
                    const SizedBox(width: 12),
                    _buildHelpTile(CupertinoIcons.arrow_right_arrow_left, '가상자산 입출금', '트래블룰/네트워크'),
                    const SizedBox(width: 12),
                    _buildHelpTile(CupertinoIcons.shield_lefthalf_fill, '가상자산이용자보호법', '자산 및 예치금 보호'),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. 공지사항 목록
                const Text('업비트 전체 공지사항', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2024))),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: config.notices.map((n) {
                      return InkWell(
                        onTap: onEdit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: n.isImportant ? const Color(0xFFC84A31).withValues(alpha: 0.1) : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  n.category,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: n.isImportant ? const Color(0xFFC84A31) : Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  n.title,
                                  style: TextStyle(fontSize: 13, fontWeight: n.isImportant ? FontWeight.bold : FontWeight.normal, color: const Color(0xFF222222)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(n.date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpTile(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: const Color(0xFF093687)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2024))),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
