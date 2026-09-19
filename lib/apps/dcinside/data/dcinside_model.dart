/// 디시인사이드 작성자 유형
enum DcAuthorType {
  anonymous,  // 유동닉 (ㅇㅇ, IP 표시)
  fixed,      // 고정닉 (파란 갤로그 뱃지)
  subManager, // 부매니저 / 파딱 (하늘색 완장)
  manager,    // 매니저 / 주딱 (주황색 완장)
}

/// 디시인사이드 댓글 모델
class DcComment {
  final String id;
  final String authorName;
  final String ipOrBadge;
  final DcAuthorType authorType;
  final String content;
  final String createdAt;
  final bool isReply;

  const DcComment({
    required this.id,
    required this.authorName,
    required this.ipOrBadge,
    required this.authorType,
    required this.content,
    required this.createdAt,
    this.isReply = false,
  });

  DcComment copyWith({
    String? id,
    String? authorName,
    String? ipOrBadge,
    DcAuthorType? authorType,
    String? content,
    String? createdAt,
    bool? isReply,
  }) {
    return DcComment(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      ipOrBadge: ipOrBadge ?? this.ipOrBadge,
      authorType: authorType ?? this.authorType,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isReply: isReply ?? this.isReply,
    );
  }
}

/// 디시인사이드 게시글 모델
class DcPost {
  final String id;
  final String category; // [일반], [정보], [인증], [후기], [공지]
  final String title;
  final String content;
  final String authorName;
  final String ipOrBadge;
  final DcAuthorType authorType;
  final String createdAt;
  final int viewCount;
  final int recommendCount;
  final int dislikeCount;
  final List<DcComment> comments;
  final bool isConcept; // 개념글 여부

  const DcPost({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.authorName,
    required this.ipOrBadge,
    required this.authorType,
    required this.createdAt,
    required this.viewCount,
    required this.recommendCount,
    required this.dislikeCount,
    required this.comments,
    this.isConcept = false,
  });

  DcPost copyWith({
    String? id,
    String? category,
    String? title,
    String? content,
    String? authorName,
    String? ipOrBadge,
    DcAuthorType? authorType,
    String? createdAt,
    int? viewCount,
    int? recommendCount,
    int? dislikeCount,
    List<DcComment>? comments,
    bool? isConcept,
  }) {
    return DcPost(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      ipOrBadge: ipOrBadge ?? this.ipOrBadge,
      authorType: authorType ?? this.authorType,
      createdAt: createdAt ?? this.createdAt,
      viewCount: viewCount ?? this.viewCount,
      recommendCount: recommendCount ?? this.recommendCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      comments: comments ?? this.comments,
      isConcept: isConcept ?? this.isConcept,
    );
  }
}

/// 디시인사이드 갤러리 전체 설정 모델
class DcinsideConfig {
  final String galleryName;
  final String galleryCategory; // 마이너 갤러리, 미니 갤러리, 정식 갤러리
  final String activeTab; // 전체글, 개념글, 공지
  final String selectedPostId;
  final List<DcPost> posts;

  const DcinsideConfig({
    required this.galleryName,
    required this.galleryCategory,
    required this.activeTab,
    required this.selectedPostId,
    required this.posts,
  });

  DcinsideConfig copyWith({
    String? galleryName,
    String? galleryCategory,
    String? activeTab,
    String? selectedPostId,
    List<DcPost>? posts,
  }) {
    return DcinsideConfig(
      galleryName: galleryName ?? this.galleryName,
      galleryCategory: galleryCategory ?? this.galleryCategory,
      activeTab: activeTab ?? this.activeTab,
      selectedPostId: selectedPostId ?? this.selectedPostId,
      posts: posts ?? this.posts,
    );
  }

  static DcinsideConfig defaultPreset() {
    return const DcinsideConfig(
      galleryName: '각성자 갤러리',
      galleryCategory: '마이너 갤러리',
      activeTab: '전체글',
      selectedPostId: 'post_1',
      posts: [
        DcPost(
          id: 'post_1',
          category: '[일반]',
          title: '야 방금 F급 짐꾼 S급 각성한 거 실화냐? ㄷㄷㄷ',
          content: '강남 던전 브레이크 현장에서 짐꾼 한 명이 맨손으로 보스 몬스터 찢어버림 ㅋㅋㅋㅋ\n\n'
              '옆에 있던 길드 마스터 표정 굳은 거 봤냐?\n'
              '검은 오라 치솟으면서 대검 소환하던데 진짜 각성자 협회 난리 나겠네 ㄷㄷ\n\n'
              '이 사람 과거 기록 아는 사람 있냐? 전생에 영웅이었나 봄 ㄹㅇ',
          authorName: 'ㅇㅇ',
          ipOrBadge: '(223.38)',
          authorType: DcAuthorType.anonymous,
          createdAt: '2026.09.19 16:42:15',
          viewCount: 4821,
          recommendCount: 1420,
          dislikeCount: 18,
          isConcept: true,
          comments: [
            DcComment(
              id: 'c1',
              authorName: 'ㅇㅇ',
              ipOrBadge: '(118.235)',
              authorType: DcAuthorType.anonymous,
              content: 'ㄹㅇㅋㅋ 나 현장 30m 뒤에 있었는데 충격파로 가로등 다 뽑힘',
              createdAt: '16:43:02',
            ),
            DcComment(
              id: 'c2',
              authorName: '던전헌터_공식',
              ipOrBadge: '갤로그',
              authorType: DcAuthorType.fixed,
              content: '저 사람 F급 협회 등록증 가지고 있던데 재측정 들어가면 바로 S급 확정임',
              createdAt: '16:43:28',
            ),
            DcComment(
              id: 'c3',
              authorName: 'ㅇㅇ',
              ipOrBadge: '(175.223)',
              authorType: DcAuthorType.anonymous,
              content: '성지순례 왔습니다. 로또 1등 되게 해주세요',
              createdAt: '16:44:11',
            ),
            DcComment(
              id: 'c4',
              authorName: '주딱_완장',
              ipOrBadge: '매니저',
              authorType: DcAuthorType.manager,
              content: '각성자 신상 털이나 악플 달면 무통보 30일 차단함',
              createdAt: '16:45:00',
            ),
          ],
        ),
        DcPost(
          id: 'post_2',
          category: '[정보]',
          title: '속보) 각성자 협회 긴급 브리핑 예정 (링크)',
          content: '오늘 발생한 강남 7구역 던전 브레이크 건으로 17시 협회장 직접 브리핑한답니다.',
          authorName: '정보통',
          ipOrBadge: '부매니저',
          authorType: DcAuthorType.subManager,
          createdAt: '2026.09.19 16:38:00',
          viewCount: 2310,
          recommendCount: 450,
          dislikeCount: 5,
          isConcept: true,
          comments: [],
        ),
        DcPost(
          id: 'post_3',
          category: '[인증]',
          title: '방금 S급 각성 현장 직찍 사진 푼다 ㅋㅋㅋ',
          content: '빛기둥 솟구칠 때 핸드폰으로 바로 찍음. 화질은 좀 깨지는데 대검 윤곽 확실히 보임',
          authorName: 'ㅇㅇ',
          ipOrBadge: '(121.160)',
          authorType: DcAuthorType.anonymous,
          createdAt: '2026.09.19 16:35:12',
          viewCount: 3890,
          recommendCount: 890,
          dislikeCount: 12,
          isConcept: true,
          comments: [],
        ),
        DcPost(
          id: 'post_4',
          category: '[잡담]',
          title: '솔직히 저 사람 헌터 길드 어디 들어갈 거 같냐?',
          content: '해성 길드에서 백지수표 들고 찾아갈 듯 ㅋㅋㅋㅋ 아님 독고다이 1인 길드 창설?',
          authorName: '프로관전러',
          ipOrBadge: '갤로그',
          authorType: DcAuthorType.fixed,
          createdAt: '2026.09.19 16:30:45',
          viewCount: 1450,
          recommendCount: 120,
          dislikeCount: 8,
          isConcept: false,
          comments: [],
        ),
      ],
    );
  }
}
