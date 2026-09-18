import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/kakaobank_model.dart';

/// 카카오뱅크 이체 내역 및 거래 성공 뷰
class KakaoBankTransferPage extends StatelessWidget {
  final KakaoBankConfig config;
  final VoidCallback onClose;

  const KakaoBankTransferPage({
    super.key,
    required this.config,
    required this.onClose,
  });

  String _formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 상단 닫기 헤더
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: const Color(0xFF16161A),
          child: Row(
            children: [
              InkWell(
                onTap: onClose,
                child: const Icon(CupertinoIcons.xmark, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('거래 내역', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        // 최근 입출금 거래 내역 리스트
        Expanded(
          child: Container(
            color: const Color(0xFF101014),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: config.transactions.length,
              itemBuilder: (context, index) {
                final tx = config.transactions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C22),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: tx.isIncome ? const Color(0xFF3B82F6) : const Color(0xFFEF4444),
                        child: Icon(
                          tx.isIncome ? CupertinoIcons.arrow_down : CupertinoIcons.arrow_up,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(tx.date, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${tx.isIncome ? "+" : "-"}${_formatPrice(tx.amount)}',
                            style: TextStyle(
                              color: tx.isIncome ? const Color(0xFF60A5FA) : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text('잔액 ${_formatPrice(tx.balanceAfter)}', style: const TextStyle(color: Colors.white38, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
