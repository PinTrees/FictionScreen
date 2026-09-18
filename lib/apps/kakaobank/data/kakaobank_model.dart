/// 카카오뱅크 거래 내역 아이템 모델
class KakaoBankTransactionItem {
  final String id;
  final String title;
  final String date;
  final int amount;
  final bool isIncome;
  final int balanceAfter;
  final String category;
  final String? memo;

  KakaoBankTransactionItem({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.balanceAfter,
    this.category = '기타',
    this.memo,
  });
}

/// 카카오뱅크 체크/신용카드 정보
class KakaoBankCardInfo {
  final String cardName;
  final String lastDigits;
  final int usedAmountThisMonth;
  final String paymentDate;

  KakaoBankCardInfo({
    required this.cardName,
    required this.lastDigits,
    required this.usedAmountThisMonth,
    required this.paymentDate,
  });
}

/// 26주적금 챌린지 모델
class KakaoBankSavings26Weeks {
  final String title;
  int currentWeek;
  final int targetAmount;
  int totalSaved;
  final String character;

  KakaoBankSavings26Weeks({
    required this.title,
    required this.currentWeek,
    required this.targetAmount,
    required this.totalSaved,
    this.character = 'choonsik',
  });
}

/// 저금통 모델 (동전 모으기)
class KakaoBankPiggyBank {
  final String nickname;
  int amount;
  final String itemEstimate;

  KakaoBankPiggyBank({
    required this.nickname,
    required this.amount,
    this.itemEstimate = '놀이공원 자유이용권 1장',
  });
}

/// 카카오뱅크 전역 설정/상태 모델
class KakaoBankConfig {
  String userName;
  String accountName;
  String accountNumber;
  int balance;
  int safeBoxBalance;
  int safeBoxTarget;
  bool hideBalance;
  int creditScore;
  String characterType; // 'ryan', 'choonsik', 'apeach'
  KakaoBankSavings26Weeks savings26;
  KakaoBankPiggyBank piggyBank;
  KakaoBankCardInfo cardInfo;
  List<KakaoBankTransactionItem> transactions;

  KakaoBankConfig({
    required this.userName,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    this.safeBoxBalance = 25000000,
    this.safeBoxTarget = 50000000,
    this.hideBalance = false,
    this.creditScore = 956,
    this.characterType = 'ryan',
    required this.savings26,
    required this.piggyBank,
    required this.cardInfo,
    required this.transactions,
  });

  factory KakaoBankConfig.defaultPreset() {
    return KakaoBankConfig(
      userName: '라이언',
      accountName: '카카오뱅크 입출금 통장',
      accountNumber: '3333-01-8899123',
      balance: 100000000,
      safeBoxBalance: 25000000,
      safeBoxTarget: 50000000,
      hideBalance: false,
      creditScore: 956,
      characterType: 'ryan',
      savings26: KakaoBankSavings26Weeks(
        title: '26주적금 with 춘식이',
        currentWeek: 24,
        targetAmount: 2600000,
        totalSaved: 2400000,
        character: 'choonsik',
      ),
      piggyBank: KakaoBankPiggyBank(
        nickname: '라이언의 비밀저금통',
        amount: 87400,
        itemEstimate: '패밀리 레스토랑 외식 1회',
      ),
      cardInfo: KakaoBankCardInfo(
        cardName: '프렌즈 체크카드 (노랑)',
        lastDigits: '8910',
        usedAmountThisMonth: 642800,
        paymentDate: '10일 결제 예정',
      ),
      transactions: [
        KakaoBankTransactionItem(
          id: '1',
          title: '김철수',
          date: '09.18 15:30',
          amount: 500000,
          isIncome: true,
          balanceAfter: 100000000,
          category: '이체',
          memo: '프로젝트 정산금',
        ),
        KakaoBankTransactionItem(
          id: '2',
          title: '스타벅스 강남점',
          date: '09.18 12:15',
          amount: 6500,
          isIncome: false,
          balanceAfter: 99500000,
          category: '카페/간식',
          memo: '아이스 아메리카노',
        ),
        KakaoBankTransactionItem(
          id: '3',
          title: '쿠팡 결제',
          date: '09.17 21:04',
          amount: 43200,
          isIncome: false,
          balanceAfter: 99506500,
          category: '쇼핑',
          memo: '생필품 로켓배송',
        ),
        KakaoBankTransactionItem(
          id: '4',
          title: '이영희',
          date: '09.17 18:40',
          amount: 1000000,
          isIncome: true,
          balanceAfter: 99549700,
          category: '이체',
          memo: '축하금',
        ),
        KakaoBankTransactionItem(
          id: '5',
          title: '세이프박스 보관',
          date: '09.15 10:00',
          amount: 5000000,
          isIncome: false,
          balanceAfter: 98549700,
          category: '저축',
          memo: '이자 모으기',
        ),
      ],
    );
  }
}
