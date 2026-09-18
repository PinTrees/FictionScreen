import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'win11_snap_layouts.dart';

/// Windows 11 순정 미카(Mica) 글래스 창 프레임 및 타이틀바
class Win11WindowFrame extends StatefulWidget {
  final String title;
  final String? iconAsset;
  final IconData? iconData;
  final Widget child;
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final Function(DragEndDetails)? onTitleDragEnd;
  final Widget? customTitleWidget;
  final double width;
  final double height;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final bool isMaximized;

  const Win11WindowFrame({
    super.key,
    required this.title,
    this.iconAsset,
    this.iconData,
    required this.child,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.onTitleDragEnd,
    this.customTitleWidget,
    this.width = 820,
    this.height = 540,
    this.onSnapLayout,
    this.isMaximized = false,
  });

  @override
  State<Win11WindowFrame> createState() => _Win11WindowFrameState();
}

class _Win11WindowFrameState extends State<Win11WindowFrame> {
  bool _showSnapLayouts = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool effectiveMaximized = widget.isMaximized ||
        (widget.width >= screenSize.width - 5 && widget.height >= screenSize.height - 55);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color(0xFF202020).withValues(alpha: 0.94),
            borderRadius: effectiveMaximized ? BorderRadius.zero : BorderRadius.circular(12),
            border: effectiveMaximized
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                    width: 1,
                  ),
            boxShadow: effectiveMaximized
                ? const []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.55),
                      blurRadius: 36,
                      spreadRadius: 2,
                      offset: const Offset(0, 14),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: effectiveMaximized ? BorderRadius.zero : BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Column(
                children: [
                  // 1. Windows 11 상단 타이틀바
                  _buildTitleBar(effectiveMaximized),
                  // 2. 창 내부 본문
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ),
        ),

        // 최대화 버튼 호버 시 표시되는 스냅 레이아웃 팝업
        if (_showSnapLayouts)
          Positioned(
            right: 48,
            top: 42,
            child: MouseRegion(
              onEnter: (_) => setState(() => _showSnapLayouts = true),
              onExit: (_) => setState(() => _showSnapLayouts = false),
              child: Win11SnapLayoutsPopup(
                onSelectZone: (layout, zone) {
                  setState(() => _showSnapLayouts = false);
                  widget.onSnapLayout?.call(layout, zone);
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTitleBar(bool isMaximized) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: widget.onTitleDragStart,
      onPanUpdate: widget.onTitleDragUpdate,
      onPanEnd: widget.onTitleDragEnd,
      onDoubleTap: widget.onMaximize,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          border: Border(
            bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        child: Row(
          children: [
            // 커스텀 타이틀 영역(예: 파일 탐색기 탭) 또는 기본 앱 아이콘 & 이름
            if (widget.customTitleWidget != null)
              Expanded(child: widget.customTitleWidget!)
            else ...[
              const SizedBox(width: 12),
              if (widget.iconAsset != null)
                Image.asset(widget.iconAsset!, width: 16, height: 16)
              else if (widget.iconData != null)
                Icon(widget.iconData, size: 16, color: const Color(0xFF60A5FA))
              else
                const Icon(CupertinoIcons.app_fill, size: 16, color: Colors.white70),
              const SizedBox(width: 10),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
            ],

            // 우측 3버튼 컨트롤 (—, □ / ❐, ✕)
            _buildWindowButton(
              icon: const Icon(CupertinoIcons.minus, size: 10, color: Colors.white),
              onTap: widget.onMinimize,
            ),
            MouseRegion(
              onEnter: (_) => setState(() => _showSnapLayouts = true),
              onExit: (_) {
                // 약간의 딜레이를 주어 팝업으로 마우스 이동 허용
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted && !_showSnapLayouts) {
                    setState(() => _showSnapLayouts = false);
                  }
                });
              },
              child: _buildWindowButton(
                icon: isMaximized ? _buildRestoreIcon() : _buildMaximizeIcon(),
                onTap: widget.onMaximize,
              ),
            ),
            _buildWindowButton(
              icon: const Icon(CupertinoIcons.xmark, size: 10, color: Colors.white),
              hoverColor: const Color(0xFFE81123),
              onTap: widget.onClose,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaximizeIcon() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }

  Widget _buildRestoreIcon() {
    return SizedBox(
      width: 10,
      height: 10,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 7.5,
              height: 7.5,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 7.5,
              height: 7.5,
              decoration: BoxDecoration(
                color: const Color(0xFF202020),
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowButton({
    required Widget icon,
    VoidCallback? onTap,
    Color? hoverColor,
  }) {
    return _Win11TitleButton(
      icon: icon,
      hoverColor: hoverColor ?? Colors.white.withValues(alpha: 0.1),
      onTap: onTap,
    );
  }
}

class _Win11TitleButton extends StatefulWidget {
  final Widget icon;
  final Color hoverColor;
  final VoidCallback? onTap;

  const _Win11TitleButton({
    required this.icon,
    required this.hoverColor,
    this.onTap,
  });

  @override
  State<_Win11TitleButton> createState() => _Win11TitleButtonState();
}

class _Win11TitleButtonState extends State<_Win11TitleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 46,
          height: 40,
          color: _isHovered ? widget.hoverColor : Colors.transparent,
          child: Center(child: widget.icon),
        ),
      ),
    );
  }
}
