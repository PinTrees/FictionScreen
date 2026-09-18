import 'dart:math' as math;
import 'package:flutter/material.dart';

/// iOS 26 홈스크린 앱 아이콘 흔들림(Jiggle) 애니메이션 위젯
class Ios26Jiggle extends StatefulWidget {
  final Widget child;
  final bool isJiggling;
  final int index;

  const Ios26Jiggle({
    super.key,
    required this.child,
    required this.isJiggling,
    this.index = 0,
  });

  @override
  State<Ios26Jiggle> createState() => _Ios26JiggleState();
}

class _Ios26JiggleState extends State<Ios26Jiggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );
    if (widget.isJiggling) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant Ios26Jiggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isJiggling != oldWidget.isJiggling) {
      if (widget.isJiggling) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isJiggling) {
      return widget.child;
    }

    final phase = (widget.index * 0.28) % 1.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = (_controller.value + phase) % 1.0;
        final angle = math.sin(progress * 2 * math.pi) * 0.038;
        final dx = math.cos(progress * 2 * math.pi) * 1.0;
        final dy = math.sin(progress * 2 * math.pi) * 0.8;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Transform.rotate(
            angle: angle,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
