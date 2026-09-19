import 'dart:async';
import 'package:flutter/material.dart';

/// 요소가 서서히 커지며 부드럽게 '뿅' 하고 나타나는 트렌디한 바운스 등장 애니메이션 위젯
class PopEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double startScale;
  final double startOffsetY;
  final Curve curve;
  final Curve fadeCurve;
  final bool autoStart;

  const PopEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 650),
    this.startScale = 0.96,
    this.startOffsetY = 0.0,
    this.curve = Curves.easeOutQuart,
    this.fadeCurve = Curves.easeOutQuart,
    this.autoStart = true,
  });

  @override
  State<PopEntrance> createState() => _PopEntranceState();
}

class _PopEntranceState extends State<PopEntrance> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.startScale,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.fadeCurve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.startOffsetY),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.autoStart) {
      if (widget.delay > Duration.zero) {
        _timer = Timer(widget.delay, () {
          if (mounted) _controller.forward();
        });
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            alignment: Alignment.center,
            child: Opacity(
              opacity: _opacityAnimation.value.clamp(0.0, 1.0),
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
