import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';

/// iOS 26 리퀴드 글래스 수직 인터랙티브 슬라이더 (화면 밝기 및 음량 볼륨)
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight.isFinite ? constraints.maxHeight : 154.0;
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            final delta = -details.primaryDelta! / height;
            onChanged((value + delta).clamp(0.0, 1.0));
          },
          child: Ios26LiquidGlass(
            height: height,
            borderRadius: 33,
            blurSigma: 34,
            hasCornerGlow: false,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                FractionallySizedBox(
                  heightFactor: value,
                  widthFactor: 1.0,
                  child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(33))),
                ),
                Positioned(
                  bottom: 16,
                  child: Icon(icon, color: value > 0.35 ? iconColor : Colors.white70, size: 24),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
