class BlindPollOption {
  final String id;
  final String text;
  final int votes;
  final bool isVoted;

  const BlindPollOption({
    required this.id,
    required this.text,
    required this.votes,
    this.isVoted = false,
  });

  BlindPollOption copyWith({
    String? id,
    String? text,
    int? votes,
    bool? isVoted,
  }) {
    return BlindPollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      votes: votes ?? this.votes,
      isVoted: isVoted ?? this.isVoted,
    );
  }
}

class BlindPoll {
  final String title;
  final List<BlindPollOption> options;
  final bool hasVoted;
  final String? selectedOptionId;

  const BlindPoll({
    required this.title,
    required this.options,
    this.hasVoted = false,
    this.selectedOptionId,
  });

  int get totalVotes => options.fold(0, (sum, opt) => sum + opt.votes);

  BlindPoll copyWith({
    String? title,
    List<BlindPollOption>? options,
    bool? hasVoted,
    String? selectedOptionId,
  }) {
    return BlindPoll(
      title: title ?? this.title,
      options: options ?? this.options,
      hasVoted: hasVoted ?? this.hasVoted,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
    );
  }
}

class BlindCommentItem {
  final String id;
  final String authorCompany;
  final String authorMaskedId;
  final String content;
  final String timeAgo;
  final int likeCount;
  final bool isAuthor;
  final bool isLiked;
  final List<BlindCommentItem> replies;

  const BlindCommentItem({
    required this.id,
    required this.authorCompany,
    required this.authorMaskedId,
    required this.content,
    required this.timeAgo,
    this.likeCount = 0,
    this.isAuthor = false,
    this.isLiked = false,
    this.replies = const [],
  });

  BlindCommentItem copyWith({
    String? id,
    String? authorCompany,
    String? authorMaskedId,
    String? content,
    String? timeAgo,
    int? likeCount,
    bool? isAuthor,
    bool? isLiked,
    List<BlindCommentItem>? replies,
  }) {
    return BlindCommentItem(
      id: id ?? this.id,
      authorCompany: authorCompany ?? this.authorCompany,
      authorMaskedId: authorMaskedId ?? this.authorMaskedId,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
      likeCount: likeCount ?? this.likeCount,
      isAuthor: isAuthor ?? this.isAuthor,
      isLiked: isLiked ?? this.isLiked,
      replies: replies ?? this.replies,
    );
  }
}

class BlindPostItem {
  final String id;
  final String channel;
  final String authorCompany;
  final String authorMaskedId;
  final String title;
  final String content;
  final String createdAt;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final BlindPoll? poll;
  final List<BlindCommentItem> comments;
  final bool isBookmarked;
  final bool isLiked;

  const BlindPostItem({
    required this.id,
    required this.channel,
    required this.authorCompany,
    required this.authorMaskedId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.viewCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    this.poll,
    this.comments = const [],
    this.isBookmarked = false,
    this.isLiked = false,
  });

  BlindPostItem copyWith({
    String? id,
    String? channel,
    String? authorCompany,
    String? authorMaskedId,
    String? title,
    String? content,
    String? createdAt,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    BlindPoll? poll,
    List<BlindCommentItem>? comments,
    bool? isBookmarked,
    bool? isLiked,
  }) {
    return BlindPostItem(
      id: id ?? this.id,
      channel: channel ?? this.channel,
      authorCompany: authorCompany ?? this.authorCompany,
      authorMaskedId: authorMaskedId ?? this.authorMaskedId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      poll: poll ?? this.poll,
      comments: comments ?? this.comments,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class BlindConfig {
  final String selectedChannel;
  final BlindPostItem currentPost;
  final List<BlindPostItem> feedPosts;

  const BlindConfig({
    required this.selectedChannel,
    required this.currentPost,
    required this.feedPosts,
  });

  BlindConfig copyWith({
    String? selectedChannel,
    BlindPostItem? currentPost,
    List<BlindPostItem>? feedPosts,
  }) {
    return BlindConfig(
      selectedChannel: selectedChannel ?? this.selectedChannel,
      currentPost: currentPost ?? this.currentPost,
      feedPosts: feedPosts ?? this.feedPosts,
    );
  }

  static BlindConfig defaultPreset() {
    final defaultPost = BlindPostItem(
      id: 'post-1',
      channel: '이직·커리어',
      authorCompany: '삼성전자',
      authorMaskedId: 's***',
      title: '30대 중반 이직 고민 중인데 형들 의견 좀 (삼전 vs 네카라)',
      content: '''현재 삼전 DS 사업부 7년차 책임입니다.
최근 네카라 중 한 곳에서 시니어 포지션으로 오퍼를 받았습니다.

1. 삼전 현직 유지:
- 원천징수 기준 영끌 1.1~1.2억 수준 (PS/PI 포함)
- 수원/기흥 출퇴근 셔틀 편함
- 안정적이지만 조직 문화가 조금 경직됨

2. 네카라 이직:
- 기본급 20% 인상 + RSU 3년 분할 약 4,000만원
- 판교 출퇴근 (재택 주 2~3일 혼합)
- 커리어 전환 및 유연한 개발 문화

가정이 있는 입장에서 판교 테크기업으로 넘어가는 게 맞을지, 삼전에서 버티는 게 나을지 투표와 현실적인 조언 부탁드립니다.''',
      createdAt: '15분 전',
      viewCount: 4280,
      likeCount: 184,
      commentCount: 52,
      poll: const BlindPoll(
        title: '어디로 가는 게 나을까요?',
        options: [
          BlindPollOption(id: 'opt-1', text: '삼전 DS 유지 (안정성+성과급)', votes: 842),
          BlindPollOption(id: 'opt-2', text: '네카라 이직 (재택+커리어 확장)', votes: 1215),
          BlindPollOption(id: 'opt-3', text: '결과만 보기', votes: 198),
        ],
      ),
      comments: const [
        BlindCommentItem(
          id: 'c-1',
          authorCompany: '네이버',
          authorMaskedId: 'n***',
          content: '재택 주 2~3일이 삶의 질 진짜 압도적으로 바꿉니다. 판교 오시면 삼전으로 다시 안 돌아가실걸요.',
          timeAgo: '12분 전',
          likeCount: 42,
          replies: [
            BlindCommentItem(
              id: 'c-1-1',
              authorCompany: '삼성전자',
              authorMaskedId: 's***',
              content: '셔틀에서 버리는 왕복 2시간 생각하면 혹하긴 하네요 ㅠㅠ',
              timeAgo: '10분 전',
              isAuthor: true,
              likeCount: 15,
            ),
          ],
        ),
        BlindCommentItem(
          id: 'c-2',
          authorCompany: '현대자동차',
          authorMaskedId: 'h***',
          content: '가정 있고 애기 어리면 무조건 재택 낀 판교 추천합니다. 육아에 재택 있고 없고는 천지차이입니다.',
          timeAgo: '8분 전',
          likeCount: 29,
        ),
        BlindCommentItem(
          id: 'c-3',
          authorCompany: '카카오',
          authorMaskedId: 'k***',
          content: '기본급 20% 업이면 베이스 올리고 다음 이직 때 더 높이 부를 수 있어요. 가는 게 이득.',
          timeAgo: '5분 전',
          likeCount: 18,
        ),
        BlindCommentItem(
          id: 'c-4',
          authorCompany: 'SK하이닉스',
          authorMaskedId: 's***',
          content: '반도체 사이클 업턴 올 때 삼전 PS 터지면 또 배아플 수도 있음. 신중히 고민하길.',
          timeAgo: '2분 전',
          likeCount: 9,
        ),
      ],
    );

    final feedPosts = [
      defaultPost,
      const BlindPostItem(
        id: 'post-2',
        channel: '블라블라',
        authorCompany: '토스',
        authorMaskedId: 't***',
        title: '신입사원이 첫날 9시 5분에 출근하더니 팀장한테 한 말',
        content: '팀장님이 "00씨 첫날인데 좀 늦었네?" 하니까 신입이 맑은 눈으로 "출근시간이 9시까지가 아니라 9시부터 업무 준비하는 거 아닌가요?" 하고 커피 타러 감 ㅋㅋㅋ',
        createdAt: '42분 전',
        viewCount: 12450,
        likeCount: 890,
        commentCount: 243,
      ),
      const BlindPostItem(
        id: 'post-3',
        channel: '직장인 토픽',
        authorCompany: '쿠팡',
        authorMaskedId: 'c***',
        title: '솔직히 대기업 10년 다녀도 아파트 한 채 사기 힘든 현실',
        content: '세후 월급 열심히 모아도 서울 집값 상승 속도를 도저히 못 따라가네요. 동기들도 다들 주식이나 코인 안 하면 답 없다고 한숨만 쉽니다.',
        createdAt: '1시간 전',
        viewCount: 8320,
        likeCount: 432,
        commentCount: 167,
      ),
      const BlindPostItem(
        id: 'post-4',
        channel: '주식·투자',
        authorCompany: '미래에셋증권',
        authorMaskedId: 'm***',
        title: '오늘 코스피/나스닥 흐름 보니까 조만간 큰 변곡점 올 듯',
        content: '금리 인하 사이클 진입하면서 빅테크 실적 장세로 전환되는 중입니다. 현금 비중 30% 유지하면서 분할 매수 타이밍 잡는 걸 추천합니다.',
        createdAt: '2시간 전',
        viewCount: 6540,
        likeCount: 210,
        commentCount: 88,
      ),
      const BlindPostItem(
        id: 'post-5',
        channel: '썸·연애',
        authorCompany: '대한항공',
        authorMaskedId: 'k***',
        title: '소개팅에서 상대방 연봉이나 자산 물어보는 타이밍 언제임?',
        content: '첫 만남에 물어보면 당연히 비매너인 건 아는데 보통 몇 번째 애프터 때 슬쩍 파악하시나요?',
        createdAt: '3시간 전',
        viewCount: 5120,
        likeCount: 95,
        commentCount: 114,
      ),
    ];

    return BlindConfig(
      selectedChannel: '전체',
      currentPost: defaultPost,
      feedPosts: feedPosts,
    );
  }
}
