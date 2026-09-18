import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung Galaxy One UI 9 플래그십 스플릿 알림 셰이드 (Notification Shade) 패널
class OneUi9NotificationShade extends StatefulWidget {
  final String timeString;
  final String dateString;
  final VoidCallback onClose;
  final VoidCallback? onSwitchToQuickSettings;
  final VoidCallback? onOpenSettings;

  const OneUi9NotificationShade({
    super.key,
    required this.timeString,
    required this.dateString,
    required this.onClose,
    this.onSwitchToQuickSettings,
    this.onOpenSettings,
  });

  @override
  State<OneUi9NotificationShade> createState() => _OneUi9NotificationShadeState();
}

class _OneUi9NotificationShadeState extends State<OneUi9NotificationShade> {
  bool _isPlayingMedia = true;

  final List<Map<String, String>> _notifications = [
    {
      'app': 'Galaxy AI',
      'title': 'Now Brief 데일리 리포트',
      'body': '오늘의 날씨는 24° 대체로 맑음이며, 추천 이동 경로는 올림픽대로입니다.',
      'time': '방금 전',
    },
    {
      'app': '카카오톡',
      'icon': 'assets/images/kakaotalk_icon.webp',
      'title': '디자인 팀 단톡방',
      'body': '이민호: One UI 9 좌우 슬라이드와 깃허브 공식 아이콘 적용 완료했습니다!',
      'time': '2분 전',
    },
    {
      'app': '토스 (Toss)',
      'title': '토스뱅크 입금 안내',
      'body': '송금 100,000원이 정상 입금되었습니다. 확인 후 잔액을 조회하세요.',
      'time': '7분 전',
    },
    {
      'app': 'Samsung Health',
      'icon': 'assets/images/galaxy/icons/health.png',
      'title': '활동 목표 100% 달성!',
      'body': '오늘 걸음 수 10,250보 달성! 연속 7일 목표를 달성하셨습니다.',
      'time': '25분 전',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! < -12) {
          widget.onSwitchToQuickSettings?.call();
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! < -8) {
          widget.onClose();
        }
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.68),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: SafeArea(
              child: Column(
                children: [
                  // 상단 시스템 헤더 & 탭 전환
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        Container(width: 44, height: 4.5, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(3))),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(widget.timeString, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Text(widget.dateString, style: const TextStyle(color: Colors.white60, fontSize: 13)),
                            const Spacer(),
                            // 스플릿 전환 탭
                            InkWell(
                              onTap: widget.onSwitchToQuickSettings,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                                child: const Row(
                                  children: [
                                    Text('빠른 설정', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                    SizedBox(width: 4),
                                    Icon(CupertinoIcons.slider_horizontal_3, size: 12, color: Colors.white70),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkWell(onTap: widget.onClose, child: const Icon(CupertinoIcons.power, size: 19, color: Colors.white70)),
                            const SizedBox(width: 14),
                            InkWell(
                              onTap: () {
                                widget.onClose();
                                widget.onOpenSettings?.call();
                              },
                              child: const Icon(CupertinoIcons.gear_alt_fill, size: 19, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 알림 스크롤 리스트
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // 1. 미디어 플레이어 캡슐
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)]),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(CupertinoIcons.music_note, color: Colors.white, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Golden Hour', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      const Text('JVKE · Samsung Music', style: TextStyle(color: Colors.white60, fontSize: 11)),
                                      const SizedBox(height: 6),
                                      LinearProgressIndicator(
                                        value: 0.62,
                                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF60A5FA)),
                                        minHeight: 3,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  children: [
                                    const Icon(CupertinoIcons.backward_fill, color: Colors.white70, size: 18),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () => setState(() => _isPlayingMedia = !_isPlayingMedia),
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                        child: Icon(_isPlayingMedia ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill, color: Colors.black, size: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(CupertinoIcons.forward_fill, color: Colors.white70, size: 18),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // 2. 알림 목록 헤더
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('알림 목록', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                              InkWell(
                                onTap: () => setState(() => _notifications.clear()),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                                  child: const Text('모두 지우기', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 3. 알림 아이템 리스트
                          if (_notifications.isEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: const Center(child: Text('새로운 알림이 없습니다', style: TextStyle(color: Colors.white38, fontSize: 13))),
                            )
                          else
                            ..._notifications.map((notif) {
                              final String? image = notif['icon'];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.09),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(11),
                                        child: image != null
                                            ? Image.asset(image, fit: BoxFit.cover)
                                            : Container(
                                                color: const Color(0xFF6366F1),
                                                child: const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(notif['app']!, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                                              Text(notif['time']!, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(notif['title']!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 2),
                                          Text(notif['body']!, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
