import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../widgets/common/live_web_view.dart';
import '../data/chrome_model.dart';
import 'chrome_new_tab_page.dart';
import 'chrome_simulated_portal.dart';

class ChromeWebContent extends StatefulWidget {
  final ChromeTab tab;
  final List<ChromeBookmark> bookmarks;
  final bool openInNewTabByDefault;
  final ValueChanged<String> onNavigate;
  final ValueChanged<String> onOpenNewTab;

  const ChromeWebContent({
    super.key,
    required this.tab,
    required this.bookmarks,
    required this.openInNewTabByDefault,
    required this.onNavigate,
    required this.onOpenNewTab,
  });

  @override
  State<ChromeWebContent> createState() => _ChromeWebContentState();
}

class _ChromeWebContentState extends State<ChromeWebContent> {
  bool _forceSimulator = false;

  bool _isLikelyBlocked(String url) {
    final u = url.toLowerCase();
    return u.contains('naver.com') ||
        u.contains('daum.net') ||
        u.contains('youtube.com') ||
        u.contains('youtu.be') ||
        u.contains('github.com') ||
        u.contains('instagram.com') ||
        u.contains('twitter.com') ||
        u.contains('x.com') ||
        u.contains('facebook.com') ||
        u.contains('namu.wiki');
  }

  @override
  Widget build(BuildContext context) {
    final tab = widget.tab;

    // 1. New Tab / Start Page
    if (tab.isNewTabPage) {
      return ChromeNewTabPage(
        bookmarks: widget.bookmarks,
        openInNewTabByDefault: widget.openInNewTabByDefault,
        onNavigate: widget.onNavigate,
        onOpenNewTab: widget.onOpenNewTab,
      );
    }

    // 2. Simulated Portal for X-Frame-Options blocked sites
    if (_forceSimulator || _isLikelyBlocked(tab.url)) {
      return Stack(
        children: [
          ChromeSimulatedPortal(
            url: tab.url,
            onNavigate: widget.onNavigate,
            onOpenNewTab: widget.onOpenNewTab,
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: FloatingActionButton.extended(
              backgroundColor: const Color(0xFF303134),
              foregroundColor: Colors.white,
              icon: const Icon(CupertinoIcons.arrow_2_circlepath, size: 14),
              label: const Text('직접 iframe 뷰 시도', style: TextStyle(fontSize: 11)),
              onPressed: () => setState(() => _forceSimulator = !_forceSimulator),
            ),
          ),
        ],
      );
    }

    // 3. Live Web View (iframe) with floating helper
    return Stack(
      children: [
        LiveWebView(url: tab.url),

        // Quick overlay button to switch to reader if iframe fails
        Positioned(
          right: 12,
          bottom: 12,
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF303134).withValues(alpha: 0.85),
            foregroundColor: Colors.white70,
            icon: const Icon(CupertinoIcons.shield_lefthalf_fill, size: 14),
            label: const Text('시뮬레이터/리더 전환', style: TextStyle(fontSize: 11)),
            onPressed: () => setState(() => _forceSimulator = true),
          ),
        ),
      ],
    );
  }
}
