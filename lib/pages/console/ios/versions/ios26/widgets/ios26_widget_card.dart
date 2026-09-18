import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios26_liquid_glass.dart';

/// iOS 26 공식 리퀴드 글래스 (Liquid Glass) 날씨 2x2 위젯
class Ios26WeatherWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const Ios26WeatherWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Ios26LiquidGlass(
        height: 156,
        borderRadius: 26,
        blurSigma: 36,
        saturation: 1.5,
        tintColor: const Color(0xFF1A6DD6),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 상단: 도시명 & 온도 & 태양 아이콘
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '서울',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '23°',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -1.0,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber.withValues(alpha: 0.2),
                  ),
                  child: const Icon(
                    CupertinoIcons.sun_max_fill,
                    color: Color(0xFFFFD60A),
                    size: 26,
                  ),
                ),
              ],
            ),

            // 하단: 상태 및 최고/최저 기온
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '대체로 맑음',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '최고: 26°  최저: 15°',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// iOS 26 공식 리퀴드 글래스 (Liquid Glass) 캘린더 2x2 위젯
class Ios26CalendarWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const Ios26CalendarWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    final weekdayStr = weekdays[now.weekday - 1];

    return GestureDetector(
      onTap: onTap,
      child: Ios26LiquidGlass(
        height: 156,
        borderRadius: 26,
        blurSigma: 36,
        saturation: 1.45,
        tintColor: const Color(0xFF1E1E22),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 상단 요일 & 날짜
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weekdayStr,
                  style: const TextStyle(
                    color: Color(0xFFFF453A),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '${now.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -1.5,
                    height: 1.1,
                  ),
                ),
              ],
            ),

            // 하단 일정 미리보기 카드
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 3.5,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A84FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '스튜디오 작업 세션',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '오후 2:00 ~ 3:30',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
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
