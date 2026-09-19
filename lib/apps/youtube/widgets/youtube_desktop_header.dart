import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YouTubeDesktopHeader extends StatelessWidget {
  final bool isSidebarOpen;
  final VoidCallback onToggleSidebar;
  final bool isDesktopMode;
  final VoidCallback onToggleDesktopMode;
  final VoidCallback onOpenEditDialog;
  final VoidCallback onNavigateHome;
  final String userAvatarUrl;

  const YouTubeDesktopHeader({
    super.key,
    required this.isSidebarOpen,
    required this.onToggleSidebar,
    required this.isDesktopMode,
    required this.onToggleDesktopMode,
    required this.onOpenEditDialog,
    required this.onNavigateHome,
    this.userAvatarUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        border: Border(
          bottom: BorderSide(color: Color(0xFF272727), width: 1),
        ),
      ),
      child: Row(
        children: [
          // 1. Left: Hamburger menu + YouTube Logo
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 22),
            tooltip: '가이드',
            onPressed: onToggleSidebar,
          ),
          const SizedBox(width: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onNavigateHome,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red play badge
                Container(
                  width: 30,
                  height: 21,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'YouTube',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(width: 3),
                Transform.translate(
                  offset: const Offset(0, -6),
                  child: const Text(
                    'KR',
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // 2. Center: Search Bar & Voice Search
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                          border: Border.all(color: const Color(0xFF303030), width: 1),
                        ),
                        child: Row(
                          children: const [
                            SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                '검색',
                                style: TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222),
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                        border: Border.all(color: const Color(0xFF303030), width: 1),
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.search,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Circular Voice Search button
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFF222222),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.mic_fill,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 3. Right: Action Buttons & Mode Switcher
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 💻 데스크톱 / 📱 모바일 토글 버튼
              InkWell(
                onTap: onToggleDesktopMode,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF272727),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDesktopMode ? const Color(0xFF3EA6FF) : const Color(0xFF444444),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDesktopMode ? CupertinoIcons.device_desktop : CupertinoIcons.device_phone_portrait,
                        color: isDesktopMode ? const Color(0xFF3EA6FF) : Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isDesktopMode ? '데스크톱 모드' : '모바일 모드',
                        style: TextStyle(
                          color: isDesktopMode ? const Color(0xFF3EA6FF) : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ✏️ 시나리오 편집 버튼
              InkWell(
                onTap: onOpenEditDialog,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFFF0000).withValues(alpha: 0.5), width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.pencil_ellipsis_rectangle, color: Color(0xFFFF4E4E), size: 14),
                      SizedBox(width: 5),
                      Text(
                        '시나리오 편집',
                        style: TextStyle(
                          color: Color(0xFFFF4E4E),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // 만들기 버튼
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF272727),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(CupertinoIcons.plus, color: Colors.white, size: 15),
                    SizedBox(width: 4),
                    Text(
                      '만들기',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 알림 벨 (🔔 9+)
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.bell, color: Colors.white, size: 20),
                    tooltip: '알림',
                    onPressed: () {},
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCC0000),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '9+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 4),

              // 계정 프로필 아바타
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'F',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
