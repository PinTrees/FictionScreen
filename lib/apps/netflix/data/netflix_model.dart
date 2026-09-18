import 'dart:ui';

/// 넷플릭스 프로필 모델
class NetflixProfile {
  final String id;
  final String name;
  final Color avatarBgColor;
  final String? avatarAsset;
  final bool isKids;

  const NetflixProfile({
    required this.id,
    required this.name,
    this.avatarBgColor = const Color(0xFFE50914),
    this.avatarAsset,
    this.isKids = false,
  });

  NetflixProfile copyWith({
    String? id,
    String? name,
    Color? avatarBgColor,
    String? avatarAsset,
    bool? isKids,
  }) {
    return NetflixProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarBgColor: avatarBgColor ?? this.avatarBgColor,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      isKids: isKids ?? this.isKids,
    );
  }
}

/// 넷플릭스 회차/에피소드 정보
class NetflixEpisode {
  final int episodeNumber;
  final String title;
  final int durationMinutes;
  final String description;
  final String thumbnailUrl;

  const NetflixEpisode({
    required this.episodeNumber,
    required this.title,
    required this.durationMinutes,
    required this.description,
    required this.thumbnailUrl,
  });

  NetflixEpisode copyWith({
    int? episodeNumber,
    String? title,
    int? durationMinutes,
    String? description,
    String? thumbnailUrl,
  }) {
    return NetflixEpisode(
      episodeNumber: episodeNumber ?? this.episodeNumber,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}

/// 넷플릭스 미디어 콘텐츠 (시리즈 / 영화)
class NetflixMediaItem {
  final String id;
  final String title;
  final String tagline;
  final String description;
  final String posterUrl;
  final String backdropUrl;
  final int matchPercentage; // e.g. 98 -> 98% 일치
  final String ageRating; // 'ALL', '12', '15', '19'
  final int releaseYear;
  final String durationOrSeasons; // e.g. '시즌 2개' or '2시간 18분'
  final List<String> qualityBadges; // ['4K Ultra HD', '공간 음향', 'HDR']
  final List<String> genres;
  final List<String> cast;
  final String director;
  final bool isOriginal;
  final bool isTop10;
  final int? top10Rank; // 1 ~ 10
  final List<NetflixEpisode> episodes;

  const NetflixMediaItem({
    required this.id,
    required this.title,
    this.tagline = '',
    required this.description,
    required this.posterUrl,
    required this.backdropUrl,
    this.matchPercentage = 98,
    this.ageRating = '19',
    this.releaseYear = 2026,
    this.durationOrSeasons = '시즌 1개',
    this.qualityBadges = const ['4K Ultra HD', '공간 음향'],
    this.genres = const ['스릴러', '드라마'],
    this.cast = const ['이정재', '이병헌', '임시완'],
    this.director = '황동혁',
    this.isOriginal = true,
    this.isTop10 = false,
    this.top10Rank,
    this.episodes = const [],
  });

  NetflixMediaItem copyWith({
    String? id,
    String? title,
    String? tagline,
    String? description,
    String? posterUrl,
    String? backdropUrl,
    int? matchPercentage,
    String? ageRating,
    int? releaseYear,
    String? durationOrSeasons,
    List<String>? qualityBadges,
    List<String>? genres,
    List<String>? cast,
    String? director,
    bool? isOriginal,
    bool? isTop10,
    int? top10Rank,
    List<NetflixEpisode>? episodes,
  }) {
    return NetflixMediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      ageRating: ageRating ?? this.ageRating,
      releaseYear: releaseYear ?? this.releaseYear,
      durationOrSeasons: durationOrSeasons ?? this.durationOrSeasons,
      qualityBadges: qualityBadges ?? this.qualityBadges,
      genres: genres ?? this.genres,
      cast: cast ?? this.cast,
      director: director ?? this.director,
      isOriginal: isOriginal ?? this.isOriginal,
      isTop10: isTop10 ?? this.isTop10,
      top10Rank: top10Rank ?? this.top10Rank,
      episodes: episodes ?? this.episodes,
    );
  }
}

/// 넷플릭스 전체 설정 모델
class NetflixConfig {
  final List<NetflixProfile> profiles;
  final String activeProfileId;
  final bool showProfileSelector;
  final NetflixMediaItem heroMedia;
  final List<NetflixMediaItem> top10Series;
  final List<NetflixMediaItem> trendingList;
  final List<NetflixMediaItem> originalsList;
  final List<NetflixMediaItem> myList;

  const NetflixConfig({
    required this.profiles,
    required this.activeProfileId,
    this.showProfileSelector = false,
    required this.heroMedia,
    required this.top10Series,
    required this.trendingList,
    required this.originalsList,
    required this.myList,
  });

  NetflixProfile get activeProfile =>
      profiles.firstWhere((p) => p.id == activeProfileId, orElse: () => profiles.first);

  NetflixConfig copyWith({
    List<NetflixProfile>? profiles,
    String? activeProfileId,
    bool? showProfileSelector,
    NetflixMediaItem? heroMedia,
    List<NetflixMediaItem>? top10Series,
    List<NetflixMediaItem>? trendingList,
    List<NetflixMediaItem>? originalsList,
    List<NetflixMediaItem>? myList,
  }) {
    return NetflixConfig(
      profiles: profiles ?? this.profiles,
      activeProfileId: activeProfileId ?? this.activeProfileId,
      showProfileSelector: showProfileSelector ?? this.showProfileSelector,
      heroMedia: heroMedia ?? this.heroMedia,
      top10Series: top10Series ?? this.top10Series,
      trendingList: trendingList ?? this.trendingList,
      originalsList: originalsList ?? this.originalsList,
      myList: myList ?? this.myList,
    );
  }

  /// 기본 완성형 프리셋
  factory NetflixConfig.defaultPreset() {
    final defaultProfiles = [
      const NetflixProfile(id: 'p1', name: '크리에이터', avatarBgColor: Color(0xFFE50914)),
      const NetflixProfile(id: 'p2', name: '영화광', avatarBgColor: Color(0xFF0071EB)),
      const NetflixProfile(id: 'p3', name: '야식러', avatarBgColor: Color(0xFF2ECC71)),
      const NetflixProfile(id: 'p4', name: '키즈', avatarBgColor: Color(0xFFF1C40F), isKids: true),
    ];

    const hero = NetflixMediaItem(
      id: 'squid_game_3',
      title: '오징어 게임: 파이널 시즌',
      tagline: '모든 게임의 끝, 마지막 선택의 순간',
      description: '456억 원의 상금이 걸린 의문의 서바이벌에 다시 참가한 기훈. 잔혹한 게임을 멈추기 위해 시스템의 핵심으로 잠입하지만, 더 거대한 어둠이 그를 기다리고 있다.',
      posterUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?w=600&q=80',
      backdropUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=1600&q=80',
      matchPercentage: 99,
      ageRating: '19',
      releaseYear: 2026,
      durationOrSeasons: '시즌 3개',
      qualityBadges: ['4K Ultra HD', '공간 음향', 'Dolby Vision'],
      genres: ['스릴러', '서스펜스', '한국 드라마'],
      cast: ['이정재', '이병헌', '위하준', '임시완', '강하늘', '박규영'],
      director: '황동혁',
      isOriginal: true,
      isTop10: true,
      top10Rank: 1,
      episodes: [
        NetflixEpisode(
          episodeNumber: 1,
          title: '1화: 다시 시작된 초대장',
          durationMinutes: 62,
          description: '기훈은 공항에서 발길을 돌려 의문의 주최측을 추적하기 시작한다. 하지만 그를 기다리고 있는 것은 상상치 못한 새로운 초대장이었다.',
          thumbnailUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?w=500&q=80',
        ),
        NetflixEpisode(
          episodeNumber: 2,
          title: '2화: 판돈과 원칙',
          durationMinutes: 58,
          description: '새로운 456명의 참가자가 낯선 경기장에 모이고, 규칙이 뒤바뀐 첫 번째 게임이 잔혹하게 펼쳐진다.',
          thumbnailUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500&q=80',
        ),
        NetflixEpisode(
          episodeNumber: 3,
          title: '3화: 가면 뒤의 진실',
          durationMinutes: 65,
          description: '프런트맨의 비밀 통로를 발견한 준호는 형의 과거가 얽힌 충격적인 문서를 마주하게 된다.',
          thumbnailUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=500&q=80',
        ),
      ],
    );

    final top10 = [
      hero,
      const NetflixMediaItem(
        id: 'cyber_seoul',
        title: '사이버 서울 2077',
        tagline: '네온 불빛 아래 감춰진 기억들',
        description: '인공지능과 인간의 경계가 무너진 미래 서울. 불법 기억 복원사 강우는 자신의 지워진 과거와 국가 기밀이 연결되어 있음을 알게 된다.',
        posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600&q=80',
        backdropUrl: 'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=1600&q=80',
        matchPercentage: 97,
        ageRating: '15',
        releaseYear: 2026,
        durationOrSeasons: '시즌 1개',
        genres: ['SF', '액션', '사이버펑크'],
        cast: ['송강호', '김태리', '박정민'],
        director: '봉준호',
        isOriginal: true,
        isTop10: true,
        top10Rank: 2,
      ),
      const NetflixMediaItem(
        id: 'glory_revenge',
        title: '더 글로리: 심연',
        tagline: '끝나지 않은 복수의 궤적',
        description: '평화가 찾아왔다고 믿었던 순간, 감옥 안에서 시작된 또 다른 복수의 체스판이 하나씩 맞춰지기 시작한다.',
        posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600&q=80',
        backdropUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1600&q=80',
        matchPercentage: 96,
        ageRating: '19',
        releaseYear: 2025,
        durationOrSeasons: '시즌 2개',
        genres: ['드라마', '복수', '서스펜스'],
        cast: ['송혜교', '이도현', '임지연'],
        director: '안길호',
        isOriginal: true,
        isTop10: true,
        top10Rank: 3,
      ),
      const NetflixMediaItem(
        id: 'demon_hunter',
        title: '경이로운 귀살대',
        tagline: '붉은 달이 뜨면 악령이 눈을 뜬다',
        description: '현대 도심 한가운데 출몰하는 악귀들을 퇴치하는 국수집 국물 연구원들의 신비로운 비밀 수사 일지.',
        posterUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600&q=80',
        backdropUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1600&q=80',
        matchPercentage: 95,
        ageRating: '15',
        releaseYear: 2026,
        durationOrSeasons: '시즌 1개',
        genres: ['판타지', '액션', '퇴마'],
        cast: ['조병규', '김세정', '유준상'],
        director: '유선동',
        isOriginal: true,
        isTop10: true,
        top10Rank: 4,
      ),
      const NetflixMediaItem(
        id: 'killer_paradox',
        title: '살인자ㅇ난감 2',
        tagline: '우연인가, 신의 심판인가',
        description: '악인을 감별하는 초자연적인 본능을 지닌 평범한 청년과, 그를 끝까지 뒤쫓는 집요한 형사의 쫓고 쫓기는 2차 심리전.',
        posterUrl: 'https://images.unsplash.com/photo-1542204165-65bf26472b9b?w=600&q=80',
        backdropUrl: 'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=1600&q=80',
        matchPercentage: 94,
        ageRating: '19',
        releaseYear: 2026,
        durationOrSeasons: '시즌 2개',
        genres: ['스릴러', '다크 코미디', '범죄'],
        cast: ['최우식', '손석구', '이희준'],
        director: '이창희',
        isOriginal: true,
        isTop10: true,
        top10Rank: 5,
      ),
    ];

    final trending = [
      const NetflixMediaItem(
        id: 'eight_show',
        title: 'The 8 Show 시즌 2',
        tagline: '시간이 쌓이면 돈이 된다',
        description: '8명의 참가자가 8개 층에 나뉘어 시간을 버티는 쇼. 상금을 둘러싼 더 잔혹한 계급 투쟁이 벌어진다.',
        posterUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&q=80',
        backdropUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=1600&q=80',
        matchPercentage: 98,
        ageRating: '19',
        releaseYear: 2025,
        durationOrSeasons: '시즌 2개',
        genres: ['블랙코미디', '스릴러'],
        cast: ['류준열', '천우희', '박정민'],
        director: '한재림',
        isOriginal: true,
      ),
      const NetflixMediaItem(
        id: 'sweet_home',
        title: '스위트홈: 리버스',
        tagline: '괴물이 되지 못한 자들의 세상',
        description: '욕망으로 뒤덮인 세상, 새로운 변종 생명체들의 충돌 속에서 인간성을 지키려는 생존자들의 사투.',
        posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600&q=80',
        backdropUrl: 'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=1600&q=80',
        matchPercentage: 93,
        ageRating: '19',
        releaseYear: 2026,
        durationOrSeasons: '시즌 4개',
        genres: ['크리처물', '호러', 'SF'],
        cast: ['송강', '이진욱', '이시영'],
        director: '이응복',
        isOriginal: true,
      ),
      const NetflixMediaItem(
        id: 'money_heist_korea',
        title: '종이의 집: 서울 리로드',
        tagline: '사상 최대의 조폐국 점령',
        description: '남북 통일 조폐국을 장악한 천재 강도단 교수와 팀원들의 숨막히는 인질 협상 작전.',
        posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600&q=80',
        backdropUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=1600&q=80',
        matchPercentage: 91,
        ageRating: '19',
        releaseYear: 2025,
        durationOrSeasons: '시즌 2개',
        genres: ['범죄', '케이퍼 무비'],
        cast: ['유지태', '김윤진', '박해수'],
        director: '김홍선',
        isOriginal: true,
      ),
      const NetflixMediaItem(
        id: 'kingdom_ashin',
        title: '킹덤: 생사초의 기원',
        tagline: '죽은 자가 살아나 피를 갈구한다',
        description: '조선 북방 국경 지대에서 발견된 생사초의 비밀과 아신의 비극적 복수극.',
        posterUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600&q=80',
        backdropUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1600&q=80',
        matchPercentage: 96,
        ageRating: '19',
        releaseYear: 2025,
        durationOrSeasons: '1시간 48분',
        genres: ['사극', '좀비', '액션'],
        cast: ['전지현', '박병은', '김시아'],
        director: '김성훈',
        isOriginal: true,
      ),
    ];

    return NetflixConfig(
      profiles: defaultProfiles,
      activeProfileId: 'p1',
      showProfileSelector: false,
      heroMedia: hero,
      top10Series: top10,
      trendingList: trending,
      originalsList: [hero, top10[1], top10[2], trending[0]],
      myList: [top10[1], trending[1], hero],
    );
  }
}
