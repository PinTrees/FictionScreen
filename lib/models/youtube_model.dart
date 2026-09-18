class YoutubeComment {
  String id;
  String author;
  String timeAgo;
  String text;
  String likes;
  bool isHearted;
  bool isPinned;

  YoutubeComment({
    required this.id,
    required this.author,
    required this.timeAgo,
    required this.text,
    this.likes = '1.2천',
    this.isHearted = false,
    this.isPinned = false,
  });
}

class YoutubeConfig {
  String title;
  String channelName;
  String subscriberCount;
  String viewCount;
  String uploadTime;
  String likeCount;
  bool isSubscribed;
  List<YoutubeComment> comments;

  YoutubeConfig({
    this.title = '충격 실화) 아무도 몰랐던 그날의 비밀...',
    this.channelName = '미스터리 이슈 저장소',
    this.subscriberCount = '28.5만명',
    this.viewCount = '120만회',
    this.uploadTime = '3일 전',
    this.likeCount = '4.8만',
    this.isSubscribed = true,
    required this.comments,
  });

  static YoutubeConfig defaultPreset() {
    return YoutubeConfig(
      title: '충격 실화) 아무도 몰랐던 그날의 비밀...',
      channelName: '미스터리 이슈 저장소',
      subscriberCount: '28.5만명',
      viewCount: '120만회',
      uploadTime: '3일 전',
      likeCount: '4.8만',
      comments: [
        YoutubeComment(
          id: '1',
          author: '지나가는행인A',
          timeAgo: '1일 전',
          text: '진짜 이거 보고 소름 돋아서 잠을 못 자겠네 ㄷㄷ',
          likes: '3.4천',
          isHearted: true,
          isPinned: true,
        ),
        YoutubeComment(
          id: '2',
          author: '알고리즘의노예',
          timeAgo: '18시간 전',
          text: '편집 미쳤다 다음 편 언제 올라와요?',
          likes: '892',
        ),
      ],
    );
  }
}
