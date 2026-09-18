import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/upbit_model.dart';

class UpbitOrderbook extends StatelessWidget {
  final UpbitCoinItem coin;
  final Function(double price)? onSelectPrice;

  const UpbitOrderbook({
    super.key,
    required this.coin,
    this.onSelectPrice,
  });

  String _formatPrice(double price) {
    if (price >= 100) {
      return NumberFormat('#,###').format(price.toInt());
    } else if (price >= 1) {
      return NumberFormat('#,##0.00').format(price);
    } else {
      return NumberFormat('0.0000').format(price);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = coin.currentPrice > 100000 ? 50000.0 : (coin.currentPrice > 1000 ? 5.0 : 1.0);
    final asks = List.generate(6, (i) {
      final p = coin.currentPrice + step * (6 - i);
      final size = (1.2 + (6 - i) * 0.45);
      return UpbitOrderbookUnit(price: p, size: size, isAsk: true);
    });

    final bids = List.generate(6, (i) {
      final p = coin.currentPrice - step * (i + 1);
      final size = (1.5 + (i + 1) * 0.38);
      return UpbitOrderbookUnit(price: p, size: size, isAsk: false);
    });

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 호가 헤더
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: const Color(0xFFF9FAFB),
            child: const Row(
              children: [
                Expanded(child: Text('호가(KRW)', style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold))),
                Text('잔량', style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // 매도 호가 (위)
          ...asks.map((unit) => _buildOrderRow(unit)),

          // 현재가 강조 라인
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: coin.isRise ? const Color(0xFFFDF0EF) : const Color(0xFFECF2FE),
              border: Border.symmetric(horizontal: BorderSide(color: coin.isRise ? const Color(0xFFC84A31) : const Color(0xFF1261C4), width: 1.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatPrice(coin.currentPrice),
                  style: TextStyle(
                    color: coin.isRise ? const Color(0xFFC84A31) : const Color(0xFF1261C4),
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${coin.changeRate > 0 ? '+' : ''}${coin.changeRate.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: coin.isRise ? const Color(0xFFC84A31) : const Color(0xFF1261C4),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // 매수 호가 (아래)
          ...bids.map((unit) => _buildOrderRow(unit)),
        ],
      ),
    );
  }

  Widget _buildOrderRow(UpbitOrderbookUnit unit) {
    final bgColor = unit.isAsk ? const Color(0xFFF2F6FE) : const Color(0xFFFCF2F0);
    final textColor = unit.isAsk ? const Color(0xFF1261C4) : const Color(0xFFC84A31);
    final barColor = unit.isAsk ? const Color(0xFFC8DCFE) : const Color(0xFFF8CBC5);

    return InkWell(
      onTap: () => onSelectPrice?.call(unit.price),
      child: Container(
        height: 28,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.8), width: 0.5)),
        ),
        child: Stack(
          children: [
            // 잔량 막대 그래프
            Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: (unit.size / 6.0).clamp(0.05, 0.95),
                child: Container(color: barColor.withValues(alpha: 0.45)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatPrice(unit.price),
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  Text(
                    unit.size.toStringAsFixed(3),
                    style: const TextStyle(color: Color(0xFF333333), fontSize: 10),
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
