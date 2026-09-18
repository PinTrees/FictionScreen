import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/upbit_model.dart';

class UpbitMobileDepositPage extends StatelessWidget {
  final UpbitConfig config;
  final VoidCallback onOpenEditDialog;

  const UpbitMobileDepositPage({
    super.key,
    required this.config,
    required this.onOpenEditDialog,
  });

  String _format(num val) => NumberFormat('#,###').format(val);

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
                  const Text('입출금', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E2024))),
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
                  // 원화 KRW 계좌 카드
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Text('원화 (KRW)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E2024))),
                                SizedBox(width: 6),
                                Text('케이뱅크 연동', style: TextStyle(fontSize: 10, color: Color(0xFF093687), fontWeight: FontWeight.bold)),
                              ],
                            ),
                            IconButton(icon: const Icon(Icons.refresh, size: 18, color: Colors.black54), onPressed: onOpenEditDialog),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${_format(config.krwBalance)} 원', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Color(0xFF1E2024))),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF093687),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: onOpenEditDialog,
                                child: const Text('입금', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF093687)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: onOpenEditDialog,
                                child: const Text('출금', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF093687))),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 디지털 자산 목록 헤더
                  const Text('디지털 자산 입출금', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2024))),
                  const SizedBox(height: 10),

                  // 코인별 입출금 목록
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: config.coins.map((c) {
                        final holding = config.holdings.firstWhere(
                          (h) => h.symbol == c.symbol,
                          orElse: () => UpbitHoldingItem(symbol: c.symbol, koreanName: c.koreanName, holdingQuantity: 0, avgBuyPrice: 0, currentPrice: c.currentPrice),
                        );

                        return InkWell(
                          onTap: onOpenEditDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.koreanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    Text(c.symbol, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${holding.holdingQuantity} ${c.symbol}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text('${_format(holding.evalAmount)} KRW', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                  ],
                                ),
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
          ],
        ),
      ),
    );
  }
}
