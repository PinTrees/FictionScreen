import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';

/// Apple iOS 26 공식 리퀴드 글래스 수직 인터랙티브 캡슐 슬라이더 (화면 밝기 & 음량 볼륨)
class Ios26VerticalSlider extends StatelessWidget {
  final double value;
  final IconData icon;
  final Color iconColor;
  final ValueChanged<double> onChanged;

  const Ios26VerticalSlider({
    super.key,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const double sliderHeight = 160.0;
    const double sliderRadius = 32.0;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final delta = -details.primaryDelta! / sliderHeight;
        onChanged((value + delta).clamp(0.0, 1.0));
      },
      child: Ios26LiquidGlass(
        height: sliderHeight,
        borderRadius: sliderRadius,
        blurSigma: 36,
        tintColor: const Color(0xFF0F2644),
        hasCornerGlow: false,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 하단에서부터 채워지는 순백색 액체 필러
            FractionallySizedBox(
              heightFactor: value.clamp(0.0, 1.0),
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(sliderRadius),
                ),
              ),
            ),

            // 하단 고정 상징 아이콘 (채워진 흰색 위에서는 유색 아이콘 표시)
            Positioned(
              bottom: 16,
              child: Icon(
                icon,
                color: value > 0.18 ? iconColor : Colors.white70,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
