class PinterestConfig {
  String pinTitle;
  String creatorName;
  String followerCount;
  String description;
  String savedCount;
  String boardName;

  PinterestConfig({
    this.pinTitle = 'Minimalist Modern Interior Inspiration',
    this.creatorName = 'DesignArchive Studio',
    this.followerCount = '1.8만명',
    this.description = '모던하고 차분한 무드의 거실 아키텍처 가구 레이아웃 컬렉션입니다.',
    this.savedCount = '2.4천',
    this.boardName = '인테리어 디자인 필독',
  });

  static PinterestConfig defaultPreset() {
    return PinterestConfig();
  }
}
