import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum WindowStyle {
  macos,
  windows,
  windows10,
  windows7,
  windowsXp,
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

    final borderColor = style == WindowStyle.windowsXp
        ? const Color(0xFF0055EA)
        : (style == WindowStyle.windows10
            ? const Color(0xFF0078D7)
            : (style == WindowStyle.windows7
                ? Colors.white.withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.15)));

    final backgroundColor = style == WindowStyle.windowsXp
        ? const Color(0xFFECE9D8)
        : (style == WindowStyle.windows10
            ? const Color(0xFF1F1F1F)
            : (style == WindowStyle.windows7
                ? const Color(0xFF4578A8).withValues(alpha: 0.65)
                : const Color(0xFF161824).withValues(alpha: 0.92)));

    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
          boxShadow: isMaximized
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  ),
                  if (style == WindowStyle.windows7)
                    BoxShadow(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                      blurRadius: 10,
                      spreadRadius: 1,
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
          : (style == WindowStyle.windowsXp
              ? _buildWindowsXpTitleBar()
              : (style == WindowStyle.windows7
                  ? _buildWindows7TitleBar()
                  : (style == WindowStyle.windows10
                      ? _buildWindows10TitleBar()
                      : _buildWindowsTitleBar()))),
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

  Widget _buildWindows7TitleBar() {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 10, right: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF75AADB).withValues(alpha: 0.85),
            const Color(0xFF4578A8).withValues(alpha: 0.70),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Segoe UI',
              shadows: [
                Shadow(color: Colors.white, blurRadius: 10),
                Shadow(color: Colors.white, blurRadius: 4),
              ],
            ),
          ),
          const Spacer(),
          // 에어로 캡슐 버튼
          Container(
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 0.8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Win7AeroCaptionButton(
                  width: 28,
                  onTap: onMinimize ?? onClose,
                  child: Container(width: 8, height: 2, color: Colors.black87),
                ),
                _Win7AeroCaptionButton(
                  width: 28,
                  onTap: onMaximize ?? () {},
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87, width: 1.0),
                    ),
                  ),
                ),
                _Win7AeroCaptionButton(
                  width: 44,
                  isClose: true,
                  onTap: onClose,
                  child: const Icon(CupertinoIcons.xmark, size: 11, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowsXpTitleBar() {
    return Container(
      height: 29,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0058EE),
            Color(0xFF3593FF),
            Color(0xFF288EFF),
            Color(0xFF0055EA),
            Color(0xFF0040C8),
          ],
          stops: [0.0, 0.15, 0.4, 0.7, 1.0],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Segoe UI',
                shadows: [
                  Shadow(color: Color(0xFF002266), blurRadius: 2, offset: Offset(1, 1)),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildWinXpCaptionBtn(const Icon(CupertinoIcons.minus, size: 10, color: Colors.white), onMinimize ?? onClose, false),
              const SizedBox(width: 2),
              _buildWinXpCaptionBtn(const Icon(CupertinoIcons.square, size: 10, color: Colors.white), onMaximize ?? () {}, false),
              const SizedBox(width: 2),
              _buildWinXpCaptionBtn(const Icon(CupertinoIcons.xmark, size: 10, color: Colors.white), onClose, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWinXpCaptionBtn(Widget iconWidget, VoidCallback onTap, bool isClose) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 21,
        height: 21,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isClose
                ? const [Color(0xFFE2614E), Color(0xFFC7301B), Color(0xFFA81C08)]
                : const [Color(0xFF3F8CFF), Color(0xFF1E6BE6), Color(0xFF0F50C2)],
          ),
          border: Border.all(color: Colors.white, width: 1),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 1, offset: Offset(1, 1))],
        ),
        alignment: Alignment.center,
        child: iconWidget,
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

class _Win7AeroCaptionButton extends StatefulWidget {
  final double width;
  final Widget child;
  final VoidCallback? onTap;
  final bool isClose;

  const _Win7AeroCaptionButton({
    required this.width,
    required this.child,
    required this.onTap,
    this.isClose = false,
  });

  @override
  State<_Win7AeroCaptionButton> createState() => _Win7AeroCaptionButtonState();
}

class _Win7AeroCaptionButtonState extends State<_Win7AeroCaptionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.isClose
                  ? (_isHovered
                      ? [const Color(0xFFFF5C5C), const Color(0xFFD61818)]
                      : [const Color(0xFFE27474).withValues(alpha: 0.85), const Color(0xFFA82E2E).withValues(alpha: 0.9)])
                  : (_isHovered
                      ? [const Color(0xFFBFE0FF), const Color(0xFF6EB7F5)]
                      : [Colors.white.withValues(alpha: 0.45), Colors.white.withValues(alpha: 0.15)]),
            ),
            border: widget.isClose
                ? null
                : const Border(right: BorderSide(color: Colors.black12, width: 0.8)),
            boxShadow: (widget.isClose && _isHovered)
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF3B30).withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}
