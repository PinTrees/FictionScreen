import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../apps/screen_template.dart';

class WorkspaceSidebar extends StatefulWidget {
  final List<ScreenTemplate> templates;
  final String selectedTemplateId;
  final ValueChanged<String> onSelectTemplate;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;
  final bool isDarkMode;

  const WorkspaceSidebar({
    super.key,
    required this.templates,
    required this.selectedTemplateId,
    required this.onSelectTemplate,
    required this.isCollapsed,
    required this.onToggleCollapse,
    required this.isDarkMode,
  });

  @override
  State<WorkspaceSidebar> createState() => _WorkspaceSidebarState();
}

class _WorkspaceSidebarState extends State<WorkspaceSidebar> {
  final TextEditingController _searchCtrl = TextEditingController();
  TemplateCategory? _selectedCategory;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ScreenTemplate> get _filteredTemplates {
    return widget.templates.where((t) {
      if (_selectedCategory != null && t.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = t.title.toLowerCase().contains(q);
        final matchDesc = t.description.toLowerCase().contains(q);
        final matchId = t.id.toLowerCase().contains(q);
        final matchCat = t.category.label.toLowerCase().contains(q);
        return matchTitle || matchDesc || matchId || matchCat;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final isCollapsed = widget.isCollapsed;

    // Rescene FlutterWebEmbedding style widths
    final sidebarWidth = isCollapsed ? 74.0 : 268.0;

    final bgColor = isDark ? const Color(0xFF0D1017) : const Color(0xFFF8FAFC);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final searchBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFEDEFEF);

    final filtered = _filteredTemplates;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 230),
      curve: Curves.easeOutCubic,
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Search Bar & Category Pills (Only when Expanded)
          if (!isCollapsed) ...[
            // Search Bar (Border-free filled container)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: searchBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  style: TextStyle(color: textColor, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: '어플 검색...',
                    hintStyle: TextStyle(color: textSubColor.withValues(alpha: 0.6), fontSize: 12.5),
                    prefixIcon: Icon(CupertinoIcons.search, size: 16, color: textSubColor),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(CupertinoIcons.xmark_circle_fill, size: 14, color: textSubColor),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                ),
              ),
            ),

            // Category Filter Pills (Horizontal Scroll, NO OUTLINE)
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildCategoryPill(null, '전체 (${widget.templates.length})', isDark),
                  ...TemplateCategory.values.map((cat) {
                    final count = widget.templates.where((t) => t.category == cat).length;
                    return _buildCategoryPill(cat, '${cat.label.split(' / ').first} ($count)', isDark);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ] else ...[
            // Collapsed Top Quick Toggle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: IconButton(
                  tooltip: '사이드바 펼치기',
                  icon: const Icon(CupertinoIcons.chevron_right, size: 16),
                  color: textSubColor,
                  onPressed: widget.onToggleCollapse,
                  style: IconButton.styleFrom(
                    backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
          ],

          // 2. Applications List (Rescene-inspired scale feedback & borderless)
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        '검색 결과 없음',
                        style: TextStyle(color: textSubColor, fontSize: 12.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: isCollapsed ? 8 : 10,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSelected = item.id == widget.selectedTemplateId;
                      return _SidebarAppItem(
                        item: item,
                        isSelected: isSelected,
                        isCollapsed: isCollapsed,
                        isDark: isDark,
                        textColor: textColor,
                        textSubColor: textSubColor,
                        onTap: () => widget.onSelectTemplate(item.id),
                      );
                    },
                  ),
          ),

          // 3. Bottom Footer Status & Collapse Toggle
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 6 : 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF090B10) : const Color(0xFFEFF2F6),
            ),
            child: isCollapsed
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.templates.length}개 가상 스크린',
                        style: TextStyle(
                          color: textSubColor,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: widget.onToggleCollapse,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Icon(
                            CupertinoIcons.chevron_left,
                            size: 14,
                            color: textSubColor,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(TemplateCategory? cat, String label, bool isDark) {
    final isSelected = _selectedCategory == cat;
    final activeBg = const Color(0xFF6366F1);
    final inactiveBg = isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0);

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () => setState(() => _selectedCategory = cat),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : inactiveBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : const Color(0xFF475569)),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rescene GameSidebar inspired menu item with scale and smooth press feedback
class _SidebarAppItem extends StatefulWidget {
  final ScreenTemplate item;
  final bool isSelected;
  final bool isCollapsed;
  final bool isDark;
  final Color textColor;
  final Color textSubColor;
  final VoidCallback onTap;

  const _SidebarAppItem({
    required this.item,
    required this.isSelected,
    required this.isCollapsed,
    required this.isDark,
    required this.textColor,
    required this.textSubColor,
    required this.onTap,
  });

  @override
  State<_SidebarAppItem> createState() => _SidebarAppItemState();
}

class _SidebarAppItemState extends State<_SidebarAppItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final isCollapsed = widget.isCollapsed;
    final isDark = widget.isDark;
    final item = widget.item;

    final activeBgColor = isDark
        ? const Color(0xFF6366F1).withValues(alpha: 0.22)
        : const Color(0xFFEEF2FF);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Tooltip(
        message: isCollapsed ? item.title : '',
        child: AnimatedScale(
          scale: _isPressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 115),
          curve: Curves.easeOutCubic,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                padding: isCollapsed
                    ? const EdgeInsets.symmetric(vertical: 10)
                    : const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? activeBgColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isCollapsed
                    ? Center(
                        child: _buildAppIcon(item, size: 28),
                      )
                    : Row(
                        children: [
                          _buildAppIcon(item, size: 30),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        item.title,
                                        style: TextStyle(
                                          color: isSelected
                                              ? (isDark ? Colors.white : const Color(0xFF4338CA))
                                              : widget.textColor,
                                          fontSize: 12.5,
                                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (item.badge.isNotEmpty) ...[
                                      const SizedBox(width: 5),
                                      _buildBadge(item.badge),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.category.label,
                                  style: TextStyle(
                                    color: widget.textSubColor.withValues(alpha: 0.8),
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              CupertinoIcons.chevron_right,
                              color: isDark ? const Color(0xFF818CF8) : const Color(0xFF6366F1),
                              size: 13,
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon(ScreenTemplate item, {required double size}) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: item.themeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: item.imageAsset != null
            ? Image.asset(item.imageAsset!, fit: BoxFit.contain)
            : Icon(item.icon, color: item.themeColor, size: size * 0.55),
      ),
    );
  }

  Widget _buildBadge(String badge) {
    final isHot = badge == 'HOT' || badge == '인기';
    final badgeColor = isHot ? const Color(0xFFEF4444) : const Color(0xFF10B981);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        badge,
        style: TextStyle(
          color: badgeColor,
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
