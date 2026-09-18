import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../data/chrome_model.dart';

class ChromeBookmarksBar extends StatelessWidget {
  final List<ChromeBookmark> bookmarks;
  final bool openInNewTabByDefault;
  final ValueChanged<String> onNavigate;
  final ValueChanged<String> onOpenNewTab;

  const ChromeBookmarksBar({
    super.key,
    required this.bookmarks,
    required this.openInNewTabByDefault,
    required this.onNavigate,
    required this.onOpenNewTab,
  });

  void _handleClick(String url) {
    if (openInNewTabByDefault) {
      onOpenNewTab(url);
    } else {
      onNavigate(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      color: const Color(0xFF2B2D30),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: bookmarks.length,
              separatorBuilder: (context, index) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final bm = bookmarks[index];
                return InkWell(
                  onTap: () => _handleClick(bm.url),
                  onLongPress: () => onOpenNewTab(bm.url),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          bm.icon ?? CupertinoIcons.bookmark_fill,
                          size: 12,
                          color: bm.color ?? const Color(0xFF4285F4),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          bm.title,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 4),
          const Icon(CupertinoIcons.folder_fill, size: 12, color: Colors.white38),
          const SizedBox(width: 4),
          const Text('모든 북마크', style: TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }
}
