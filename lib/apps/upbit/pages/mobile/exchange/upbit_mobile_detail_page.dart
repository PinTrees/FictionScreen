import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/upbit_model.dart';
import '../../../widgets/upbit_chart_preview.dart';
import '../../../widgets/upbit_orderbook.dart';

class UpbitMobileDetailPage extends StatefulWidget {
  final UpbitCoinItem coin;
  final VoidCallback onBack;
  final VoidCallback onOpenEditDialog;

  const UpbitMobileDetailPage({
    super.key,
    required this.coin,
    required this.onBack,
    required this.onOpenEditDialog,
  });

  @override
  State<UpbitMobileDetailPage> createState() => _UpbitMobileDetailPageState();
}

class _UpbitMobileDetailPageState extends State<UpbitMobileDetailPage> {
  int _activeSubTab = 0; // 0: 호가, 1: 차트, 2: 정보

  String _formatNumber(num val) => NumberFormat('#,###').format(val);

  @override
  Widget build(BuildContext context) {
    final coin = widget.coin;
    final color = coin.isRise ? const Color(0xFFC84A31) : (coin.isFall ? const Color(0xFF1261C4) : const Color(0xFF333333));
    final sign = coin.isRise ? '+' : '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.left_chevron, color: Colors.black87, size: 20),
                    onPressed: widget.onBack,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(coin.koreanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${coin.symbol}/KRW', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_formatNumber(coin.currentPrice)} KRW', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: color)),
                      Text('$sign${coin.changeRate.toStringAsFixed(2)}%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 18, color: Colors.black87),
                    onPressed: widget.onOpenEditDialog,
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
              child: Row(
                children: ['호가', '차트', '정보'].asMap().entries.map((entry) {
                  final idx = entry.key;
                  final label = entry.value;
                  final isActive = _activeSubTab == idx;
                  return Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _activeSubTab = idx),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: isActive ? const Color(0xFF093687) : Colors.transparent, width: 2)),
                        ),
                        child: Text(label, style: TextStyle(color: isActive ? const Color(0xFF093687) : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: _activeSubTab == 1
                  ? UpbitChartPreview(coin: coin)
                  : SingleChildScrollView(child: UpbitOrderbook(coin: coin)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC84A31),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: widget.onOpenEditDialog,
                      child: const Text('매수', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1261C4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: widget.onOpenEditDialog,
                      child: const Text('매도', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
