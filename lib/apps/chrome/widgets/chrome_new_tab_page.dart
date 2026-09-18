import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../data/chrome_model.dart';

class ChromeNewTabPage extends StatefulWidget {
  final List<ChromeBookmark> bookmarks;
  final bool openInNewTabByDefault;
  final ValueChanged<String> onNavigate;
  final ValueChanged<String> onOpenNewTab;

  const ChromeNewTabPage({
    super.key,
    required this.bookmarks,
    required this.openInNewTabByDefault,
    required this.onNavigate,
    required this.onOpenNewTab,
  });

  @override
  State<ChromeNewTabPage> createState() => _ChromeNewTabPageState();
}

class _ChromeNewTabPageState extends State<ChromeNewTabPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    String targetUrl;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      targetUrl = trimmed;
    } else if (trimmed.contains('.') && !trimmed.contains(' ')) {
      targetUrl = 'https://$trimmed';
    } else {
      targetUrl = 'https://www.google.com/search?q=${Uri.encodeComponent(trimmed)}&igu=1';
    }

    if (widget.openInNewTabByDefault) {
      widget.onOpenNewTab(targetUrl);
    } else {
      widget.onNavigate(targetUrl);
    }
  }

  void _handleTileClick(String url) {
    if (widget.openInNewTabByDefault) {
      widget.onOpenNewTab(url);
    } else {
      widget.onNavigate(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF202124),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google Brand Logo
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _letter('G', const Color(0xFF4285F4)),
                _letter('o', const Color(0xFFEA4335)),
                _letter('o', const Color(0xFFFBBC05)),
                _letter('g', const Color(0xFF4285F4)),
                _letter('l', const Color(0xFF34A853)),
                _letter('e', const Color(0xFFEA4335)),
              ],
            ),
            const SizedBox(height: 28),

            // Search Bar
            Container(
              constraints: const BoxConstraints(maxWidth: 560),
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF303134),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.search, color: Colors.white38, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Google 검색 또는 URL 입력',
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: _handleSearch,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.mic_fill, size: 16, color: Colors.white70),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.camera_fill, size: 16, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Speed Dial Grid
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: widget.bookmarks.map((bm) {
                return InkWell(
                  onTap: () => _handleTileClick(bm.url),
                  onLongPress: () => widget.onOpenNewTab(bm.url),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 90,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFF303134),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            bm.icon ?? CupertinoIcons.globe,
                            color: bm.color ?? const Color(0xFF4285F4),
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bm.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _letter(String char, Color color) {
    return Text(
      char,
      style: TextStyle(
        color: color,
        fontSize: 54,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.5,
      ),
    );
  }
}
