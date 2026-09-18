import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/upbit_model.dart';

class UpbitDesktopTrendsPage extends StatelessWidget {
  final UpbitConfig config;
  final Function(String symbol) onSelectCoin;

  const UpbitDesktopTrendsPage({
    super.key,
    required this.config,
    required this.onSelectCoin,
  });

  String _format(num val) => NumberFormat('#,###').format(val);

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
                // 1. 디지털 자산 지수 (UBMI & UBAI) 카드
                Row(
                  children: [
                    Expanded(
                      child: _buildIndexCard(
                        'UBMI (업비트 종합 시장 지수)',
                        '15,240.28',
                        '+3.85%',
                        '가상자산 시장 전체 시가총액 변동률 지수',
                        const Color(0xFFC84A31),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildIndexCard(
                        'UBAI (업비트 알트코인 지수)',
                        '6,892.15',
                        '+5.12%',
                        '비트코인을 제외한 알트코인 시장 지수',
                        const Color(0xFFC84A31),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('공포·탐욕 지수', style: TextStyle(color: Colors.black54, fontSize: 12)),
                            const SizedBox(height: 6),
                            const Row(
                              children: [
                                Text('78', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFC84A31))),
                                SizedBox(width: 6),
                                Text('탐욕 (Greed)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFC84A31))),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(value: 0.78, minHeight: 8, backgroundColor: Colors.grey.shade200, color: const Color(0xFFC84A31)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 2. 실시간 급등 코인 랭킹 TOP
                const Text('주간 상승률 TOP 디지털 자산', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2024))),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: config.coins.take(5).map((c) {
                      return InkWell(
                        onTap: () => onSelectCoin(c.symbol),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(color: const Color(0xFF093687).withValues(alpha: 0.1), shape: BoxShape.circle),
                                child: Center(child: Text(c.symbol.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF093687)))),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.koreanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text('${c.symbol}/KRW', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                  ],
                                ),
                              ),
                              Text('${_format(c.currentPrice)} KRW', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(width: 24),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFFDF0EF), borderRadius: BorderRadius.circular(4)),
                                child: Text('+${c.changeRate.toStringAsFixed(2)}%', style: const TextStyle(color: Color(0xFFC84A31), fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. 테마별 섹터 분류
                const Text('디지털 자산 테마 분류', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2024))),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildThemeCard('AI / 인공지능', 'WLD, NEAR, RENDER, GRT', '+8.45%'),
                    const SizedBox(width: 12),
                    _buildThemeCard('레이어 1', 'BTC, ETH, SOL, AVAX, SUI', '+4.12%'),
                    const SizedBox(width: 12),
                    _buildThemeCard('디파이 (DeFi)', 'AAVE, UNI, MKR, COMP', '+3.89%'),
                    const SizedBox(width: 12),
                    _buildThemeCard('밈 (MEME)', 'DOGE, SHIB, PEPE, BONK', '+6.70%'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndexCard(String title, String indexValue, String change, String desc, Color changeColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(indexValue, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E2024))),
              const SizedBox(width: 8),
              Text(change, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: changeColor)),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildThemeCard(String title, String coins, String change) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF093687))),
            const SizedBox(height: 6),
            Text(coins, style: const TextStyle(fontSize: 10, color: Colors.black54), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Text(change, style: const TextStyle(color: Color(0xFFC84A31), fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
