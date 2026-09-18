import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/upbit_model.dart';

class UpbitMobileInvestmentPage extends StatelessWidget {
  final UpbitConfig config;
  final VoidCallback onOpenEditDialog;

  const UpbitMobileInvestmentPage({
    super.key,
    required this.config,
    required this.onOpenEditDialog,
  });

  String _formatNumber(num val) => NumberFormat('#,###').format(val);

  @override
  Widget build(BuildContext context) {
    final isProfit = config.totalProfitAmount >= 0;
    final profitColor = isProfit ? const Color(0xFFC84A31) : const Color(0xFF1261C4);
    final sign = isProfit ? '+' : '';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('투자내역', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E2024))),
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('총 보유자산', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _formatNumber(config.totalAssets),
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Color(0xFF1E2024)),
                            ),
                            const SizedBox(width: 4),
                            const Text('KRW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
                          ],
                        ),
                        const Divider(height: 24, color: Color(0xFFEEEEEE)),
                        _buildStatRow('총 평가손익', '$sign${_formatNumber(config.totalProfitAmount)} KRW', valueColor: profitColor, isBold: true),
                        const SizedBox(height: 8),
                        _buildStatRow('총 수익률', '$sign${config.totalProfitRate.toStringAsFixed(2)}%', valueColor: profitColor, isBold: true),
                        const SizedBox(height: 8),
                        _buildStatRow('총 매수금액', '${_formatNumber(config.totalBuyAmount)} KRW'),
                        const SizedBox(height: 8),
                        _buildStatRow('총 평가금액', '${_formatNumber(config.totalEvalAmount)} KRW'),
                        const SizedBox(height: 8),
                        _buildStatRow('보유 KRW', '${_formatNumber(config.krwBalance)} KRW'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('보유 가상자산', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E2024))),
                      Text('총 ${config.holdings.length}종목', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...config.holdings.map((holding) => _buildHoldingCard(holding)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF222222),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildHoldingCard(UpbitHoldingItem item) {
    final isProfit = item.profitAmount >= 0;
    final color = isProfit ? const Color(0xFFC84A31) : const Color(0xFF1261C4);
    final sign = isProfit ? '+' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(item.koreanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E2024))),
                  const SizedBox(width: 6),
                  Text(item.symbol, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Text(
                '$sign${item.profitRate.toStringAsFixed(2)}%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF0F0F0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('평가금액', style: TextStyle(color: Colors.black45, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text('${_formatNumber(item.evalAmount)} KRW', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('평가손익', style: TextStyle(color: Colors.black45, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text('$sign${_formatNumber(item.profitAmount)} KRW', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('보유수량: ${item.holdingQuantity} ${item.symbol}', style: const TextStyle(color: Colors.black54, fontSize: 11)),
              Text('매수평균가: ${_formatNumber(item.avgBuyPrice)} KRW', style: const TextStyle(color: Colors.black54, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
