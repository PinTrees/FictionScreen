import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'windows_desktop_icon_widget.dart';

/// 바탕화면 개별 아이콘 우클릭 컨텍스트 메뉴 (열기, 이름 바꾸기, 삭제)
class WindowsItemContextMenu extends StatelessWidget {
  final Offset position;
  final DesktopIconItem item;
  final VoidCallback onOpen;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const WindowsItemContextMenu({
    super.key,
    required this.position,
    required this.item,
    required this.onOpen,
    required this.onRename,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            onSecondaryTap: onClose,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          left: position.dx.clamp(10.0, MediaQuery.of(context).size.width - 200.0),
          top: position.dy.clamp(10.0, MediaQuery.of(context).size.height - 200.0),
          child: Container(
            width: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF20222A).withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuItem(
                        icon: CupertinoIcons.arrow_up_right_square,
                        label: '열기(O)',
                        onTap: () {
                          onClose();
                          onOpen();
                        },
                      ),
                      const Divider(color: Colors.white12, height: 6),
                      // 기본 시스템 앱은 이름 변경 및 삭제 불가
                      if (!item.isSystemApp) ...[
                        _buildMenuItem(
                          icon: CupertinoIcons.pencil,
                          label: '이름 바꾸기(M)',
                          onTap: () {
                            onClose();
                            onRename();
                          },
                        ),
                        _buildMenuItem(
                          icon: CupertinoIcons.trash,
                          label: '삭제(D)',
                          iconColor: const Color(0xFFEF4444),
                          labelColor: const Color(0xFFFCA5A5),
                          onTap: () {
                            onClose();
                            onDelete();
                          },
                        ),
                      ] else ...[
                        _buildDisabledMenuItem(
                          icon: CupertinoIcons.pencil,
                          label: '이름 바꾸기 (기본 앱 불가)',
                        ),
                      ],
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
    Color iconColor = Colors.white70,
    Color labelColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.white.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledMenuItem({
    required IconData icon,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white30, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
