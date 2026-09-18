import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/upbit_model.dart';

class UpbitCoinTile extends StatelessWidget {
  final UpbitCoinItem coin;
  final bool isSelected;
  final VoidCallback onTap;

  const UpbitCoinTile({
    super.key,
    required this.coin,
    this.isSelected = false,
    required this.onTap,
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

  String _formatVolume(double volume) {
    return '${NumberFormat('#,###').format(volume.toInt())}백만';
  }

  @override
  Widget build(BuildContext context) {
    final color = coin.isRise
        ? const Color(0xFFC84A31)
        : (coin.isFall ? const Color(0xFF1261C4) : const Color(0xFF333333));
    final sign = coin.isRise ? '+' : '';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F4FC) : Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
        ),
        child: Row(
          children: [
            // 1. 코인 한글명 및 심볼
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    coin.koreanName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF222222)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text('${coin.symbol}/KRW', style: const TextStyle(fontSize: 10, color: Color(0xFF888888))),
                ],
              ),
            ),

            // 2. 현재가
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatPrice(coin.currentPrice),
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color),
                  ),
                ],
              ),
            ),

            // 3. 전일대비 변동률 & 거래대금
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$sign${coin.changeRate.toStringAsFixed(2)}%',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatVolume(coin.tradeVolume24h),
                    style: const TextStyle(fontSize: 10, color: Color(0xFF888888)),
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
