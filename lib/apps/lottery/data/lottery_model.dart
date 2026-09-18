/// 로또 6/45 단일 게임 슬립지 항목 (A, B, C, D, E)
class LottoGameItem {
  final String label; // A, B, C, D, E
  final String type; // '자동', '반자동', '수동'
  final List<int> numbers; // 6개 번호 (1~45)

  const LottoGameItem({
    required this.label,
    required this.type,
    required this.numbers,
  });

  LottoGameItem copyWith({
    String? label,
    String? type,
    List<int>? numbers,
  }) {
    return LottoGameItem(
      label: label ?? this.label,
      type: type ?? this.type,
      numbers: numbers ?? List<int>.from(this.numbers),
    );
  }
}

/// 동행복권 전체 설정 모델
class LotteryConfig {
  // 로또 6/45 회차 및 추첨 정보
  final int round;
  final String drawDate;
  final String issueDate;
  final String payDueDate;
  final String barcode;
  final String trCode;
  final String storeName;

  // 당첨 번호 (6개 + 보너스 1개)
  final List<int> winningNumbers;
  final int bonusNumber;

  // 당첨금 통계
  final String firstPrizeTotal;
  final int firstPrizeWinners;
  final String firstPrizePerGame;

  // 내 슬립지 복권 영수증 게임들 (A~E 5게임)
  final List<LottoGameItem> slipGames;

  // QR 당첨 결과 시뮬레이션 설정
  final int myWinningRank; // 1: 1등, 2: 2등, 3: 3등, 4: 4등, 5: 5등, 0: 낙첨
  final String myWinningAmount; // 예: "2,586,381,123원"
  final String myWinningGameLabel; // 당첨된 행 (예: 'A')

  // 연금복권 720+ 설정
  final int pensionRound;
  final int pensionGroup; // 1~5조
  final List<int> pensionNumbers; // 6자리 숫자 (예: [2, 8, 4, 1, 9, 3])
  final List<int> pensionBonusNumbers; // 각조 6자리 숫자

  // 스피또 2000 설정
  final int spitoRound;
  final int spitoLuckyNumber1;
  final int spitoLuckyNumber2;
  final String spitoPrizeAmount;

  const LotteryConfig({
    required this.round,
    required this.drawDate,
    required this.issueDate,
    required this.payDueDate,
    required this.barcode,
    required this.trCode,
    required this.storeName,
    required this.winningNumbers,
    required this.bonusNumber,
    required this.firstPrizeTotal,
    required this.firstPrizeWinners,
    required this.firstPrizePerGame,
    required this.slipGames,
    required this.myWinningRank,
    required this.myWinningAmount,
    required this.myWinningGameLabel,
    required this.pensionRound,
    required this.pensionGroup,
    required this.pensionNumbers,
    required this.pensionBonusNumbers,
    required this.spitoRound,
    required this.spitoLuckyNumber1,
    required this.spitoLuckyNumber2,
    required this.spitoPrizeAmount,
  });

  LotteryConfig copyWith({
    int? round,
    String? drawDate,
    String? issueDate,
    String? payDueDate,
    String? barcode,
    String? trCode,
    String? storeName,
    List<int>? winningNumbers,
    int? bonusNumber,
    String? firstPrizeTotal,
    int? firstPrizeWinners,
    String? firstPrizePerGame,
    List<LottoGameItem>? slipGames,
    int? myWinningRank,
    String? myWinningAmount,
    String? myWinningGameLabel,
    int? pensionRound,
    int? pensionGroup,
    List<int>? pensionNumbers,
    List<int>? pensionBonusNumbers,
    int? spitoRound,
    int? spitoLuckyNumber1,
    int? spitoLuckyNumber2,
    String? spitoPrizeAmount,
  }) {
    return LotteryConfig(
      round: round ?? this.round,
      drawDate: drawDate ?? this.drawDate,
      issueDate: issueDate ?? this.issueDate,
      payDueDate: payDueDate ?? this.payDueDate,
      barcode: barcode ?? this.barcode,
      trCode: trCode ?? this.trCode,
      storeName: storeName ?? this.storeName,
      winningNumbers: winningNumbers ?? List<int>.from(this.winningNumbers),
      bonusNumber: bonusNumber ?? this.bonusNumber,
      firstPrizeTotal: firstPrizeTotal ?? this.firstPrizeTotal,
      firstPrizeWinners: firstPrizeWinners ?? this.firstPrizeWinners,
      firstPrizePerGame: firstPrizePerGame ?? this.firstPrizePerGame,
      slipGames: slipGames ?? List<LottoGameItem>.from(this.slipGames),
      myWinningRank: myWinningRank ?? this.myWinningRank,
      myWinningAmount: myWinningAmount ?? this.myWinningAmount,
      myWinningGameLabel: myWinningGameLabel ?? this.myWinningGameLabel,
      pensionRound: pensionRound ?? this.pensionRound,
      pensionGroup: pensionGroup ?? this.pensionGroup,
      pensionNumbers: pensionNumbers ?? List<int>.from(this.pensionNumbers),
      pensionBonusNumbers: pensionBonusNumbers ?? List<int>.from(this.pensionBonusNumbers),
      spitoRound: spitoRound ?? this.spitoRound,
      spitoLuckyNumber1: spitoLuckyNumber1 ?? this.spitoLuckyNumber1,
      spitoLuckyNumber2: spitoLuckyNumber2 ?? this.spitoLuckyNumber2,
      spitoPrizeAmount: spitoPrizeAmount ?? this.spitoPrizeAmount,
    );
  }

  /// 1등 대박 당첨 기본 프리셋 (유튜브/쇼츠/상황극용)
  factory LotteryConfig.defaultPreset() {
    return const LotteryConfig(
      round: 1140,
      drawDate: '2024년 10월 05일 추첨',
      issueDate: '2024/10/04 (금) 18:24:11',
      payDueDate: '2025.10.06',
      barcode: '91845 28419 39182 48192 10293 84712',
      trCode: 'TR : 04921-29183-19283-84912',
      storeName: '로또명당 잠실매표소 (서울 송파구)',
      winningNumbers: [7, 11, 23, 31, 38, 44],
      bonusNumber: 15,
      firstPrizeTotal: '28,450,192,350원',
      firstPrizeWinners: 11,
      firstPrizePerGame: '2,586,381,123원',
      slipGames: [
        LottoGameItem(label: 'A', type: '자 동', numbers: [7, 11, 23, 31, 38, 44]), // 1등 일치!
        LottoGameItem(label: 'B', type: '자 동', numbers: [3, 14, 21, 29, 35, 42]),
        LottoGameItem(label: 'C', type: '반자동', numbers: [1, 7, 18, 25, 33, 40]),
        LottoGameItem(label: 'D', type: '수 동', numbers: [9, 12, 20, 27, 36, 45]),
        LottoGameItem(label: 'E', type: '자 동', numbers: [5, 16, 22, 30, 39, 41]),
      ],
      myWinningRank: 1,
      myWinningAmount: '2,586,381,123원',
      myWinningGameLabel: 'A',
      pensionRound: 231,
      pensionGroup: 3,
      pensionNumbers: [1, 7, 4, 8, 2, 5],
      pensionBonusNumbers: [6, 2, 9, 3, 0, 8],
      spitoRound: 59,
      spitoLuckyNumber1: 14,
      spitoLuckyNumber2: 28,
      spitoPrizeAmount: '2,000,000,000원',
    );
  }

  /// 2등 당첨 프리셋 (5개 일치 + 보너스 볼 일치)
  factory LotteryConfig.secondPrizePreset() {
    return LotteryConfig.defaultPreset().copyWith(
      myWinningRank: 2,
      myWinningAmount: '56,841,200원',
      slipGames: [
        const LottoGameItem(label: 'A', type: '자 동', numbers: [7, 11, 23, 31, 38, 15]), // 5개 + 보너스(15)
        const LottoGameItem(label: 'B', type: '자 동', numbers: [3, 14, 21, 29, 35, 42]),
        const LottoGameItem(label: 'C', type: '반자동', numbers: [1, 7, 18, 25, 33, 40]),
        const LottoGameItem(label: 'D', type: '수 동', numbers: [9, 12, 20, 27, 36, 45]),
        const LottoGameItem(label: 'E', type: '자 동', numbers: [5, 16, 22, 30, 39, 41]),
      ],
    );
  }

  /// 3등 당첨 프리셋 (5개 일치)
  factory LotteryConfig.thirdPrizePreset() {
    return LotteryConfig.defaultPreset().copyWith(
      myWinningRank: 3,
      myWinningAmount: '1,489,200원',
      slipGames: [
        const LottoGameItem(label: 'A', type: '자 동', numbers: [7, 11, 23, 31, 38, 2]),
        const LottoGameItem(label: 'B', type: '자 동', numbers: [3, 14, 21, 29, 35, 42]),
        const LottoGameItem(label: 'C', type: '반자동', numbers: [1, 7, 18, 25, 33, 40]),
        const LottoGameItem(label: 'D', type: '수 동', numbers: [9, 12, 20, 27, 36, 45]),
        const LottoGameItem(label: 'E', type: '자 동', numbers: [5, 16, 22, 30, 39, 41]),
      ],
    );
  }

  /// 낙첨 프리셋 (아쉽게 모두 탈락)
  factory LotteryConfig.losePreset() {
    return LotteryConfig.defaultPreset().copyWith(
      myWinningRank: 0,
      myWinningAmount: '0원',
      slipGames: [
        const LottoGameItem(label: 'A', type: '자 동', numbers: [2, 8, 14, 26, 33, 41]),
        const LottoGameItem(label: 'B', type: '자 동', numbers: [4, 12, 19, 28, 37, 43]),
        const LottoGameItem(label: 'C', type: '반자동', numbers: [1, 6, 17, 24, 32, 40]),
        const LottoGameItem(label: 'D', type: '수 동', numbers: [5, 10, 18, 25, 35, 42]),
        const LottoGameItem(label: 'E', type: '자 동', numbers: [3, 9, 16, 22, 34, 45]),
      ],
    );
  }
}
