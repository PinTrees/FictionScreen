import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios26_dynamic_island.dart';

/// iOS 26 순정 상단 상태 표시줄
/// - 상태바 우측 또는 전체를 아래로 드래그(Swipe Down)하거나 탭하면 제어 센터(Control Center) 진입
class Ios26StatusBar extends StatelessWidget {
  final String timeString;
  final VoidCallback? onDynamicIslandTap;
  final GestureDragStartCallback? onLeftDragStart;
  final GestureDragUpdateCallback? onLeftDragUpdate;
  final GestureDragEndCallback? onLeftDragEnd;
  final GestureDragStartCallback? onRightDragStart;
  final GestureDragUpdateCallback? onRightDragUpdate;
  final GestureDragEndCallback? onRightDragEnd;

  const Ios26StatusBar({
    super.key,
    required this.timeString,
    this.onDynamicIslandTap,
    this.onLeftDragStart,
    this.onLeftDragUpdate,
    this.onLeftDragEnd,
    this.onRightDragStart,
    this.onRightDragUpdate,
    this.onRightDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormatted = timeString.length >= 5 ? timeString.substring(0, 5) : timeString;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              // 좌측 절반: 아래로 드래그 시 알림 센터(Notification Center) 진입
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragStart: onLeftDragStart,
                  onVerticalDragUpdate: onLeftDragUpdate,
                  onVerticalDragEnd: onLeftDragEnd,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
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
                  ),
                ),
              ),

              // 다이내믹 아일랜드 영역 여백 확보 (중앙 126px)
              const SizedBox(width: 126),

              // 우측 절반: 아래로 드래그 시 제어 센터(Control Center) 진입
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragStart: onRightDragStart,
                  onVerticalDragUpdate: onRightDragUpdate,
                  onVerticalDragEnd: onRightDragEnd,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 4, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
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
                        const SizedBox(width: 4),
                        const Text(
                          'LTE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(CupertinoIcons.wifi, color: Colors.white, size: 14),
                        const SizedBox(width: 5),
                        _buildBatteryIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 중앙 다이내믹 아일랜드 (상태바 중앙)
          Ios26DynamicIsland(onTap: onDynamicIslandTap),
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
