import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// macOS 27 Golden Gate 데스크톱 및 항목 우클릭 컨텍스트 메뉴
/// - Liquid Glass 반투명 블러 머티리얼
/// - 바탕화면 우클릭: 새로운 폴더, 새로운 텍스트 문서, 배경화면 변경, 시스템 설정, 운영체제 빠른 전환 서브메뉴
/// - 폴더/파일 우클릭: 열기, 이름 변경, 정보 가져오기, 휴지통으로 이동 (삭제)
class Macos27ContextMenu extends StatefulWidget {
  final Offset position;
  final VoidCallback onNewFolder;
  final VoidCallback? onNewDocument;
  final VoidCallback onOpenWallpaperSettings;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenOsSwitch;
  final VoidCallback? onOpenItem;
  final VoidCallback? onRenameItem;
  final VoidCallback? onDeleteItem;
  final Function(String osKey)? onSelectOs;
  final bool isItemTarget;
  final String? targetTitle;
  final VoidCallback onClose;

  const Macos27ContextMenu({
    super.key,
    required this.position,
    required this.onNewFolder,
    this.onNewDocument,
    required this.onOpenWallpaperSettings,
    required this.onOpenSettings,
    required this.onOpenOsSwitch,
    this.onOpenItem,
    this.onRenameItem,
    this.onDeleteItem,
    this.onSelectOs,
    this.isItemTarget = false,
    this.targetTitle,
    required this.onClose,
  });

  @override
  State<Macos27ContextMenu> createState() => _Macos27ContextMenuState();
}

class _Macos27ContextMenuState extends State<Macos27ContextMenu> {
  bool _isOsSubmenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double menuLeft = widget.position.dx.clamp(10.0, screenSize.width - 230.0);
    final double menuTop = widget.position.dy.clamp(10.0, screenSize.height - (widget.isItemTarget ? 210.0 : 330.0));

    final bool openSubmenuRight = (menuLeft + 216 + 220) < screenSize.width;
    final double submenuLeft = openSubmenuRight ? (menuLeft + 212) : (menuLeft - 212);
    final double submenuTop = (menuTop + 140).clamp(10.0, screenSize.height - 330.0);

    return Stack(
      children: [
        // 외부 영역 탭 시 닫기
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            onSecondaryTap: widget.onClose,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),

        // 1. macOS 27 Liquid Glass 메인 컨텍스트 메뉴
        Positioned(
          left: menuLeft,
          top: menuTop,
          child: Container(
            width: 216,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E26).withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.16), width: 0.8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.isItemTarget ? _buildItemTargetMenu() : _buildDesktopMenu(),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 2. macOS 27 Liquid Glass 운영체제 전환 플라이아웃 서브메뉴
        if (_isOsSubmenuOpen && !widget.isItemTarget)
          Positioned(
            left: submenuLeft,
            top: submenuTop,
            child: Container(
              width: 216,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E26).withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.16), width: 0.8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuItem(
                          label: '콘솔 에디터 스튜디오',
                          icon: CupertinoIcons.slider_horizontal_3,
                          highlightColor: const Color(0xFF818CF8),
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('workspace');
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          label: 'Windows 11',
                          icon: CupertinoIcons.square_grid_2x2_fill,
                          highlightColor: const Color(0xFF00A4EF),
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('windows_11');
                          },
                        ),
                        _buildMenuItem(
                          label: 'Windows 10',
                          icon: CupertinoIcons.device_desktop,
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('windows_10');
                          },
                        ),
                        _buildMenuItem(
                          label: 'Windows 7 (Aero)',
                          icon: CupertinoIcons.device_desktop,
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('windows_7');
                          },
                        ),
                        _buildMenuItem(
                          label: 'Windows XP (Luna)',
                          icon: CupertinoIcons.device_desktop,
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('windows_xp');
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          label: 'macOS 27 (Golden Gate)',
                          imageAsset: 'assets/images/apple_logo.webp',
                          badge: '현재',
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('macos_27');
                          },
                        ),
                        _buildMenuItem(
                          label: 'macOS 15 (Sequoia)',
                          imageAsset: 'assets/images/apple_logo.webp',
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('macos_15');
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          label: 'SteamOS (Steam Deck)',
                          imageAsset: 'assets/images/steamdeck_icon.png',
                          highlightColor: const Color(0xFF67C1F5),
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('steamos');
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          label: 'Galaxy (One UI 9)',
                          icon: CupertinoIcons.device_phone_portrait,
                          highlightColor: const Color(0xFF10B981),
                          onTap: () {
                            widget.onClose();
                            widget.onSelectOs?.call('galaxy');
                          },
                        ),
                        _buildMenuItem(
                          label: 'iPhone (iOS 26)',
                          icon: CupertinoIcons.device_phone_portrait,
                          highlightColor: const Color(0xFFA855F7),
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

  List<Widget> _buildItemTargetMenu() {
    return [
      _buildMenuItem(
        label: '열기',
        icon: CupertinoIcons.folder_open,
        onTap: () {
          widget.onOpenItem?.call();
          widget.onClose();
        },
      ),
      _buildMenuItem(
        label: '이름 변경',
        icon: CupertinoIcons.pencil,
        onTap: () {
          widget.onRenameItem?.call();
          widget.onClose();
        },
      ),
      _buildMenuItem(
        label: '정보 가져오기',
        icon: CupertinoIcons.info_circle,
        onTap: widget.onClose,
      ),
      _buildDivider(),
      _buildMenuItem(
        label: '휴지통으로 이동',
        icon: CupertinoIcons.trash,
        highlightColor: const Color(0xFFEF4444),
        onTap: () {
          widget.onDeleteItem?.call();
          widget.onClose();
        },
      ),
    ];
  }

  List<Widget> _buildDesktopMenu() {
    return [
      _buildMenuItem(
        label: '새로운 폴더',
        icon: CupertinoIcons.folder_badge_plus,
        onHover: () => setState(() => _isOsSubmenuOpen = false),
        onTap: () {
          widget.onNewFolder();
          widget.onClose();
        },
      ),
      _buildMenuItem(
        label: '새로운 텍스트 문서',
        icon: CupertinoIcons.doc_text,
        onHover: () => setState(() => _isOsSubmenuOpen = false),
        onTap: () {
          widget.onNewDocument?.call();
          widget.onClose();
        },
      ),
      _buildDivider(),
      _buildMenuItem(
        label: '배경화면 변경...',
        icon: CupertinoIcons.photo,
        onHover: () => setState(() => _isOsSubmenuOpen = false),
        onTap: () {
          widget.onOpenWallpaperSettings();
          widget.onClose();
        },
      ),
      _buildMenuItem(
        label: '스택 사용',
        icon: CupertinoIcons.square_stack_3d_up,
        onHover: () => setState(() => _isOsSubmenuOpen = false),
        onTap: widget.onClose,
      ),
      _buildMenuItem(
        label: '보기 옵션 보기',
        icon: CupertinoIcons.slider_horizontal_3,
        onHover: () => setState(() => _isOsSubmenuOpen = false),
        onTap: widget.onClose,
      ),
      _buildDivider(),
      _buildMenuItem(
        label: '시스템 설정...',
        icon: CupertinoIcons.gear_alt_fill,
        onHover: () => setState(() => _isOsSubmenuOpen = false),
        onTap: () {
          widget.onOpenSettings();
          widget.onClose();
        },
      ),
      _buildMenuItem(
        label: '운영체제 전환',
        icon: CupertinoIcons.device_laptop,
        trailing: '›',
        highlightColor: const Color(0xFF60CDFF),
        isSelected: _isOsSubmenuOpen,
        onHover: () => setState(() => _isOsSubmenuOpen = true),
        onTap: () => setState(() => _isOsSubmenuOpen = !_isOsSubmenuOpen),
      ),
    ];
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      color: Colors.white.withValues(alpha: 0.1),
    );
  }

  Widget _buildMenuItem({
    required String label,
    IconData? icon,
    String? imageAsset,
    String? trailing,
    String? badge,
    Color? highlightColor,
    bool isSelected = false,
    VoidCallback? onHover,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover?.call(),
      child: Material(
        color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          hoverColor: const Color(0xFF3B82F6),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              children: [
                if (imageAsset != null)
                  Image.asset(imageAsset, width: 14, height: 14, fit: BoxFit.contain, color: isSelected ? Colors.white : (highlightColor ?? Colors.white70))
                else if (icon != null)
                  Icon(icon, size: 14, color: isSelected ? Colors.white : (highlightColor ?? Colors.white70)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : (highlightColor ?? Colors.white),
                      fontSize: 12,
                      fontWeight: (highlightColor != null || isSelected) ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF60CDFF).withValues(alpha: 0.6), width: 0.8),
                    ),
                    child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                if (trailing != null)
                  Text(
                    trailing,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
