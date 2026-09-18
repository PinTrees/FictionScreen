import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/blind_model.dart';
import '../../widgets/blind_bottom_nav.dart';
import '../../widgets/blind_post_card.dart';

class BlindMobileHomePage extends StatefulWidget {
  final BlindConfig config;
  final ValueChanged<BlindConfig>? onConfigChanged;
  final ValueChanged<BlindPostItem> onSelectPost;
  final VoidCallback onEditStory;

  const BlindMobileHomePage({
    super.key,
    required this.config,
    this.onConfigChanged,
    required this.onSelectPost,
    required this.onEditStory,
  });

  @override
  State<BlindMobileHomePage> createState() => _BlindMobileHomePageState();
}

class _BlindMobileHomePageState extends State<BlindMobileHomePage> {
  int _tabIndex = 0;
  String _selectedCategory = '홈';

  final List<String> _categories = [
    '홈',
    '인기글',
    '블라블라',
    '이직·커리어',
    '직장인',
    '썸·연애',
    '주식·투자',
    '부동산',
    'IT·인터넷',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 16,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDA3238),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'blind',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.search, size: 20, color: Color(0xFF2B2D31)),
              onPressed: () {},
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(CupertinoIcons.bell, size: 20, color: Color(0xFF2B2D31)),
                  onPressed: () {},
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDA3238),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.pencil_circle, size: 21, color: Color(0xFFDA3238)),
              onPressed: widget.onEditStory,
              tooltip: '시나리오 편집',
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
      body: Column(
        children: [
          // Category Pills
          Container(
            height: 42,
            color: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final isSelected = _selectedCategory == cat;
                return InkWell(
                  onTap: () => setState(() => _selectedCategory = cat),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1E2024) : const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF495057),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(color: Color(0xFFE9ECEF), height: 1),

          // Posts Feed
          Expanded(
            child: ListView.builder(
              itemCount: widget.config.feedPosts.length,
              itemBuilder: (context, idx) {
                final post = widget.config.feedPosts[idx];
                return BlindPostCard(
                  post: post,
                  onTap: () => widget.onSelectPost(post),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onEditStory,
        backgroundColor: const Color(0xFFDA3238),
        icon: const Icon(CupertinoIcons.pencil, size: 16, color: Colors.white),
        label: const Text(
          '글쓰기',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        elevation: 3,
      ),
      bottomNavigationBar: BlindBottomNav(
        currentIndex: _tabIndex,
        onTap: (idx) => setState(() => _tabIndex = idx),
      ),
    );
  }
}
