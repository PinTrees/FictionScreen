import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iPhone iOS 상단 다이내믹 아일랜드 & 상태바
class IosStatusBar extends StatelessWidget {
  final String timeString;

  const IosStatusBar({
    super.key,
    required this.timeString,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 시간
            Text(
              timeString,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: -0.2,
              ),
            ),

            // Dynamic Island Pill
            Container(
              width: 96,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),

            // 상태 아이콘들
            const Row(
              children: [
                Icon(CupertinoIcons.antenna_radiowaves_left_right, color: Colors.white, size: 14),
                SizedBox(width: 5),
                Icon(CupertinoIcons.wifi, color: Colors.white, size: 15),
                SizedBox(width: 5),
                Icon(CupertinoIcons.battery_full, color: Colors.white, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}