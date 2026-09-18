/// 당근마켓 채팅 메시지 아이템 모델
class DaangnMessageItem {
  final String id;
  final bool isMe;
  final String text;
  final String time;
  final String? imageAsset;

  DaangnMessageItem({
    required this.id,
    required this.isMe,
    required this.text,
    required this.time,
    this.imageAsset,
  });
}

/// 당근마켓 모조 스크린 설정 모델
class DaangnConfig {
  String sellerName;
  String sellerLocation;
  double mannerTemp; // 예: 36.5, 42.3
  String productTitle;
  int productPrice;
  String tradeStatus; // '판매중', '예약중', '거래완료'
  String? productImageAsset;
  List<DaangnMessageItem> messages;

  DaangnConfig({
    required this.sellerName,
    required this.sellerLocation,
    this.mannerTemp = 37.8,
    required this.productTitle,
    required this.productPrice,
    this.tradeStatus = '판매중',
    this.productImageAsset,
    required this.messages,
  });

  factory DaangnConfig.defaultPreset() {
    return DaangnConfig(
      sellerName: '당근이네',
      sellerLocation: '역삼동',
      mannerTemp: 41.2,
      productTitle: '아이폰 15 프로 자급제 128GB 미개봉 팝니다',
      productPrice: 1150000,
      tradeStatus: '판매중',
      productImageAsset: 'assets/images/apple_logo.webp',
      messages: [
        DaangnMessageItem(
          id: '1',
          isMe: false,
          text: '안녕하세요! 혹시 아이폰 아직 판매중인가요?',
          time: '오후 2:10',
        ),
        DaangnMessageItem(
          id: '2',
          isMe: true,
          text: '네! 네고 없이 바로 거래 가능하십니다 :)',
          time: '오후 2:12',
        ),
        DaangnMessageItem(
          id: '3',
          isMe: false,
          text: '혹시 만원만 네고해주시면 지금 바로 역삼역으로 가겠습니다!',
          time: '오후 2:15',
        ),
      ],
    );
  }
}
