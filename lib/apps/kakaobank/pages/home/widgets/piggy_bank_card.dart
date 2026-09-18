import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/kakaobank_model.dart';

class KakaoBankPiggyBankCard extends StatelessWidget {
  final KakaoBankPiggyBank piggyBank;
  final VoidCallback onTap;

  const KakaoBankPiggyBankCard({
    super.key,
    required this.piggyBank,
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
          color: const Color(0xFF2B2228),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFEC4899),
              child: Text('🐷', style: TextStyle(fontSize: 15)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(piggyBank.nickname, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      Text('(${piggyBank.itemEstimate})', style: const TextStyle(color: Color(0xFFF472B6), fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(_formatPrice(piggyBank.amount), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('엿보기', style: TextStyle(color: Colors.white70, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}
