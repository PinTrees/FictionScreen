import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../data/chrome_model.dart';

class ChromeTabBar extends StatelessWidget {
  final List<ChromeTab> tabs;
  final int activeTabIndex;
  final ValueChanged<int> onSelectTab;
  final ValueChanged<int> onCloseTab;
  final VoidCallback onNewTab;

  const ChromeTabBar({
    super.key,
    required this.tabs,
    required this.activeTabIndex,
    required this.onSelectTab,
    required this.onCloseTab,
    required this.onNewTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      color: const Color(0xFF1E1F22),
      padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              separatorBuilder: (context, index) => const SizedBox(width: 2),
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isSelected = index == activeTabIndex;

                return _buildTabItem(context, index, tab, isSelected);
              },
            ),
          ),
          const SizedBox(width: 4),

          // [+] New Tab Button
          Tooltip(
            message: '새 탭 열기 (Ctrl+T)',
            child: InkWell(
              onTap: onNewTab,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.add,
                  size: 15,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, int index, ChromeTab tab, bool isSelected) {
    final title = tab.title.isEmpty ? (tab.isNewTabPage ? '새 탭' : tab.url) : tab.title;

    return InkWell(
      onTap: () => onSelectTab(index),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: Container(
        constraints: const BoxConstraints(minWidth: 120, maxWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2B2D30) : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Row(
          children: [
            if (tab.isLoading)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF4285F4)),
              )
            else
              Icon(
                tab.isNewTabPage ? CupertinoIcons.search : CupertinoIcons.globe,
                size: 13,
                color: isSelected ? const Color(0xFF4285F4) : Colors.white54,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),

            // Tab Close Button
            InkWell(
              onTap: () => onCloseTab(index),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  CupertinoIcons.xmark,
                  size: 11,
                  color: isSelected ? Colors.white70 : Colors.white38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
