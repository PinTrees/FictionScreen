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
            // 좌측 영역 (시각, AI 나우 인디케이터)
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Row(
                children: [
                  Text(timeString, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
                  const SizedBox(width: 8),
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF818CF8), shape: BoxShape.circle)),
                ],
              ),
            ),

            const Spacer(),

            // 중앙 펀치홀 카메라 컷아웃
            Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 0.8),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 4, spreadRadius: 0.5)],
              ),
            ),

            const Spacer(),

            // 우측 영역 (VoLTE, 5G, Wi-Fi, 74% 배터리)
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(border: Border.all(color: Colors.white70, width: 0.8), borderRadius: BorderRadius.circular(3)),
                    child: const Text('5G', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 5),
                  const Icon(CupertinoIcons.wifi, size: 14, color: Colors.white),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(6)),
                    child: const Row(
                      children: [
                        Text('74', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        SizedBox(width: 2),
                        Icon(CupertinoIcons.bolt_fill, size: 9, color: Color(0xFF10B981)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
