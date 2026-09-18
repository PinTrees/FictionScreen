import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/kakaobank_model.dart';

/// 카카오뱅크 메인 홈 뷰 (통장 카드 리스트 & 잔액)
class KakaoBankHomePage extends StatelessWidget {
  final KakaoBankConfig config;
  final VoidCallback? onHeaderTap;
  final VoidCallback? onAccountCardTap;
  final VoidCallback? onTransferTap;

  const KakaoBankHomePage({
    super.key,
    required this.config,
    this.onHeaderTap,
    this.onAccountCardTap,
    this.onTransferTap,
  });

  String _formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 상단 헤더 (사용자 닉네임 & 내 프로필)
        GestureDetector(
          onTap: onHeaderTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            color: const Color(0xFF16161A),
            child: Row(
              children: [
                Text(
                  '${config.userName}의 통장',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFFEE500),
                  child: Text('🐻', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),

        // 통장 카드 스크롤 영역
        Expanded(
          child: Container(
            color: const Color(0xFF101014),
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              children: [
                // 1. 카카오뱅크 메인 입출금 통장 시그니처 옐로우 카드
                GestureDetector(
                  onTap: onAccountCardTap,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE500),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFEE500).withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              config.accountName,
                              style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            const Icon(CupertinoIcons.star_fill, size: 14, color: Colors.black38),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          config.accountNumber,
                          style: const TextStyle(color: Colors.black45, fontSize: 11),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatPrice(config.balance),
                              style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.black12,
                              child: Text('🦁', style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 이체 / 가져오기 버튼
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: onTransferTap,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text('이체', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text('가져오기', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 2. 세이프박스 서브 카드
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222228),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF3B82F6),
                        child: Icon(CupertinoIcons.lock_fill, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('세이프박스', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(_formatPrice(config.safeBoxBalance), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Text('입출금', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 3. 26주 적금 서브 카드
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222228),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF10B981),
                        child: Icon(CupertinoIcons.graph_square_fill, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('26주 적금 (24주차 성공)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(_formatPrice(config.savingsBalance), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Icon(CupertinoIcons.chevron_right, color: Colors.white38, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
