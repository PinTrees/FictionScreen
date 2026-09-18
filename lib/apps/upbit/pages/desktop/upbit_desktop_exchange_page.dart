import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/upbit_model.dart';
import '../../widgets/upbit_chart_preview.dart';
import '../../widgets/upbit_coin_tile.dart';
import '../../widgets/upbit_orderbook.dart';
import 'upbit_desktop_header.dart';

class UpbitDesktopExchangePage extends StatefulWidget {
  final UpbitConfig config;
  final Function(String symbol) onSelectCoin;
  final VoidCallback onEdit;

  const UpbitDesktopExchangePage({
    super.key,
    required this.config,
    required this.onSelectCoin,
    required this.onEdit,
  });

  @override
  State<UpbitDesktopExchangePage> createState() => _UpbitDesktopExchangePageState();
}

class _UpbitDesktopExchangePageState extends State<UpbitDesktopExchangePage> {
  String _activeGnbTab = '거래소';
  String _activeMarketTab = 'KRW';
  bool _isBuyTab = true; // true: 매수, false: 매도
  final TextEditingController _orderPriceCtrl = TextEditingController();
  final TextEditingController _orderQtyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _orderPriceCtrl.text = widget.config.selectedCoin.currentPrice.toInt().toString();
  }

  @override
  void didUpdateWidget(covariant UpbitDesktopExchangePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.selectedCoinSymbol != oldWidget.config.selectedCoinSymbol) {
      _orderPriceCtrl.text = widget.config.selectedCoin.currentPrice.toInt().toString();
    }
  }

  @override
  void dispose() {
    _orderPriceCtrl.dispose();
    _orderQtyCtrl.dispose();
    super.dispose();
  }

  String _formatNumber(num val) => NumberFormat('#,###').format(val);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9ECF1),
      body: Column(
        children: [
          // 1. 데스크탑 GNB 헤더
          UpbitDesktopHeader(
            activeTab: _activeGnbTab,
            onSelectTab: (tab) => setState(() => _activeGnbTab = tab),
            onEdit: widget.onEdit,
          ),

          // 2. 메인 콘텐츠
          Expanded(
            child: _activeGnbTab == '투자내역'
                ? _buildInvestmentView()
                : _buildExchangeDeskView(),
          ),

          // 3. 하단 공식 푸터
          _buildDesktopFooter(),
        ],
      ),
    );
  }

  // 거래소 데스크 화면 (호가창 + 차트 + 주문창 + 시세목록)
  Widget _buildExchangeDeskView() {
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
              // 코인명 및 심볼
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.koreanName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2024)),
                  ),
                  Text('${coin.symbol}/KRW', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const SizedBox(width: 28),

              // 대형 현재가 & 변동률
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_formatNumber(coin.currentPrice)} KRW',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color),
                  ),
                  Row(
                    children: [
                      Text('전일대비 ', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      Text(
                        '$sign${coin.changeRate.toStringAsFixed(2)}%  ▲ ${_formatNumber(coin.changeAmount)}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              // 고가/저가/거래대금
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
                      // 차트 영역 (상단)
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

                      // 주문창 (하단)
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
          // 매수 / 매도 탭
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

          // 주문 가능 금액
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('주문가능', style: TextStyle(fontSize: 11, color: Colors.black54)),
              Text('${_formatNumber(widget.config.krwBalance)} KRW', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF191919))),
            ],
          ),
          const SizedBox(height: 10),

          // 매수/매도 가격 입력란
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

          // 퍼센트 퀵 버튼 (10%, 25%, 50%, 100%)
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

          // 매수/매도 실행 버튼
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

  // 우측 코인 검색 및 시세 리스트
  Widget _buildRightCoinList() {
    return Column(
      children: [
        // 마켓 탭 (KRW, BTC, USDT, 보유)
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

        // 코인 목록
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

  // 데스크탑 투자내역 뷰
  Widget _buildInvestmentView() {
    final cfg = widget.config;
    final isProfit = cfg.totalProfitAmount >= 0;
    final profitColor = isProfit ? const Color(0xFFC84A31) : const Color(0xFF1261C4);
    final sign = isProfit ? '+' : '';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
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
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. 보유 코인 테이블
              const Text('보유 가상자산 목록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2024))),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // 테이블 헤더
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: const Color(0xFFF9FAFB),
                      child: const Row(
                        children: [
                          Expanded(flex: 3, child: Text('자산명', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54))),
                          Expanded(flex: 2, child: Text('보유수량', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.right)),
                          Expanded(flex: 2, child: Text('매수평균가', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.right)),
                          Expanded(flex: 2, child: Text('평가손익', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.right)),
                          Expanded(flex: 2, child: Text('수익률', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.right)),
                        ],
                      ),
                    ),
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
    );
  }

  Widget _buildAssetStatItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color ?? const Color(0xFF1E2024))),
      ],
    );
  }

  Widget _buildDesktopFooter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '두나무(주) | 대표이사 이석우 | 사업자등록번호: 119-86-54968 | 서울특별시 강남구 테헤란로 4길 14 | 고객센터 1588-5682\n'
            '가상자산은 고위험 상품으로서 투자금의 전부 또는 일부 손실을 초래할 수 있습니다.',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500, height: 1.4),
          ),
          Text('Copyright © 2017 - 2026 Dunamu Inc. All rights reserved.', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}
