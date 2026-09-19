import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/naver_model.dart';

/// 네이버 포털 검색어, 실시간 트렌드, 뉴스 실시간 편집 모달
class NaverEditDialog extends StatefulWidget {
  final NaverConfig config;
  final ValueChanged<NaverConfig> onConfigChanged;

  const NaverEditDialog({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<NaverEditDialog> createState() => _NaverEditDialogState();
}

class _NaverEditDialogState extends State<NaverEditDialog> {
  late TextEditingController _searchController;
  late TextEditingController _headlineController;
  late TextEditingController _pressController;
  late TextEditingController _tempController;
  late TextEditingController _dustController;
  late TextEditingController _kospiController;
  late TextEditingController _kospiChangeController;
  late TextEditingController _trending1Controller;
  late TextEditingController _trending2Controller;
  late TextEditingController _trending3Controller;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.config.searchTerm);
    _headlineController = TextEditingController(text: widget.config.newsList.first.title);
    _pressController = TextEditingController(text: widget.config.newsList.first.press);
    _tempController = TextEditingController(text: widget.config.weatherTemp);
    _dustController = TextEditingController(text: widget.config.fineDust);
    _kospiController = TextEditingController(text: widget.config.kospi);
    _kospiChangeController = TextEditingController(text: widget.config.kospiChange);

    final trend = widget.config.trendingList;
    _trending1Controller = TextEditingController(text: trend.isNotEmpty ? trend[0].keyword : '');
    _trending2Controller = TextEditingController(text: trend.length > 1 ? trend[1].keyword : '');
    _trending3Controller = TextEditingController(text: trend.length > 2 ? trend[2].keyword : '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _headlineController.dispose();
    _pressController.dispose();
    _tempController.dispose();
    _dustController.dispose();
    _kospiController.dispose();
    _kospiChangeController.dispose();
    _trending1Controller.dispose();
    _trending2Controller.dispose();
    _trending3Controller.dispose();
    super.dispose();
  }

  void _save() {
    final updatedNews = List<NaverNewsItem>.from(widget.config.newsList);
    if (updatedNews.isNotEmpty) {
      updatedNews[0] = updatedNews[0].copyWith(
        title: _headlineController.text.trim(),
        press: _pressController.text.trim(),
      );
    }

    final updatedTrending = List<NaverTrendingItem>.from(widget.config.trendingList);
    if (updatedTrending.isNotEmpty) {
      updatedTrending[0] = updatedTrending[0].copyWith(keyword: _trending1Controller.text.trim());
    }
    if (updatedTrending.length > 1) {
      updatedTrending[1] = updatedTrending[1].copyWith(keyword: _trending2Controller.text.trim());
    }
    if (updatedTrending.length > 2) {
      updatedTrending[2] = updatedTrending[2].copyWith(keyword: _trending3Controller.text.trim());
    }

    widget.onConfigChanged(
      widget.config.copyWith(
        searchTerm: _searchController.text.trim(),
        weatherTemp: _tempController.text.trim(),
        fineDust: _dustController.text.trim(),
        kospi: _kospiController.text.trim(),
        kospiChange: _kospiChangeController.text.trim(),
        newsList: updatedNews,
        trendingList: updatedTrending,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E212B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 540,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF03C75A).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.search_circle_fill, color: Color(0xFF03C75A), size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  '네이버 포털 실시간 이슈 편집',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, color: Colors.white70, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 입력 폼
            Expanded(
              child: ListView(
                children: [
                  _buildInput('검색창 검색어 (상단 메인)', _searchController),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInput('메인 톱뉴스 언론사', _pressController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInput('날씨 기온', _tempController)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInput('메인 헤드라인 기사 제목', _headlineController),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInput('코스피 지수', _kospiController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInput('코스피 변동률', _kospiChangeController)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInput('미세먼지 상태', _dustController),
                  const SizedBox(height: 16),

                  const Text(
                    '실시간 급상승 검색 트렌드 (1위~3위)',
                    style: TextStyle(color: Color(0xFF03C75A), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildInput('실검 1위', _trending1Controller),
                  const SizedBox(height: 8),
                  _buildInput('실검 2위', _trending2Controller),
                  const SizedBox(height: 8),
                  _buildInput('실검 3위', _trending3Controller),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 하단 버튼
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    widget.onConfigChanged(NaverConfig.defaultPreset());
                    Navigator.pop(context);
                  },
                  icon: const Icon(CupertinoIcons.arrow_counterclockwise, size: 14, color: Colors.white60),
                  label: const Text('기본값 복원', style: TextStyle(color: Colors.white60, fontSize: 13)),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF03C75A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _save,
                  child: const Text('적용 완료', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF141720),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
