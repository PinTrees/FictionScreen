import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Apple iOS 26 순정 알림 센터 (Notification Center)
/// - 상태표시줄 좌측을 아래로 드래그 시 실시간으로 내려오는 화면
/// - 대형 프로스트 글래스 시계 및 한국어 날짜
/// - 암호화폐 시세, 코인니스, 메모, iCloud 알림 스택 카드 리스트
/// - 하단 손전등 & 카메라 퀵 토글 버튼 및 홈 바 위로 스와이프 닫기
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
    final timeFormatted = widget.timeString.length >= 5
        ? widget.timeString.substring(0, 5)
        : widget.timeString;

    return GestureDetector(
      onTap: widget.onClose,
      behavior: HitTestBehavior.translucent,
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // 1. 상단 통신사 & 배터리 인디케이터 (알림센터 전용)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SKT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '93%',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. 대형 잠금화면 시계 & 날짜
            const SizedBox(height: 12),
            Text(
              widget.dateString.isNotEmpty ? widget.dateString : '9월 19일 (토)',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 19,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              timeFormatted,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 78,
                fontWeight: FontWeight.w300,
                letterSpacing: -3.0,
                height: 1.05,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. 알림 센터 헤더 & (X) 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '알림 센터',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _dismissedNotifications.addAll([0, 1, 2, 3, 4]);
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
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

            // 4. 스크롤 가능한 알림 카드 리스트
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                physics: const BouncingScrollPhysics(),
                children: [
                  if (!_dismissedNotifications.contains(0))
                    _buildNotificationCard(
                      index: 0,
                      badgeCount: 10,
                      iconBg: const Color(0xFF00E5AE),
                      iconWidget: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      title: 'BGB price has risen',
                      time: '10분 전',
                      body: 'BGB price has surpassed 2 USDT, now standing at 2 USDT',
                      hasStackEffect: true,
                    ),
                  if (!_dismissedNotifications.contains(1))
                    _buildNotificationCard(
                      index: 1,
                      badgeCount: 6,
                      iconBg: const Color(0xFF1E2026),
                      iconWidget: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF00C087), width: 3),
                          ),
                        ),
                      ),
                      title: 'BTC \$81,000 상회',
                      time: '13분 전',
                      body: '코인니스 마켓 모니터링에 따르면 BTC가 81,000 달러를 상회했다. 바이낸스 USDT 마켓 기준 BTC는 81,012달러에 거래되고 있다.',
                      hasStackEffect: true,
                    ),
                  if (!_dismissedNotifications.contains(2))
                    _buildNotificationCard(
                      index: 2,
                      badgeCount: 3,
                      iconBg: const Color(0xFFFFF3D6),
                      iconWidget: const Icon(
                        CupertinoIcons.cube_box_fill,
                        color: Color(0xFF8B5E3C),
                        size: 20,
                      ),
                      title: '우주고양이 보라',
                      time: '어제 오후 10:29',
                      body: '오늘은 어떤 일이 있었어? 한번 적어보자 📝',
                      hasStackEffect: false,
                    ),
                  if (!_dismissedNotifications.contains(3))
                    _buildNotificationCard(
                      index: 3,
                      iconBg: const Color(0xFF007AFF),
                      iconWidget: const Icon(
                        CupertinoIcons.cloud_fill,
                        color: Colors.white,
                        size: 20,
                      ),
                      title: 'iPhone을 백업할 수 없음',
                      time: '어제 오후 9:28',
                      body: 'iPhone이 분실되거나 고장난 경우 데이터가 손실될 수 있습니다. 지금 업그레이드하거나 저장 공간을 관리하십시오.',
                      hasStackEffect: false,
                    ),
                  if (!_dismissedNotifications.contains(4))
                    _buildNotificationCard(
                      index: 4,
                      iconBg: const Color(0xFF2AC1BC),
                      iconWidget: const Icon(
                        CupertinoIcons.bag_fill,
                        color: Colors.white,
                        size: 19,
                      ),
                      title: '[광고] 메밀노크 할인!',
                      time: '어제 오후 7:15',
                      body: '•수신거부:설정>알림/메시지',
                      hasStackEffect: false,
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // 5. 하단 퀵 액션 버튼 (손전등 & 카메라)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleActionButton(
                    icon: Icons.flashlight_on_rounded,
                    isActive: _isFlashlightOn,
                    onTap: () {
                      setState(() {
                        _isFlashlightOn = !_isFlashlightOn;
                      });
                    },
                  ),
                  _buildCircleActionButton(
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

            // 6. 하단 홈 인디케이터 바 (위로 스와이프하면 닫힘)
            GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null && details.primaryVelocity! < -100) {
                  widget.onClose();
                }
              },
              child: Container(
                width: 138,
                height: 5,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required int index,
    int? badgeCount,
    required Color iconBg,
    required Widget iconWidget,
    required String title,
    required String time,
    required String body,
    required bool hasStackEffect,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // 스택 효과: 뒤에 포개진 카드 레이어 2개
          if (hasStackEffect) ...[
            Positioned(
              bottom: -8,
              left: 14,
              right: 14,
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 0.6,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -4,
              left: 7,
              right: 7,
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                    width: 0.7,
                  ),
                ),
              ),
            ),
          ],

          // 전면 메인 알림 카드
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2836).withValues(alpha: 0.68),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 앱 아이콘 + 배지
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: iconBg,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: iconWidget,
                        ),
                        if (badgeCount != null)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Text(
                                badgeCount.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    // 텍스트 정보
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
                                    fontSize: 14,
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
                                  color: Colors.white.withValues(alpha: 0.6),
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
                              color: Colors.white.withValues(alpha: 0.88),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleActionButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Colors.white
                  : const Color(0xFF1E2836).withValues(alpha: 0.65),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 0.9,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.black : Colors.white,
              size: 24,
            ),
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
