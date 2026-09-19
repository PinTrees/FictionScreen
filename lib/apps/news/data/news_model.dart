/// 뉴스 방송국 테마
enum NewsChannelTheme {
  ytn,   // 보도전문채널 풍 (네이비 & 레드 & 화이트)
  kbs,   // 공영방송 뉴스9 풍 (딥 네이비 & 골드 옐로우)
  sbs,   // 지상파 8뉴스 풍 (코발트 블루 & 비비드 오렌지)
  jtbc,  // 뉴스룸 풍 (미드나잇 다크 퍼플 & 네온 민트)
  alert, // 국가 재난/비상 특보 풍 (경보 레드 & 블랙 스트라이프)
}

/// 뉴스 화면 분할 레이아웃
enum NewsLayoutMode {
  studioAnchor, // 스튜디오 앵커 단독 데스크
  fieldSplit,   // 스튜디오 앵커 + 현장 연결 2분할 PIP
  fullScene,    // 사건 현장 단독 전체화면
}

/// 속보 뱃지 타입
enum NewsBadgeType {
  breaking,  // [속보]
  exclusive, // [단독]
  special,   // [특보]
  live,      // [생중계]
  urgent,    // [긴급]
}

/// 사건 현장 화면 타입
enum FieldSceneType {
  prosecution, // 🏛️ 검찰청/법원 앞 포토라인
  police,      // 🚔 사건 현장 / 폴리스라인 경광등
  briefing,    // 🎤 정부/기업 긴급 기자회견장
  disaster,    // 🌋 도심 싱크홀 / 붕괴 재난 현장
  nightCity,   // 🌃 심야 도심 비 내리는 현장
}

/// 뉴스 방송 시뮬레이션 설정 모델
class NewsConfig {
  final NewsChannelTheme channelTheme;
  final String channelName;
  final NewsLayoutMode layoutMode;
  final NewsBadgeType badgeType;
  final String mainHeadline;
  final String subHeadline;
  final List<String> tickerItems;
  final String reporterName;
  final String reportLocation;
  final FieldSceneType fieldSceneType;
  final bool showSignLanguage;
  final String timeString;
  final String hotlineText;
  final String stockTicker;
  final bool crtScanlines;

  const NewsConfig({
    required this.channelTheme,
    required this.channelName,
    required this.layoutMode,
    required this.badgeType,
    required this.mainHeadline,
    required this.subHeadline,
    required this.tickerItems,
    required this.reporterName,
    required this.reportLocation,
    required this.fieldSceneType,
    required this.showSignLanguage,
    required this.timeString,
    required this.hotlineText,
    required this.stockTicker,
    required this.crtScanlines,
  });

  NewsConfig copyWith({
    NewsChannelTheme? channelTheme,
    String? channelName,
    NewsLayoutMode? layoutMode,
    NewsBadgeType? badgeType,
    String? mainHeadline,
    String? subHeadline,
    List<String>? tickerItems,
    String? reporterName,
    String? reportLocation,
    FieldSceneType? fieldSceneType,
    bool? showSignLanguage,
    String? timeString,
    String? hotlineText,
    String? stockTicker,
    bool? crtScanlines,
  }) {
    return NewsConfig(
      channelTheme: channelTheme ?? this.channelTheme,
      channelName: channelName ?? this.channelName,
      layoutMode: layoutMode ?? this.layoutMode,
      badgeType: badgeType ?? this.badgeType,
      mainHeadline: mainHeadline ?? this.mainHeadline,
      subHeadline: subHeadline ?? this.subHeadline,
      tickerItems: tickerItems ?? this.tickerItems,
      reporterName: reporterName ?? this.reporterName,
      reportLocation: reportLocation ?? this.reportLocation,
      fieldSceneType: fieldSceneType ?? this.fieldSceneType,
      showSignLanguage: showSignLanguage ?? this.showSignLanguage,
      timeString: timeString ?? this.timeString,
      hotlineText: hotlineText ?? this.hotlineText,
      stockTicker: stockTicker ?? this.stockTicker,
      crtScanlines: crtScanlines ?? this.crtScanlines,
    );
  }

  static NewsConfig defaultPreset() {
    return const NewsConfig(
      channelTheme: NewsChannelTheme.ytn,
      channelName: 'FSN 24 뉴스특보',
      layoutMode: NewsLayoutMode.fieldSplit,
      badgeType: NewsBadgeType.breaking,
      mainHeadline: '[단독] ○○그룹 일가 비자금 수천억 해외 은닉 정황 포착',
      subHeadline: '검찰 특수부 전격 압수수색 돌입... 총수 일가 핵심 임원 일괄 출국금지 조치',
      tickerItems: [
        '[속보] 코스피 장중 85포인트 급락... 서킷브레이커 1단계 발동',
        '[제보] 02-1234-5678 / 카카오톡 @FSN뉴스 / 실시간 영상 제보 접수 중',
        '[기상] 전국 대부분 지역 호우경보 발효... 시간당 50mm 강한 비 주의',
        '[외환] 원·달러 환율 1,392.50원 기록 (▲ 12.30원)',
      ],
      reporterName: '이서연 기자',
      reportLocation: '서울중앙지방검찰청 앞',
      fieldSceneType: FieldSceneType.prosecution,
      showSignLanguage: true,
      timeString: '오후 08:42 LIVE',
      hotlineText: '제보 02-1234-5678',
      stockTicker: 'KOSPI 2,482.10 ▼ 85.30 | USD/KRW 1,392.50 ▲ 12.30',
      crtScanlines: false,
    );
  }
}
