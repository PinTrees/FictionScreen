enum RocketBadgeType {
  rocket('로켓배송'),
  rocketFresh('로켓프레시'),
  rocketGlobal('로켓직구'),
  wowOnly('와우할인');

  final String label;
  const RocketBadgeType(this.label);
}

/// 쿠팡 상품 아이템 모델
class CoupangProductItem {
  final String id;
  final String title;
  final int price;
  final int originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewCount;
  final RocketBadgeType badgeType;
  final String deliveryNotice;
  final String imageUrl;
  final int cashReward;

  const CoupangProductItem({
    required this.id,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.badgeType,
    required this.deliveryNotice,
    required this.imageUrl,
    this.cashReward = 0,
  });

  CoupangProductItem copyWith({
    String? id,
    String? title,
    int? price,
    int? originalPrice,
    int? discountPercent,
    double? rating,
    int? reviewCount,
    RocketBadgeType? badgeType,
    String? deliveryNotice,
    String? imageUrl,
    int? cashReward,
  }) {
    return CoupangProductItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      badgeType: badgeType ?? this.badgeType,
      deliveryNotice: deliveryNotice ?? this.deliveryNotice,
      imageUrl: imageUrl ?? this.imageUrl,
      cashReward: cashReward ?? this.cashReward,
    );
  }
}

/// 쿠팡 카테고리 아이템
class CoupangCategoryItem {
  final String id;
  final String name;
  final String iconKey;

  const CoupangCategoryItem({
    required this.id,
    required this.name,
    required this.iconKey,
  });
}

/// 쿠팡 프로모션 배너 아이템
class CoupangBannerItem {
  final String id;
  final String title;
  final String subTitle;
  final String tag;
  final String imageUrl;
  final int bgColorHex;

  const CoupangBannerItem({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.tag,
    required this.imageUrl,
    this.bgColorHex = 0xFF1C2237,
  });
}

/// 쿠팡 전역 설정 모델 (모바일 및 데스크탑 공용)
class CoupangConfig {
  String searchKeyword;
  String userLocation;
  String wowMemberName;
  int cartCount;
  int selectedCategoryIndex;
  List<CoupangBannerItem> banners;
  List<CoupangCategoryItem> categories;
  List<CoupangProductItem> products;

  CoupangConfig({
    this.searchKeyword = '맥북 M4 Pro 16인치',
    this.userLocation = '서울시 강남구 테헤란로 152 역삼역 3번출구',
    this.wowMemberName = '홍길동',
    this.cartCount = 3,
    this.selectedCategoryIndex = 0,
    required this.banners,
    required this.categories,
    required this.products,
  });

  CoupangConfig copyWith({
    String? searchKeyword,
    String? userLocation,
    String? wowMemberName,
    int? cartCount,
    int? selectedCategoryIndex,
    List<CoupangBannerItem>? banners,
    List<CoupangCategoryItem>? categories,
    List<CoupangProductItem>? products,
  }) {
    return CoupangConfig(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      userLocation: userLocation ?? this.userLocation,
      wowMemberName: wowMemberName ?? this.wowMemberName,
      cartCount: cartCount ?? this.cartCount,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      products: products ?? this.products,
    );
  }

  static CoupangConfig defaultPreset() {
    return CoupangConfig(
      searchKeyword: '애플 맥북 M4 Pro 16인치 스페이스 블랙',
      userLocation: '서울시 강남구 테헤란로 152 (강남파이낸스센터)',
      wowMemberName: 'FictionMaker',
      cartCount: 4,
      banners: const [
        CoupangBannerItem(
          id: 'b1',
          title: '2026 애플 신제품 얼리버드 로켓배송',
          subTitle: '최대 18% 카드 즉시할인 + 애플케어+ 번들 혜택',
          tag: '로켓와우 단독특가',
          imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80',
          bgColorHex: 0xFF141824,
        ),
        CoupangBannerItem(
          id: 'b2',
          title: '내일 아침 문 앞 도착! 로켓프레시 봄맞이 신선특가',
          subTitle: '산지직송 딸기 & 한우 1++ 구이용 새벽 7시 전 배송',
          tag: '로켓프레시',
          imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=800&q=80',
          bgColorHex: 0xFF0D2818,
        ),
        CoupangBannerItem(
          id: 'b3',
          title: '단 하루 골드박스! 생활가전 & 데스크테리어 TOP 50',
          subTitle: '최대 55% 한정 수량 파격 할인',
          tag: '골드박스',
          imageUrl: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=800&q=80',
          bgColorHex: 0xFF2B1055,
        ),
      ],
      categories: const [
        CoupangCategoryItem(id: 'c1', name: '로켓배송', iconKey: 'rocket'),
        CoupangCategoryItem(id: 'c2', name: '로켓프레시', iconKey: 'fresh'),
        CoupangCategoryItem(id: 'c3', name: '골드박스', iconKey: 'gold'),
        CoupangCategoryItem(id: 'c4', name: '로켓직구', iconKey: 'global'),
        CoupangCategoryItem(id: 'c5', name: '와우할인', iconKey: 'wow'),
        CoupangCategoryItem(id: 'c6', name: '가전/디지털', iconKey: 'tech'),
        CoupangCategoryItem(id: 'c7', name: '패션의류', iconKey: 'fashion'),
        CoupangCategoryItem(id: 'c8', name: '식품', iconKey: 'food'),
        CoupangCategoryItem(id: 'c9', name: '홈/인테리어', iconKey: 'home'),
        CoupangCategoryItem(id: 'c10', name: '쿠팡플레이', iconKey: 'play'),
      ],
      products: [
        CoupangProductItem(
          id: 'p1',
          title: 'Apple 2024 맥북 프로 16 M4 Pro (14코어 CPU, 20코어 GPU, 24GB, 512GB) 스페이스 블랙',
          price: 3390000,
          originalPrice: 3790000,
          discountPercent: 11,
          rating: 4.9,
          reviewCount: 3842,
          badgeType: RocketBadgeType.rocket,
          deliveryNotice: '내일(토) 새벽 7시 전 도착 보장',
          imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&q=80',
          cashReward: 33900,
        ),
        CoupangProductItem(
          id: 'p2',
          title: '[로켓프레시] 1++등급 친환경 무항생제 한우 채끝스테이크 300g (냉장)',
          price: 36800,
          originalPrice: 48000,
          discountPercent: 23,
          rating: 4.8,
          reviewCount: 14209,
          badgeType: RocketBadgeType.rocketFresh,
          deliveryNotice: '내일(토) 오전 7시 전 도착 보장',
          imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80',
          cashReward: 1840,
        ),
        CoupangProductItem(
          id: 'p3',
          title: '소니 WH-1000XM5 프리미엄 무선 노이즈캔슬링 헤드폰 블랙',
          price: 419000,
          originalPrice: 479000,
          discountPercent: 13,
          rating: 4.9,
          reviewCount: 9284,
          badgeType: RocketBadgeType.rocket,
          deliveryNotice: '내일(토) 도착 보장',
          imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80',
          cashReward: 8380,
        ),
        CoupangProductItem(
          id: 'p4',
          title: '네스프레소 버츄오 팝 캡슐커피머신 + 웰컴 캡슐 세트',
          price: 139000,
          originalPrice: 199000,
          discountPercent: 30,
          rating: 4.7,
          reviewCount: 5120,
          badgeType: RocketBadgeType.rocket,
          deliveryNotice: '내일(토) 새벽 7시 전 도착 보장',
          imageUrl: 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=500&q=80',
          cashReward: 2780,
        ),
        CoupangProductItem(
          id: 'p5',
          title: '스탠리 퀜처 H2.0 플로우스테이트 텀블러 887ml 크림화이트',
          price: 49000,
          originalPrice: 59000,
          discountPercent: 17,
          rating: 4.8,
          reviewCount: 18450,
          badgeType: RocketBadgeType.rocket,
          deliveryNotice: '내일(토) 도착 보장',
          imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&q=80',
          cashReward: 980,
        ),
        CoupangProductItem(
          id: 'p6',
          title: '[로켓직구] 다이슨 V12 감지 슬림 컴플리트 무선청소기 니켈/골드',
          price: 689000,
          originalPrice: 990000,
          discountPercent: 30,
          rating: 4.9,
          reviewCount: 3190,
          badgeType: RocketBadgeType.rocketGlobal,
          deliveryNotice: '3일 후 무료 항공 직배송',
          imageUrl: 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=500&q=80',
          cashReward: 13780,
        ),
      ],
    );
  }
}
