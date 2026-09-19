import 'package:flutter/material.dart';

/// 유튜브 댓글 모델
class YoutubeComment {
  String id;
  String author;
  String avatarUrl;
  String timeAgo;
  String text;
  int likes;
  bool isLiked;
  bool isHearted;
  bool isPinned;

  YoutubeComment({
    String? id,
    required this.author,
    this.avatarUrl = '',
    required this.timeAgo,
    required this.text,
    dynamic likes = 1200,
    this.isLiked = false,
    this.isHearted = false,
    this.isPinned = false,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        likes = likes is int ? likes : (int.tryParse(likes.toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0);
}

/// 유튜브 추천/피드 동영상 아이템 모델
class YoutubeVideoItem {
  final String id;
  final String videoId; // 실제 유튜브 IFrame 임베드용 ID
  final String title;
  final String channelName;
  final String channelAvatarLetter;
  final Color channelAvatarBg;
  final String? thumbnailAsset;
  final String? networkThumbnail;
  final List<Color> gradientColors;
  final String viewCount;
  final String uploadTime;
  final String duration;
  final String subscriberCount;
  final String likeCount;
  final String description;

  YoutubeVideoItem({
    required this.id,
    required this.videoId,
    required this.title,
    required this.channelName,
    this.channelAvatarLetter = 'Y',
    this.channelAvatarBg = const Color(0xFFFF0000),
    this.thumbnailAsset,
    this.networkThumbnail,
    this.gradientColors = const [Color(0xFF1E293B), Color(0xFF0F172A)],
    required this.viewCount,
    required this.uploadTime,
    required this.duration,
    this.subscriberCount = '28.5만명',
    this.likeCount = '4.8만',
    this.description = '이 영상은 FictionScreen에서 시뮬레이션 및 실제 재생 가능한 유튜브 콘텐츠입니다.',
  });

  String get channelTitle => channelName;
  String get publishedTime => uploadTime;
  String get channelAvatarUrl => '';
  String get thumbnailUrl {
    if (networkThumbnail != null && networkThumbnail!.isNotEmpty) {
      return networkThumbnail!;
    }
    if (videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    }
    return thumbnailAsset ?? '';
  }
}

/// 유튜브 구독 채널 모델
class YoutubeChannelItem {
  final String id;
  final String name;
  final String avatarLetter;
  final Color avatarBg;
  final bool hasUnseen;
  final bool isLive;
  final String customAvatarUrl;

  YoutubeChannelItem({
    required this.id,
    required this.name,
    required this.avatarLetter,
    required this.avatarBg,
    this.hasUnseen = true,
    this.isLive = false,
    this.customAvatarUrl = '',
  });

  bool get hasNew => hasUnseen;
  String get avatarUrl => customAvatarUrl;
}

/// 유튜브 전역 설정 모델 (기존 호환성 100% 유지)
class YoutubeConfig {
  String title;
  String channelName;
  String subscriberCount;
  String viewCount;
  String uploadTime;
  String likeCount;
  bool isSubscribed;
  bool isLiked;
  String videoId; // 실제 유튜브 재생용 ID (예: 'jfKfPfyJRdk', 'dQw4w9WgXcQ')
  String description;
  String customThumbnailUrl;
  String customAvatarUrl;
  String currentTime;
  String totalTime;
  bool? isDesktopMode; // null이면 화면 너비에 따라 자동 감지, true/false면 고정
  List<YoutubeComment> comments;
  List<YoutubeVideoItem> recommendedVideos;
  List<YoutubeChannelItem> subscribedChannels;

  YoutubeConfig({
    this.title = '충격 실화) 아무도 몰랐던 그날의 비밀...',
    this.channelName = '미스터리 이슈 저장소',
    this.subscriberCount = '28.5만명',
    this.viewCount = '120만회',
    this.uploadTime = '3일 전',
    this.likeCount = '4.8만',
    this.isSubscribed = true,
    this.isLiked = false,
    this.videoId = 'jfKfPfyJRdk', // Lofi Girl 24/7 스트림 기본값
    this.description = '오늘 영상에서는 많은 분들이 제보해주신 미스터리한 실화 사건의 전말을 파헤쳐 봅니다.\n\n'
        '📌 타임라인\n'
        '00:00 오프닝 및 사건 개요\n'
        '02:15 결정적인 단서의 발견\n'
        '07:40 충격적인 결말\n\n'
        '구독과 좋아요, 알림 설정은 영상 제작에 큰 힘이 됩니다! #미스터리 #실화 #이슈',
    this.customThumbnailUrl = '',
    this.customAvatarUrl = '',
    this.currentTime = '04:12',
    this.totalTime = '14:28',
    this.isDesktopMode,
    required this.comments,
    List<YoutubeVideoItem>? recommendedVideos,
    List<YoutubeChannelItem>? subscribedChannels,
  })  : recommendedVideos = recommendedVideos ?? _defaultRecommendedVideos(),
        subscribedChannels = subscribedChannels ?? _defaultSubscribedChannels();

  String get videoTitle => title;
  String get channelAvatarUrl => customAvatarUrl;
  String get thumbnailUrl {
    if (customThumbnailUrl.isNotEmpty) {
      return customThumbnailUrl;
    }
    if (videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    }
    return '';
  }

  YoutubeConfig copyWith({
    String? title,
    String? channelName,
    String? subscriberCount,
    String? viewCount,
    String? uploadTime,
    String? likeCount,
    bool? isSubscribed,
    bool? isLiked,
    String? videoId,
    String? description,
    String? customThumbnailUrl,
    String? customAvatarUrl,
    String? channelAvatarUrl,
    String? currentTime,
    String? totalTime,
    String? thumbnailUrl,
    bool? isDesktopMode,
    List<YoutubeComment>? comments,
    List<YoutubeVideoItem>? recommendedVideos,
    List<YoutubeChannelItem>? subscribedChannels,
  }) {
    return YoutubeConfig(
      title: title ?? this.title,
      channelName: channelName ?? this.channelName,
      subscriberCount: subscriberCount ?? this.subscriberCount,
      viewCount: viewCount ?? this.viewCount,
      uploadTime: uploadTime ?? this.uploadTime,
      likeCount: likeCount ?? this.likeCount,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      isLiked: isLiked ?? this.isLiked,
      videoId: videoId ?? this.videoId,
      description: description ?? this.description,
      customThumbnailUrl: thumbnailUrl ?? customThumbnailUrl ?? this.customThumbnailUrl,
      customAvatarUrl: channelAvatarUrl ?? customAvatarUrl ?? this.customAvatarUrl,
      currentTime: currentTime ?? this.currentTime,
      totalTime: totalTime ?? this.totalTime,
      isDesktopMode: isDesktopMode ?? this.isDesktopMode,
      comments: comments ?? this.comments,
      recommendedVideos: recommendedVideos ?? this.recommendedVideos,
      subscribedChannels: subscribedChannels ?? this.subscribedChannels,
    );
  }

  static List<YoutubeVideoItem> _defaultRecommendedVideos() {
    return [
      YoutubeVideoItem(
        id: 'v1',
        videoId: '5qap5aO4i9A', // Lofi Hip Hop
        title: '하루를 차분하게 정리하는 로파이 비트 플레이리스트 ☕🎶',
        channelName: 'Chill Vibes Music',
        channelAvatarLetter: 'C',
        channelAvatarBg: const Color(0xFF6366F1),
        thumbnailAsset: 'assets/images/macos_golden_gate.webp',
        viewCount: '58만회',
        uploadTime: '1주 전',
        duration: '1:24:10',
        subscriberCount: '112만명',
        likeCount: '3.9만',
      ),
      YoutubeVideoItem(
        id: 'v2',
        videoId: 'kJQP7kiw5Fk', // Despacito
        title: '신형 맥북 M4 Max 언박싱 & 개발자 실사용 솔직 리뷰! 💻🔥',
        channelName: 'Tech Explorer 테크탐험',
        channelAvatarLetter: 'T',
        channelAvatarBg: const Color(0xFF10B981),
        thumbnailAsset: 'assets/images/win11_bloom.webp',
        viewCount: '34만회',
        uploadTime: '2일 전',
        duration: '14:22',
        subscriberCount: '45.2만명',
        likeCount: '1.8만',
      ),
      YoutubeVideoItem(
        id: 'v3',
        videoId: 'fJ9rUzIMcZQ', // Queen
        title: '제주도 3박 4일 완벽 힐링 코스 VLOG 🌴 (현지인 노을 맛집 총정리)',
        channelName: '데일리 트래블',
        channelAvatarLetter: 'D',
        channelAvatarBg: const Color(0xFFF59E0B),
        thumbnailAsset: 'assets/images/win7_harmony.webp',
        viewCount: '18만회',
        uploadTime: '5일 전',
        duration: '18:05',
        subscriberCount: '8.4만명',
        likeCount: '9.2천',
      ),
      YoutubeVideoItem(
        id: 'v4',
        videoId: 'L_LUpnjgPso', // Cyberpunk vibes
        title: '선 정리 끝판왕! 데스크 셋업 룸투어 (Cyberpunk & Minimal) 🌃✨',
        channelName: '미니멀 데스크 라이프',
        channelAvatarLetter: 'M',
        channelAvatarBg: const Color(0xFF8B5CF6),
        thumbnailAsset: 'assets/images/win10_hero.webp',
        viewCount: '76만회',
        uploadTime: '2주 전',
        duration: '11:48',
        subscriberCount: '32.1만명',
        likeCount: '2.5만',
      ),
    ];
  }

  static List<YoutubeChannelItem> _defaultSubscribedChannels() {
    return [
      YoutubeChannelItem(id: 'ch1', name: '미스터리 이슈', avatarLetter: 'M', avatarBg: const Color(0xFFFF0000), isLive: true),
      YoutubeChannelItem(id: 'ch2', name: 'Chill Vibes', avatarLetter: 'C', avatarBg: const Color(0xFF6366F1)),
      YoutubeChannelItem(id: 'ch3', name: '테크탐험', avatarLetter: 'T', avatarBg: const Color(0xFF10B981)),
      YoutubeChannelItem(id: 'ch4', name: '데일리 트래블', avatarLetter: 'D', avatarBg: const Color(0xFFF59E0B)),
      YoutubeChannelItem(id: 'ch5', name: '코딩하는 디자이너', avatarLetter: 'K', avatarBg: const Color(0xFFEC4899)),
    ];
  }

  static Map<String, YoutubeConfig> getGenrePresets() {
    return {
      'hunter': hunterPreset(),
      'mystery': mysteryPreset(),
      'coin': coinPreset(),
      'idol': idolPreset(),
      'streamer': streamerPreset(),
    };
  }

  static YoutubeConfig defaultPreset() => mysteryPreset();

  static YoutubeConfig mysteryPreset() {
    return YoutubeConfig(
      title: '충격 실화) 아무도 몰랐던 그날의 비밀... 풀스토리 독점 공개',
      channelName: '미스터리 이슈 저장소',
      subscriberCount: '28.5만명',
      viewCount: '120만회',
      uploadTime: '3일 전',
      likeCount: '4.8만',
      isLiked: false,
      videoId: 'jfKfPfyJRdk',
      description: '오늘 영상에서는 많은 분들이 제보해주신 미스터리한 실화 사건의 전말을 파헤쳐 봅니다.\n\n'
          '📌 타임라인\n'
          '00:00 오프닝 및 사건 개요\n'
          '02:15 결정적인 단서의 발견\n'
          '07:40 충격적인 결말\n\n'
          '구독과 좋아요, 알림 설정은 영상 제작에 큰 힘이 됩니다! #미스터리 #실화 #이슈',
      comments: [
        YoutubeComment(
          id: '1',
          author: '지나가는행인A',
          timeAgo: '1일 전',
          text: '진짜 이거 보고 소름 돋아서 잠을 못 자겠네 ㄷㄷ 12:45 부분 연출 소름입니다',
          likes: 3400,
          isHearted: true,
          isPinned: true,
        ),
        YoutubeComment(
          id: '2',
          author: '알고리즘의노예',
          timeAgo: '18시간 전',
          text: '편집 미쳤다 진짜.. 다음 편 언제 올라오나요 현기증 납니다',
          likes: 892,
        ),
        YoutubeComment(
          id: '3',
          author: '퇴근후맥주한캔',
          timeAgo: '8시간 전',
          text: '퇴근하고 치킨 뜯으면서 보는데 밥도둑이 따로 없네요 ㅋㅋㅋ',
          likes: 421,
        ),
      ],
    );
  }

  static YoutubeConfig hunterPreset() {
    return YoutubeConfig(
      title: '[충격 실황] F급 짐꾼에서 S급 각성? 던전 브레이크 생존자의 충격 증언 풀버전 ㄷㄷ',
      channelName: '헌터스 타임즈 공식 (Hunter\'s Times)',
      subscriberCount: '185만명',
      viewCount: '342만회',
      uploadTime: '12시간 전',
      likeCount: '14.2만',
      isLiked: false,
      videoId: 'L_LUpnjgPso',
      description: '강남역 11번 출구 7등급 게이트 붕괴 현장에서 벌어진 기적의 실화!\n\n'
          '📌 핵심 포인트 요약\n'
          '01:20 생존자 인터뷰: "짐꾼 학생이 붉은 번개를 내뿜더니..."\n'
          '04:30 헌터관리국 협회장 긴급 브리핑\n'
          '08:15 마력 측정치 스카우터 오버플로우 순간\n\n'
          '#헌터 #각성 #레이드 #웹소설 #판타지',
      comments: [
        YoutubeComment(
          id: 'h1',
          author: '헌터스타임즈_공식',
          timeAgo: '12시간 전',
          text: '📌 당시 던전 내부 미공개 블라인드 영상 추가 입수했습니다. 고정 댓글 링크 확인해주세요.',
          likes: 8900,
          isHearted: true,
          isPinned: true,
        ),
        YoutubeComment(
          id: 'h2',
          author: '던전공략전문가',
          timeAgo: '10시간 전',
          text: '야 저 짐꾼이 메고 있던 낡은 배낭에서 보검 꺼낸 거 실화냐? 진짜 웹소설 주인공이네 ㄷㄷ',
          likes: 4520,
        ),
        YoutubeComment(
          id: 'h3',
          author: 'A급길드스카우터',
          timeAgo: '7시간 전',
          text: '이미 주요 5대 길드 총수들 영입하려고 강남 세브란스 병원 앞에 대기 타고 있답니다 ㅋㅋㅋ',
          likes: 2310,
        ),
      ],
    );
  }

  static YoutubeConfig coinPreset() {
    return YoutubeConfig(
      title: '[생방송 하이라이트] 비트코인 -30% 대폭락... 전재산 20억 풀숏 마진콜 당한 트레이더 오열 ㅠㅠ',
      channelName: '코인하는 불개미 (Crypto Ant)',
      subscriberCount: '41.2만명',
      viewCount: '168만회',
      uploadTime: '6시간 전',
      likeCount: '6.4만',
      isLiked: false,
      videoId: '5qap5aO4i9A',
      description: '절대로 레버리지 선물 거래는 하지 마십시오...\n'
          '모든 자산을 잃고 방송을 켠 한 트레이더의 뼈아픈 고백과 경고의 메시지.\n\n'
          '#비트코인 #선물거래 #청산 #마진콜 #한강수온 #주식',
      comments: [
        YoutubeComment(
          id: 'c1',
          author: '비트성인',
          timeAgo: '5시간 전',
          text: '진짜 레전드 방송이었다... 모니터 샷건 칠 때 현실 멘붕 온 게 손끝까지 느껴지더라',
          likes: 3120,
          isPinned: true,
        ),
        YoutubeComment(
          id: 'c2',
          author: '국밥부장관',
          timeAgo: '4시간 전',
          text: '형님 일단 한강 가지 마시고 따뜻한 순대국밥 한 그릇 먼저 드세요... 인생 아직 안 끝났습니다 힘내세요',
          likes: 1840,
        ),
        YoutubeComment(
          id: 'c3',
          author: '리스크관리맨',
          timeAgo: '2시간 전',
          text: '선물 100배율은 투자가 아니라 그냥 도박입니다... 제발 초보분들 따라하지 마세요',
          likes: 920,
        ),
      ],
    );
  }

  static YoutubeConfig idolPreset() {
    return YoutubeConfig(
      title: '[4K 입덕직캠] 신인 걸그룹 \'LUX\' 센터 하린 - \'Starlight\' 엠카운트다운 데뷔 무대 (FanCam)',
      channelName: 'Mnet K-POP Official',
      subscriberCount: '2,050만명',
      viewCount: '482만회',
      uploadTime: '2일 전',
      likeCount: '32만',
      isLiked: true,
      videoId: 'kJQP7kiw5Fk',
      description: '[MPD직캠] 럭스(LUX) 하린 - Starlight (HARIN FanCam) | @MCOUNTDOWN\n\n'
          '#LUX #하린 #HARIN #Starlight #엠카운트다운 #직캠 #4K #KPOP',
      comments: [
        YoutubeComment(
          id: 'i1',
          author: 'KPOP_Global_Stan',
          timeAgo: '2일 전',
          text: '엔딩 포즈 때 눈빛 마주치고 심장 멎는 줄 알았음... 5세대 비주얼 센터 원탑 확정이다 ✨',
          likes: 12500,
          isHearted: true,
          isPinned: true,
        ),
        YoutubeComment(
          id: 'i2',
          author: '보컬트레이너K',
          timeAgo: '1일 전',
          text: '격한 댄스 브레이크 라이브 하면서 호흡 흔들림 1도 없는 거 실화냐? 연습량 진짜 어마어마했네',
          likes: 7420,
        ),
        YoutubeComment(
          id: 'i3',
          author: 'Lux_Official_Fan',
          timeAgo: '15시간 전',
          text: '이 영상 유튜브 알고리즘 타고 해외 반응 터졌네 ㅋㅋㅋ 음방 1위 가자!!',
          likes: 4180,
        ),
      ],
    );
  }

  static YoutubeConfig streamerPreset() {
    return YoutubeConfig(
      title: '[합방 레전드] 역대급 술먹방 사건 터졌습니다 ㅋㅋㅋㅋㅋ 매니저 뛰쳐나온 결정적 순간',
      channelName: '인방 레전드 모음집',
      subscriberCount: '68.9만명',
      viewCount: '145만회',
      uploadTime: '18시간 전',
      likeCount: '5.1만',
      isLiked: false,
      videoId: 'fJ9rUzIMcZQ',
      description: '어제자 트위치/치지직 합방 방송 하이라이트 클립 모음!\n'
          '도네이션 미션 수행하다가 벌어진 대참사 ㅋㅋㅋㅋ\n\n'
          '#인방 #스트리머 #합방 #하이라이트 #클립 #웃긴영상',
      comments: [
        YoutubeComment(
          id: 's1',
          author: '클립장인',
          timeAgo: '17시간 전',
          text: 'ㅋㅋㅋㅋㅋ 표정 굳어가는 거 진짜 영구박제감이다 10번 연속으로 돌려보는 중 ㅋㅋㅋ',
          likes: 5120,
          isPinned: true,
        ),
        YoutubeComment(
          id: 's2',
          author: '매니저의눈물',
          timeAgo: '14시간 전',
          text: '매니저 뒤에서 문 벌컥 열고 난입할 때 육성으로 뿜었네 ㅋㅋㅋㅋㅋ',
          likes: 3840,
        ),
        YoutubeComment(
          id: 's3',
          author: '야간알바생',
          timeAgo: '9시간 전',
          text: '이건 이번주 인방 핫클립 1등 무조건 확정이다 ㅋㅋㅋㅋ',
          likes: 1950,
        ),
      ],
    );
  }
}
