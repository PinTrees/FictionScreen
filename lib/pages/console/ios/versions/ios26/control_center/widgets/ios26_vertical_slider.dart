import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';

/// Apple iOS 26 리퀴드 글래스 수직 인터랙티브 캡슐 슬라이더 (화면 밝기 & 음량 볼륨)
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

  @override
  Widget build(BuildContext context) {
    final radius = width / 2.0;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final delta = -details.primaryDelta! / height;
        onChanged((value + delta).clamp(0.0, 1.0));
      },
      child: Ios26LiquidGlass(
        width: width,
        height: height,
        borderRadius: radius,
        blurSigma: 36,
        tintColor: const Color(0xFF0F2644),
        hasCornerGlow: false,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 하단에서부터 채워지는 리퀴드 백색 필러
            FractionallySizedBox(
              heightFactor: value.clamp(0.0, 1.0),
              alignment: Alignment.bottomCenter,
              child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius))),
            ),

            // 하단 고정 상징 아이콘 (채워진 흰색 위 여부에 따라 색상 전환)
            Positioned(
              bottom: height * 0.10,
              child: iconBuilder(value > 0.18),
            ),
          ],
        ),
      ),
    );
  }
}
