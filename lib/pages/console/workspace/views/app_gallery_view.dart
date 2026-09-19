import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../apps/screen_template.dart';
import '../../../../widgets/scale_button.dart';

/// 콘솔 메인 페이지에서 어플을 고를 수 있는 갤러리/카탈로그 뷰
class AppGalleryView extends StatefulWidget {
  final List<ScreenTemplate> templates;
  final ValueChanged<String> onSelectApp;
  final bool isDarkMode;

  const AppGalleryView({
    super.key,
    required this.templates,
    required this.onSelectApp,
    required this.isDarkMode,
  });

  @override
  State<AppGalleryView> createState() => _AppGalleryViewState();
}

class _AppGalleryViewState extends State<AppGalleryView> {
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
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final searchBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFE2E8F0).withValues(alpha: 0.7);

    final filtered = _filteredTemplates;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount = 3;
        if (width < 720) {
          crossAxisCount = 1;
        } else if (width < 1100) {
          crossAxisCount = 2;
        } else if (width < 1500) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 4;
        }

        return ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(scrollbars: false),
          child: CustomScrollView(
            slivers: [
              // Top spacing so initial content sits gracefully below the 56px floating app bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 72),
              ),

                // 1. Header Banner
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Title
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(CupertinoIcons.square_grid_2x2_fill, color: Color(0xFF00B0FF), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '스튜디오 어플 탐색',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '원하는 화면을 선택하면 피그마 스타일의 전체화면 정밀 에디터가 열립니다.',
                                  style: TextStyle(color: textSubColor, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Search & Category Filters (ZERO OUTLINE)
                        Column(
                          children: [
                            Row(
                              children: [
                                // Search field
                                Expanded(
                                  child: Container(
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: searchBgColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      controller: _searchCtrl,
                                      style: TextStyle(color: textColor, fontSize: 13.5),
                                      decoration: InputDecoration(
                                        hintText: '어플 이름, 카테고리, 설명으로 검색...',
                                        hintStyle: TextStyle(color: textSubColor.withValues(alpha: 0.6), fontSize: 13),
                                        prefixIcon: Icon(CupertinoIcons.search, size: 17, color: textSubColor),
                                        suffixIcon: _searchQuery.isNotEmpty
                                            ? IconButton(
                                                icon: Icon(CupertinoIcons.xmark_circle_fill, size: 15, color: textSubColor),
                                                onPressed: () {
                                                  _searchCtrl.clear();
                                                  setState(() => _searchQuery = '');
                                                },
                                              )
                                            : null,
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 11),
                                      ),
                                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Category Filter Pills
                            SizedBox(
                              height: 34,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _buildCategoryPill(null, '전체 (${widget.templates.length})', isDark),
                                  ...TemplateCategory.values.map((cat) {
                                    final count = widget.templates.where((t) => t.category == cat).length;
                                    return _buildCategoryPill(cat, '${cat.label} ($count)', isDark);
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),
                      ],
                    ),
                  ),
                ),

                // 2. Grid of Apps
                if (filtered.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          '일치하는 어플이 없습니다.',
                          style: TextStyle(color: textSubColor, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 18,
                        mainAxisExtent: 184,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = filtered[index];
                          return _AppGalleryCard(
                            template: item,
                            isDark: isDark,
                            textColor: textColor,
                            textSubColor: textSubColor,
                            onTap: () => widget.onSelectApp(item.id),
                          );
                        },
                        childCount: filtered.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 36),
                ),
              ],
            ),
          );
        },
      );
  }

  Widget _buildCategoryPill(TemplateCategory? cat, String label, bool isDark) {
    final isSelected = _selectedCategory == cat;
    final activeBg = const Color(0xFF00B0FF);
    final inactiveBg = isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0);

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () => setState(() => _selectedCategory = cat),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : inactiveBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppGalleryCard extends StatefulWidget {
  final ScreenTemplate template;
  final bool isDark;
  final Color textColor;
  final Color textSubColor;
  final VoidCallback onTap;

  const _AppGalleryCard({
    required this.template,
    required this.isDark,
    required this.textColor,
    required this.textSubColor,
    required this.onTap,
  });

  @override
  State<_AppGalleryCard> createState() => _AppGalleryCardState();
}

class _AppGalleryCardState extends State<_AppGalleryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.template;
    final isDark = widget.isDark;

    final cardBgColor = isDark ? const Color(0xFF0F131D) : Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? (_isHovered ? 0.45 : 0.25) : (_isHovered ? 0.12 : 0.04)),
              blurRadius: _isHovered ? 24 : 12,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: ScaleButton(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Icon + Title + Category + Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (item.themeColor).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: item.imageAsset != null
                            ? Image.asset(item.imageAsset!, fit: BoxFit.contain)
                            : Icon(item.icon, color: item.themeColor, size: 24),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    color: widget.textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (item.badge.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                _buildBadge(item.badge),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.category.label,
                            style: TextStyle(
                              color: widget.textSubColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Middle: Description
                Expanded(
                  child: Text(
                    item.description,
                    style: TextStyle(
                      color: widget.textSubColor.withValues(alpha: 0.85),
                      fontSize: 12,
                      height: 1.45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Bottom Action: Open Editor (NO OUTLINE)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B0FF).withValues(alpha: _isHovered ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '피그마 에디터 열기',
                            style: TextStyle(
                              color: const Color(0xFF00B0FF),
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            CupertinoIcons.arrow_right,
                            size: 11,
                            color: const Color(0xFF00B0FF),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String badge) {
    final isHot = badge == 'HOT' || badge == '인기';
    final color = isHot ? const Color(0xFFEF4444) : const Color(0xFF10B981);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        badge,
        style: TextStyle(
          color: color,
          fontSize: 8.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
