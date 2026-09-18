import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KakaoBankTransferCompletePage extends StatelessWidget {
  final String recipient;
  final int amount;
  final int balanceAfter;
  final VoidCallback onConfirm;

  const KakaoBankTransferCompletePage({
    super.key,
    required this.recipient,
    required this.amount,
    required this.balanceAfter,
    required this.onConfirm,
  });

  String _formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 시그니처 완료 아이콘
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEE500),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(CupertinoIcons.check_mark, color: Color(0xFF191919), size: 38),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '$recipient 님에게',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_formatPrice(amount)}을 보냈습니다',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 36),

                      // 영수증 카드
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C22),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildReceiptRow('받는 분', recipient),
                            const SizedBox(height: 12),
                            _buildReceiptRow('보낸 금액', _formatPrice(amount)),
                            const SizedBox(height: 12),
                            _buildReceiptRow('출금 후 잔액', _formatPrice(balanceAfter)),
                            const Divider(height: 24, color: Colors.white10),
                            _buildReceiptRow('수수료', '면제 (무료)'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 확인 버튼
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEE500),
                  foregroundColor: const Color(0xFF111111),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: onConfirm,
                child: const Text('확인', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
