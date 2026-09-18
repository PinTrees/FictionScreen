import 'package:flutter/material.dart';

/// 아이콘 및 버튼 클릭 시 쫀득한 스케일 다운 & 바운스 피드백을 제공하는 공통 인터랙티브 래퍼
class ScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSecondaryTap;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final double pressedScale;
  final Duration duration;
  final Curve curve;
  final HitTestBehavior behavior;

  const ScaleButton({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.onTapDown,
    this.onTapUp,
    this.pressedScale = 0.90,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeOutCubic,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    widget.onTapDown?.call(details);
    if (widget.onTap != null || widget.onDoubleTap != null) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    widget.onTapUp?.call(details);
    if (_isPressed) setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (_isPressed) setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onSecondaryTap: widget.onSecondaryTap,
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
