import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios26_dynamic_island.dart';

/// iOS 26 순정 상단 상태 표시줄
class Ios26StatusBar extends StatelessWidget {
  final String timeString;
  final VoidCallback? onDynamicIslandTap;

  const Ios26StatusBar({
    super.key,
    required this.timeString,
    this.onDynamicIslandTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormatted = timeString.length >= 5 ? timeString.substring(0, 5) : timeString;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              Row(
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
            ],
          ),
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
