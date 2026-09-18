/// 코인 기본 정보 모델
class UpbitCoinItem {
  final String symbol; // 예: "BTC"
  final String koreanName; // 예: "비트코인"
  final String market; // "KRW-BTC"
  double currentPrice; // 현재가 (원)
  double changeRate; // 전일대비 변동률 (예: 2.45 -> +2.45%)
  double changeAmount; // 전일대비 변동금액
  double tradeVolume24h; // 24시간 거래대금 (백만 원)
  double highPrice; // 당일 고가
  double lowPrice; // 당일 저가

  UpbitCoinItem({
    required this.symbol,
    required this.koreanName,
    required this.market,
    required this.currentPrice,
    required this.changeRate,
    required this.changeAmount,
    required this.tradeVolume24h,
    required this.highPrice,
    required this.lowPrice,
  });

  bool get isRise => changeRate > 0;
  bool get isFall => changeRate < 0;
  bool get isEven => changeRate == 0;
}

/// 보유 코인 포트폴리오 아이템 (소설 캡처/인증샷 특화)
class UpbitHoldingItem {
  final String symbol;
  final String koreanName;
  double holdingQuantity; // 보유 수량 (예: 2.5 BTC)
  double avgBuyPrice; // 매수 평균가 (예: 62,000,000원)
  double currentPrice; // 현재가 (예: 138,500,000원)

  UpbitHoldingItem({
    required this.symbol,
    required this.koreanName,
    required this.holdingQuantity,
    required this.avgBuyPrice,
    required this.currentPrice,
  });

  double get buyAmount => holdingQuantity * avgBuyPrice; // 매수금액
  double get evalAmount => holdingQuantity * currentPrice; // 평가금액
  double get profitAmount => evalAmount - buyAmount; // 평가손익
  double get profitRate => buyAmount > 0 ? (profitAmount / buyAmount) * 100 : 0.0; // 수익률 (%)
}

/// 호가 아이템 (Orderbook)
class UpbitOrderbookUnit {
  final double price;
  final double size; // 잔량
  final bool isAsk; // true: 매도(파란색), false: 매수(빨간색)

  UpbitOrderbookUnit({
    required this.price,
    required this.size,
    required this.isAsk,
  });
}

/// 업비트 전역 설정 및 상태 모델
class UpbitConfig {
  double totalAssets; // 총 보유자산 (원)
  double krwBalance; // 보유 KRW (원)
  String selectedCoinSymbol; // 현재 선택된 코인 ("BTC")
  List<UpbitCoinItem> coins; // 코인 시세 목록
  List<UpbitHoldingItem> holdings; // 보유 코인 목록
  String activeMarketTab; // "KRW", "BTC", "USDT", "보유"
  String activeGnbTab; // "거래소", "입출금", "투자내역", "코인동향", "스테이킹"

  UpbitConfig({
    required this.totalAssets,
    required this.krwBalance,
    this.selectedCoinSymbol = 'BTC',
    required this.coins,
    required this.holdings,
    this.activeMarketTab = 'KRW',
    this.activeGnbTab = '거래소',
  });

  // 총 매수금액
  double get totalBuyAmount => holdings.fold(0.0, (sum, item) => sum + item.buyAmount);

  // 총 평가금액
  double get totalEvalAmount => holdings.fold(0.0, (sum, item) => sum + item.evalAmount);

  // 총 평가손익
  double get totalProfitAmount => totalEvalAmount - totalBuyAmount;

  // 총 수익률
  double get totalProfitRate => totalBuyAmount > 0 ? (totalProfitAmount / totalBuyAmount) * 100 : 0.0;

  UpbitCoinItem get selectedCoin => coins.firstWhere(
        (c) => c.symbol == selectedCoinSymbol,
        orElse: () => coins.first,
      );

  factory UpbitConfig.defaultPreset() {
    return UpbitConfig(
      totalAssets: 3450230000,
      krwBalance: 50230000,
      selectedCoinSymbol: 'BTC',
      coins: [
        UpbitCoinItem(
          symbol: 'BTC',
          koreanName: '비트코인',
          market: 'KRW-BTC',
          currentPrice: 138500000,
          changeRate: 2.85,
          changeAmount: 3840000,
          tradeVolume24h: 394201,
          highPrice: 141200000,
          lowPrice: 134500000,
        ),
        UpbitCoinItem(
          symbol: 'ETH',
          koreanName: '이더리움',
          market: 'KRW-ETH',
          currentPrice: 4850000,
          changeRate: 3.42,
          changeAmount: 160000,
          tradeVolume24h: 182300,
          highPrice: 4950000,
          lowPrice: 4680000,
        ),
        UpbitCoinItem(
          symbol: 'SOL',
          koreanName: '솔라나',
          market: 'KRW-SOL',
          currentPrice: 284000,
          changeRate: 6.12,
          changeAmount: 16400,
          tradeVolume24h: 245100,
          highPrice: 292000,
          lowPrice: 266000,
        ),
        UpbitCoinItem(
          symbol: 'XRP',
          koreanName: '리플',
          market: 'KRW-XRP',
          currentPrice: 3250,
          changeRate: -1.22,
          changeAmount: -40,
          tradeVolume24h: 512400,
          highPrice: 3380,
          lowPrice: 3180,
        ),
        UpbitCoinItem(
          symbol: 'DOGE',
          koreanName: '도지코인',
          market: 'KRW-DOGE',
          currentPrice: 385,
          changeRate: 8.45,
          changeAmount: 30,
          tradeVolume24h: 420500,
          highPrice: 410,
          lowPrice: 350,
        ),
        UpbitCoinItem(
          symbol: 'ADA',
          koreanName: '에이다',
          market: 'KRW-ADA',
          currentPrice: 1240,
          changeRate: -0.48,
          changeAmount: -6,
          tradeVolume24h: 84200,
          highPrice: 1280,
          lowPrice: 1210,
        ),
        UpbitCoinItem(
          symbol: 'AVAX',
          koreanName: '아발란체',
          market: 'KRW-AVAX',
          currentPrice: 54200,
          changeRate: 4.23,
          changeAmount: 2200,
          tradeVolume24h: 68400,
          highPrice: 55800,
          lowPrice: 51500,
        ),
        UpbitCoinItem(
          symbol: 'SUI',
          koreanName: '수이',
          market: 'KRW-SUI',
          currentPrice: 4820,
          changeRate: 11.57,
          changeAmount: 500,
          tradeVolume24h: 198200,
          highPrice: 5100,
          lowPrice: 4280,
        ),
        UpbitCoinItem(
          symbol: 'SHIB',
          koreanName: '시바이누',
          market: 'KRW-SHIB',
          currentPrice: 0.0382,
          changeRate: -2.05,
          changeAmount: -0.0008,
          tradeVolume24h: 154000,
          highPrice: 0.0402,
          lowPrice: 0.0371,
        ),
      ],
      holdings: [
        UpbitHoldingItem(
          symbol: 'BTC',
          koreanName: '비트코인',
          holdingQuantity: 20.5,
          avgBuyPrice: 58000000,
          currentPrice: 138500000,
        ),
        UpbitHoldingItem(
          symbol: 'ETH',
          koreanName: '이더리움',
          holdingQuantity: 100.0,
          avgBuyPrice: 2800000,
          currentPrice: 4850000,
        ),
        UpbitHoldingItem(
          symbol: 'SOL',
          koreanName: '솔라나',
          holdingQuantity: 300.0,
          avgBuyPrice: 95000,
          currentPrice: 284000,
        ),
      ],
    );
  }
}
