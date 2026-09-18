import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios18_dynamic_island.dart';

/// iOS 18 순정 상단 상태 표시줄 (SF Pro 볼드 시계 + 다이내믹 아일랜드 + 5G/와이파이/배터리)
class Ios18StatusBar extends StatelessWidget {
  final String timeString;
  final VoidCallback? onDynamicIslandTap;

  const Ios18StatusBar({
    super.key,
    required this.timeString,
    this.onDynamicIslandTap,
  });

  @override
  Widget build(BuildContext context) {
    // 9:41 형식 시간 추출 (초 단위 제외)
    final timeFormatted = timeString.length >= 5 ? timeString.substring(0, 5) : timeString;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. 좌측 시간 & 우측 시스템 상태 아이콘 (셀룰러, 5G, Wi-Fi, 배터리)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 좌측 볼드 시간
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

              // 우측 시스템 지표 (5G, WiFi, 배터리)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 통신사 4단 신호 막대
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

                  // 5G 배지
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

                  // Wi-Fi
                  const Icon(CupertinoIcons.wifi, color: Colors.white, size: 15),
                  const SizedBox(width: 6),

                  // iOS 18 배터리 아이콘 (둥근 캡슐 + 내부 충전 게이지)
                  _buildBatteryIndicator(),
                ],
              ),
            ],
          ),

          // 2. 중앙 인터랙티브 다이내믹 아일랜드
          Ios18DynamicIsland(onTap: onDynamicIslandTap),
        ],
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
