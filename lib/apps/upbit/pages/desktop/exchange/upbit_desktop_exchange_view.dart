import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/upbit_model.dart';
import '../../../widgets/upbit_chart_preview.dart';
import '../../../widgets/upbit_coin_tile.dart';
import '../../../widgets/upbit_orderbook.dart';

class UpbitDesktopExchangeView extends StatefulWidget {
  final UpbitConfig config;
  final Function(String symbol) onSelectCoin;
  final VoidCallback onEdit;

  const UpbitDesktopExchangeView({
    super.key,
    required this.config,
    required this.onSelectCoin,
    required this.onEdit,
  });

  @override
  State<UpbitDesktopExchangeView> createState() => _UpbitDesktopExchangeViewState();
}

class _UpbitDesktopExchangeViewState extends State<UpbitDesktopExchangeView> {
  String _activeMarketTab = 'KRW';
  bool _isBuyTab = true;
  final TextEditingController _orderPriceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _orderPriceCtrl.text = widget.config.selectedCoin.currentPrice.toInt().toString();
  }

  @override
  void didUpdateWidget(covariant UpbitDesktopExchangeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.selectedCoinSymbol != oldWidget.config.selectedCoinSymbol) {
      _orderPriceCtrl.text = widget.config.selectedCoin.currentPrice.toInt().toString();
    }
  }

  @override
  void dispose() {
    _orderPriceCtrl.dispose();
    super.dispose();
  }

  String _formatNumber(num val) => NumberFormat('#,###').format(val);

  @override
  Widget build(BuildContext context) {
    final coin = widget.config.selectedCoin;
    final color = coin.isRise ? const Color(0xFFC84A31) : (coin.isFall ? const Color(0xFF1261C4) : const Color(0xFF333333));
    final sign = coin.isRise ? '+' : '';

    return Column(
      children: [
        // 상단 코인 요약 바 (Ticker Bar)
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coin.koreanName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2024))),
                  Text('${coin.symbol}/KRW', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const SizedBox(width: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_formatNumber(coin.currentPrice)} KRW', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
                  Row(
                    children: [
                      Text('전일대비 ', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      Text('$sign${coin.changeRate.toStringAsFixed(2)}%  ▲ ${_formatNumber(coin.changeAmount)}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              _buildTickerStat('고가', _formatNumber(coin.highPrice), const Color(0xFFC84A31)),
              const SizedBox(width: 20),
              _buildTickerStat('저가', _formatNumber(coin.lowPrice), const Color(0xFF1261C4)),
              const SizedBox(width: 20),
              _buildTickerStat('거래대금(24H)', '${_formatNumber(coin.tradeVolume24h)} 백만', Colors.black87),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // 메인 3단 데스크 그리드
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. 호가창 (왼쪽)
                SizedBox(
                  width: 280,
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    clipBehavior: Clip.antiAlias,
                    child: UpbitOrderbook(
                      coin: coin,
                      onSelectPrice: (p) => setState(() => _orderPriceCtrl.text = p.toInt().toString()),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 2. 차트 & 주문창 (가운데)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          clipBehavior: Clip.antiAlias,
                          child: UpbitChartPreview(coin: coin),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          clipBehavior: Clip.antiAlias,
                          child: _buildOrderForm(coin),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 3. 코인 리스트 (오른쪽)
                SizedBox(
                  width: 320,
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    clipBehavior: Clip.antiAlias,
                    child: _buildRightCoinList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTickerStat(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }

  Widget _buildOrderForm(UpbitCoinItem coin) {
    final isBuy = _isBuyTab;
    final themeColor = isBuy ? const Color(0xFFC84A31) : const Color(0xFF1261C4);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _isBuyTab = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: isBuy ? const Color(0xFFC84A31) : Colors.transparent, width: 2.5)),
                    ),
                    alignment: Alignment.center,
                    child: Text('매수', style: TextStyle(color: isBuy ? const Color(0xFFC84A31) : Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _isBuyTab = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: !isBuy ? const Color(0xFF1261C4) : Colors.transparent, width: 2.5)),
                    ),
                    alignment: Alignment.center,
                    child: Text('매도', style: TextStyle(color: !isBuy ? const Color(0xFF1261C4) : Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('주문가능', style: TextStyle(fontSize: 11, color: Colors.black54)),
              Text('${_formatNumber(widget.config.krwBalance)} KRW', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF191919))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 60, child: Text(isBuy ? '매수가격' : '매도가격', style: const TextStyle(fontSize: 11, color: Colors.black87))),
              Expanded(
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.centerRight,
                  child: Text('${_formatNumber(coin.currentPrice)} KRW', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 60),
              ...['10%', '25%', '50%', '최대'].map((label) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: () {},
                      child: Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87)),
                    ),
                  ),
                );
              }),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 38),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: widget.onEdit,
            child: Text(isBuy ? '매수 (주문)' : '매도 (주문)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildRightCoinList() {
    return Column(
      children: [
        Container(
          color: const Color(0xFFF9FAFB),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: ['KRW', 'BTC', 'USDT', '보유'].map((tab) {
              final isTabActive = _activeMarketTab == tab;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _activeMarketTab = tab),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: isTabActive ? const Color(0xFF093687) : Colors.transparent, width: 2)),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isTabActive ? FontWeight.bold : FontWeight.normal,
                        color: isTabActive ? const Color(0xFF093687) : Colors.black54,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.config.coins.length,
            itemBuilder: (context, index) {
              final coin = widget.config.coins[index];
              return UpbitCoinTile(
                coin: coin,
                isSelected: coin.symbol == widget.config.selectedCoinSymbol,
                onTap: () => widget.onSelectCoin(coin.symbol),
              );
            },
          ),
        ),
      ],
    );
  }
}
