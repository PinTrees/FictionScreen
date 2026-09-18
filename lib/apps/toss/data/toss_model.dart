class TossTransaction {
  String id;
  String title;
  String time;
  int amount;
  bool isTransfer; // 송금 vs 입금

  TossTransaction({
    required this.id,
    required this.title,
    required this.time,
    required this.amount,
    this.isTransfer = true,
  });
}

class TossConfig {
  String userName;
  String bankName;
  String accountNumber;
  int balance;
  String receiverName;
  int sendAmount;
  String completionMessage;
  String transactionTime;
  bool isDarkTheme;
  List<TossTransaction> history;

  TossConfig({
    this.userName = '김토스',
    this.bankName = '토스뱅크 통장',
    this.accountNumber = '1000-8839-1204',
    this.balance = 2480000,
    this.receiverName = '이영희',
    this.sendAmount = 50000,
    this.completionMessage = '이영희님에게 50,000원을 보냈어요',
    this.transactionTime = '오늘 14:32',
    this.isDarkTheme = false,
    required this.history,
  });

  static TossConfig defaultPreset() {
    return TossConfig(
      userName: '김토스',
      bankName: '토스뱅크 통장',
      accountNumber: '1000-8839-1204',
      balance: 2480000,
      receiverName: '이영희',
      sendAmount: 50000,
      completionMessage: '이영희님에게 50,000원을 보냈어요',
      transactionTime: '오늘 14:32',
      isDarkTheme: false,
      history: [
        TossTransaction(
          id: '1',
          title: '이영희',
          time: '오늘 14:32',
          amount: -50000,
          isTransfer: true,
        ),
        TossTransaction(
          id: '2',
          title: '쿠팡 결제',
          time: '어제 21:15',
          amount: -18900,
          isTransfer: true,
        ),
        TossTransaction(
          id: '3',
          title: '월급 (주식회사 픽션)',
          time: '09.25 10:00',
          amount: 3500000,
          isTransfer: false,
        ),
      ],
    );
  }
}
