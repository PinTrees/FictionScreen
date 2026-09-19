import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows 10 순정 플랫 & 샤프 창 프레임 (직각 0px 모서리, 1px 액센트 보더, 직사각형 캡션 버튼)
class Win10WindowFrame extends StatefulWidget {
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
  final bool isMaximized;
  final bool isFocused;

  const Win10WindowFrame({
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
    this.isMaximized = false,
    this.isFocused = true,
  });

  @override
  State<Win10WindowFrame> createState() => _Win10WindowFrameState();
}

class _Win10WindowFrameState extends State<Win10WindowFrame> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool effectiveMaximized = widget.isMaximized ||
        (widget.width >= screenSize.width - 5 && widget.height >= screenSize.height - 45);

    // Windows 10 액센트 컬러: 활성화 시 #0078D7 (블루), 비활성화 시 #3E3E42 (다크 그레이)
    final borderColor = effectiveMaximized
        ? Colors.transparent
        : (widget.isFocused ? const Color(0xFF0078D7) : const Color(0xFF3E3E42));

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.zero, // Windows 10의 절대적인 특징: 0px 직각 모서리
        border: effectiveMaximized
            ? null
            : Border.all(
                color: borderColor,
                width: 1.0,
              ),
        boxShadow: effectiveMaximized
            ? const []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: widget.isFocused ? 0.50 : 0.28),
                  blurRadius: widget.isFocused ? 20 : 10,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        children: [
          // 1. Windows 10 순정 31px 타이틀바
          _buildTitleBar(effectiveMaximized),
          // 2. 창 내부 본문 (직각 0px)
          Expanded(
            child: Container(
              color: const Color(0xFF191919),
              child: widget.child,
            ),
          ),
        ],
      ),
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
        height: 31,
        color: widget.isFocused ? const Color(0xFF2B2B2B) : const Color(0xFF1F1F1F),
        child: Row(
          children: [
            // 커스텀 타이틀 위젯 (리본 탭 등) 또는 기본 아이콘 + 제목
            if (widget.customTitleWidget != null)
              Expanded(child: widget.customTitleWidget!)
            else ...[
              const SizedBox(width: 8),
              if (widget.iconAsset != null)
                Image.asset(widget.iconAsset!, width: 16, height: 16, fit: BoxFit.contain)
              else if (widget.iconData != null)
                Icon(widget.iconData, size: 15, color: widget.isFocused ? const Color(0xFF60A5FA) : Colors.white60)
              else
                Icon(CupertinoIcons.app_fill, size: 15, color: widget.isFocused ? Colors.white70 : Colors.white38),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.isFocused ? Colors.white : Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Segoe UI',
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ],

            // 우측 Windows 10 직사각형 캡션 버튼 3종 (최소화, 최대화/이전크기, 닫기)
            _Win10CaptionButton(
              width: 46,
              height: 31,
              icon: Container(
                width: 10,
                height: 1,
                color: widget.isFocused ? Colors.white : Colors.white60,
              ),
              hoverColor: const Color(0xFF3F3F41),
              onTap: widget.onMinimize,
            ),
            _Win10CaptionButton(
              width: 46,
              height: 31,
              icon: isMaximized
                  ? _buildWin10RestoreIcon()
                  : _buildWin10MaximizeIcon(),
              hoverColor: const Color(0xFF3F3F41),
              onTap: widget.onMaximize,
            ),
            _Win10CaptionButton(
              width: 46,
              height: 31,
              icon: Icon(
                CupertinoIcons.xmark,
                size: 10.5,
                color: widget.isFocused ? Colors.white : Colors.white60,
              ),
              hoverColor: const Color(0xFFE81123), // Windows 10 시그니처 레드
              pressColor: const Color(0xFFF1707A),
              onTap: widget.onClose,
            ),
          ],
        ),
      ),
    );
  }

  // Windows 10 최대화 아이콘: 모서리 각진 10x10 정사각형
  Widget _buildWin10MaximizeIcon() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isFocused ? Colors.white : Colors.white60,
          width: 1.0,
        ),
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  // Windows 10 이전 크기로 복원 아이콘: 각진 겹친 사각형
  Widget _buildWin10RestoreIcon() {
    final color = widget.isFocused ? Colors.white : Colors.white60;
    return SizedBox(
      width: 10,
      height: 10,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 1.0),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: widget.isFocused ? const Color(0xFF2B2B2B) : const Color(0xFF1F1F1F),
                border: Border.all(color: color, width: 1.0),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Windows 10 직사각형 캡션 버튼 (풀-하이트 밀착, 칼각 호버)
class _Win10CaptionButton extends StatefulWidget {
  final double width;
  final double height;
  final Widget icon;
  final Color hoverColor;
  final Color? pressColor;
  final VoidCallback? onTap;

  const _Win10CaptionButton({
    required this.width,
    required this.height,
    required this.icon,
    required this.hoverColor,
    this.pressColor,
    this.onTap,
  });

  @override
  State<_Win10CaptionButton> createState() => _Win10CaptionButtonState();
}

class _Win10CaptionButtonState extends State<_Win10CaptionButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.transparent;
    if (_isPressed) {
      bg = widget.pressColor ?? widget.hoverColor.withValues(alpha: 0.8);
    } else if (_isHovered) {
      bg = widget.hoverColor;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          color: bg,
          alignment: Alignment.center,
          child: widget.icon,
        ),
      ),
    );
  }
}
