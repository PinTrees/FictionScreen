import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/upbit_model.dart';

class UpbitMobileCoinInfoPage extends StatelessWidget {
  final UpbitConfig config;
  final Function(String symbol) onSelectCoin;
  final VoidCallback onOpenEditDialog;

  const UpbitMobileCoinInfoPage({
    super.key,
    required this.config,
    required this.onSelectCoin,
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
                  const Text('코인정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E2024))),
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
                  // 1. 공포·탐욕 지수 카드
                  Container(
                    padding: const EdgeInsets.all(18),
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
                            const Text('디지털 자산 심리지수', style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
                            Text('2026.09.19 기준', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('78', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFFC84A31))),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFFDF0EF), borderRadius: BorderRadius.circular(4)),
                              child: const Text('탐욕 (Greed)', style: TextStyle(color: Color(0xFFC84A31), fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.78,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade200,
                            color: const Color(0xFFC84A31),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('매우 공포', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            Text('중립', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            Text('매우 탐욕', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. 급등 코인 TOP 3
                  const Text('실시간 상승률 급등 코인', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2024))),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: config.coins.take(3).map((c) {
                        return InkWell(
                          onTap: () => onSelectCoin(c.symbol),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
                            child: Row(
                              children: [
                                Text(c.koreanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(width: 4),
                                Text(c.symbol, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${_format(c.currentPrice)} KRW', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text('+${c.changeRate.toStringAsFixed(2)}%', style: const TextStyle(color: Color(0xFFC84A31), fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. 주요 거래소 공지 & 뉴스
                  const Text('공지사항 및 뉴스', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2024))),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: config.notices.map((n) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: n.isImportant ? const Color(0xFFC84A31).withValues(alpha: 0.1) : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(n.category, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: n.isImportant ? const Color(0xFFC84A31) : Colors.black54)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(n.title, style: const TextStyle(fontSize: 12, color: Color(0xFF222222)), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            ],
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
