import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung Galaxy One UI 9 상단 상태바 (펀치홀 카메라 및 실시간 드래그 다운 연동)
class OneUi9StatusBar extends StatelessWidget {
  final String timeString;
  final GestureDragStartCallback? onVerticalDragStart;
  final GestureDragUpdateCallback? onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;
  final VoidCallback? onTap;

  const OneUi9StatusBar({
    super.key,
    required this.timeString,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onTap: onTap,
      child: SizedBox(
        height: 44,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(timeString, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.2)),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.wifi, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  _buildSignalBars(),
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 0.8),
                    ),
                    child: const Text('100', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, height: 1.0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalBars() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(width: 2.2, height: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1))),
        const SizedBox(width: 1.5),
        Container(width: 2.2, height: 6.5, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1))),
        const SizedBox(width: 1.5),
        Container(width: 2.2, height: 9, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1))),
        const SizedBox(width: 1.5),
        Container(width: 2.2, height: 11.5, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1))),
      ],
    );
  }
}
