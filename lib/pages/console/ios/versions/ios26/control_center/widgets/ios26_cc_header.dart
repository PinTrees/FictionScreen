import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 26 제어 센터 상단 헤더 (+ 및 ⏻ 유틸리티 버튼, SKT LTE 4바 & 93% 배터리)
class Ios26CcHeader extends StatelessWidget {
  final VoidCallback onClose;

  const Ios26CcHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. 최상단 액션 행 (+ 및 ⏻) - 스크린샷 100% 일치 (다이내믹 아일랜드 없음)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: const Icon(CupertinoIcons.plus, color: Colors.white, size: 24),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(CupertinoIcons.power, color: Colors.white, size: 22),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // 2. 상태 서브헤더 (4바 SKT LTE | 🔒 93% 🔋⚡)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 통신사 4바 + SKT LTE
              Row(
                children: [
                  _buildSignalBars(),
                  const SizedBox(width: 6),
                  const Text('SKT LTE', style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
                ],
              ),

              // 잠금 + 배터리 93% + 녹색 충전 배터리
              Row(
                children: [
                  Icon(CupertinoIcons.lock_fill, color: Colors.white.withValues(alpha: 0.9), size: 12),
                  const SizedBox(width: 4),
                  const Text('93%', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 5),
                  Container(
                    width: 25,
                    height: 12.5,
                    padding: const EdgeInsets.all(1.2),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.5), border: Border.all(color: Colors.white, width: 1.1)),
                    child: Container(
                      decoration: BoxDecoration(color: const Color(0xFF34C759), borderRadius: BorderRadius.circular(1.5)),
                      child: const Center(child: Icon(Icons.bolt_rounded, color: Colors.black, size: 10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignalBars() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildBar(4), const SizedBox(width: 1.5),
        _buildBar(6), const SizedBox(width: 1.5),
        _buildBar(8), const SizedBox(width: 1.5),
        _buildBar(10),
      ],
    );
  }

  Widget _buildBar(double height) {
    return Container(width: 2.5, height: height, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0.8)));
  }
}
