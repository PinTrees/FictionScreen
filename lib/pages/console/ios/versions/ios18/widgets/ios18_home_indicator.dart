import 'package:flutter/material.dart';

/// iOS 18 하단 홈 바 (Home Indicator - 위로 스와이프하거나 탭 시 홈 화면 복귀)
class Ios18HomeIndicator extends StatelessWidget {
  final VoidCallback onHome;
  final bool isDark;

  const Ios18HomeIndicator({
    super.key,
    required this.onHome,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < -100) {
          onHome();
        }
      },
      onTap: onHome,
      child: Container(
        height: 24,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Container(
          width: 138,
          height: 5,
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
