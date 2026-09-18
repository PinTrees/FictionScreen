import 'package:flutter/material.dart';

/// 인스타그램 스토리 모델
class InstagramStoryItem {
  final String id;
  final String username;
  final String avatarLetter;
  final Color avatarBg;
  final String? imageAsset;
  final bool hasUnseenStory;
  final String storyTime;
  final String storyText;

  InstagramStoryItem({
    required this.id,
    required this.username,
    required this.avatarLetter,
    required this.avatarBg,
    this.imageAsset,
    this.hasUnseenStory = true,
    this.storyTime = '2시간 전',
    this.storyText = '오늘의 노을 스팟 대공개 🌅',
  });
}

/// 인스타그램 댓글 모델
class InstagramCommentItem {
  final String id;
  final String username;
  final String text;
  final String timeAgo;
  int likes;
  bool isLiked;

  InstagramCommentItem({
    required this.id,
    required this.username,
    required this.text,
    required this.timeAgo,
    this.likes = 0,
    this.isLiked = false,
  });
}

/// 인스타그램 DM 메시지 모델
class InstagramDmMessage {
  final String sender;
  final String text;
  final String time;
  final bool isMe;

  InstagramDmMessage({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
}

/// 인스타그램 DM 채팅방 모델
class InstagramDmThread {
  final String id;
  final String username;
  final String avatarLetter;
  final Color avatarBg;
  final bool isOnline;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final List<InstagramDmMessage> messages;

  InstagramDmThread({
    required this.id,
    required this.username,
    required this.avatarLetter,
    required this.avatarBg,
    this.isOnline = true,
    required this.lastMessage,
    required this.timeAgo,
    this.unreadCount = 0,
    required this.messages,
  });
}

/// 인스타그램 피드 포스트 모델
class InstagramFeedPost {
  final String id;
  String username;
  String location;
  final String userAvatarLetter;
  final Color userAvatarBg;
  final String? imageAsset;
  final List<Color> gradientColors;
  String likesText;
  int likesCount;
  String caption;
  String timeAgo;
  int commentCount;
  bool isLiked;
  bool isSaved;
  final List<InstagramCommentItem> comments;

  InstagramFeedPost({
    required this.id,
    required this.username,
    required this.location,
    required this.userAvatarLetter,
    required this.userAvatarBg,
    this.imageAsset,
    this.gradientColors = const [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
    required this.likesText,
    required this.likesCount,
    required this.caption,
    required this.timeAgo,
    required this.commentCount,
    this.isLiked = false,
    this.isSaved = false,
    required this.comments,
  });
}

/// 인스타그램 전역 설정 모델 (기존 호환성 100% 유지)
class InstagramConfig {
  String username;
  String location;
  String likes;
  String caption;
  String timeAgo;
  int commentCount;
  bool isLiked;
  bool isSaved;

  // 프로필 통계
  String postCount;
  String followersCount;
  String followingCount;
  String bioName;
  String bioCategory;
  String bioDescription;
  String bioLink;

  // 데이터 목록
  List<InstagramStoryItem> stories;
  List<InstagramFeedPost> posts;
  List<InstagramDmThread> dmThreads;

  InstagramConfig({
    this.username = 'sunset_traveler',
    this.location = 'Jeju Island, South Korea',
    this.likes = '1,429',
    this.caption = '오늘 하루도 끝없는 바다와 함께 힐링 완료 🌊✨ #제주도 #여행스타그램 #노을맛집',
    this.timeAgo = '4시간 전',
    this.commentCount = 38,
    this.isLiked = true,
    this.isSaved = false,
    this.postCount = '128',
    this.followersCount = '14.8만',
    this.followingCount = '420',
    this.bioName = '노을 여행자 🌅',
    this.bioCategory = '디지털 크리에이터',
    this.bioDescription = '카메라 하나 메고 전 세계의 노을을 찾아 떠납니다 ✈️\n영상 제작 문의는 DM 주세요 💌',
    this.bioLink = 'fiction-screen.web.app',
    List<InstagramStoryItem>? stories,
    List<InstagramFeedPost>? posts,
    List<InstagramDmThread>? dmThreads,
  })  : stories = stories ?? _defaultStories(),
        posts = posts ?? _defaultPosts(),
        dmThreads = dmThreads ?? _defaultDmThreads();

  void syncPrimaryPost() {
    if (posts.isNotEmpty) {
      posts[0].username = username;
      posts[0].location = location;
      posts[0].likesText = likes;
      posts[0].caption = caption;
      posts[0].timeAgo = timeAgo;
    }
  }

  static List<InstagramStoryItem> _defaultStories() {
    return [
      InstagramStoryItem(
        id: 's1',
        username: 'travel_lover',
        avatarLetter: 'T',
        avatarBg: const Color(0xFFEC4899),
        storyText: '제주도 푸른 바다 도착! 날씨 최고 🏝️',
        imageAsset: 'assets/images/macos_golden_gate.webp',
      ),
      InstagramStoryItem(
        id: 's2',
        username: 'daily_foodie',
        avatarLetter: 'D',
        avatarBg: const Color(0xFFF59E0B),
        storyText: '오늘 점심 맛집 탐방 성공 🍜',
      ),
      InstagramStoryItem(
        id: 's3',
        username: 'design_studio',
        avatarLetter: 'S',
        avatarBg: const Color(0xFF3B82F6),
        storyText: '신규 UI 디자인 시스템 완성 💻',
      ),
      InstagramStoryItem(
        id: 's4',
        username: 'seoul_vibes',
        avatarLetter: 'V',
        avatarBg: const Color(0xFF10B981),
        storyText: '성수동 카페거리 야경 🌙',
      ),
      InstagramStoryItem(
        id: 's5',
        username: 'coffee_holic',
        avatarLetter: 'C',
        avatarBg: const Color(0xFF8B5CF6),
        storyText: '오늘의 핸드드립 커피 ☕',
      ),
    ];
  }

  static List<InstagramFeedPost> _defaultPosts() {
    return [
      InstagramFeedPost(
        id: 'p1',
        username: 'sunset_traveler',
        location: 'Jeju Island, South Korea',
        userAvatarLetter: 'S',
        userAvatarBg: const Color(0xFFF97316),
        imageAsset: 'assets/images/macos_golden_gate.webp',
        likesText: '1,429',
        likesCount: 1429,
        caption: '오늘 하루도 끝없는 바다와 함께 힐링 완료 🌊✨ #제주도 #여행스타그램 #노을맛집',
        timeAgo: '4시간 전',
        commentCount: 38,
        isLiked: true,
        isSaved: false,
        comments: [
          InstagramCommentItem(id: 'c1', username: 'photo_lover', text: '와 노을 색감 진짜 미쳤네요 ㅠㅠ 필터 뭐 쓰셨나요?', timeAgo: '3시간 전', likes: 12),
          InstagramCommentItem(id: 'c2', username: 'jeju_island_tour', text: '제주 서쪽 해변인가요? 너무 멋집니다 👍', timeAgo: '2시간 전', likes: 5),
          InstagramCommentItem(id: 'c3', username: 'daily_travel', text: '다음 주에 가는데 장소 공유 가능할까요?!', timeAgo: '1시간 전', likes: 2),
        ],
      ),
      InstagramFeedPost(
        id: 'p2',
        username: 'apple_creator',
        location: 'Cupertino, California',
        userAvatarLetter: 'A',
        userAvatarBg: const Color(0xFF6366F1),
        imageAsset: 'assets/images/win11_bloom.webp',
        likesText: '3,842',
        likesCount: 3842,
        caption: '새로운 디바이스와 함께하는 데스크 셋업 💻✨ 집중력 200% 상승! #데스크테리어 #작업공간 #개발자',
        timeAgo: '8시간 전',
        commentCount: 52,
        isLiked: false,
        isSaved: true,
        comments: [
          InstagramCommentItem(id: 'c4', username: 'code_runner', text: '키보드랑 모니터 정보 알 수 있을까요?', timeAgo: '6시간 전', likes: 8),
          InstagramCommentItem(id: 'c5', username: 'minimal_life', text: '선 정리가 예술이네요.. 배합 완벽', timeAgo: '5시간 전', likes: 3),
        ],
      ),
    ];
  }

  static List<InstagramDmThread> _defaultDmThreads() {
    return [
      InstagramDmThread(
        id: 'dm1',
        username: 'minji_film',
        avatarLetter: '민지',
        avatarBg: const Color(0xFFEC4899),
        isOnline: true,
        lastMessage: '작가님 혹시 다음 주 협업 영상 일정 가능하신가요?',
        timeAgo: '10분 전',
        unreadCount: 2,
        messages: [
          InstagramDmMessage(sender: 'minji_film', text: '안녕하세요 작가님! 피드 노을 사진 너무 잘 보고 있어요.', time: '오후 4:10', isMe: false),
          InstagramDmMessage(sender: 'sunset_traveler', text: '안녕하세요 민지님! 좋게 봐주셔서 감사합니다 ㅎㅎ', time: '오후 4:15', isMe: true),
          InstagramDmMessage(sender: 'minji_film', text: '작가님 혹시 다음 주 협업 영상 일정 가능하신가요?', time: '오후 4:20', isMe: false),
        ],
      ),
      InstagramDmThread(
        id: 'dm2',
        username: 'seoul_camera_club',
        avatarLetter: '출사',
        avatarBg: const Color(0xFF3B82F6),
        isOnline: false,
        lastMessage: '이번 주말 한강 출사 모임 공지 확인 부탁드립니다!',
        timeAgo: '1시간 전',
        unreadCount: 0,
        messages: [
          InstagramDmMessage(sender: 'seoul_camera_club', text: '이번 주말 한강 출사 모임 공지 확인 부탁드립니다!', time: '오후 3:00', isMe: false),
        ],
      ),
      InstagramDmThread(
        id: 'dm3',
        username: 'jeju_cafe_official',
        avatarLetter: '제주',
        avatarBg: const Color(0xFFF59E0B),
        isOnline: true,
        lastMessage: '사진 예쁘게 올려주셔서 음료 쿠폰 보내드렸어요 :)',
        timeAgo: '어제',
        unreadCount: 0,
        messages: [
          InstagramDmMessage(sender: 'jeju_cafe_official', text: '사진 예쁘게 올려주셔서 음료 쿠폰 보내드렸어요 :)', time: '어제', isMe: false),
        ],
      ),
    ];
  }

  static InstagramConfig defaultPreset() {
    return InstagramConfig();
  }
}
