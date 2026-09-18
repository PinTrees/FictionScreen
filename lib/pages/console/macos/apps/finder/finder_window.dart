import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// macOS Finder 창
class FinderWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String templateId)? onOpenTemplate;
  final Function(GestureDragStartDetails)? onTitleDragStart;
  final Function(GestureDragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const FinderWindow({
    super.key,
    required this.onClose,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 780,
    this.height = 520,
  });

  @override
  State<FinderWindow> createState() => _FinderWindowState();
}

class _FinderWindowState extends State<FinderWindow> {
  String _selectedCategory = 'applications';
  int _viewMode = 0; // 0: Grid, 1: List

  final List<Map<String, dynamic>> _favorites = [
    {'id': 'airdrop', 'name': 'AirDrop', 'icon': CupertinoIcons.antenna_radiowaves_left_right},
    {'id': 'recents', 'name': '최근 항목', 'icon': CupertinoIcons.clock},
    {'id': 'applications', 'name': '응용 프로그램', 'icon': CupertinoIcons.app_badge},
    {'id': 'desktop', 'name': '데스크탑', 'icon': CupertinoIcons.desktopcomputer},
    {'id': 'documents', 'name': '문서', 'icon': CupertinoIcons.doc_text},
    {'id': 'downloads', 'name': '다운로드', 'icon': CupertinoIcons.arrow_down_circle},
  ];

  final List<Map<String, dynamic>> _appItems = [
    {'title': '카카오톡', 'image': 'assets/images/kakaotalk_icon.webp', 'type': 'kakaotalk', 'size': '64 MB'},
    {'title': 'Instagram', 'image': 'assets/images/instagram_icon.webp', 'type': 'instagram', 'size': '98 MB'},
    {'title': 'YouTube Studio', 'icon': CupertinoIcons.play_arrow_solid, 'color': Color(0xFFFF0000), 'type': 'youtube', 'size': '112 MB'},
    {'title': 'BSOD 에디터', 'icon': CupertinoIcons.device_desktop, 'color': Color(0xFF0078D7), 'type': 'windows_bsod', 'size': '45 MB'},
    {'title': '배달의민족', 'icon': CupertinoIcons.bag_fill, 'color': Color(0xFF2AC1BC), 'type': 'delivery', 'size': '84 MB'},
    {'title': 'Safari', 'image': 'assets/images/macos/safari.webp', 'type': 'safari', 'size': '52 MB'},
    {'title': '터미널', 'image': 'assets/images/macos/terminal.webp', 'type': 'terminal', 'size': '18 MB'},
    {'title': '메모', 'image': 'assets/images/macos/notes.webp', 'type': 'notes', 'size': '24 MB'},
    {'title': '메일', 'image': 'assets/images/macos/mail.webp', 'type': 'mail', 'size': '38 MB'},
    {'title': '지도', 'image': 'assets/images/macos/maps.webp', 'type': 'maps', 'size': '42 MB'},
  ];

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: 'Finder - 응용 프로그램',
      style: WindowStyle.macos,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.chevron_left, size: 16, color: Colors.white54),
                    const SizedBox(width: 8),
                    Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.white24),
                  ],
                ),
                const SizedBox(width: 18),
                Text(
                  '응용 프로그램',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      _buildViewModeBtn(CupertinoIcons.square_grid_2x2, 0),
                      _buildViewModeBtn(CupertinoIcons.list_bullet, 1),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: 180,
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.search, size: 13, color: Colors.white38),
                      SizedBox(width: 6),
                      Text('검색', style: TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 190,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Text(
                          '즐겨찾기',
                          style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ..._favorites.map((fav) {
                        final isSelected = _selectedCategory == fav['id'];
                        return InkWell(
                          onTap: () => setState(() => _selectedCategory = fav['id']),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF3B82F6).withValues(alpha: 0.25) : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(fav['icon'] as IconData, size: 15, color: isSelected ? const Color(0xFF60A5FA) : const Color(0xFF38BDF8)),
                                const SizedBox(width: 10),
                                Text(
                                  fav['name'] as String,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.white70,
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 14),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Text(
                          '위치',
                          style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildSidebarItem(CupertinoIcons.device_laptop, 'Macintosh HD'),
                      _buildSidebarItem(CupertinoIcons.cloud, 'iCloud Drive'),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(16),
                    child: _viewMode == 0 ? _buildGridView() : _buildListView(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Row(
              children: [
                Text(
                  '${_appItems.length}개 항목, 256.4 GB 사용 가능',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeBtn(IconData icon, int mode) {
    final isSelected = _viewMode == mode;
    return InkWell(
      onTap: () => setState(() => _viewMode = mode),
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.white54),
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.white54),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _appItems.length,
      itemBuilder: (context, index) {
        final item = _appItems[index];
        final String? image = item['image'];
        final IconData? icon = item['icon'];
        final Color? color = item['color'];

        return InkWell(
          onTap: () {
            final type = item['type'] as String;
            if (widget.onOpenTemplate != null && (type == 'kakaotalk' || type == 'instagram' || type == 'youtube' || type == 'windows_bsod' || type == 'delivery')) {
              widget.onOpenTemplate!(type);
            }
          },
          borderRadius: BorderRadius.circular(10),
          hoverColor: Colors.white.withValues(alpha: 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 54,
                height: 54,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: image != null
                      ? Image.asset(image, fit: BoxFit.cover, filterQuality: FilterQuality.high)
                      : Container(
                          color: color ?? Colors.grey,
                          child: Icon(icon, color: Colors.white, size: 28),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['title'] as String,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _appItems.length,
      itemBuilder: (context, index) {
        final item = _appItems[index];
        final String? image = item['image'];
        final IconData? icon = item['icon'];
        final Color? color = item['color'];

        return InkWell(
          onTap: () {
            final type = item['type'] as String;
            if (widget.onOpenTemplate != null && (type == 'kakaotalk' || type == 'instagram' || type == 'youtube' || type == 'windows_bsod' || type == 'delivery')) {
              widget.onOpenTemplate!(type);
            }
          },
          borderRadius: BorderRadius.circular(6),
          hoverColor: Colors.white.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: image != null
                        ? Image.asset(image, fit: BoxFit.cover)
                        : Container(
                            color: color ?? Colors.grey,
                            child: Icon(icon, color: Colors.white, size: 16),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                Text(item['size'] as String, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
        );
      },
    );
  }
}
