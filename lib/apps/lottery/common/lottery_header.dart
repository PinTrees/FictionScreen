import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 동행복권 상단 GNB 헤더 및 탭 네비게이션
class LotteryHeader extends StatelessWidget {
  final int currentTabIndex;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onSelectFirstPrize;
  final VoidCallback onSelectSecondPrize;
  final VoidCallback onSelectLose;

  const LotteryHeader({
    super.key,
    required this.currentTabIndex,
    required this.onTabChanged,
    required this.onSelectFirstPrize,
    required this.onSelectSecondPrize,
    required this.onSelectLose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 최상단 브랜드 바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // 동행복권 공식 로고
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/lottery_icon.webp',
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/images/lottery_logo.svg',
                      height: 22,
                      semanticsLabel: '동행복권',
                    ),
                  ],
                ),
                const Spacer(),

                // 크리에이터 빠른 연출 프리셋 버튼들
                Wrap(
                  spacing: 6,
                  children: [
                    _buildPresetChip(
                      label: '🎉 1등 연출',
                      color: const Color(0xFFDC2626),
                      onTap: onSelectFirstPrize,
                    ),
                    _buildPresetChip(
                      label: '🥈 2등 연출',
                      color: const Color(0xFF2563EB),
                      onTap: onSelectSecondPrize,
                    ),
                    _buildPresetChip(
                      label: '😢 낙첨 연출',
                      color: const Color(0xFF64748B),
                      onTap: onSelectLose,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. 4대 복권 서비스 탭
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildNavTab(
                  index: 0,
                  title: '로또 6/45 추첨결과',
                  icon: CupertinoIcons.circle_grid_hex_fill,
                ),
                _buildNavTab(
                  index: 1,
                  title: '내 로또 영수증 (QR 당첨확인)',
                  icon: CupertinoIcons.qrcode_viewfinder,
                  badge: '핵심',
                ),
                _buildNavTab(
                  index: 2,
                  title: '연금복권 720+',
                  icon: CupertinoIcons.calendar,
                ),
                _buildNavTab(
                  index: 3,
                  title: '스피또 2000 즉석복권',
                  icon: CupertinoIcons.sparkles,
                  badge: '긁기',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildNavTab({
    required int index,
    required String title,
    required IconData icon,
    String? badge,
  }) {
    final isSelected = currentTabIndex == index;

    return InkWell(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF0066B3) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? const Color(0xFF0066B3) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF0066B3) : const Color(0xFF334155),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
