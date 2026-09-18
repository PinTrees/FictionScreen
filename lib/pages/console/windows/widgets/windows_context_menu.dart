import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows 11 모던 Fluent 우클릭 컨텍스트 드롭다운 메뉴
class WindowsContextMenu extends StatelessWidget {
  final Offset position;
  final VoidCallback onRefresh;
  final VoidCallback onNewFolder;
  final VoidCallback onNewNote;
  final VoidCallback onOpenSettings;
  final VoidCallback onClose;
  final Function(String sortType)? onSort;

  const WindowsContextMenu({
    super.key,
    required this.position,
    required this.onRefresh,
    required this.onNewFolder,
    required this.onNewNote,
    required this.onOpenSettings,
    required this.onClose,
    this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 외부 영역 클릭 시 닫기
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            onSecondaryTap: onClose,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),

        // Windows 11 Fluent 스타일 드롭다운 메뉴 (마우스 우클릭 위치)
        Positioned(
          left: position.dx.clamp(10.0, MediaQuery.of(context).size.width - 240.0),
          top: position.dy.clamp(10.0, MediaQuery.of(context).size.height - 320.0),
          child: Container(
            width: 230,
            decoration: BoxDecoration(
              color: const Color(0xFF20222A).withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuItem(
                        icon: CupertinoIcons.eye_fill,
                        label: '보기(V)',
                        trailing: '›',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: CupertinoIcons.line_horizontal_3_decrease,
                        label: '정렬 기준(O)',
                        trailing: '›',
                        onTap: () {
                          onSort?.call('name');
                          onClose();
                        },
                      ),
                      _buildMenuItem(
                        icon: CupertinoIcons.arrow_clockwise,
                        label: '새로 고침(E)',
                        onTap: () {
                          onRefresh();
                          onClose();
                        },
                      ),
                      const Divider(color: Colors.white12, height: 10),
                      _buildMenuItem(
                        icon: CupertinoIcons.plus_square_fill,
                        label: '새로 만들기(W)',
                        trailing: '›',
                        onTap: () {
                          onNewFolder();
                          onClose();
                        },
                      ),
                      const Divider(color: Colors.white12, height: 10),
                      _buildMenuItem(
                        icon: CupertinoIcons.device_desktop,
                        label: '디스플레이 설정(D)',
                        onTap: () {
                          onOpenSettings();
                          onClose();
                        },
                      ),
                      _buildMenuItem(
                        icon: CupertinoIcons.photo_fill_on_rectangle_fill,
                        label: '개인 설정(R)',
                        onTap: () {
                          onOpenSettings();
                          onClose();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.white.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          children: [
            Icon(icon, size: 15, color: Colors.white70),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            if (trailing != null)
              Text(trailing, style: const TextStyle(color: Colors.white38, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
