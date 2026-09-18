import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios26_dynamic_island.dart';

/// iOS 26 순정 상단 상태 표시줄
/// - 상태바 우측 또는 전체를 아래로 드래그(Swipe Down)하거나 탭하면 제어 센터(Control Center) 진입
class Ios26StatusBar extends StatelessWidget {
  final String timeString;
  final VoidCallback? onDynamicIslandTap;
  final VoidCallback? onOpenControlCenter;

  const Ios26StatusBar({
    super.key,
    required this.timeString,
    this.onDynamicIslandTap,
    this.onOpenControlCenter,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormatted = timeString.length >= 5 ? timeString.substring(0, 5) : timeString;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 80) {
          onOpenControlCenter?.call();
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 6) {
          onOpenControlCenter?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 좌측 시간 (탭 시 노티피케이션/홈)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    timeFormatted,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                      fontFamily: '.SF Pro Text',
                    ),
                  ),
                ),

                // 우측 시스템 지표 (5G, WiFi, 배터리) - 탭하거나 아래로 내리면 제어 센터 오픈
                GestureDetector(
                  onTap: onOpenControlCenter,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildSignalBar(4),
                          const SizedBox(width: 1.5),
                          _buildSignalBar(6),
                          const SizedBox(width: 1.5),
                          _buildSignalBar(8),
                          const SizedBox(width: 1.5),
                          _buildSignalBar(10),
                        ],
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        '5G',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(CupertinoIcons.wifi, color: Colors.white, size: 15),
                      const SizedBox(width: 6),
                      _buildBatteryIndicator(),
                    ],
                  ),
                ),
              ],
            ),

            // 중앙 다이내믹 아일랜드
            Ios26DynamicIsland(onTap: onDynamicIslandTap),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalBar(double height) {
    return Container(
      width: 2.5,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.8),
      ),
    );
  }

  Widget _buildBatteryIndicator() {
    return Container(
      width: 25,
      height: 12.5,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF34C759),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
