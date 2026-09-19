import 'dart:ui';
import 'package:flutter/material.dart';
import '../windows/versions/win11/widgets/win11_window_frame.dart';
import '../windows/versions/win10/widgets/win10_window_frame.dart';
import '../windows/versions/win7/widgets/win7_window_frame.dart';
import '../windows/versions/winxp/widgets/winxp_window_frame.dart';

enum WindowStyle {
  macos,
  windows,
  windows10,
  windows7,
  windowsXp,
}

/// 가상 OS 통합 윈도우 창 프레임
/// - 각 OS 버전에 맞는 순정 헤드(타이틀바, 캡션 버튼, 외곽선, 모서리 곡률)를 완벽 지원
class OsWindowFrame extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? iconAsset;
  final WindowStyle style;
  final Widget child;
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final Function(DragEndDetails)? onTitleDragEnd;
  final double width;
  final double height;
  final bool? isMaximized;

  const OsWindowFrame({
    super.key,
    required this.title,
    this.icon,
    this.iconAsset,
    required this.style,
    required this.child,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.onTitleDragEnd,
    this.width = 680,
    this.height = 480,
    this.isMaximized,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool effectiveMaximized = isMaximized ??
        (width >= screenSize.width - 5 && height >= screenSize.height - 55);

    switch (style) {
      case WindowStyle.windows:
        return Win11WindowFrame(
          title: title,
          iconAsset: iconAsset,
          iconData: icon,
          width: width,
          height: height,
          isMaximized: effectiveMaximized,
          onClose: onClose,
          onMinimize: onMinimize,
          onMaximize: onMaximize,
          onSnapLayout: onSnapLayout,
          onTitleDragStart: onTitleDragStart,
          onTitleDragUpdate: onTitleDragUpdate,
          onTitleDragEnd: onTitleDragEnd,
          child: child,
        );

      case WindowStyle.windows10:
        return Win10WindowFrame(
          title: title,
          iconAsset: iconAsset,
          iconData: icon,
          width: width,
          height: height,
          isMaximized: effectiveMaximized,
          onClose: onClose,
          onMinimize: onMinimize,
          onMaximize: onMaximize,
          onTitleDragStart: onTitleDragStart,
          onTitleDragUpdate: onTitleDragUpdate,
          onTitleDragEnd: onTitleDragEnd,
          child: child,
        );

      case WindowStyle.windows7:
        return Win7WindowFrame(
          title: title,
          iconAsset: iconAsset,
          iconData: icon,
          width: width,
          height: height,
          isMaximized: effectiveMaximized,
          onClose: onClose,
          onMinimize: onMinimize,
          onMaximize: onMaximize,
          onSnapLayout: onSnapLayout,
          onTitleDragStart: onTitleDragStart,
          onTitleDragUpdate: onTitleDragUpdate,
          child: child,
        );

      case WindowStyle.windowsXp:
        return WinXpWindowFrame(
          title: title,
          iconAsset: iconAsset,
          iconData: icon,
          width: width,
          height: height,
          isMaximized: effectiveMaximized,
          onClose: onClose,
          onMinimize: onMinimize,
          onMaximize: onMaximize,
          onTitleDragStart: onTitleDragStart,
          onTitleDragUpdate: onTitleDragUpdate,
          child: child,
        );

      case WindowStyle.macos:
        return _buildMacWindow(context, effectiveMaximized);
    }
  }

  Widget _buildMacWindow(BuildContext context, bool effectiveMaximized) {
    final borderRadius = effectiveMaximized
        ? BorderRadius.zero
        : BorderRadius.circular(12);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF161824).withValues(alpha: 0.92),
          borderRadius: borderRadius,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1.0,
          ),
          boxShadow: effectiveMaximized
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Column(
              children: [
                _buildMacTitleBar(),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacTitleBar() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: onTitleDragStart,
      onPanUpdate: onTitleDragUpdate,
      onPanEnd: onTitleDragEnd,
      child: Container(
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
                    if (iconAsset != null) ...[
                      Image.asset(iconAsset!, width: 14, height: 14),
                      const SizedBox(width: 6),
                    ] else if (icon != null) ...[
                      Icon(icon, size: 14, color: Colors.white70),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 54),
          ],
        ),
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
}
