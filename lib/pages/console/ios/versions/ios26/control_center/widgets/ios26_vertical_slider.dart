import 'dart:ui';
import 'package:flutter/material.dart';

/// Apple iOS 26 리퀴드 글래스 수직 인터랙티브 캡슐 슬라이더 (화면 밝기 & 음량 볼륨)
/// - 하단에서부터 정확히 채워지는 백색 필러
/// - 드래그/터치 좌표 1:1 직관적 연동 (위로 올리면 증가, 아래로 내리면 감소)
class Ios26VerticalSlider extends StatelessWidget {
  final double width;
  final double height;
  final double value;
  final Widget Function(bool isOnFill) iconBuilder;
  final ValueChanged<double> onChanged;

  const Ios26VerticalSlider({
    super.key,
    required this.width,
    required this.height,
    required this.value,
    required this.iconBuilder,
    required this.onChanged,
  });

  void _handleTouch(double dy) {
    // dy: 0(최상단 -> 100% 최대), height(최하단 -> 0% 최소)
    final normalized = (1.0 - (dy / height)).clamp(0.0, 1.0);
    onChanged(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final radius = width / 2.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) => _handleTouch(details.localPosition.dy),
      onVerticalDragStart: (details) => _handleTouch(details.localPosition.dy),
      onVerticalDragUpdate: (details) => _handleTouch(details.localPosition.dy),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.20),
            width: 0.8,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.25),
                    Colors.white.withValues(alpha: 0.10),
                    Colors.white.withValues(alpha: 0.16),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // 1. 하단에서부터 위로 차오르는 순백색 리퀴드 필러
                  FractionallySizedBox(
                    heightFactor: value.clamp(0.0, 1.0),
                    widthFactor: 1.0,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                    ),
                  ),

                  // 2. 하단 상징 아이콘 (채워진 높이에 따라 색상 전환)
                  Positioned(
                    bottom: height * 0.09,
                    child: IgnorePointer(
                      child: iconBuilder(value > 0.16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
