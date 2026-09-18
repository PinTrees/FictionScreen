import 'package:flutter/material.dart';
import '../../data/chrome_model.dart';
import '../../widgets/chrome_bookmarks_bar.dart';
import '../../widgets/chrome_nav_toolbar.dart';
import '../../widgets/chrome_tab_bar.dart';
import '../../widgets/chrome_web_content.dart';

class ChromeDesktopWorkspace extends StatelessWidget {
  final ChromeConfig config;
  final ValueChanged<ChromeConfig> onConfigChanged;
  final VoidCallback onOpenEditDialog;

  const ChromeDesktopWorkspace({
    super.key,
    required this.config,
    required this.onConfigChanged,
    required this.onOpenEditDialog,
  });

  void _selectTab(int index) {
    if (index >= 0 && index < config.tabs.length) {
      onConfigChanged(config.copyWith(activeTabIndex: index));
    }
  }

  void _closeTab(int index) {
    final updatedTabs = List<ChromeTab>.from(config.tabs);
    if (updatedTabs.length <= 1) {
      // Last tab closed -> reset to a fresh new tab
      updatedTabs[0] = const ChromeTab(id: 'tab-new', title: '새 탭', url: 'chrome://newtab');
      onConfigChanged(config.copyWith(tabs: updatedTabs, activeTabIndex: 0));
      return;
    }

    updatedTabs.removeAt(index);
    int newIndex = config.activeTabIndex;
    if (newIndex >= updatedTabs.length) {
      newIndex = updatedTabs.length - 1;
    } else if (newIndex > index) {
      newIndex--;
    }

    onConfigChanged(config.copyWith(tabs: updatedTabs, activeTabIndex: newIndex));
  }

  void _newTab([String url = 'chrome://newtab', String title = '새 탭']) {
    final newId = 'tab-${DateTime.now().millisecondsSinceEpoch}';
    final newTab = ChromeTab(
      id: newId,
      title: title,
      url: url,
      history: [url],
      historyIndex: 0,
    );
    final updatedTabs = List<ChromeTab>.from(config.tabs)..add(newTab);
    onConfigChanged(config.copyWith(
      tabs: updatedTabs,
      activeTabIndex: updatedTabs.length - 1,
    ));
  }

  void _navigateActiveTab(String url) {
    final currentTab = config.activeTab;
    final updatedHistory = List<String>.from(currentTab.history);

    // If navigated from middle of history, discard forward history
    if (currentTab.historyIndex < updatedHistory.length - 1) {
      updatedHistory.removeRange(currentTab.historyIndex + 1, updatedHistory.length);
    }
    updatedHistory.add(url);

    String derivedTitle = url;
    if (url.contains('google.com')) {
      derivedTitle = 'Google 검색';
    } else if (url.contains('naver.com')) {
      derivedTitle = 'NAVER';
    } else if (url.contains('daum.net')) {
      derivedTitle = 'Daum';
    } else if (url.contains('youtube.com')) {
      derivedTitle = 'YouTube';
    } else if (url.contains('wikipedia.org')) {
      derivedTitle = '위키백과';
    } else if (url.contains('namu.wiki')) {
      derivedTitle = '나무위키';
    } else if (url.contains('github.com')) {
      derivedTitle = 'GitHub';
    } else if (url == 'chrome://newtab') {
      derivedTitle = '새 탭';
    }

    final updatedActive = currentTab.copyWith(
      url: url,
      title: derivedTitle,
      history: updatedHistory,
      historyIndex: updatedHistory.length - 1,
    );

    final updatedTabs = List<ChromeTab>.from(config.tabs);
    updatedTabs[config.activeTabIndex] = updatedActive;

    onConfigChanged(config.copyWith(tabs: updatedTabs));
  }

  void _goBack() {
    final currentTab = config.activeTab;
    if (!currentTab.canGoBack) return;

    final newIndex = currentTab.historyIndex - 1;
    final newUrl = currentTab.history[newIndex];
    final updatedActive = currentTab.copyWith(
      url: newUrl,
      historyIndex: newIndex,
    );

    final updatedTabs = List<ChromeTab>.from(config.tabs);
    updatedTabs[config.activeTabIndex] = updatedActive;
    onConfigChanged(config.copyWith(tabs: updatedTabs));
  }

  void _goForward() {
    final currentTab = config.activeTab;
    if (!currentTab.canGoForward) return;

    final newIndex = currentTab.historyIndex + 1;
    final newUrl = currentTab.history[newIndex];
    final updatedActive = currentTab.copyWith(
      url: newUrl,
      historyIndex: newIndex,
    );

    final updatedTabs = List<ChromeTab>.from(config.tabs);
    updatedTabs[config.activeTabIndex] = updatedActive;
    onConfigChanged(config.copyWith(tabs: updatedTabs));
  }

  void _reload() {
    final currentTab = config.activeTab;
    _navigateActiveTab(currentTab.url);
  }

  void _home() {
    _navigateActiveTab('https://www.google.com/search?igu=1');
  }

  void _handleOmniboxSubmit(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    String finalUrl = trimmed;
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      if (trimmed.contains('.') && !trimmed.contains(' ')) {
        finalUrl = 'https://$trimmed';
      } else {
        finalUrl = 'https://www.google.com/search?q=${Uri.encodeComponent(trimmed)}&igu=1';
      }
    }

    if (config.openInNewTabByDefault) {
      _newTab(finalUrl, finalUrl);
    } else {
      _navigateActiveTab(finalUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1F22),
      child: Column(
        children: [
          // 1. Multi-Tab Bar
          ChromeTabBar(
            tabs: config.tabs,
            activeTabIndex: config.activeTabIndex,
            onSelectTab: _selectTab,
            onCloseTab: _closeTab,
            onNewTab: () => _newTab('chrome://newtab', '새 탭'),
          ),

          // 2. Navigation Omnibox Toolbar
          ChromeNavToolbar(
            activeTab: config.activeTab,
            openInNewTabByDefault: config.openInNewTabByDefault,
            onBack: _goBack,
            onForward: _goForward,
            onReload: _reload,
            onHome: _home,
            onSubmitUrl: _handleOmniboxSubmit,
            onToggleNewTabMode: (enabled) {
              onConfigChanged(config.copyWith(openInNewTabByDefault: enabled));
            },
            onEditConfig: onOpenEditDialog,
          ),

          // 3. Bookmarks Bar (Optional)
          if (config.showBookmarksBar)
            ChromeBookmarksBar(
              bookmarks: config.bookmarks,
              openInNewTabByDefault: config.openInNewTabByDefault,
              onNavigate: _navigateActiveTab,
              onOpenNewTab: (url) => _newTab(url, url),
            ),

          // 4. Web Content Frame (Intercepts links and renders within Chrome)
          Expanded(
            child: ChromeWebContent(
              tab: config.activeTab,
              bookmarks: config.bookmarks,
              openInNewTabByDefault: config.openInNewTabByDefault,
              onNavigate: _navigateActiveTab,
              onOpenNewTab: (url) => _newTab(url, url),
            ),
          ),
        ],
      ),
    );
  }
}
