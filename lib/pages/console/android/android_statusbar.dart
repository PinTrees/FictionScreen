import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung Galaxy OneUI 상단 상태바
class AndroidStatusBar extends StatelessWidget {
  final String timeString;

  const AndroidStatusBar({
    super.key,
    required this.timeString,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 좌측 시간 & 알림 인디케이터
            Row(
              children: [
                Text(
                  timeString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.chat_bubble_fill, color: Colors.white70, size: 12),
              ],
            ),

            // 우측 통신 및 배터리
            const Row(
              children: [
                Icon(CupertinoIcons.waveform, color: Colors.white, size: 14),
                SizedBox(width: 5),
                Icon(CupertinoIcons.wifi, color: Colors.white, size: 14),
                SizedBox(width: 5),
                Text('98%', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Icon(CupertinoIcons.battery_full, color: Colors.white, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}