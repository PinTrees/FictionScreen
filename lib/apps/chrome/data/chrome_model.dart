import 'package:flutter/material.dart';

class ChromeTab {
  final String id;
  final String title;
  final String url;
  final String? faviconUrl;
  final bool isLoading;
  final bool isPinned;
  final List<String> history;
  final int historyIndex;

  const ChromeTab({
    required this.id,
    required this.title,
    required this.url,
    this.faviconUrl,
    this.isLoading = false,
    this.isPinned = false,
    this.history = const [],
    this.historyIndex = 0,
  });

  bool get canGoBack => historyIndex > 0;
  bool get canGoForward => historyIndex < history.length - 1;
  bool get isNewTabPage => url.isEmpty || url == 'chrome://newtab' || url == 'about:blank';

  ChromeTab copyWith({
    String? id,
    String? title,
    String? url,
    String? faviconUrl,
    bool? isLoading,
    bool? isPinned,
    List<String>? history,
    int? historyIndex,
  }) {
    return ChromeTab(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      isLoading: isLoading ?? this.isLoading,
      isPinned: isPinned ?? this.isPinned,
      history: history ?? this.history,
      historyIndex: historyIndex ?? this.historyIndex,
    );
  }
}

class ChromeBookmark {
  final String id;
  final String title;
  final String url;
  final IconData? icon;
  final Color? color;
  final bool requiresSimulation; // true if site blocks iframes (like Naver/Daum/GitHub)

  const ChromeBookmark({
    required this.id,
    required this.title,
    required this.url,
    this.icon,
    this.color,
    this.requiresSimulation = false,
  });
}

class ChromeConfig {
  final List<ChromeTab> tabs;
  final int activeTabIndex;
  final List<ChromeBookmark> bookmarks;
  final bool isIncognito;
  final bool showBookmarksBar;
  final bool openInNewTabByDefault;

  const ChromeConfig({
    required this.tabs,
    this.activeTabIndex = 0,
    required this.bookmarks,
    this.isIncognito = false,
    this.showBookmarksBar = true,
    this.openInNewTabByDefault = true,
  });

  ChromeTab get activeTab {
    if (tabs.isEmpty) {
      return const ChromeTab(id: 'tab-new', title: '새 탭', url: 'chrome://newtab');
    }
    final index = (activeTabIndex >= 0 && activeTabIndex < tabs.length) ? activeTabIndex : 0;
    return tabs[index];
  }

  ChromeConfig copyWith({
    List<ChromeTab>? tabs,
    int? activeTabIndex,
    List<ChromeBookmark>? bookmarks,
    bool? isIncognito,
    bool? showBookmarksBar,
    bool? openInNewTabByDefault,
  }) {
    return ChromeConfig(
      tabs: tabs ?? this.tabs,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      bookmarks: bookmarks ?? this.bookmarks,
      isIncognito: isIncognito ?? this.isIncognito,
      showBookmarksBar: showBookmarksBar ?? this.showBookmarksBar,
      openInNewTabByDefault: openInNewTabByDefault ?? this.openInNewTabByDefault,
    );
  }

  static ChromeConfig defaultPreset() {
    final defaultTabs = [
      const ChromeTab(
        id: 'tab-1',
        title: 'Google',
        url: 'https://www.google.com/search?igu=1',
        history: ['https://www.google.com/search?igu=1'],
        historyIndex: 0,
      ),
      const ChromeTab(
        id: 'tab-2',
        title: '위키백과 - 우리 모두의 백과사전',
        url: 'https://ko.wikipedia.org',
        history: ['https://ko.wikipedia.org'],
        historyIndex: 0,
      ),
      const ChromeTab(
        id: 'tab-3',
        title: 'FictionScreen - 픽션스크린',
        url: 'https://fiction-screen.web.app',
        history: ['https://fiction-screen.web.app'],
        historyIndex: 0,
      ),
    ];

    final defaultBookmarks = [
      const ChromeBookmark(
        id: 'bm-google',
        title: 'Google',
        url: 'https://www.google.com/search?igu=1',
        icon: Icons.search,
        color: Color(0xFF4285F4),
      ),
      const ChromeBookmark(
        id: 'bm-naver',
        title: '네이버',
        url: 'https://www.naver.com',
        icon: Icons.public,
        color: Color(0xFF03C75A),
        requiresSimulation: true,
      ),
      const ChromeBookmark(
        id: 'bm-daum',
        title: '다음 (Daum)',
        url: 'https://www.daum.net',
        icon: Icons.language,
        color: Color(0xFFFFCC00),
        requiresSimulation: true,
      ),
      const ChromeBookmark(
        id: 'bm-wiki',
        title: '위키백과',
        url: 'https://ko.wikipedia.org',
        icon: Icons.menu_book,
        color: Color(0xFFE0E0E0),
      ),
      const ChromeBookmark(
        id: 'bm-youtube',
        title: 'YouTube',
        url: 'https://www.youtube.com',
        icon: Icons.play_circle_fill,
        color: Color(0xFFFF0000),
        requiresSimulation: true,
      ),
      const ChromeBookmark(
        id: 'bm-namu',
        title: '나무위키',
        url: 'https://namu.wiki',
        icon: Icons.forest,
        color: Color(0xFF008275),
        requiresSimulation: true,
      ),
      const ChromeBookmark(
        id: 'bm-github',
        title: 'GitHub',
        url: 'https://github.com',
        icon: Icons.code,
        color: Color(0xFF24292E),
        requiresSimulation: true,
      ),
      const ChromeBookmark(
        id: 'bm-fiction',
        title: 'FictionScreen',
        url: 'https://fiction-screen.web.app',
        icon: Icons.devices,
        color: Color(0xFF68217A),
      ),
    ];

    return ChromeConfig(
      tabs: defaultTabs,
      activeTabIndex: 0,
      bookmarks: defaultBookmarks,
      isIncognito: false,
      showBookmarksBar: true,
      openInNewTabByDefault: true,
    );
  }
}
