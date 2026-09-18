import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/kakaobank_model.dart';

class KakaoBankCreditCardSummaryCard extends StatelessWidget {
  final KakaoBankCardInfo cardInfo;
  final int creditScore;
  final VoidCallback onTap;

  const KakaoBankCreditCardSummaryCard({
    super.key,
    required this.cardInfo,
    required this.creditScore,
    required this.onTap,
  });

  String _formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E24),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(CupertinoIcons.creditcard, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(cardInfo.cardName, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(cardInfo.paymentDate, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('이번 달 쓴 금액', style: TextStyle(color: Colors.white54, fontSize: 13)),
                Text(_formatPrice(cardInfo.usedAmountThisMonth), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 20, color: Colors.white10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(CupertinoIcons.shield_lefthalf_fill, color: Color(0xFF60A5FA), size: 14),
                    SizedBox(width: 6),
                    Text('내 신용점수', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                Text('$creditScore점 (상위 3%)', style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
