class InstagramConfig {
  String username;
  String location;
  String likes;
  String caption;
  String timeAgo;
  int commentCount;
  bool isLiked;
  bool isSaved;

  InstagramConfig({
    this.username = 'sunset_traveler',
    this.location = 'Jeju Island, South Korea',
    this.likes = '1,429',
    this.caption = '오늘 하루도 끝없는 바다와 함께 힐링 완료 🌊✨ #제주도 #여행스타그램 #노을맛집',
    this.timeAgo = '4시간 전',
    this.commentCount = 38,
    this.isLiked = true,
    this.isSaved = false,
  });

  static InstagramConfig defaultPreset() {
    return InstagramConfig();
  }
}
