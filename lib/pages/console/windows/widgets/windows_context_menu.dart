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
  final Function(String osKey)? onSelectOs;

  const WindowsContextMenu({
    super.key,
    required this.position,
    required this.onRefresh,
    required this.onNewFolder,
    required this.onNewTextDocument,
    required this.onOpenSettings,
    required this.onClose,
    this.onSort,
    this.onSelectOs,
  });

  @override
  State<WindowsContextMenu> createState() => _WindowsContextMenuState();
}

class _WindowsContextMenuState extends State<WindowsContextMenu> {
  bool _isNewSubmenuOpen = false;
  bool _isOsSubmenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double menuLeft = widget.position.dx.clamp(10.0, screenSize.width - 240.0);
    final double menuTop = widget.position.dy.clamp(10.0, screenSize.height - 380.0);

    // 서브메뉴 표시 위치 계산 (화면 우측 여유 있으면 우측, 없으면 좌측)
    final bool openSubmenuRight = (menuLeft + 230 + 190) < screenSize.width;
    final double submenuLeft = openSubmenuRight ? (menuLeft + 224) : (menuLeft - 180);
    final double submenuTop = (menuTop + 104).clamp(10.0, screenSize.height - 120.0);

    final bool openOsSubmenuRight = (menuLeft + 230 + 220) < screenSize.width;
    final double osSubmenuLeft = openOsSubmenuRight ? (menuLeft + 224) : (menuLeft - 215);
    final double osSubmenuTop = (menuTop + 140).clamp(10.0, screenSize.height - 330.0);

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
                        onHover: () => setState(() { _isNewSubmenuOpen = false; _isOsSubmenuOpen = false; }),
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: CupertinoIcons.line_horizontal_3_decrease,
                        label: '정렬 기준(O)',
                        trailing: '›',
                        onHover: () => setState(() { _isNewSubmenuOpen = false; _isOsSubmenuOpen = false; }),
                        onTap: () {
                          widget.onSort?.call('name');
                          widget.onClose();
                        },
                      ),
                      _buildMenuItem(
                        icon: CupertinoIcons.arrow_clockwise,
                        label: '새로 고침(E)',
                        onHover: () => setState(() { _isNewSubmenuOpen = false; _isOsSubmenuOpen = false; }),
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
                        onHover: () => setState(() { _isNewSubmenuOpen = true; _isOsSubmenuOpen = false; }),
                        onTap: () => setState(() { _isNewSubmenuOpen = !_isNewSubmenuOpen; _isOsSubmenuOpen = false; }),
                      ),

                      // 운영체제 전환 (호버 또는 클릭 시 서브메뉴 표시)
                      _buildMenuItem(
                        icon: CupertinoIcons.device_laptop,
                        label: '운영체제 전환(S)',
                        trailing: '›',
                        isSelected: _isOsSubmenuOpen,
                        onHover: () => setState(() { _isOsSubmenuOpen = true; _isNewSubmenuOpen = false; }),
                        onTap: () => setState(() { _isOsSubmenuOpen = !_isOsSubmenuOpen; _isNewSubmenuOpen = false; }),
                      ),

                      const Divider(color: Colors.white12, height: 10),
                      _buildMenuItem(
                        icon: CupertinoIcons.device_desktop,
                        label: '디스플레이 설정(D)',
                        onHover: () => setState(() { _isNewSubmenuOpen = false; _isOsSubmenuOpen = false; }),
                        onTap: () {
                          widget.onOpenSettings();
                          widget.onClose();
                        },
                      ),
                      _buildMenuItem(
                        icon: CupertinoIcons.photo_fill_on_rectangle_fill,
                        label: '개인 설정(R)',
                        onHover: () => setState(() { _isNewSubmenuOpen = false; _isOsSubmenuOpen = false; }),
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
                        _buildSubmenuItem(
                          imageAsset: 'assets/images/windows/folder.png',
                          label: '폴더(F)',
                          onTap: () {
                            widget.onClose();
                            widget.onNewFolder();
                          },
                        ),
                        const Divider(color: Colors.white12, height: 8),
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

        // 3. '운영체제 전환' 플라이아웃 서브메뉴
        if (_isOsSubmenuOpen)
          Positioned(
            left: osSubmenuLeft,
            top: osSubmenuTop,
            child: Container(
              width: 215,
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
                        _buildOsSubmenuItem(
                          icon: CupertinoIcons.square_grid_2x2_fill,
                          label: 'Windows 11',
                          badge: '현재',
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('windows_11');
                          },
                        ),
                        _buildOsSubmenuItem(
                          icon: CupertinoIcons.device_desktop,
                          label: 'Windows 10',
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('windows_10');
                          },
                        ),
                        _buildOsSubmenuItem(
                          icon: CupertinoIcons.device_desktop,
                          label: 'Windows 7 (Aero)',
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('windows_7');
                          },
                        ),
                        _buildOsSubmenuItem(
                          icon: CupertinoIcons.device_desktop,
                          label: 'Windows XP (Luna)',
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('windows_xp');
                          },
                        ),
                        const Divider(color: Colors.white12, height: 8),
                        _buildOsSubmenuItem(
                          imageAsset: 'assets/images/apple_logo.webp',
                          label: 'macOS 27 (Golden Gate)',
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('macos_27');
                          },
                        ),
                        _buildOsSubmenuItem(
                          imageAsset: 'assets/images/apple_logo.webp',
                          label: 'macOS 15 (Sequoia)',
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('macos_15');
                          },
                        ),
                        const Divider(color: Colors.white12, height: 8),
                        _buildOsSubmenuItem(
                          icon: CupertinoIcons.device_phone_portrait,
                          label: 'Galaxy (One UI 9)',
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('galaxy');
                          },
                        ),
                        _buildOsSubmenuItem(
                          icon: CupertinoIcons.device_phone_portrait,
                          label: 'iPhone (iOS 26)',
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('ios');
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

  Widget _buildOsSubmenuItem({
    IconData? icon,
    String? imageAsset,
    required String label,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.white.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          children: [
            if (imageAsset != null)
              Image.asset(imageAsset, width: 15, height: 15, fit: BoxFit.contain, color: Colors.white)
            else if (icon != null)
              Icon(icon, size: 15, color: const Color(0xFF60CDFF)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF60CDFF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF60CDFF).withValues(alpha: 0.5), width: 0.8),
                ),
                child: Text(badge, style: const TextStyle(color: Color(0xFF60CDFF), fontSize: 9, fontWeight: FontWeight.w600)),
              ),
          ],
        ),
      ),
    );
  }
}
