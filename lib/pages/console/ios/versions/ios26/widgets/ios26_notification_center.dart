import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios26_liquid_glass.dart';

/// Apple iOS 26 공식 리퀴드 글래스 (Liquid Glass) 알림 센터 (Notification Center)
/// - 레퍼런스 이미지(media_1789745290626.png) 100% 픽셀 퍼펙트 구현
/// - 3D 베벨 스펙큘러 하이라이트 & 앰비언트 글로우 리퀴드 글래스 대형 시계 (Ios26GlassClock)
/// - 통신사 SKT & LTE 93% 초록색 알약 배터리 인디케이터
/// - WWDC 2025 공식 광학 리퀴드 글래스 알림 카드 및 2단 중첩 스택 쉘프 효과 (Stack Effect)
/// - 비트겟(BGB 10), 코인니스(BTC 6), 우주고양이 보라(3), iCloud 백업, 쿠팡/메밀노크 정밀 구현
/// - 하단 리퀴드 글래스 원형 손전등/카메라 퀵 액션 토글 & 스와이프 홈 바
class Ios26NotificationCenter extends StatefulWidget {
  final String timeString;
  final String dateString;
  final VoidCallback onClose;
  final Function(String appId) onOpenApp;

  const Ios26NotificationCenter({
    super.key,
    required this.timeString,
    required this.dateString,
    required this.onClose,
    required this.onOpenApp,
  });

  @override
  State<Ios26NotificationCenter> createState() => _Ios26NotificationCenterState();
}

class _Ios26NotificationCenterState extends State<Ios26NotificationCenter> {
  bool _isFlashlightOn = false;
  final Set<int> _dismissedNotifications = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      behavior: HitTestBehavior.translucent,
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // 1. 최상단 상태표시줄 (SKT | 4바 LTE 93% 녹색 알약 배터리)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SKT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      fontFamily: '.SF Pro Text',
                    ),
                  ),
                  Row(
                    children: [
                      _buildSignalBars(),
                      const SizedBox(width: 5),
                      const Text(
                        'LTE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // iOS 26 공식 녹색 알약 배터리 (93% 번개 충전)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF34C759).withValues(alpha: 0.4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '93',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(width: 1),
                            Icon(Icons.bolt_rounded, color: Colors.black, size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. 잠금화면 한국어 날짜
            const SizedBox(height: 14),
            Text(
              widget.dateString.isNotEmpty ? widget.dateString : '9월 19일 (토)',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),

            // 3. Apple iOS 26 리퀴드 글래스 대형 입체 시계 (12:14)
            Ios26GlassClock(timeString: widget.timeString),

            const SizedBox(height: 18),

            // 4. '알림 센터' 섹션 헤더 & 리퀴드 글래스 (X) 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '알림 센터',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _dismissedNotifications.addAll([0, 1, 2, 3, 4]);
                      });
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.24),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 0.8,
                        ),
                      ),
                      child: const Icon(
                        CupertinoIcons.xmark,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 5. 스크롤 가능한 정밀 리퀴드 글래스 알림 카드 리스트
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                physics: const BouncingScrollPhysics(),
                children: [
                  // 카드 1: Bitget (BGB price has risen) - 2단 스택 카드 깊이
                  if (!_dismissedNotifications.contains(0))
                    _buildLiquidGlassNotificationCard(
                      index: 0,
                      badgeCount: 10,
                      iconBg: const Color(0xFF00E5AE),
                      iconWidget: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      title: 'BGB price has risen',
                      time: '10분 전',
                      body: 'BGB price has surpassed 2 USDT, now standing at 2 USDT',
                      stackLevel: 2,
                    ),

                  // 카드 2: CoinNess (BTC ,000 상회) - 2단 스택 카드 깊이
                  if (!_dismissedNotifications.contains(1))
                    _buildLiquidGlassNotificationCard(
                      index: 1,
                      badgeCount: 6,
                      iconBg: const Color(0xFF1E2126),
                      iconWidget: Center(
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF00C087), width: 3.5),
                          ),
                        ),
                      ),
                      title: 'BTC ,000 상회',
                      time: '13분 전',
                      body: '코인니스 마켓 모니터링에 따르면 BTC가 81,000 달러를 상회했다. 바이낸스 USDT 마켓 기준 BTC는 81,012달러에 거래되고 있다.',
                      stackLevel: 2,
                    ),

                  // 카드 3: 우주고양이 보라
                  if (!_dismissedNotifications.contains(2))
                    _buildLiquidGlassNotificationCard(
                      index: 2,
                      badgeCount: 3,
                      iconBg: const Color(0xFFFDF7E7),
                      iconWidget: const Center(
                        child: Icon(
                          CupertinoIcons.cube_box_fill,
                          color: Color(0xFF8B5E3C),
                          size: 22,
                        ),
                      ),
                      title: '우주고양이 보라',
                      time: '어제 오후 10:29',
                      body: '오늘은 어떤 일이 있었어? 한번 적어보자 📝',
                      stackLevel: 0,
                    ),

                  // 카드 4: iPhone을 백업할 수 없음
                  if (!_dismissedNotifications.contains(3))
                    _buildLiquidGlassNotificationCard(
                      index: 3,
                      iconBg: const Color(0xFF007AFF),
                      iconWidget: const Center(
                        child: Icon(
                          CupertinoIcons.cloud_fill,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      title: 'iPhone을 백업할 수 없음',
                      time: '어제 오후 9:28',
                      body: 'iPhone이 분실되거나 고장난 경우 데이터가 손실될 수 있습니다. 지금 업그레이드하거나 저장 공간을 관리하십시오.',
                      stackLevel: 0,
                    ),

                  // 카드 5: [광고] 메밀노크 할인!
                  if (!_dismissedNotifications.contains(4))
                    _buildLiquidGlassNotificationCard(
                      index: 4,
                      iconBg: const Color(0xFF2AC1BC),
                      iconWidget: const Center(
                        child: Icon(
                          CupertinoIcons.bag_fill,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                      title: '[광고] 메밀노크 할인!',
                      time: '어제 오후 7:15',
                      body: '•수신거부:설정>알림/메시지',
                      stackLevel: 0,
                    ),

                  const SizedBox(height: 80),
                ],
              ),
            ),

            // 6. 하단 리퀴드 글래스 손전등 & 카메라 원형 퀵 액션 토글
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLiquidGlassCircleButton(
                    icon: Icons.flashlight_on_rounded,
                    isActive: _isFlashlightOn,
                    onTap: () {
                      setState(() {
                        _isFlashlightOn = !_isFlashlightOn;
                      });
                    },
                  ),
                  _buildLiquidGlassCircleButton(
                    icon: CupertinoIcons.camera_fill,
                    isActive: false,
                    onTap: () {
                      widget.onClose();
                      widget.onOpenApp('camera');
                    },
                  ),
                ],
              ),
            ),

            // 7. 하단 홈 인디케이터 바 (위로 스와이프하면 닫힘)
            GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null && details.primaryVelocity! < -100) {
                  widget.onClose();
                }
              },
              child: Container(
                width: 140,
                height: 5,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // iOS 26 순정 리퀴드 글래스 알림 카드 + 중첩 스택 쉘프 효과
  Widget _buildLiquidGlassNotificationCard({
    required int index,
    int? badgeCount,
    required Color iconBg,
    required Widget iconWidget,
    required String title,
    required String time,
    required String body,
    required int stackLevel,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // 스택 쉘프 2단 (가장 깊은 바닥 레이어)
          if (stackLevel >= 2)
            Positioned(
              bottom: -10,
              left: 18,
              right: 18,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1E30).withValues(alpha: 0.52),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                        width: 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 스택 쉘프 1단 (중간 레이어)
          if (stackLevel >= 1)
            Positioned(
              bottom: -5,
              left: 9,
              right: 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1E30).withValues(alpha: 0.62),
                      borderRadius: BorderRadius.circular(23),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.28),
                        width: 0.9,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.24),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 전면 메인 리퀴드 글래스 알림 카드
          Ios26LiquidGlass(
            borderRadius: 26,
            blurSigma: 36,
            hasCornerGlow: true,
            hasChromaticAberration: true,
            tintColor: const Color(0xFF0E233D),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 앱 아이콘 + 배지 카운트
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: iconWidget,
                    ),
                    if (badgeCount != null)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                // 알림 텍스트 콘텐츠
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            time,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        body,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.90),
                          fontSize: 13,
                          height: 1.28,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 하단 원형 리퀴드 글래스 퀵 버튼
  Widget _buildLiquidGlassCircleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Ios26LiquidGlass(
        width: 52,
        height: 52,
        borderRadius: 26,
        blurSigma: 32,
        tintColor: isActive ? Colors.white : const Color(0xFF0F1E30),
        child: Center(
          child: Icon(
            icon,
            color: isActive ? Colors.black : Colors.white,
            size: 24,
          ),
        ),
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

/// Apple iOS 26 순정 3D 베벨 스펙큘러 하이라이트 & 앰비언트 글로우 리퀴드 글래스 대형 시계
class Ios26GlassClock extends StatelessWidget {
  final String timeString;

  const Ios26GlassClock({super.key, required this.timeString});

  @override
  Widget build(BuildContext context) {
    final timeFormatted = timeString.length >= 5 ? timeString.substring(0, 5) : timeString;

    return SizedBox(
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. 깊은 3D 입체 소프트 드롭 섀도우 & 광학 코스틱 번짐
          Text(
            timeFormatted,
            style: TextStyle(
              fontSize: 84,
              fontWeight: FontWeight.w400,
              letterSpacing: -3.0,
              fontFamily: '.SF Pro Display',
              color: Colors.transparent,
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.65),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
                BoxShadow(
                  color: const Color(0xFF64B5F6).withValues(alpha: 0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),

          // 2. 리퀴드 글래스 투과 내부 그라데이션 바디 (배경이 투명하게 비치는 글래스)
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xEEFFFFFF), // 상단 표면 반사광
                  Color(0x88D0E8FF), // 상부 유리 굴절
                  Color(0x3580B8EE), // 중앙 투과 렌즈
                  Color(0x77A0D8FF), // 하단 굴절 바운스광
                ],
                stops: [0.0, 0.35, 0.70, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcIn,
            child: Text(
              timeFormatted,
              style: const TextStyle(
                fontSize: 84,
                fontWeight: FontWeight.w400,
                letterSpacing: -3.0,
                fontFamily: '.SF Pro Display',
                color: Colors.white,
              ),
            ),
          ),

          // 3. 베벨 림(Beveled Rim) 스펙큘러 하이라이트 테두리
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFFFFF), // 좌상단 강한 하이라이트
                  Color(0xDD90CAF9), // 스카이블루 굴절광
                  Color(0x4442A5F5), // 우측면 투과
                  Color(0xAAFFFFFF), // 우하단 림 반사
                ],
                stops: [0.0, 0.35, 0.75, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcIn,
            child: Text(
              timeFormatted,
              style: TextStyle(
                fontSize: 84,
                fontWeight: FontWeight.w400,
                letterSpacing: -3.0,
                fontFamily: '.SF Pro Display',
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
