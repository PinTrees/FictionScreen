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

  static YoutubeConfig defaultPreset() {
    return YoutubeConfig(
      title: '충격 실화) 아무도 몰랐던 그날의 비밀...',
      channelName: '미스터리 이슈 저장소',
      subscriberCount: '28.5만명',
      viewCount: '120만회',
      uploadTime: '3일 전',
      likeCount: '4.8만',
      isLiked: false,
      videoId: 'jfKfPfyJRdk',
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
}
