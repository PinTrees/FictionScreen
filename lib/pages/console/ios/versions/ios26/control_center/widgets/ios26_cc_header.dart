import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 26 제어 센터 상단 헤더 (+ 버튼, 다이내믹 아일랜드, 전원 버튼, SKT LTE 4바 & 93% 배터리)
class Ios26CcHeader extends StatelessWidget {
  final VoidCallback onClose;

  const Ios26CcHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. 최상단 바 (+ 유틸리티, 중앙 다이내믹 아일랜드, 전원 ⏻ 버튼)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleButton(
                icon: CupertinoIcons.plus,
                onTap: () {},
              ),
              Container(
                width: 124,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              _buildCircleButton(
                icon: CupertinoIcons.power,
                onTap: onClose,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 2. 상단 상태 서브헤더 (4바 SKT LTE & 잠금 + 배터리 93% + 번개 충전)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 통신사 신호 4바 + SKT LTE
              Row(
                children: [
                  _buildSignalBars(),
                  const SizedBox(width: 5),
                  const Text(
                    'SKT LTE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),

              // 잠금 + 배터리 93% + 녹색 충전 배터리
              Row(
                children: [
                  Icon(CupertinoIcons.lock_fill, color: Colors.white.withValues(alpha: 0.85), size: 12),
                  const SizedBox(width: 4),
                  const Text(
                    '93%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 25,
                    height: 12.5,
                    padding: const EdgeInsets.all(1.2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.5),
                      border: Border.all(color: Colors.white, width: 1.1),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF34C759),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.bolt_rounded, color: Colors.black, size: 10),
                      ),
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

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 0.6),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildSignalBars() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildBar(4),
        const SizedBox(width: 1.5),
        _buildBar(6),
        const SizedBox(width: 1.5),
        _buildBar(8),
        const SizedBox(width: 1.5),
        _buildBar(10),
      ],
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 2.5,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.8),
      ),
    );
  }
}
