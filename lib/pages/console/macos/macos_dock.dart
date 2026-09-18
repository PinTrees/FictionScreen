import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// macOS 하단 플로팅 글래스 독(Dock)
class MacosDock extends StatefulWidget {
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onGoHome;

  const MacosDock({
    super.key,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onGoHome,
  });

  @override
  State<MacosDock> createState() => _MacosDockState();
}

class _MacosDockState extends State<MacosDock> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E).withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 1. macOS 기본 앱들
                _buildDockApp(
                  index: 0,
                  tooltip: 'Finder',
                  icon: CupertinoIcons.sparkles,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () {},
                ),
                _buildDockApp(
                  index: 1,
                  tooltip: 'Safari',
                  icon: CupertinoIcons.compass,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF60A5FA), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () {},
                ),
                _buildDockApp(
                  index: 2,
                  tooltip: 'Mail',
                  icon: CupertinoIcons.mail_solid,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () {},
                ),
                _buildDockApp(
                  index: 3,
                  tooltip: 'Messages',
                  icon: CupertinoIcons.chat_bubble_fill,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF34D399), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () {},
                ),
                _buildDockApp(
                  index: 4,
                  tooltip: 'Maps',
                  icon: CupertinoIcons.map_fill,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () {},
                ),
                _buildDockApp(
                  index: 5,
                  tooltip: 'Photos',
                  icon: CupertinoIcons.photo_fill_on_rectangle_fill,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFB7185), Color(0xFFE11D48)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () {},
                ),
                _buildDockApp(
                  index: 6,
                  tooltip: 'Music',
                  icon: CupertinoIcons.music_note_2,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF43F5E), Color(0xFFBE123C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () {},
                ),
                _buildDockApp(
                  index: 7,
                  tooltip: '시스템 설정 (OS 변경 / 배경화면)',
                  icon: CupertinoIcons.gear_alt_fill,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF64748B), Color(0xFF334155)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: widget.onOpenSettings,
                ),
                _buildDockApp(
                  index: 8,
                  tooltip: 'Terminal',
                  icon: CupertinoIcons.chevron_left_slash_chevron_right,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () {},
                ),

                // 구분선
                _buildDockDivider(),

                // 2. FictionScreen 스튜디오 앱들
                _buildDockApp(
                  index: 9,
                  tooltip: '카카오톡 채팅 에디터',
                  icon: CupertinoIcons.chat_bubble_2_fill,
                  iconColor: Colors.black87,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFEE500), Color(0xFFF5D000)],
                  ),
                  onTap: () => widget.onOpenTemplate('kakaotalk'),
                ),
                _buildDockApp(
                  index: 10,
                  tooltip: 'Windows 블루스크린 에디터',
                  icon: CupertinoIcons.device_desktop,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0078D7), Color(0xFF005A9E)],
                  ),
                  onTap: () => widget.onOpenTemplate('windows_bsod'),
                ),
                _buildDockApp(
                  index: 11,
                  tooltip: 'YouTube 화면 에디터',
                  icon: CupertinoIcons.play_arrow_solid,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF0000), Color(0xFFCC0000)],
                  ),
                  onTap: () => widget.onOpenTemplate('youtube'),
                ),
                _buildDockApp(
                  index: 12,
                  tooltip: 'Instagram 피드 에디터',
                  icon: CupertinoIcons.camera_fill,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => widget.onOpenTemplate('instagram'),
                ),
                _buildDockApp(
                  index: 13,
                  tooltip: '배달의민족 배송 에디터',
                  icon: CupertinoIcons.bag_fill,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2AC1BC), Color(0xFF1B8D89)],
                  ),
                  onTap: () => widget.onOpenTemplate('delivery'),
                ),

                // 구분선
                _buildDockDivider(),

                // 3. 홈 이동 & 휴지통
                _buildDockApp(
                  index: 14,
                  tooltip: '랜딩 홈으로 이동',
                  icon: CupertinoIcons.house_fill,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF475569), Color(0xFF1E293B)],
                  ),
                  onTap: widget.onGoHome,
                ),
                _buildDockApp(
                  index: 15,
                  tooltip: '휴지통',
                  icon: CupertinoIcons.trash_fill,
                  iconColor: Colors.white70,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF334155), Color(0xFF1E293B)],
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDockDivider() {
    return Container(
      width: 1,
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Colors.white.withValues(alpha: 0.18),
    );
  }

  Widget _buildDockApp({
    required int index,
    required String tooltip,
    required IconData icon,
    Color iconColor = Colors.white,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    final bool isHovered = _hoveredIndex == index;
    final double size = isHovered ? 52 : 44;
    final double iconSize = isHovered ? 28 : 24;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: tooltip,
        waitDuration: const Duration(milliseconds: 300),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoveredIndex = index),
          onExit: (_) => setState(() => _hoveredIndex = null),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              width: size,
              height: size,
              margin: EdgeInsets.only(bottom: isHovered ? 6 : 0),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(size * 0.28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: isHovered ? 14 : 6,
                    offset: Offset(0, isHovered ? 6 : 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: iconSize),
              ),
            ),
          ),
        ),
      ),
    );
  }
}