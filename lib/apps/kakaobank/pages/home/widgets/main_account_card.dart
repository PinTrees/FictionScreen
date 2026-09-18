import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/kakaobank_model.dart';

class KakaoBankMainAccountCard extends StatelessWidget {
  final KakaoBankConfig config;
  final VoidCallback onTap;
  final VoidCallback onTransfer;
  final VoidCallback? onBring;

  const KakaoBankMainAccountCard({
    super.key,
    required this.config,
    required this.onTap,
    required this.onTransfer,
    this.onBring,
  });

  String _formatPrice(int price) {
    if (config.hideBalance) return '잔액 숨김';
    final formatter = NumberFormat('#,###');
    return '${formatter.format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE500),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFEE500).withValues(alpha: 0.28),
              blurRadius: 18,
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
                  style: const TextStyle(color: Color(0xFF191919), fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(CupertinoIcons.star_fill, size: 14, color: Colors.black26),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              config.accountNumber,
              style: const TextStyle(color: Color(0xFF555555), fontSize: 11),
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatPrice(config.balance),
                  style: const TextStyle(color: Color(0xFF111111), fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black12,
                  child: Text('🦁', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 이체 / 가져오기 액션 바
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onTransfer,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('이체', style: TextStyle(color: Color(0xFF191919), fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: onBring,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('가져오기', style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
