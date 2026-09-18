/// 카카오뱅크 거래 내역 아이템 모델
class KakaoBankTransactionItem {
  final String id;
  final String title; // 예: "김철수", "토스 이체", "스타벅스"
  final String date;  // 예: "09.18 14:20"
  final int amount;   // 금액
  final bool isIncome;// 입금(true) vs 출금(false)
  final int balanceAfter; // 거래 후 잔액

  KakaoBankTransactionItem({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.balanceAfter,
  });
}

/// 카카오뱅크 모조 스크린 설정 모델
class KakaoBankConfig {
  String userName;
  String accountName;
  String accountNumber;
  int balance;
  int safeBoxBalance;
  int savingsBalance;
  String characterType; // 'ryan', 'choonsik', 'apeach'
  List<KakaoBankTransactionItem> transactions;

  KakaoBankConfig({
    required this.userName,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    this.safeBoxBalance = 25000000,
    this.savingsBalance = 2600000,
    this.characterType = 'ryan',
    required this.transactions,
  });

  factory KakaoBankConfig.defaultPreset() {
    return KakaoBankConfig(
      userName: '라이언',
      accountName: '카카오뱅크 입출금 통장',
      accountNumber: '3333-01-8899123',
      balance: 100000000,
      safeBoxBalance: 25000000,
      savingsBalance: 2600000,
      characterType: 'ryan',
      transactions: [
        KakaoBankTransactionItem(
          id: '1',
          title: '김철수',
          date: '09.18 15:30',
          amount: 500000,
          isIncome: true,
          balanceAfter: 100000000,
        ),
        KakaoBankTransactionItem(
          id: '2',
          title: '스타벅스 강남점',
          date: '09.18 12:15',
          amount: 6500,
          isIncome: false,
          balanceAfter: 99500000,
        ),
        KakaoBankTransactionItem(
          id: '3',
          title: '이영희',
          date: '09.17 18:40',
          amount: 1000000,
          isIncome: true,
          balanceAfter: 99506500,
        ),
      ],
    );
  }
}
