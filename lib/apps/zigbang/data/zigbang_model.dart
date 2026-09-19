/// 직방 (Zigbang) 부동산 매물 데이터 모델
class ZigbangProperty {
  final String id;
  final String title;
  final String roomType; // 원룸, 투룸, 오피스텔, 아파트, 빌라
  final String priceType; // 월세, 전세, 매매
  final String deposit; // e.g. "1,000만", "5,000만", "18억 5,000만"
  final String rent; // e.g. "70만", "0", ""
  final String maintenanceCost; // e.g. "12만"
  final String area; // e.g. "28.5㎡ (8.6평)"
  final String floor; // e.g. "8층 / 15층"
  final String location; // e.g. "강남역 도보 4분"
  final List<String> tags; // ["직방인증", "VR홈투어", "신축첫입주", "주차가능", "풀옵션"]
  final String agentName; // "강남탑공인중개사사무소"
  final String description;
  final String imageType; // officetel, apartment, terrace, luxury
  final bool isLiked;

  const ZigbangProperty({
    required this.id,
    required this.title,
    required this.roomType,
    required this.priceType,
    required this.deposit,
    this.rent = '',
    required this.maintenanceCost,
    required this.area,
    required this.floor,
    required this.location,
    required this.tags,
    required this.agentName,
    required this.description,
    required this.imageType,
    this.isLiked = false,
  });

  String get priceDisplay {
    if (priceType == '월세') {
      return '$priceType $deposit/$rent';
    } else {
      return '$priceType $deposit';
    }
  }

  ZigbangProperty copyWith({
    String? id,
    String? title,
    String? roomType,
    String? priceType,
    String? deposit,
    String? rent,
    String? maintenanceCost,
    String? area,
    String? floor,
    String? location,
    List<String>? tags,
    String? agentName,
    String? description,
    String? imageType,
    bool? isLiked,
  }) {
    return ZigbangProperty(
      id: id ?? this.id,
      title: title ?? this.title,
      roomType: roomType ?? this.roomType,
      priceType: priceType ?? this.priceType,
      deposit: deposit ?? this.deposit,
      rent: rent ?? this.rent,
      maintenanceCost: maintenanceCost ?? this.maintenanceCost,
      area: area ?? this.area,
      floor: floor ?? this.floor,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      agentName: agentName ?? this.agentName,
      description: description ?? this.description,
      imageType: imageType ?? this.imageType,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

/// 직방 전체 상태 설정 모델
class ZigbangConfig {
  final String selectedCategory; // 전체, 원·투룸, 아파트, 오피스텔, 빌라
  final String searchQuery;
  final List<ZigbangProperty> properties;
  final String selectedPropertyId;

  const ZigbangConfig({
    required this.selectedCategory,
    required this.searchQuery,
    required this.properties,
    required this.selectedPropertyId,
  });

  ZigbangProperty get selectedProperty {
    return properties.firstWhere(
      (p) => p.id == selectedPropertyId,
      orElse: () => properties.first,
    );
  }

  ZigbangConfig copyWith({
    String? selectedCategory,
    String? searchQuery,
    List<ZigbangProperty>? properties,
    String? selectedPropertyId,
  }) {
    return ZigbangConfig(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      properties: properties ?? this.properties,
      selectedPropertyId: selectedPropertyId ?? this.selectedPropertyId,
    );
  }

  /// 4가지 고품질 부동산 프리셋 매물
  static ZigbangConfig defaultPreset() {
    final list = [
      const ZigbangProperty(
        id: 'prop_gangnam',
        title: '강남역 초역세권 하이엔드 오피스텔 (루카831)',
        roomType: '오피스텔',
        priceType: '월세',
        deposit: '5,000만',
        rent: '280만',
        maintenanceCost: '18만',
        area: '43.2㎡ (13.1평)',
        floor: '18층 / 29층',
        location: '신분당선·2호선 강남역 도보 3분',
        tags: ['직방인증', 'VR홈투어', '신축첫입주', '시티뷰', '피트니스/루프탑풀'],
        agentName: '강남더퍼스트공인중개사사무소 (대표: 김태현)',
        description: '테헤란로와 강남대로를 품은 특급 파노라마 조망. 인피니티 루프탑 풀, 컨시어지 서비스 제공. 전 호실 최고급 빌트인 가전 및 이탈리아산 마감재 풀세팅.',
        imageType: 'luxury',
        isLiked: true,
      ),
      const ZigbangProperty(
        id: 'prop_mapo',
        title: '마포래미안푸르지오 로얄동 한강조망 34평',
        roomType: '아파트',
        priceType: '매매',
        deposit: '18억 5,000만',
        rent: '',
        maintenanceCost: '22만',
        area: '84.9㎡ (34.2평)',
        floor: '21층 / 25층',
        location: '애오개역 도보 4분 / 마포역 10분',
        tags: ['직방인증', '한강조망', '올수리', '역세권', '대단지브랜드'],
        agentName: '마포황금공인중개사 (대표: 박지수)',
        description: '마포 대장주 래미안푸르지오 남향 로얄층 매물. 최근 올리모델링 완료되어 즉시 입주 가능. 아현초·중·고 도보 통학 및 광화문/여의도 출퇴근 15분 컷.',
        imageType: 'apartment',
        isLiked: false,
      ),
      const ZigbangProperty(
        id: 'prop_hongdae',
        title: '홍대 연남동 감성 복층 테라스 원룸 (반려동물 가능)',
        roomType: '원·투룸',
        priceType: '월세',
        deposit: '1,000만',
        rent: '75만',
        maintenanceCost: '8만',
        area: '26.4㎡ (8.0평)',
        floor: '4층 / 5층',
        location: '홍대입구역 3번 출구 도보 5분',
        tags: ['직방인증', '테라스', '복층', '반려동물', '풀옵션'],
        agentName: '연남센트럴부동산 (대표: 최원호)',
        description: '경의선 숲길 바로 앞 감성 테라스 하우스. 높은 층고의 쾌적한 복층 구조, 채광 좋은 단독 야외 테라스 완비. 세탁기, 냉장고, 에어컨, 인덕션 풀옵션.',
        imageType: 'terrace',
        isLiked: true,
      ),
      const ZigbangProperty(
        id: 'prop_pangyo',
        title: '판교 테크노밸리 도보권 신축 숲세권 투룸',
        roomType: '빌라',
        priceType: '전세',
        deposit: '4억 8,000만',
        rent: '',
        maintenanceCost: '10만',
        area: '52.8㎡ (16.0평)',
        floor: '3층 / 4층',
        location: '판교역 버스 8분 / 테크노밸리 도보',
        tags: ['직방인증', '전세대출가능', '주차100%', '엘리베이터', '조용한숲세권'],
        agentName: '판교밸리부동산 (대표: 이민재)',
        description: 'IT 직장인에게 안성맞춤인 조용하고 쾌적한 신축 빌라. HUG/HF 전세대출 90% 협조 가능. 넓은 거실과 분리형 방 2개, 지하 자주식 주차장 완비.',
        imageType: 'officetel',
        isLiked: false,
      ),
    ];

    return ZigbangConfig(
      selectedCategory: '전체',
      searchQuery: '강남역, 마포, 홍대, 판교',
      properties: list,
      selectedPropertyId: 'prop_gangnam',
    );
  }
}
