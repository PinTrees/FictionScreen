/// 야놀자 객실 아이템 (대실 / 숙박)
class YanoljaRoomItem {
  final String id;
  final String name;
  final int rentPrice;       // 대실 가격 (예: 45,000원)
  final int stayPrice;       // 숙박 가격 (예: 180,000원)
  final String rentTime;     // 대실 이용시간 (예: "최대 4시간")
  final String stayCheckIn;  // 숙박 입실 (예: "15:00 입실 / 11:00 퇴실")
  final int availableCount;  // 잔여 객실
  final String? imageUrl;

  YanoljaRoomItem({
    required this.id,
    required this.name,
    required this.rentPrice,
    required this.stayPrice,
    this.rentTime = '최대 4시간',
    this.stayCheckIn = '15:00 입실 ~ 익일 11:00 퇴실',
    this.availableCount = 3,
    this.imageUrl,
  });
}

/// 야놀자 숙소 아이템 모델
class YanoljaLodgingItem {
  final String id;
  String name;
  String type; // 호텔, 모텔, 펜션/풀빌라, 리조트, 게스트하우스
  String location; // 예: "강남구 역삼동 · 역삼역 3번 출구 도보 3분"
  double rating; // 4.9
  int reviewCount; // 1,420
  String badge; // "쿠폰할인", "단독특가", "인기급상승"
  int minRentPrice;
  int minStayPrice;
  String? imageUrl;
  List<YanoljaRoomItem> rooms;

  YanoljaLodgingItem({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.rating,
    required this.reviewCount,
    this.badge = '쿠폰할인',
    required this.minRentPrice,
    required this.minStayPrice,
    this.imageUrl,
    required this.rooms,
  });
}

/// 야놀자 예약 완료 내역 모델 (스토리/소설 캡처 특화)
class YanoljaReservation {
  String reservationNo;
  String lodgingName;
  String roomName;
  bool isRent; // true: 대실, false: 숙박
  String checkInInfo; // "2026.09.19 (금) 15:00"
  String checkOutInfo; // "2026.09.20 (토) 11:00"
  String guestName;
  String guestPhone;
  int totalAmount;
  String paymentMethod;

  YanoljaReservation({
    required this.reservationNo,
    required this.lodgingName,
    required this.roomName,
    required this.isRent,
    required this.checkInInfo,
    required this.checkOutInfo,
    required this.guestName,
    required this.guestPhone,
    required this.totalAmount,
    this.paymentMethod = '카카오페이 간편결제',
  });
}

/// 야놀자 전역 상태 설정 모델
class YanoljaConfig {
  String selectedRegion;
  String dateRangeText;
  int guestCount;
  String activeCategory; // '전체', '호텔/리조트', '펜션/풀빌라', '모텔', '캠핑/글램핑'
  List<YanoljaLodgingItem> lodgings;
  YanoljaReservation? latestReservation;
  String searchKeyword;

  YanoljaConfig({
    required this.selectedRegion,
    required this.dateRangeText,
    this.guestCount = 2,
    this.activeCategory = '전체',
    required this.lodgings,
    this.latestReservation,
    this.searchKeyword = '',
  });

  String get region => selectedRegion;
  set region(String val) => selectedRegion = val;

  String get dateText => dateRangeText;
  set dateText(String val) => dateRangeText = val;

  factory YanoljaConfig.defaultPreset() {
    return YanoljaConfig(
      selectedRegion: '서울 강남/역삼/선릉',
      dateRangeText: '09.19(금) - 09.20(토) · 1박',
      guestCount: 2,
      activeCategory: '전체',
      latestReservation: YanoljaReservation(
        reservationNo: 'YN20260919-883921',
        lodgingName: '시그니엘 서울',
        roomName: '프리미어 더블 룸 (리버뷰)',
        isRent: false,
        checkInInfo: '2026.09.19 (금) 15:00',
        checkOutInfo: '2026.09.20 (토) 11:00',
        guestName: '김민준',
        guestPhone: '010-9876-5432',
        totalAmount: 480000,
        paymentMethod: '토스페이 간편결제',
      ),
      lodgings: [
        YanoljaLodgingItem(
          id: '1',
          name: '시그니엘 서울 (Signiel Seoul)',
          type: '호텔',
          location: '송파구 잠실동 · 잠실역 1번 출구 도보 2분',
          rating: 4.9,
          reviewCount: 3840,
          badge: 'NOL 단독특가',
          minRentPrice: 0,
          minStayPrice: 480000,
          rooms: [
            YanoljaRoomItem(
              id: 'r1',
              name: '프리미어 더블 룸 (리버뷰)',
              rentPrice: 0,
              stayPrice: 480000,
              stayCheckIn: '15:00 입실 ~ 11:00 퇴실',
            ),
            YanoljaRoomItem(
              id: 'r2',
              name: '디럭스 스위트 트윈 룸',
              rentPrice: 0,
              stayPrice: 750000,
              stayCheckIn: '15:00 입실 ~ 11:00 퇴실',
            ),
          ],
        ),
        YanoljaLodgingItem(
          id: '2',
          name: '강남 호텔 인스파이어 (Inspire Gangnam)',
          type: '모텔',
          location: '강남구 역삼동 · 역삼역 3번 출구 250m',
          rating: 4.8,
          reviewCount: 1520,
          badge: '쿠폰할인 10%',
          minRentPrice: 35000,
          minStayPrice: 85000,
          rooms: [
            YanoljaRoomItem(
              id: 'r3',
              name: '스탠다드 더블 (넷플릭스 OTT 완비)',
              rentPrice: 35000,
              stayPrice: 85000,
              rentTime: '최대 4시간 이용',
              stayCheckIn: '20:00 입실 ~ 12:00 퇴실',
            ),
            YanoljaRoomItem(
              id: 'r4',
              name: '디럭스 스파 욕조 룸 (스타일러 구비)',
              rentPrice: 45000,
              stayPrice: 110000,
              rentTime: '최대 5시간 이용',
              stayCheckIn: '18:00 입실 ~ 12:00 퇴실',
            ),
          ],
        ),
        YanoljaLodgingItem(
          id: '3',
          name: '가평 리버파크 풀빌라 & 스파',
          type: '펜션/풀빌라',
          location: '경기 가평군 청평면 · 북한강변 파노라마 뷰',
          rating: 4.9,
          reviewCount: 920,
          badge: '온수풀 무료',
          minRentPrice: 0,
          minStayPrice: 280000,
          rooms: [
            YanoljaRoomItem(
              id: 'r5',
              name: '독채 프라이빗 온수 풀빌라 101호',
              rentPrice: 0,
              stayPrice: 280000,
              stayCheckIn: '15:00 입실 ~ 11:00 퇴실',
            ),
          ],
        ),
        YanoljaLodgingItem(
          id: '4',
          name: '파라다이스시티 (Paradise City)',
          type: '호텔/리조트',
          location: '인천 중구 영종해안남로 · 씨메르 스파 포함',
          rating: 4.9,
          reviewCount: 4200,
          badge: '씨메르 무료입장',
          minRentPrice: 0,
          minStayPrice: 390000,
          rooms: [
            YanoljaRoomItem(
              id: 'r6',
              name: '디럭스 킹 룸 (원더박스 2인 패키지)',
              rentPrice: 0,
              stayPrice: 390000,
              stayCheckIn: '15:00 입실 ~ 11:00 퇴실',
            ),
          ],
        ),
      ],
    );
  }
}
