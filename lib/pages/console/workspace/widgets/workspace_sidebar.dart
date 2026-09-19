import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../apps/screen_template.dart';

class WorkspaceSidebar extends StatefulWidget {
  final List<ScreenTemplate> templates;
  final String selectedTemplateId;
  final ValueChanged<String> onSelectTemplate;

  const WorkspaceSidebar({
    super.key,
    required this.templates,
    required this.selectedTemplateId,
    required this.onSelectTemplate,
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
    final filtered = _filteredTemplates;

    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1017),
        border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: '어플 검색 (이름, 카테고리)...',
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 12.5),
                  prefixIcon: const Icon(CupertinoIcons.search, size: 16, color: Colors.white38),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(CupertinoIcons.xmark_circle_fill, size: 14, color: Colors.white38),
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

          // 2. Category Filter Pills (Horizontal Scroll)
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                _buildCategoryPill(null, '전체 (${widget.templates.length})'),
                ...TemplateCategory.values.map((cat) {
                  final count = widget.templates.where((t) => t.category == cat).length;
                  return _buildCategoryPill(cat, '${cat.label.split(' / ').first} ($count)');
                }),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(color: Colors.white10, height: 1),

          // 3. Applications List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        '검색 결과가 없습니다',
                        style: TextStyle(color: Colors.white38, fontSize: 12.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSelected = item.id == widget.selectedTemplateId;
                      return _buildAppItem(item, isSelected);
                    },
                  ),
          ),

          // 4. Bottom Footer Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF090B10),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: Row(
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
                  '${widget.templates.length}개 가상 앱 편집 가능',
                  style: const TextStyle(color: Colors.white54, fontSize: 11.5, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const Text(
                  'v3.5',
                  style: TextStyle(color: Colors.white24, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(TemplateCategory? cat, String label) {
    final isSelected = _selectedCategory == cat;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () => setState(() => _selectedCategory = cat),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF818CF8) : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppItem(ScreenTemplate item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: InkWell(
        onTap: () => widget.onSelectTemplate(item.id),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.5)) : null,
          ),
          child: Row(
            children: [
              // Icon / Image
              Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: item.themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: item.themeColor.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: item.imageAsset != null
                      ? Image.asset(item.imageAsset!, fit: BoxFit.contain)
                      : Icon(item.icon, color: item.themeColor, size: 17),
                ),
              ),
              const SizedBox(width: 10),

              // Title & Category
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
                              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.88),
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.badge.isNotEmpty) ...[
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: item.badge == 'HOT' || item.badge == '인기'
                                  ? const Color(0xFFEF4444).withValues(alpha: 0.2)
                                  : const Color(0xFF10B981).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.badge,
                              style: TextStyle(
                                color: item.badge == 'HOT' || item.badge == '인기'
                                    ? const Color(0xFFF87171)
                                    : const Color(0xFF34D399),
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category.label,
                      style: const TextStyle(color: Colors.white38, fontSize: 10.5),
                    ),
                  ],
                ),
              ),

              if (isSelected)
                const Icon(CupertinoIcons.chevron_right, color: Color(0xFF818CF8), size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
