class AppPlatformInfo {
  final String id;
  final String name;
  final String assetPath;
  final bool isConsole;

  const AppPlatformInfo({
    required this.id,
    required this.name,
    required this.assetPath,
    this.isConsole = false,
  });
}

class AppPlatformIcons {
  // 1. Hero Quick-Launch Pills (No news, No CCTV)
  static const List<AppPlatformInfo> heroQuickPills = [
    AppPlatformInfo(id: 'kakaotalk', name: '카카오톡', assetPath: 'assets/images/kakaotalk_icon.webp'),
    AppPlatformInfo(id: 'daangn', name: '당근마켓', assetPath: 'assets/images/daangn_icon.webp'),
    AppPlatformInfo(id: 'blind', name: '블라인드', assetPath: 'assets/images/blind_icon.webp'),
    AppPlatformInfo(id: 'excel', name: 'Microsoft 엑셀', assetPath: 'assets/images/excel_icon.webp'),
    AppPlatformInfo(id: 'dcinside', name: '디시인사이드', assetPath: 'assets/images/dcinside_icon.webp'),
    AppPlatformInfo(id: 'upbit', name: '업비트 코인', assetPath: 'assets/images/upbit_icon.webp'),
    AppPlatformInfo(id: 'youtube', name: '유튜브', assetPath: 'assets/images/youtube_icon.webp'),
    AppPlatformInfo(id: 'x_twitter', name: 'X (트위터)', assetPath: 'assets/images/x_twitter_icon.webp'),
    AppPlatformInfo(id: 'pinterest', name: '핀터레스트', assetPath: 'assets/images/pinterest_icon.webp'),
  ];

  // 2. Virtual Desktop OS (8 platforms)
  static const List<AppPlatformInfo> osList = [
    AppPlatformInfo(id: 'windows_11', name: 'Windows 11', assetPath: 'assets/images/win11_logo.png', isConsole: true),
    AppPlatformInfo(id: 'windows_10', name: 'Windows 10', assetPath: 'assets/images/win10_logo.png', isConsole: true),
    AppPlatformInfo(id: 'windows_7', name: 'Windows 7', assetPath: 'assets/images/win7_logo.png', isConsole: true),
    AppPlatformInfo(id: 'windows_xp', name: 'Windows XP', assetPath: 'assets/images/winxp_logo.png', isConsole: true),
    AppPlatformInfo(id: 'macos', name: 'macOS Sonoma', assetPath: 'assets/images/macos/finder.webp', isConsole: true),
    AppPlatformInfo(id: 'steamos', name: 'SteamOS (Steam Deck)', assetPath: 'assets/images/steamos_logo.png', isConsole: true),
    AppPlatformInfo(id: 'windows_bsod', name: '블루스크린 (BSOD)', assetPath: 'assets/images/win11_logo.png'),
    AppPlatformInfo(id: 'windows_update', name: '가짜 윈도우 업데이트', assetPath: 'assets/images/windows/settings.png'),
  ];

  // 3. Mobile Applications (9 platforms)
  static const List<AppPlatformInfo> appList = [
    AppPlatformInfo(id: 'kakaotalk', name: '카카오톡', assetPath: 'assets/images/kakaotalk_icon.webp'),
    AppPlatformInfo(id: 'daangn', name: '당근마켓', assetPath: 'assets/images/daangn_icon.webp'),
    AppPlatformInfo(id: 'toss', name: '토스 송금', assetPath: 'assets/images/toss_icon.png'),
    AppPlatformInfo(id: 'kakaobank', name: '카카오뱅크', assetPath: 'assets/images/kakaobank_icon.webp'),
    AppPlatformInfo(id: 'upbit', name: '업비트 코인', assetPath: 'assets/images/upbit_icon.webp'),
    AppPlatformInfo(id: 'instagram', name: '인스타그램', assetPath: 'assets/images/instagram_icon.webp'),
    AppPlatformInfo(id: 'delivery', name: '배달 플랫폼', assetPath: 'assets/images/delivery_icon.webp'),
    AppPlatformInfo(id: 'lottery', name: '동행복권 1등', assetPath: 'assets/images/lottery_icon.webp'),
    AppPlatformInfo(id: 'yanolja', name: '야놀자 여행', assetPath: 'assets/images/yanolja_icon.webp'),
  ];

  // 4. Websites & Professional Tools (20 platforms - No news, No CCTV)
  static const List<AppPlatformInfo> siteList = [
    AppPlatformInfo(id: 'blind', name: '블라인드', assetPath: 'assets/images/blind_icon.webp'),
    AppPlatformInfo(id: 'dcinside', name: '디시인사이드', assetPath: 'assets/images/dcinside_icon.webp'),
    AppPlatformInfo(id: 'youtube', name: '유튜브', assetPath: 'assets/images/youtube_icon.webp'),
    AppPlatformInfo(id: 'netflix', name: '넷플릭스', assetPath: 'assets/images/netflix_icon.webp'),
    AppPlatformInfo(id: 'excel', name: 'Microsoft Excel', assetPath: 'assets/images/excel_icon.webp'),
    AppPlatformInfo(id: 'powerpoint', name: 'PowerPoint (PPT)', assetPath: 'assets/images/powerpoint_icon.webp'),
    AppPlatformInfo(id: 'word', name: 'Word 기밀문서', assetPath: 'assets/images/word_icon.webp'),
    AppPlatformInfo(id: 'steam', name: 'Steam 게임', assetPath: 'assets/images/steam_icon.webp'),
    AppPlatformInfo(id: 'naver', name: '네이버 포털', assetPath: 'assets/images/naver_icon.webp'),
    AppPlatformInfo(id: 'coupang', name: '쿠팡 쇼핑몰', assetPath: 'assets/images/coupang_icon.webp'),
    AppPlatformInfo(id: 'davinci_resolve', name: '다빈치 리졸브', assetPath: 'assets/images/davinci_resolve_icon.webp'),
    AppPlatformInfo(id: 'photoshop', name: '포토샵 에디터', assetPath: 'assets/images/photoshop_icon.webp'),
    AppPlatformInfo(id: 'visual_studio', name: '비주얼 스튜디오', assetPath: 'assets/images/visual_studio_icon.webp'),
    AppPlatformInfo(id: 'chrome', name: '구글 크롬', assetPath: 'assets/images/windows/chrome.png'),
    AppPlatformInfo(id: 'edge', name: '마이크로소프트 엣지', assetPath: 'assets/images/windows/edge.png'),
    AppPlatformInfo(id: 'discord', name: '디스코드', assetPath: 'assets/images/discord_icon.webp'),
    AppPlatformInfo(id: 'telegram', name: '텔레그램', assetPath: 'assets/images/telegram_icon.webp'),
    AppPlatformInfo(id: 'x_twitter', name: 'X (트위터)', assetPath: 'assets/images/x_twitter_icon.webp'),
    AppPlatformInfo(id: 'pinterest', name: '핀터레스트', assetPath: 'assets/images/pinterest_icon.webp'),
    AppPlatformInfo(id: 'zigbang', name: '직방 부동산', assetPath: 'assets/images/zigbang_icon.webp'),
  ];
}
