import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../widgets/common/live_web_view.dart';
import '../../../common/os_window_frame.dart';

/// macOS Safari 웹 브라우저 창 (실시간 라이브 웹뷰 탑재)
class SafariWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String templateId)? onOpenTemplate;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const SafariWindow({
    super.key,
    required this.onClose,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 820,
    this.height = 540,
  });

  @override
  State<SafariWindow> createState() => _SafariWindowState();
}

class _SafariWindowState extends State<SafariWindow> {
  final TextEditingController _urlController = TextEditingController(text: 'https://fiction-screen.web.app');
  bool _isBrowsing = false;
  String _currentUrl = 'https://fiction-screen.web.app';

  final List<Map<String, dynamic>> _favorites = [
    {'title': 'FictionScreen', 'url': 'https://fiction-screen.web.app', 'image': 'assets/images/apple_logo.webp'},
    {'title': 'Flutter Dev', 'url': 'https://flutter.dev', 'image': 'assets/images/apple_logo.webp'},
    {'title': 'Wikipedia', 'url': 'https://en.wikipedia.org', 'image': 'assets/images/apple_logo.webp'},
    {'title': '카카오톡', 'type': 'kakaotalk', 'image': 'assets/images/kakaotalk_icon.webp'},
    {'title': '인스타그램', 'type': 'instagram', 'image': 'assets/images/instagram_icon.webp'},
    {'title': '유튜브', 'type': 'youtube', 'icon': CupertinoIcons.play_arrow_solid, 'color': Color(0xFFFF0000)},
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
      title: 'Safari - ${_isBrowsing ? _currentUrl : "시작 페이지"}',
      style: WindowStyle.macos,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          // 상단 Safari 통합 툴바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _isBrowsing = false),
                  child: const Icon(CupertinoIcons.house_fill, size: 16, color: Color(0xFF60A5FA)),
                ),
                const SizedBox(width: 10),
                const Icon(CupertinoIcons.chevron_left, size: 16, color: Colors.white54),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.white24),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.lock_fill, size: 12, color: Colors.white38),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                            onSubmitted: _loadUrl,
                          ),
                        ),
                        InkWell(
                          onTap: () => _loadUrl(_urlController.text),
                          child: const Icon(CupertinoIcons.arrow_clockwise, size: 12, color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 라이브 웹뷰 / 시작 페이지
          Expanded(
            child: _isBrowsing
                ? LiveWebView(url: _currentUrl)
                : Container(
                    color: const Color(0xFF141720),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('즐겨찾기', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: _favorites.length,
                            itemBuilder: (context, index) {
                              final fav = _favorites[index];
                              final String? url = fav['url'] as String?;
                              final String? type = fav['type'] as String?;
                              final String? image = fav['image'] as String?;
                              final IconData? icon = fav['icon'] as IconData?;
                              final Color? color = fav['color'] as Color?;

                              return InkWell(
                                onTap: () {
                                  if (url != null) {
                                    _loadUrl(url);
                                  } else if (type != null && widget.onOpenTemplate != null) {
                                    widget.onOpenTemplate!(type);
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: image != null
                                            ? Image.asset(image, fit: BoxFit.cover)
                                            : Container(color: color ?? Colors.grey, child: Icon(icon, color: Colors.white, size: 24)),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(fav['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
