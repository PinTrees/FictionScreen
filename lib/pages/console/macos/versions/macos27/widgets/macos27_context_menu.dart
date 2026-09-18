import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// macOS 27 Golden Gate 데스크톱 및 항목 우클릭 컨텍스트 메뉴
/// - Liquid Glass 반투명 블러 머티리얼
/// - 바탕화면 우클릭: 새로운 폴더, 새로운 텍스트 문서, 배경화면 변경, 시스템 설정, OS 전환
/// - 폴더/파일 우클릭: 열기, 이름 변경, 정보 가져오기, 휴지통으로 이동 (삭제)
class Macos27ContextMenu extends StatelessWidget {
  final Offset position;
  final VoidCallback onNewFolder;
  final VoidCallback? onNewDocument;
  final VoidCallback onOpenWallpaperSettings;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenOsSwitch;
  final VoidCallback? onOpenItem;
  final VoidCallback? onRenameItem;
  final VoidCallback? onDeleteItem;
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
    this.isItemTarget = false,
    this.targetTitle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double menuLeft = position.dx.clamp(10.0, screenSize.width - 230.0);
    final double menuTop = position.dy.clamp(10.0, screenSize.height - (isItemTarget ? 210.0 : 310.0));

    return Stack(
      children: [
        // 외부 영역 탭 시 닫기
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            onSecondaryTap: onClose,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),

        // macOS 27 Liquid Glass 컨텍스트 메뉴
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
                    children: isItemTarget ? _buildItemTargetMenu() : _buildDesktopMenu(),
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
          onOpenItem?.call();
          onClose();
        },
      ),
      _buildMenuItem(
        label: '이름 변경',
        icon: CupertinoIcons.pencil,
        onTap: () {
          onRenameItem?.call();
          onClose();
        },
      ),
      _buildMenuItem(
        label: '정보 가져오기',
        icon: CupertinoIcons.info_circle,
        onTap: onClose,
      ),
      _buildDivider(),
      _buildMenuItem(
        label: '휴지통으로 이동',
        icon: CupertinoIcons.trash,
        highlightColor: const Color(0xFFEF4444),
        onTap: () {
          onDeleteItem?.call();
          onClose();
        },
      ),
    ];
  }

  List<Widget> _buildDesktopMenu() {
    return [
      _buildMenuItem(
        label: '새로운 폴더',
        icon: CupertinoIcons.folder_badge_plus,
        onTap: () {
          onNewFolder();
          onClose();
        },
      ),
      _buildMenuItem(
        label: '새로운 텍스트 문서',
        icon: CupertinoIcons.doc_text,
        onTap: () {
          onNewDocument?.call();
          onClose();
        },
      ),
      _buildDivider(),
      _buildMenuItem(
        label: '배경화면 변경...',
        icon: CupertinoIcons.photo,
        onTap: () {
          onOpenWallpaperSettings();
          onClose();
        },
      ),
      _buildMenuItem(
        label: '스택 사용',
        icon: CupertinoIcons.square_stack_3d_up,
        onTap: onClose,
      ),
      _buildMenuItem(
        label: '보기 옵션 보기',
        icon: CupertinoIcons.slider_horizontal_3,
        onTap: onClose,
      ),
      _buildDivider(),
      _buildMenuItem(
        label: '시스템 설정...',
        icon: CupertinoIcons.gear_alt_fill,
        onTap: () {
          onOpenSettings();
          onClose();
        },
      ),
      _buildMenuItem(
        label: '운영체제 전환...',
        icon: CupertinoIcons.device_laptop,
        highlightColor: const Color(0xFF60CDFF),
        onTap: () {
          onOpenOsSwitch();
          onClose();
        },
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
    required IconData icon,
    Color? highlightColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        hoverColor: const Color(0xFF3B82F6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            children: [
              Icon(icon, size: 14, color: highlightColor ?? Colors.white70),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: highlightColor ?? Colors.white,
                    fontSize: 12,
                    fontWeight: highlightColor != null ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
