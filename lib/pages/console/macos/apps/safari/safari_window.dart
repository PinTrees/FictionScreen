import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// macOS Safari 웹 브라우저 창
class SafariWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String templateId)? onOpenTemplate;
  final Function(GestureDragStartDetails)? onTitleDragStart;
  final Function(GestureDragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const SafariWindow({
    super.key,
    required this.onClose,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 820,
    this.height = 540,
  });

  @override
  State<SafariWindow> createState() => _SafariWindowState();
}

class _SafariWindowState extends State<SafariWindow> {
  int _activeTab = 0;
  final TextEditingController _urlController = TextEditingController(text: 'https://fiction-screen.web.app/console');

  final List<Map<String, dynamic>> _favorites = [
    {'title': '카카오톡', 'image': 'assets/images/kakaotalk_icon.webp', 'type': 'kakaotalk', 'domain': 'fiction-screen.web.app'},
    {'title': '인스타그램', 'image': 'assets/images/instagram_icon.webp', 'type': 'instagram', 'domain': 'fiction-screen.web.app'},
    {'title': '유튜브', 'icon': CupertinoIcons.play_arrow_solid, 'color': Color(0xFFFF0000), 'type': 'youtube', 'domain': 'youtube.com'},
    {'title': '블루스크린', 'icon': CupertinoIcons.device_desktop, 'color': Color(0xFF0078D7), 'type': 'windows_bsod', 'domain': 'fiction-screen.web.app'},
    {'title': '배달의민족', 'icon': CupertinoIcons.bag_fill, 'color': Color(0xFF2AC1BC), 'type': 'delivery', 'domain': 'fiction-screen.web.app'},
    {'title': 'Apple', 'image': 'assets/images/apple_logo.webp', 'type': null, 'domain': 'apple.com'},
  ];

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: 'Safari - FictionScreen Start Page',
      style: WindowStyle.macos,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Row(
              children: [
                const Row(
                  children: [
                    Icon(CupertinoIcons.chevron_left, size: 16, color: Colors.white54),
                    SizedBox(width: 8),
                    Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.white24),
                  ],
                ),
                const SizedBox(width: 14),
                const Icon(CupertinoIcons.sidebar_left, size: 16, color: Colors.white54),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.lock_fill, size: 12, color: Colors.white38),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const Icon(CupertinoIcons.arrow_clockwise, size: 12, color: Colors.white38),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Row(
                  children: [
                    Icon(CupertinoIcons.share, size: 16, color: Colors.white54),
                    SizedBox(width: 12),
                    Icon(CupertinoIcons.plus, size: 16, color: Colors.white54),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: Row(
              children: [
                _buildTab(0, 'FictionScreen Console', 'assets/images/apple_logo.webp'),
                const SizedBox(width: 4),
                _buildTab(1, 'Apple Inc.', 'assets/images/apple_logo.webp'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFF141720),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '즐겨찾기',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _favorites.length,
                      itemBuilder: (context, index) {
                        final fav = _favorites[index];
                        final String? image = fav['image'];
                        final IconData? icon = fav['icon'];
                        final Color? color = fav['color'];

                        return InkWell(
                          onTap: () {
                            final type = fav['type'] as String?;
                            if (type != null && widget.onOpenTemplate != null) {
                              widget.onOpenTemplate!(type);
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          hoverColor: Colors.white.withValues(alpha: 0.08),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
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
                                fav['title'] as String,
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 36),
                    const Text(
                      '개인정보 보호 리포트',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: const Row(
                        children: [
                          Icon(CupertinoIcons.shield_lefthalf_fill, size: 28, color: Color(0xFF10B981)),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Safari가 지난 7일 동안 38개의 트래커를 차단했습니다.',
                                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '방문하는 모든 웹사이트에서 사용자의 프로필이 구축되는 것을 방지합니다.',
                                  style: TextStyle(color: Colors.white54, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title, String icon) {
    final isSelected = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 180,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: Image.asset(icon, fit: BoxFit.contain),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(CupertinoIcons.xmark, size: 10, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}
