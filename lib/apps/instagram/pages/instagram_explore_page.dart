import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InstagramExplorePage extends StatefulWidget {
  const InstagramExplorePage({super.key});

  @override
  State<InstagramExplorePage> createState() => _InstagramExplorePageState();
}

class _InstagramExplorePageState extends State<InstagramExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    '인기',
    '여행',
    '인테리어',
    '음식',
    '스타일',
    '자연 & 풍경',
    '반려동물',
    '테크 & 개발',
  ];

  final List<Map<String, dynamic>> _exploreItems = [
    {
      'image': 'assets/images/macos_golden_gate.webp',
      'isReel': true,
      'gradient': [Color(0xFFF97316), Color(0xFFFBBF24)],
      'views': '12.4만',
      'caption': '골든게이트 일몰 순간 🌅',
    },
    {
      'image': null,
      'isReel': false,
      'gradient': [Color(0xFF3B82F6), Color(0xFF93C5FD)],
      'views': '4.2만',
      'caption': '청명한 하늘과 바다 🌊',
    },
    {
      'image': 'assets/images/win11_bloom.webp',
      'isReel': false,
      'gradient': [Color(0xFF6366F1), Color(0xFFA855F7)],
      'views': '8.9만',
      'caption': '모던 미니멀 데스크 셋업 💻',
    },
    {
      'image': null,
      'isReel': true,
      'gradient': [Color(0xFFEC4899), Color(0xFFF43F5E)],
      'views': '35.1만',
      'caption': '성수동 핫플 카페 브이로그 ☕',
    },
    {
      'image': 'assets/images/win10_hero.webp',
      'isReel': false,
      'gradient': [Color(0xFF0284C7), Color(0xFF0369A1)],
      'views': '1.5만',
      'caption': '사이버펑크 야경 스팟 🌃',
    },
    {
      'image': null,
      'isReel': false,
      'gradient': [Color(0xFF10B981), Color(0xFF34D399)],
      'views': '9.1만',
      'caption': '제주 숲길 힐링 트래킹 🌲',
    },
    {
      'image': 'assets/images/win7_harmony.webp',
      'isReel': true,
      'gradient': [Color(0xFF8B5CF6), Color(0xFFC084FC)],
      'views': '54.2만',
      'caption': '추억의 윈도우 감성 멜로디 🎶',
    },
    {
      'image': null,
      'isReel': false,
      'gradient': [Color(0xFFF59E0B), Color(0xFFFCD34D)],
      'views': '2.7만',
      'caption': '오늘 구운 바삭한 크루아상 🥐',
    },
    {
      'image': null,
      'isReel': false,
      'gradient': [Color(0xFF64748B), Color(0xFF94A3B8)],
      'views': '18.4만',
      'caption': '비 오는 날의 무드 🌧️',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showItemDetail(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: item['image'] != null
                      ? Image.asset(
                          item['image'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: item['gradient'] as List<Color>),
                            ),
                            child: const Center(child: Icon(CupertinoIcons.photo, color: Colors.white, size: 48)),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: item['gradient'] as List<Color>),
                          ),
                          child: const Center(child: Icon(CupertinoIcons.photo, color: Colors.white, size: 48)),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 14,
                            backgroundColor: Color(0xFF833AB4),
                            child: Text('E', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          const Text('explore_trending', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const Spacer(),
                          Text('조회 ${item['views']}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item['caption'] as String,
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: const [
                          Icon(CupertinoIcons.heart, size: 22, color: Colors.black87),
                          SizedBox(width: 16),
                          Icon(CupertinoIcons.chat_bubble, size: 20, color: Colors.black87),
                          SizedBox(width: 16),
                          Icon(CupertinoIcons.paperplane, size: 20, color: Colors.black87),
                          Spacer(),
                          Icon(CupertinoIcons.bookmark, size: 22, color: Colors.black87),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.search, size: 18, color: Colors.black54),
                  hintText: '검색',
                  hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Horizontal Category Pills
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.black : const Color(0xFFE5E7EB),
                        width: 0.8,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // 3x3 Discovery Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1.0,
              ),
              itemCount: _exploreItems.length,
              itemBuilder: (context, index) {
                final item = _exploreItems[index];
                return GestureDetector(
                  onTap: () => _showItemDetail(item),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      item['image'] != null
                          ? Image.asset(
                              item['image'] as String,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildColorTile(item),
                            )
                          : _buildColorTile(item),
                      if (item['isReel'] == true)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              CupertinoIcons.play_rectangle_fill,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorTile(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: item['gradient'] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          (item['isReel'] == true) ? CupertinoIcons.play_circle : CupertinoIcons.photo,
          color: Colors.white.withValues(alpha: 0.8),
          size: 28,
        ),
      ),
    );
  }
}
