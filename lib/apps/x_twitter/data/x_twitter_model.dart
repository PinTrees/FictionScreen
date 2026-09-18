class XTwitterConfig {
  String displayName;
  String username;
  bool isVerified;
  String tweetText;
  String postTime;
  String views;
  String retweets;
  String quotes;
  String likes;
  String bookmarks;
  bool isDark;

  XTwitterConfig({
    this.displayName = 'Elon Musk',
    this.username = 'elonmusk',
    this.isVerified = true,
    this.tweetText = 'Next I’m buying Coca-Cola to put the cocaine back in',
    this.postTime = '오전 9:56 · 2026년 9월 18일',
    this.views = '8,420만',
    this.retweets = '142만',
    this.quotes = '18.4만',
    this.likes = '482만',
    this.bookmarks = '32만',
    this.isDark = true,
  });

  static XTwitterConfig defaultPreset() {
    return XTwitterConfig();
  }
}
