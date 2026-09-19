/// 네이버 (Naver) 뉴스 기사 아이템
class NaverNewsItem {
  final String id;
  final String title;
  final String press; // 언론사 (조선일보, 연합뉴스, KBS 등)
  final String time;
  final String category; // 경제, IT/과학, 정치, 사회, 연예

  const NaverNewsItem({
    required this.id,
    required this.title,
    required this.press,
    required this.time,
    required this.category,
  });

  NaverNewsItem copyWith({
    String? id,
    String? title,
    String? press,
    String? time,
    String? category,
  }) {
    return NaverNewsItem(
      id: id ?? this.id,
      title: title ?? this.title,
      press: press ?? this.press,
      time: time ?? this.time,
      category: category ?? this.category,
    );
  }
}

/// 네이버 실시간 검색어 / 트렌드 토픽 아이템
class NaverTrendingItem {
  final int rank;
  final String keyword;
  final bool isNew;
  final String change; // "+2", "-1", "NEW", "-"

  const NaverTrendingItem({
    required this.rank,
    required this.keyword,
    this.isNew = false,
    this.change = "-",
  });

  NaverTrendingItem copyWith({
    int? rank,
    String? keyword,
    bool? isNew,
    String? change,
  }) {
    return NaverTrendingItem(
      rank: rank ?? this.rank,
      keyword: keyword ?? this.keyword,
      isNew: isNew ?? this.isNew,
      change: change ?? this.change,
    );
  }
}

/// 네이버 쇼핑 트렌드 상품
class NaverShoppingItem {
  final String id;
  final String title;
  final String price;
  final String mall;
  final String discount;

  const NaverShoppingItem({
    required this.id,
    required this.title,
    required this.price,
    required this.mall,
    required this.discount,
  });
}

/// 네이버 종합 포털 상태 설정 모델
class NaverConfig {
  final String searchTerm;
  final String weatherTemp;
  final String weatherStatus;
  final String fineDust;
  final String kospi;
  final String kospiChange;
  final String kosdaq;
  final String kosdaqChange;
  final String usdRate;
  final List<NaverNewsItem> newsList;
  final List<NaverTrendingItem> trendingList;
  final List<NaverShoppingItem> shoppingList;

  const NaverConfig({
    required this.searchTerm,
    required this.weatherTemp,
    required this.weatherStatus,
    required this.fineDust,
    required this.kospi,
    required this.kospiChange,
    required this.kosdaq,
    required this.kosdaqChange,
    required this.usdRate,
    required this.newsList,
    required this.trendingList,
    required this.shoppingList,
  });

  NaverConfig copyWith({
    String? searchTerm,
    String? weatherTemp,
    String? weatherStatus,
    String? fineDust,
    String? kospi,
    String? kospiChange,
    String? kosdaq,
    String? kosdaqChange,
    String? usdRate,
    List<NaverNewsItem>? newsList,
    List<NaverTrendingItem>? trendingList,
    List<NaverShoppingItem>? shoppingList,
  }) {
    return NaverConfig(
      searchTerm: searchTerm ?? this.searchTerm,
      weatherTemp: weatherTemp ?? this.weatherTemp,
      weatherStatus: weatherStatus ?? this.weatherStatus,
      fineDust: fineDust ?? this.fineDust,
      kospi: kospi ?? this.kospi,
      kospiChange: kospiChange ?? this.kospiChange,
      kosdaq: kosdaq ?? this.kosdaq,
      kosdaqChange: kosdaqChange ?? this.kosdaqChange,
      usdRate: usdRate ?? this.usdRate,
      newsList: newsList ?? this.newsList,
      trendingList: trendingList ?? this.trendingList,
      shoppingList: shoppingList ?? this.shoppingList,
    );
  }

  /// 네이버 순정 포털 기본 프리셋
  static NaverConfig defaultPreset() {
    return const NaverConfig(
      searchTerm: '코스피 3000포인트 돌파',
      weatherTemp: '24.5°',
      weatherStatus: '맑음',
      fineDust: '좋음 (18㎍/㎥)',
      kospi: '3,014.28',
      kospiChange: '+28.45 (+0.95%)',
      kosdaq: '894.60',
      kosdaqChange: '+6.12 (+0.69%)',
      usdRate: '1,328.50원',
      newsList: [
        NaverNewsItem(
          id: 'n1',
          title: '[속보] 코스피 2년 9개월 만에 3,000선 탈환... 반도체·AI 랠리 지속',
          press: '연합뉴스',
          time: '14분 전',
          category: '경제',
        ),
        NaverNewsItem(
          id: 'n2',
          title: '차세대 국산 초거대 생성형 AI 모델 공개... "한국어·코딩 최고 수준"',
          press: '전자신문',
          time: '32분 전',
          category: 'IT/과학',
        ),
        NaverNewsItem(
          id: 'n3',
          title: '기획재정부 "하반기 물가안정 기조 확고... 소비진작 금융지원 확대"',
          press: '조선일보',
          time: '1시간 전',
          category: '정치/경제',
        ),
        NaverNewsItem(
          id: 'n4',
          title: '글로벌 K-컬처 신드롬, 한국 오리지널 시리즈 에미상 4관왕 석권',
          press: '중앙일보',
          time: '2시간 전',
          category: '연예/문화',
        ),
        NaverNewsItem(
          id: 'n5',
          title: '오늘 전국 완연한 가을 날씨... 낮 최고 26도, 일교차 10도 이상 주의',
          press: 'KBS 뉴스',
          time: '3시간 전',
          category: '사회',
        ),
      ],
      trendingList: [
        NaverTrendingItem(rank: 1, keyword: '코스피 3000', isNew: false, change: '+2'),
        NaverTrendingItem(rank: 2, keyword: '피지컬 100 시즌2', isNew: true, change: 'NEW'),
        NaverTrendingItem(rank: 3, keyword: '아이폰 16 사전예약', isNew: false, change: '+1'),
        NaverTrendingItem(rank: 4, keyword: '엔비디아 주가', isNew: false, change: '-1'),
        NaverTrendingItem(rank: 5, keyword: '네이버페이 멤버십 데이', isNew: false, change: '-2'),
        NaverTrendingItem(rank: 6, keyword: '손흥민 토트넘 골', isNew: true, change: 'NEW'),
        NaverTrendingItem(rank: 7, keyword: '단풍 절정 시기', isNew: false, change: '+4'),
        NaverTrendingItem(rank: 8, keyword: '비트코인 시세', isNew: false, change: '-2'),
        NaverTrendingItem(rank: 9, keyword: '청약홈 마포 래미안', isNew: false, change: '-1'),
        NaverTrendingItem(rank: 10, keyword: '주말 날씨', isNew: false, change: '-'),
      ],
      shoppingList: [
        NaverShoppingItem(id: 's1', title: 'LG 그램 프로 16인치 AI 노트북', price: '1,890,000원', mall: 'LG전자 공식몰', discount: '15%'),
        NaverShoppingItem(id: 's2', title: '정관장 에브리타임 밸런스 30포', price: '72,000원', mall: 'KGC인삼공사', discount: '20%'),
        NaverShoppingItem(id: 's3', title: '나이키 에어포스 1 \'07 로우 화이트', price: '139,000원', mall: '나이키 공식스토어', discount: '적립 10%'),
        NaverShoppingItem(id: 's4', title: '네스프레소 버츄오 팝 캡슐 커피머신', price: '149,000원', mall: '네스프레소', discount: '25%'),
      ],
    );
  }
}
