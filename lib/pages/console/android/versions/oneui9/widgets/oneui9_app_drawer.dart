import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fiction_screen/pages/console/common/os_app_item.dart';

/// Samsung One UI 9 플래그십 전체 앱 서랍 (App Drawer)
class OneUi9AppDrawer extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String appId) onOpenGalaxyApp;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onGoHome;
  final VoidCallback onSignOut;

  const OneUi9AppDrawer({
    super.key,
    required this.onClose,
    required this.onOpenGalaxyApp,
    required this.onOpenTemplate,
    required this.onGoHome,
    required this.onSignOut,
  });

  @override
  State<OneUi9AppDrawer> createState() => _OneUi9AppDrawerState();
}

class _OneUi9AppDrawerState extends State<OneUi9AppDrawer> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 8) widget.onClose();
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.65),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 38, sigmaY: 38),
            child: SafeArea(
              child: Column(
                children: [
                  // 상단 Finder 검색바
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.search, color: Colors.white70, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Finder 앱 및 Galaxy AI 검색',
                                hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          const Icon(Icons.auto_awesome, color: Color(0xFFA78BFA), size: 18),
                          const SizedBox(width: 8),
                          const Icon(CupertinoIcons.mic_fill, color: Colors.white70, size: 16),
                        ],
                      ),
                    ),
                  ),

                  // 앱 그리드 리스트
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.82,
                        physics: const BouncingScrollPhysics(),
                        children: _filterApps([
                          _AppEntry('전화', CupertinoIcons.phone_fill, const Color(0xFF10B981), () => widget.onOpenGalaxyApp('phone')),
                          _AppEntry('메시지', null, const Color(0xFF3B82F6), () => widget.onOpenGalaxyApp('messages'), image: 'assets/images/galaxy/icons/messages.png'),
                          _AppEntry('갤러리', CupertinoIcons.photo_fill_on_rectangle_fill, const Color(0xFFF59E0B), () => widget.onOpenGalaxyApp('gallery')),
                          _AppEntry('인터넷', null, const Color(0xFF6366F1), () => widget.onOpenGalaxyApp('internet'), image: 'assets/images/galaxy/icons/internet.png'),
                          _AppEntry('노트', null, const Color(0xFFEA580C), () => widget.onOpenGalaxyApp('notes'), image: 'assets/images/galaxy/icons/notes.png'),
                          _AppEntry('Galaxy Store', null, const Color(0xFFEC4899), () => widget.onOpenGalaxyApp('galaxy_store'), image: 'assets/images/galaxy/icons/galaxy_store.png'),
                          _AppEntry('Health', null, const Color(0xFF10B981), () => widget.onOpenGalaxyApp('health'), image: 'assets/images/galaxy/icons/health.png'),
                          _AppEntry('Bixby', null, const Color(0xFF3B82F6), () => widget.onOpenGalaxyApp('bixby'), image: 'assets/images/galaxy/icons/bixby.png'),
                          _AppEntry('계산기', CupertinoIcons.number, const Color(0xFF059669), () => widget.onOpenGalaxyApp('calculator')),
                          _AppEntry('내 파일', CupertinoIcons.folder_fill, const Color(0xFFD97706), () => widget.onOpenGalaxyApp('my_files')),
                          _AppEntry('설정', CupertinoIcons.gear_alt_fill, const Color(0xFF475569), () => widget.onOpenGalaxyApp('settings')),
                          _AppEntry('카카오톡', null, const Color(0xFFFEE500), () => widget.onOpenTemplate('kakaotalk'), image: 'assets/images/kakaotalk_icon.webp'),
                          _AppEntry('토스 (Toss)', CupertinoIcons.money_dollar_circle_fill, const Color(0xFF0050FF), () => widget.onOpenTemplate('toss')),
                          _AppEntry('Instagram', null, Colors.pink, () => widget.onOpenTemplate('instagram'), image: 'assets/images/instagram_icon.webp'),
                          _AppEntry('X (Twitter)', CupertinoIcons.conversation_bubble, const Color(0xFF1D9BF0), () => widget.onOpenTemplate('x_twitter')),
                          _AppEntry('YouTube', CupertinoIcons.play_arrow_solid, const Color(0xFFFF0000), () => widget.onOpenTemplate('youtube')),
                          _AppEntry('쿠팡', null, Colors.red, () => widget.onOpenTemplate('coupang'), image: 'assets/images/coupang_icon.webp'),
                          _AppEntry('Netflix', null, Colors.black, () => widget.onOpenTemplate('netflix'), image: 'assets/images/netflix_icon.webp'),
                          _AppEntry('배달의민족', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC), () => widget.onOpenTemplate('delivery')),
                          _AppEntry('동행복권', null, Colors.blue, () => widget.onOpenTemplate('lottery'), image: 'assets/images/lottery_icon.webp'),
                          _AppEntry('랜딩 홈', CupertinoIcons.house_fill, const Color(0xFF334155), widget.onGoHome),
                          _AppEntry('로그아웃', CupertinoIcons.square_arrow_right, const Color(0xFFEF4444), widget.onSignOut),
                        ]),
                      ),
                    ),
                  ),

                  // 하단 닫기 바
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: widget.onClose,
                      child: Container(width: 80, height: 4, decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(2))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _filterApps(List<_AppEntry> apps) {
    return apps
        .where((app) => _searchQuery.isEmpty || app.title.toLowerCase().contains(_searchQuery))
        .map((app) => OsAppItem(
              title: app.title,
              icon: app.icon,
              imageAsset: app.image,
              iconColor: Colors.white,
              backgroundColor: app.color,
              isDesktop: false,
              onTap: () {
                widget.onClose();
                app.onTap();
              },
            ))
        .toList();
  }
}

class _AppEntry {
  final String title;
  final IconData? icon;
  final Color color;
  final VoidCallback onTap;
  final String? image;

  _AppEntry(this.title, this.icon, this.color, this.onTap, {this.image});
}
