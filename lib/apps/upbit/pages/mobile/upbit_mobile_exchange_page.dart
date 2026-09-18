import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/upbit_model.dart';
import '../../widgets/upbit_coin_tile.dart';

class UpbitMobileExchangePage extends StatefulWidget {
  final UpbitConfig config;
  final Function(String symbol) onSelectCoin;
  final VoidCallback onOpenEditDialog;

  const UpbitMobileExchangePage({
    super.key,
    required this.config,
    required this.onSelectCoin,
    required this.onOpenEditDialog,
  });

  @override
  State<UpbitMobileExchangePage> createState() => _UpbitMobileExchangePageState();
}

class _UpbitMobileExchangePageState extends State<UpbitMobileExchangePage> {
  String _activeMarket = 'KRW';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. 모바일 앱 상단바
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF093687), borderRadius: BorderRadius.circular(3)),
                        child: const Text('UP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
                      ),
                      const SizedBox(width: 4),
                      const Text('bit', style: TextStyle(color: Color(0xFF093687), fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(CupertinoIcons.search, size: 20, color: Colors.black87),
                    onPressed: widget.onOpenEditDialog,
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 18, color: Colors.black87),
                    onPressed: widget.onOpenEditDialog,
                  ),
                ],
              ),
            ),

            // 2. 마켓 선택 탭 (KRW, BTC, USDT, 보유)
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
              ),
              child: Row(
                children: ['KRW', 'BTC', 'USDT', '보유'].map((m) {
                  final isActive = _activeMarket == m;
                  return Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _activeMarket = m),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: isActive ? const Color(0xFF093687) : Colors.transparent, width: 2.5)),
                        ),
                        child: Text(
                          m,
                          style: TextStyle(
                            color: isActive ? const Color(0xFF093687) : Colors.grey.shade600,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // 3. 정렬 필터 헤더 바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: const Color(0xFFF9FAFB),
              child: const Row(
                children: [
                  Expanded(flex: 4, child: Text('한글명', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                  Expanded(flex: 4, child: Text('현재가', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                  Expanded(flex: 3, child: Text('전일대비', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                ],
              ),
            ),

            // 4. 실시간 코인 목록
            Expanded(
              child: ListView.builder(
                itemCount: widget.config.coins.length,
                itemBuilder: (context, index) {
                  final coin = widget.config.coins[index];
                  return UpbitCoinTile(
                    coin: coin,
                    onTap: () => widget.onSelectCoin(coin.symbol),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
