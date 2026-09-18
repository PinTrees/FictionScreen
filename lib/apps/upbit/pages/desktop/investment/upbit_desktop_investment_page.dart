import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/upbit_model.dart';

class UpbitDesktopInvestmentPage extends StatefulWidget {
  final UpbitConfig config;
  final VoidCallback onEdit;

  const UpbitDesktopInvestmentPage({
    super.key,
    required this.config,
    required this.onEdit,
  });

  @override
  State<UpbitDesktopInvestmentPage> createState() => _UpbitDesktopInvestmentPageState();
}

class _UpbitDesktopInvestmentPageState extends State<UpbitDesktopInvestmentPage> {
  int _activeTab = 0; // 0: 보유자산, 1: 거래내역, 2: 미체결

  String _formatNumber(num val) => NumberFormat('#,###').format(val);

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    final isProfit = cfg.totalProfitAmount >= 0;
    final profitColor = isProfit ? const Color(0xFFC84A31) : const Color(0xFF1261C4);
    final sign = isProfit ? '+' : '';

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
                // 1. 총 보유자산 요약 카드
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('내 보유자산', style: TextStyle(color: Colors.black54, fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(
                                '${_formatNumber(cfg.totalAssets)} KRW',
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1E2024)),
                              ),
                            ],
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 16),
                            label: const Text('자산/수익률 연출 설정', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: widget.onEdit,
                            style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF093687)),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildAssetStatItem('총 매수금액', '${_formatNumber(cfg.totalBuyAmount)} KRW'),
                          _buildAssetStatItem('총 평가금액', '${_formatNumber(cfg.totalEvalAmount)} KRW'),
                          _buildAssetStatItem('총 평가손익', '$sign${_formatNumber(cfg.totalProfitAmount)} KRW', color: profitColor),
                          _buildAssetStatItem('총 수익률', '$sign${cfg.totalProfitRate.toStringAsFixed(2)}%', color: profitColor),
                          _buildAssetStatItem('보유 KRW', '${_formatNumber(cfg.krwBalance)} KRW'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. 탭 바 (보유자산 / 거래내역 / 미체결)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                        child: Row(
                          children: ['보유자산 (${cfg.holdings.length})', '거래내역', '미체결 (0)'].asMap().entries.map((entry) {
                            final isActive = _activeTab == entry.key;
                            return InkWell(
                              onTap: () => setState(() => _activeTab = entry.key),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: isActive ? const Color(0xFF093687) : Colors.transparent, width: 2.5)),
                                ),
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                    color: isActive ? const Color(0xFF093687) : Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // 테이블 헤더
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: const Color(0xFFF9FAFB),
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: Text('자산명', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54))),
                            Expanded(flex: 2, child: Text('보유수량', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.right)),
                            Expanded(flex: 2, child: Text('매수평균가', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.right)),
                            Expanded(flex: 2, child: Text('평가금액', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.right)),
                            Expanded(flex: 2, child: Text('평가손익', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.right)),
                            Expanded(flex: 2, child: Text('수익률', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.right)),
                          ],
                        ),
                      ),

                      // 테이블 행 리스트
                      ...cfg.holdings.map((holding) {
                        final isHoldProfit = holding.profitAmount >= 0;
                        final hColor = isHoldProfit ? const Color(0xFFC84A31) : const Color(0xFF1261C4);
                        final hSign = isHoldProfit ? '+' : '';

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(holding.koreanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text('${holding.symbol}/KRW', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('${holding.holdingQuantity} ${holding.symbol}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.right),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('${_formatNumber(holding.avgBuyPrice)} KRW', style: const TextStyle(fontSize: 12), textAlign: TextAlign.right),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('${_formatNumber(holding.evalAmount)} KRW', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('$hSign${_formatNumber(holding.profitAmount)} KRW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: hColor), textAlign: TextAlign.right),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('$hSign${holding.profitRate.toStringAsFixed(2)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: hColor), textAlign: TextAlign.right),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetStatItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color ?? const Color(0xFF1E2024))),
      ],
    );
  }
}
