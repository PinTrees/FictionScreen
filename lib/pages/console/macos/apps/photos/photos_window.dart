import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// macOS Photos (사진) 창
class PhotosWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const PhotosWindow({
    super.key,
    required this.onClose,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 800,
    this.height = 520,
  });

  @override
  State<PhotosWindow> createState() => _PhotosWindowState();
}

class _PhotosWindowState extends State<PhotosWindow> {
  String? _previewAsset;

  final List<Map<String, String>> _photos = [
    {'title': '골든 게이트 브리지 석양', 'asset': 'assets/images/macos_golden_gate.webp'},
    {'title': 'Windows 11 블룸', 'asset': 'assets/images/win11_bloom.webp'},
    {'title': 'Windows 10 히어로', 'asset': 'assets/images/win10_hero.webp'},
    {'title': 'Windows 7 하모니', 'asset': 'assets/images/win7_harmony.webp'},
    {'title': '카카오톡 공식 아이콘', 'asset': 'assets/images/kakaotalk_icon.webp'},
    {'title': '인스타그램 공식 아이콘', 'asset': 'assets/images/instagram_icon.webp'},
    {'title': 'Apple 공식 로고', 'asset': 'assets/images/apple_logo.webp'},
  ];

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '사진 - 보관함',
      style: WindowStyle.macos,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Row(
        children: [
          Container(
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text('보관함', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                _buildSidebarItem(CupertinoIcons.photo_fill_on_rectangle_fill, '모든 사진', isSelected: true),
                _buildSidebarItem(CupertinoIcons.heart_fill, '즐겨찾는 항목'),
                _buildSidebarItem(CupertinoIcons.clock_fill, '최근 항목'),
                const SizedBox(height: 14),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text('앨범', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                _buildSidebarItem(CupertinoIcons.folder_fill, '배경화면 (2K)'),
                _buildSidebarItem(CupertinoIcons.folder_fill, '숏폼 에셋'),
                _buildSidebarItem(CupertinoIcons.folder_fill, '스크린샷'),
              ],
            ),
          ),
          Expanded(
            child: _previewAsset != null
                ? Stack(
                    children: [
                      Center(
                        child: Image.asset(_previewAsset!, fit: BoxFit.contain, filterQuality: FilterQuality.high),
                      ),
                      Positioned(
                        top: 14,
                        left: 14,
                        child: InkWell(
                          onTap: () => setState(() => _previewAsset = null),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              children: [
                                Icon(CupertinoIcons.chevron_left, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Text('목록으로', style: TextStyle(color: Colors.white, fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: _photos.length,
                    itemBuilder: (context, index) {
                      final item = _photos[index];
                      return InkWell(
                        onTap: () => setState(() => _previewAsset = item['asset']),
                        borderRadius: BorderRadius.circular(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                item['asset']!,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.medium,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Text(
                                    item['title']!,
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3B82F6).withValues(alpha: 0.25) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isSelected ? const Color(0xFF60A5FA) : Colors.white60),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
