enum DeliveryStatus {
  orderReceived('주문 접수', '가게에서 주문을 확인했습니다.'),
  cooking('맛있게 조리 중', '정성을 담아 음식을 준비하고 있어요.'),
  delivering('배달 중', '라이더가 고객님께 달려가고 있습니다.'),
  completed('배달 완료', '문 앞에 안전하게 배달을 완료했습니다!');

  final String title;
  final String description;
  const DeliveryStatus(this.title, this.description);
}

class DeliveryConfig {
  String storeName;
  String orderNumber;
  DeliveryStatus status;
  String estimatedTime;
  String menuSummary;
  int totalPrice;
  String riderMessage;

  DeliveryConfig({
    this.storeName = '홍대마약떡볶이 본점',
    this.orderNumber = 'B-1094',
    this.status = DeliveryStatus.delivering,
    this.estimatedTime = '15~25분 후 도착 예정',
    this.menuSummary = '로제 떡볶이(보통맛) + 모듬튀김 + 쿨피스',
    this.totalPrice = 21500,
    this.riderMessage = '문 앞에 두고 벨 눌러주세요',
  });

  static DeliveryConfig defaultPreset() {
    return DeliveryConfig();
  }
}
