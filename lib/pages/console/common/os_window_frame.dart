import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum WindowStyle {
  macos,
  windows,
  windows10,
}

/// 현실적인 가상 OS 윈도우 창 프레임
class OsWindowFrame extends StatelessWidget {
  final String title;
  final IconData? icon;
  final WindowStyle style;
  final Widget child;
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final Function(DragEndDetails)? onTitleDragEnd;
  final double width;
  final double height;

  const OsWindowFrame({
    super.key,
    required this.title,
    this.icon,
    required this.style,
    required this.child,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.onTitleDragEnd,
    this.width = 680,
    this.height = 480,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isMaximized = width >= screenSize.width - 5 && height >= screenSize.height - 55;
    final borderRadius = isMaximized || style == WindowStyle.windows10
        ? BorderRadius.zero
        : BorderRadius.circular(style == WindowStyle.macos ? 12 : 8);

    final borderColor = style == WindowStyle.windows10
        ? const Color(0xFF0078D7)
        : Colors.white.withValues(alpha: 0.15);

    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: style == WindowStyle.windows10 ? const Color(0xFF1F1F1F) : const Color(0xFF1E212B).withValues(alpha: 0.94),
          borderRadius: borderRadius,
          border: isMaximized
              ? null
              : Border.all(
                  color: borderColor,
                  width: 1.0,
                ),
          boxShadow: isMaximized
              ? const []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Column(
              children: [
                // 윈도우 타이틀바
                _buildTitleBar(),
                // 내부 본문
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: onTitleDragStart,
      onPanUpdate: onTitleDragUpdate,
      onPanEnd: onTitleDragEnd,
      child: style == WindowStyle.macos
          ? _buildMacTitleBar()
          : (style == WindowStyle.windows10
              ? _buildWindows10TitleBar()
              : _buildWindowsTitleBar()),
    );
  }

  Widget _buildMacTitleBar() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          // macOS 신호등 버튼 (빨, 노, 초)
          Row(
            children: [
              _buildMacTrafficLight(const Color(0xFFFF5F56), onClose),
              const SizedBox(width: 8),
              _buildMacTrafficLight(const Color(0xFFFFBD2E), onMinimize ?? onClose),
              const SizedBox(width: 8),
              _buildMacTrafficLight(const Color(0xFF27C93F), onMaximize ?? () {}),
            ],
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 54), // 좌측 신호등과 밸런스 유지용
        ],
      ),
    );
  }

  Widget _buildWindows10TitleBar() {
    return Container(
      height: 31,
      color: const Color(0xFF2B2B2B),
      child: Row(
        children: [
          const SizedBox(width: 8),
          if (icon != null) ...[
            Icon(icon, size: 14, color: const Color(0xFF60A5FA)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Segoe UI',
              ),
            ),
          ),
          _Win10TitleBarButton(
            iconWidget: Container(width: 10, height: 1, color: Colors.white),
            onTap: onMinimize ?? onClose,
          ),
          _Win10TitleBarButton(
            iconWidget: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.zero,
              ),
            ),
            onTap: onMaximize ?? () {},
          ),
          _Win10TitleBarButton(
            iconWidget: const Icon(CupertinoIcons.xmark, size: 10.5, color: Colors.white),
            onTap: onClose,
            isClose: true,
          ),
        ],
      ),
    );
  }

  Widget _buildWindowsTitleBar() {
    return Container(
      height: 36,
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          // 윈도우 우측 조작 버튼 (최소화, 최대화, 닫기)
          _buildWindowsButton(CupertinoIcons.minus, onMinimize ?? onClose),
          _buildWindowsButton(CupertinoIcons.square, onMaximize ?? () {}),
          _buildWindowsButton(
            CupertinoIcons.xmark,
            onClose,
            isClose: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMacTrafficLight(Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withValues(alpha: 0.2), width: 0.5),
        ),
      ),
    );
  }

  Widget _buildWindowsButton(IconData icon, VoidCallback onTap, {bool isClose = false}) {
    return InkWell(
      onTap: onTap,
      hoverColor: isClose ? const Color(0xFFE81123) : Colors.white.withValues(alpha: 0.1),
      child: SizedBox(
        width: 44,
        height: 36,
        child: Center(
          child: Icon(
            icon,
            size: 12,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _Win10TitleBarButton extends StatefulWidget {
  final Widget iconWidget;
  final VoidCallback onTap;
  final bool isClose;

  const _Win10TitleBarButton({
    required this.iconWidget,
    required this.onTap,
    this.isClose = false,
  });

  @override
  State<_Win10TitleBarButton> createState() => _Win10TitleBarButtonState();
}

class _Win10TitleBarButtonState extends State<_Win10TitleBarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoverBg = widget.isClose ? const Color(0xFFE81123) : const Color(0xFF3F3F41);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 46,
          height: 31,
          color: _isHovered ? hoverBg : Colors.transparent,
          alignment: Alignment.center,
          child: widget.iconWidget,
        ),
      ),
    );
  }
}
