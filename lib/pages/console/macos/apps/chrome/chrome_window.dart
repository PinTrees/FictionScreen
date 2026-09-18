import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../widgets/common/live_web_view.dart';
import '../../../common/os_window_frame.dart';

/// macOS용 Google Chrome 브라우저 창
class MacosChromeWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String templateId)? onOpenTemplate;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const MacosChromeWindow({
    super.key,
    required this.onClose,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 840,
    this.height = 540,
  });

  @override
  State<MacosChromeWindow> createState() => _MacosChromeWindowState();
}

class _MacosChromeWindowState extends State<MacosChromeWindow> {
  final TextEditingController _urlController = TextEditingController(text: 'https://www.google.com/search?igu=1');
  bool _isBrowsing = false;
  String _currentUrl = 'https://www.google.com/search?igu=1';

  final List<Map<String, String>> _quickLinks = [
    {'title': 'Google', 'url': 'https://www.google.com/search?igu=1'},
    {'title': 'FictionScreen', 'url': 'https://fiction-screen.web.app'},
    {'title': 'YouTube', 'url': 'https://www.youtube.com'},
    {'title': 'Flutter', 'url': 'https://flutter.dev'},
    {'title': 'Wikipedia', 'url': 'https://en.wikipedia.org'},
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
    return OsWindowFrame(
      title: 'Google Chrome',
      style: WindowStyle.macos,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          // Chrome 툴바 & 주소창
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: const Color(0xFF2B2D30),
            child: Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _isBrowsing = false),
                  child: const Icon(CupertinoIcons.house_fill, size: 14, color: Colors.white70),
                ),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.arrow_left, size: 14, color: Colors.white54),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.arrow_right, size: 14, color: Colors.white24),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _loadUrl(_urlController.text),
                  child: const Icon(CupertinoIcons.arrow_clockwise, size: 14, color: Colors.white54),
                ),
                const SizedBox(width: 12),

                // URL 주소 바
                Expanded(
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1F22),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.search, size: 12, color: Colors.white38),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                            onSubmitted: _loadUrl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 11,
                  backgroundColor: Color(0xFF4285F4),
                  child: Text('G', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // 크롬 본문
          Expanded(
            child: _isBrowsing
                ? LiveWebView(url: _currentUrl)
                : Container(
                    color: const Color(0xFF202124),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 480,
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF303134),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.search, color: Colors.white38, size: 16),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  decoration: const InputDecoration(
                                    hintText: 'Google 검색 또는 URL 입력',
                                    hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  onSubmitted: _loadUrl,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: _quickLinks.map((item) {
                            return InkWell(
                              onTap: () => _loadUrl(item['url']!),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 84,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(color: Color(0xFF303134), shape: BoxShape.circle),
                                      child: const Icon(CupertinoIcons.globe, color: Color(0xFF4285F4), size: 20),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(item['title']!, style: const TextStyle(color: Colors.white, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
