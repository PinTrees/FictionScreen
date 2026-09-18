import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 9 홈 화면 위젯 모음 (날씨+시계 카드, 배터리 카드, Galaxy AI 검색 캡슐)
class OneUi9WeatherClockCard extends StatelessWidget {
  final String timeString;
  final String dateString;
  final VoidCallback? onTap;

  const OneUi9WeatherClockCard({
    super.key,
    required this.timeString,
    required this.dateString,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 18, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(timeString, style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w700, letterSpacing: -1.5)),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.calendar, color: Colors.white60, size: 12),
                        const SizedBox(width: 5),
                        Text(dateString, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.sun_max_fill, color: Colors.amber, size: 26),
                      SizedBox(width: 8),
                      Text('24°', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: Colors.white.withValues(alpha: 0.1)),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.location_solid, color: Color(0xFF60A5FA), size: 13),
                    SizedBox(width: 4),
                    Text('서울시 강남구 · 대체로 맑음', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                Text('최저 18° / 최고 27°', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One UI 9 Galaxy AI 검색 캡슐 바
class OneUi9GalaxyAiSearchBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onAiTap;

  const OneUi9GalaxyAiSearchBar({super.key, this.onSearchTap, this.onAiTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.17),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.14), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            const Text('G', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 21, fontWeight: FontWeight.w900)),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Galaxy AI에게 질문 또는 검색',
                style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(onTap: onAiTap, child: const Icon(Icons.auto_awesome, color: Color(0xFFA78BFA), size: 20)),
            const SizedBox(width: 10),
            const Icon(CupertinoIcons.mic_fill, color: Colors.white70, size: 17),
            const SizedBox(width: 10),
            const Icon(CupertinoIcons.camera_fill, color: Colors.white70, size: 17),
          ],
        ),
      ),
    );
  }
}

/// One UI 9 배터리 카드 캡슐
class OneUi9BatteryWidget extends StatelessWidget {
  const OneUi9BatteryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDeviceStatus(icon: CupertinoIcons.device_phone_portrait, name: 'S26 Ultra', percent: '98%', isCharging: true),
          Container(width: 1, height: 26, color: Colors.white.withValues(alpha: 0.15)),
          _buildDeviceStatus(icon: CupertinoIcons.headphones, name: 'Buds3 Pro', percent: '100%', isCharging: false),
        ],
      ),
    );
  }

  Widget _buildDeviceStatus({required IconData icon, required String name, required String percent, required bool isCharging}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(color: Colors.white60, fontSize: 11)),
            Row(
              children: [
                Text(percent, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                if (isCharging) ...[
                  const SizedBox(width: 3),
                  const Icon(CupertinoIcons.bolt_fill, color: Color(0xFF10B981), size: 11),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}
