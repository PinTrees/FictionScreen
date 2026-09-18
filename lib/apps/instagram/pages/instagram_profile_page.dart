import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/instagram_model.dart';
import '../widgets/instagram_modal_scope.dart';

class InstagramProfilePage extends StatefulWidget {
  final InstagramConfig config;

  const InstagramProfilePage({super.key, required this.config});

  @override
  State<InstagramProfilePage> createState() => _InstagramProfilePageState();
}

class _InstagramProfilePageState extends State<InstagramProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _highlights = [
    {'title': '제주 🏝️', 'letter': '🏝️', 'asset': 'assets/images/macos_golden_gate.webp'},
    {'title': '유럽 ✈️', 'letter': '✈️', 'asset': 'assets/images/win11_bloom.webp'},
    {'title': '노을 🌅', 'letter': '🌅', 'asset': 'assets/images/win10_hero.webp'},
    {'title': '카페 ☕', 'letter': '☕', 'asset': 'assets/images/win7_harmony.webp'},
    {'title': '새로 만들기', 'letter': '+', 'asset': ''},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openEditProfile() {
    final modalScope = InstagramModalScope.maybeOf(context);
    final nameCtrl = TextEditingController(text: widget.config.bioName);
    final descCtrl = TextEditingController(text: widget.config.bioDescription);
    final linkCtrl = TextEditingController(text: widget.config.bioLink);

    final editWidget = Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (modalScope != null) {
                    modalScope.hideModal();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text('취소', style: TextStyle(color: Colors.black54, fontSize: 15)),
              ),
              const Text('프로필 편집', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.config.bioName = nameCtrl.text;
                    widget.config.bioDescription = descCtrl.text;
                    widget.config.bioLink = linkCtrl.text;
                  });
                  if (modalScope != null) {
                    modalScope.hideModal();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text('완료', style: TextStyle(color: Color(0xFF0095F6), fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: '이름', border: UnderlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descCtrl,
            maxLines: 2,
            decoration: const InputDecoration(labelText: '소개', border: UnderlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: linkCtrl,
            decoration: const InputDecoration(labelText: '링크', border: UnderlineInputBorder()),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );

    if (modalScope != null) {
      modalScope.showModal(editWidget);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => editWidget,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(CupertinoIcons.lock, size: 14, color: Colors.black87),
                const SizedBox(width: 4),
                Text(
                  widget.config.username,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                ),
                const Icon(CupertinoIcons.chevron_down, size: 14, color: Colors.black87),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.plus_app, size: 22, color: Colors.black87),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.bars, size: 22, color: Colors.black87),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile image & stats
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 37,
                            backgroundColor: const Color(0xFFF97316),
                            child: Text(
                              widget.config.username.isNotEmpty ? widget.config.username[0].toUpperCase() : 'S',
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('게시물', widget.config.postCount),
                            _buildStatItem('팔로워', widget.config.followersCount),
                            _buildStatItem('팔로잉', widget.config.followingCount),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Bio Info
                  Text(
                    widget.config.bioName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.config.bioCategory,
                      style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.config.bioDescription,
                    style: const TextStyle(fontSize: 13, height: 1.3, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.link, size: 12, color: Color(0xFF00376B)),
                      const SizedBox(width: 4),
                      Text(
                        widget.config.bioLink,
                        style: const TextStyle(color: Color(0xFF00376B), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Action Buttons: 프로필 편집 / 프로필 공유
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _openEditProfile,
                          child: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFEFEF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                '프로필 편집',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('프로필 링크를 공유합니다.'), duration: Duration(seconds: 1)),
                            );
                          },
                          child: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFEFEF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                '프로필 공유',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(CupertinoIcons.person_badge_plus, size: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Story Highlights
                  SizedBox(
                    height: 84,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _highlights.length,
                      itemBuilder: (context, index) {
                        final h = _highlights[index];
                        final isNew = index == _highlights.length - 1;
                        return Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey.shade300, width: 1),
                                  color: const Color(0xFFF9FAFB),
                                ),
                                child: Center(
                                  child: isNew
                                      ? const Icon(CupertinoIcons.plus, size: 20, color: Colors.black87)
                                      : Text(h['letter']!, style: const TextStyle(fontSize: 22)),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                h['title']!,
                                style: const TextStyle(fontSize: 11, color: Colors.black87),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.black,
                indicatorWeight: 1.5,
                tabs: const [
                  Tab(icon: Icon(CupertinoIcons.square_grid_2x2, color: Colors.black87, size: 20)),
                  Tab(icon: Icon(CupertinoIcons.play_rectangle, color: Colors.black87, size: 20)),
                  Tab(icon: Icon(CupertinoIcons.person_crop_square, color: Colors.black87, size: 20)),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Grid 1: Posts
            _buildGridGallery(),
            // Grid 2: Reels
            _buildGridGallery(isReels: true),
            // Grid 3: Tagged
            _buildGridGallery(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildGridGallery({bool isReels = false}) {
    final assets = [
      'assets/images/macos_golden_gate.webp',
      'assets/images/win11_bloom.webp',
      'assets/images/win10_hero.webp',
      'assets/images/win7_harmony.webp',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.5,
        mainAxisSpacing: 1.5,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final asset = assets[index % assets.length];
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.primaries[index % Colors.primaries.length].shade300, Colors.primaries[(index + 3) % Colors.primaries.length].shade400],
                  ),
                ),
                child: const Center(child: Icon(CupertinoIcons.photo, color: Colors.white70, size: 24)),
              ),
            ),
            if (isReels)
              Positioned(
                top: 6,
                right: 6,
                child: const Icon(CupertinoIcons.play_rectangle_fill, color: Colors.white, size: 14),
              ),
          ],
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
