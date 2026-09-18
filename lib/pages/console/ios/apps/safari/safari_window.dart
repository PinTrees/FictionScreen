import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../widgets/common/live_web_view.dart';

/// iOS 18 Safari 웹 브라우저 (실시간 라이브 웹뷰 탑재)
class IosSafariWindow extends StatefulWidget {
  final VoidCallback onClose;

  const IosSafariWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<IosSafariWindow> createState() => _IosSafariWindowState();
}

class _IosSafariWindowState extends State<IosSafariWindow> {
  final TextEditingController _urlController = TextEditingController(text: 'https://fiction-screen.web.app');
  bool _isBrowsing = false;
  String _currentUrl = 'https://fiction-screen.web.app';

  final List<Map<String, String>> _bookmarks = [
    {'title': 'FictionScreen', 'url': 'https://fiction-screen.web.app', 'asset': 'assets/images/apple_logo.webp'},
    {'title': 'Flutter Dev', 'url': 'https://flutter.dev', 'asset': 'assets/images/apple_logo.webp'},
    {'title': 'Wikipedia', 'url': 'https://en.wikipedia.org', 'asset': 'assets/images/apple_logo.webp'},
    {'title': 'Google', 'url': 'https://www.google.com/search?igu=1', 'asset': 'assets/images/apple_logo.webp'},
  ];

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _loadUrl(String input) {
    String trimmed = input.trim();
    if (trimmed.isEmpty) return;

    String finalUrl = trimmed;
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      if (trimmed.contains('.') && !trimmed.contains(' ')) {
        finalUrl = 'https://$trimmed';
      } else {
        finalUrl = 'https://www.google.com/search?q=${Uri.encodeComponent(trimmed)}&igu=1';
      }
    }

    setState(() {
      _currentUrl = finalUrl;
      _urlController.text = finalUrl;
      _isBrowsing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 브라우저 렌더링 화면
            Expanded(
              child: _isBrowsing
                  ? LiveWebView(url: _currentUrl)
                  : Container(
                      color: const Color(0xFF141720),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: widget.onClose,
                                child: const Icon(CupertinoIcons.chevron_left, color: Color(0xFF007AFF), size: 22),
                              ),
                              const Text('Safari 시작 페이지', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 22),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text('즐겨찾기', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: _bookmarks.length,
                            itemBuilder: (context, index) {
                              final bm = _bookmarks[index];
                              return InkWell(
                                onTap: () => _loadUrl(bm['url']!),
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
                                      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(bm['asset']!, fit: BoxFit.cover)),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(bm['title']!, style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),

            // iOS 18 하단 플로팅 주소 바 컨트롤러
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(color: Color(0xFF1C1C1E)),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isBrowsing = false;
                      });
                    },
                    child: const Icon(CupertinoIcons.house_fill, color: Color(0xFF007AFF), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.lock_fill, color: Colors.white38, size: 12),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller: _urlController,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                              onSubmitted: _loadUrl,
                            ),
                          ),
                          InkWell(
                            onTap: () => _loadUrl(_urlController.text),
                            child: const Icon(CupertinoIcons.arrow_clockwise, color: Colors.white70, size: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(CupertinoIcons.square_on_square, color: Color(0xFF007AFF), size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
