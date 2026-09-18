import 'dart:math' as math;
import 'package:flutter/material.dart';

/// iOS 18 홈스크린 앱 아이콘 흔들림(Jiggle) 애니메이션 위젯
/// - 실제 아이폰의 홈 화면 편집 모드 물리 진동 효과
/// - 각 아이콘 인덱스별 위상차(Phase Offset)를 적용하여 유기적이고 자연스러운 흔들림
class Ios18Jiggle extends StatefulWidget {
  final Widget child;
  final bool isJiggling;
  final int index;

  const Ios18Jiggle({
    super.key,
    required this.child,
    required this.isJiggling,
    this.index = 0,
  });

  @override
  State<Ios18Jiggle> createState() => _Ios18JiggleState();
}

class _Ios18JiggleState extends State<Ios18Jiggle>
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
  void didUpdateWidget(covariant Ios18Jiggle oldWidget) {
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

    // 인덱스 기반 자연스러운 위상차
    final phase = (widget.index * 0.28) % 1.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = (_controller.value + phase) % 1.0;
        // -2.2도 ~ +2.2도 자연스러운 회전
        final angle = math.sin(progress * 2 * math.pi) * 0.038;
        // 미세 상하좌우 떨림 (1.0px / 0.8px)
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
