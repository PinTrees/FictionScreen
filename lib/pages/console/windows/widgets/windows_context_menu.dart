import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows 11 모던 Fluent 우클릭 컨텍스트 드롭다운 메뉴 (서브메뉴 플라이아웃 지원)
class WindowsContextMenu extends StatefulWidget {
  final Offset position;
  final VoidCallback onRefresh;
  final VoidCallback onNewFolder;
  final VoidCallback onNewTextDocument;
  final VoidCallback onOpenSettings;
  final VoidCallback onClose;
  final Function(String sortType)? onSort;

  const WindowsContextMenu({
    super.key,
    required this.position,
    required this.onRefresh,
    required this.onNewFolder,
    required this.onNewTextDocument,
    required this.onOpenSettings,
    required this.onClose,
    this.onSort,
  });

  @override
  State<WindowsContextMenu> createState() => _WindowsContextMenuState();
}

class _WindowsContextMenuState extends State<WindowsContextMenu> {
  bool _isNewSubmenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double menuLeft = widget.position.dx.clamp(10.0, screenSize.width - 240.0);
    final double menuTop = widget.position.dy.clamp(10.0, screenSize.height - 340.0);

    // 서브메뉴 표시 위치 계산 (화면 우측 여유 있으면 우측, 없으면 좌측)
    final bool openSubmenuRight = (menuLeft + 230 + 190) < screenSize.width;
    final double submenuLeft = openSubmenuRight ? (menuLeft + 224) : (menuLeft - 180);
    final double submenuTop = (menuTop + 104).clamp(10.0, screenSize.height - 120.0);

    return Stack(
      children: [
        // 외부 영역 클릭 시 닫기
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            onSecondaryTap: widget.onClose,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),

        // 1. Windows 11 Fluent 메인 컨텍스트 메뉴
        Positioned(
          left: menuLeft,
          top: menuTop,
          child: Container(
            width: 230,
            decoration: BoxDecoration(
              color: const Color(0xFF20222A).withValues(alpha: 0.94),
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
                        onHover: () => setState(() => _isNewSubmenuOpen = false),
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: CupertinoIcons.line_horizontal_3_decrease,
                        label: '정렬 기준(O)',
                        trailing: '›',
                        onHover: () => setState(() => _isNewSubmenuOpen = false),
                        onTap: () {
                          widget.onSort?.call('name');
                          widget.onClose();
                        },
                      ),
                      _buildMenuItem(
                        icon: CupertinoIcons.arrow_clockwise,
                        label: '새로 고침(E)',
                        onHover: () => setState(() => _isNewSubmenuOpen = false),
                        onTap: () {
                          widget.onRefresh();
                          widget.onClose();
                        },
                      ),
                      const Divider(color: Colors.white12, height: 10),

                      // 새로 만들기 (호버 또는 클릭 시 서브메뉴 표시)
                      _buildMenuItem(
                        icon: CupertinoIcons.plus_square_fill,
                        label: '새로 만들기(W)',
                        trailing: '›',
                        isSelected: _isNewSubmenuOpen,
                        onHover: () => setState(() => _isNewSubmenuOpen = true),
                        onTap: () => setState(() => _isNewSubmenuOpen = !_isNewSubmenuOpen),
                      ),

                      const Divider(color: Colors.white12, height: 10),
                      _buildMenuItem(
                        icon: CupertinoIcons.device_desktop,
                        label: '디스플레이 설정(D)',
                        onHover: () => setState(() => _isNewSubmenuOpen = false),
                        onTap: () {
                          widget.onOpenSettings();
                          widget.onClose();
                        },
                      ),
                      _buildMenuItem(
                        icon: CupertinoIcons.photo_fill_on_rectangle_fill,
                        label: '개인 설정(R)',
                        onHover: () => setState(() => _isNewSubmenuOpen = false),
                        onTap: () {
                          widget.onOpenSettings();
                          widget.onClose();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // 2. '새로 만들기' 플라이아웃 서브메뉴 (폴더, 새 텍스트 문서)
        if (_isNewSubmenuOpen)
          Positioned(
            left: submenuLeft,
            top: submenuTop,
            child: Container(
              width: 185,
              decoration: BoxDecoration(
                color: const Color(0xFF20222A).withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 폴더(F)
                        _buildSubmenuItem(
                          imageAsset: 'assets/images/windows/folder.png',
                          label: '폴더(F)',
                          onTap: () {
                            widget.onClose();
                            widget.onNewFolder();
                          },
                        ),
                        const Divider(color: Colors.white12, height: 8),

                        // 텍스트 문서(T)
                        _buildSubmenuItem(
                          imageAsset: 'assets/images/windows/notepad.png',
                          label: '텍스트 문서(T)',
                          onTap: () {
                            widget.onClose();
                            widget.onNewTextDocument();
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
    bool isSelected = false,
    VoidCallback? onHover,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover?.call(),
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.white.withValues(alpha: 0.12),
        child: Container(
          color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            children: [
              Icon(icon, size: 15, color: isSelected ? const Color(0xFF60CDFF) : Colors.white70),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF60CDFF) : Colors.white,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null)
                Text(trailing, style: TextStyle(color: isSelected ? const Color(0xFF60CDFF) : Colors.white38, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmenuItem({
    required String imageAsset,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.white.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          children: [
            Image.asset(imageAsset, width: 16, height: 16, fit: BoxFit.contain),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
