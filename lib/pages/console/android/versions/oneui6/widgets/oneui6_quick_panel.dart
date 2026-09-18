import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 6.1 최신 스타일 Quick Panel (빠른 설정 & 알림 통합 창)
class OneUi6QuickPanel extends StatefulWidget {
  final String timeString;
  final String dateString;
  final VoidCallback onClose;
  final VoidCallback? onOpenSettings;

  const OneUi6QuickPanel({
    super.key,
    required this.timeString,
    required this.dateString,
    required this.onClose,
    this.onOpenSettings,
  });

  @override
  State<OneUi6QuickPanel> createState() => _OneUi6QuickPanelState();
}

class _OneUi6QuickPanelState extends State<OneUi6QuickPanel> {
  bool _isWifiOn = true;
  bool _isBluetoothOn = true;
  bool _isSoundOn = true;
  bool _isRotationOn = true;
  bool _isFlashlightOn = false;
  bool _isDoNotDisturbOn = false;
  bool _isPowerSavingOn = false;
  bool _isMobileDataOn = true;
  double _brightness = 0.75;

  final List<Map<String, String>> _notifications = [
    {
      'app': '카카오톡',
      'icon': 'assets/images/kakaotalk_icon.webp',
      'title': '김철수',
      'body': '오늘 오후 6시에 강남역에서 볼까?',
      'time': '방금 전',
    },
    {
      'app': 'Instagram',
      'icon': 'assets/images/instagram_icon.webp',
      'title': 'fiction_studio 님이 회원님의 게시물을 좋아합니다.',
      'body': '새로운 숏폼 템플릿이 추가되었습니다!',
      'time': '10분 전',
    },
    {
      'app': '삼성 갤러리',
      'title': '새 모바일 스크린샷 저장됨',
      'body': '갤러리 앱에서 고해상도 이미지를 확인하세요.',
      'time': '30분 전',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! < -10) {
          widget.onClose();
        }
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.65),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(widget.timeString, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Text(widget.dateString, style: const TextStyle(color: Colors.white60, fontSize: 13)),
                            const Spacer(),
                            InkWell(onTap: widget.onClose, child: const Icon(CupertinoIcons.power, size: 20, color: Colors.white70)),
                            const SizedBox(width: 16),
                            InkWell(
                              onTap: () {
                                widget.onClose();
                                widget.onOpenSettings?.call();
                              },
                              child: const Icon(CupertinoIcons.gear_alt_fill, size: 20, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildBigToggleCard(
                                  title: 'Wi-Fi',
                                  subtitle: _isWifiOn ? 'Fiction_5G' : '사용 안 함',
                                  icon: CupertinoIcons.wifi,
                                  isOn: _isWifiOn,
                                  onTap: () => setState(() => _isWifiOn = !_isWifiOn),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildBigToggleCard(
                                  title: 'Bluetooth',
                                  subtitle: _isBluetoothOn ? 'Galaxy Buds3 Pro' : '사용 안 함',
                                  icon: CupertinoIcons.bluetooth,
                                  isOn: _isBluetoothOn,
                                  onTap: () => setState(() => _isBluetoothOn = !_isBluetoothOn),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 4,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.85,
                              children: [
                                _buildQuickIconButton('소리', CupertinoIcons.speaker_2_fill, _isSoundOn, () => setState(() => _isSoundOn = !_isSoundOn)),
                                _buildQuickIconButton('자동 회전', CupertinoIcons.device_phone_portrait, _isRotationOn, () => setState(() => _isRotationOn = !_isRotationOn)),
                                _buildQuickIconButton('손전등', CupertinoIcons.lightbulb_fill, _isFlashlightOn, () => setState(() => _isFlashlightOn = !_isFlashlightOn)),
                                _buildQuickIconButton('방해 금지', CupertinoIcons.minus_circle_fill, _isDoNotDisturbOn, () => setState(() => _isDoNotDisturbOn = !_isDoNotDisturbOn)),
                                _buildQuickIconButton('절전 모드', CupertinoIcons.battery_25, _isPowerSavingOn, () => setState(() => _isPowerSavingOn = !_isPowerSavingOn)),
                                _buildQuickIconButton('모바일 데이터', CupertinoIcons.antenna_radiowaves_left_right, _isMobileDataOn, () => setState(() => _isMobileDataOn = !_isMobileDataOn)),
                                _buildQuickIconButton('비행기 모드', CupertinoIcons.airplane, false, () {}),
                                _buildQuickIconButton('모바일 핫스팟', CupertinoIcons.antenna_radiowaves_left_right, false, () {}),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.sun_min_fill, size: 18, color: Colors.white70),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: const Color(0xFF60A5FA),
                                      inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
                                      thumbColor: Colors.white,
                                      trackHeight: 12,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                                    ),
                                    child: Slider(
                                      value: _brightness,
                                      onChanged: (val) => setState(() => _brightness = val),
                                    ),
                                  ),
                                ),
                                const Icon(CupertinoIcons.sun_max_fill, size: 20, color: Colors.white),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('알림', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                              InkWell(
                                onTap: () => setState(() => _notifications.clear()),
                                child: const Text('지우기', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 13, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (_notifications.isEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: const Center(child: Text('새로운 알림이 없습니다', style: TextStyle(color: Colors.white38, fontSize: 13))),
                            )
                          else
                            ..._notifications.map((notif) {
                              final String? image = notif['icon'];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: image != null
                                            ? Image.asset(image, fit: BoxFit.cover)
                                            : Container(color: const Color(0xFF3B82F6), child: const Icon(CupertinoIcons.bell_fill, size: 16, color: Colors.white)),
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
                                              Text(notif['app']!, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                                              Text(notif['time']!, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(notif['title']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                          Text(notif['body']!, style: const TextStyle(color: Colors.white70, fontSize: 11)),
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

  Widget _buildBigToggleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isOn,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isOn ? const Color(0xFF3B82F6) : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isOn ? Colors.white : Colors.white60),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: isOn ? Colors.white : Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(color: isOn ? Colors.white70 : Colors.white38, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickIconButton(String title, IconData icon, bool isOn, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isOn ? const Color(0xFF3B82F6) : Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: isOn ? Colors.white : Colors.white60),
          ),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(color: isOn ? Colors.white : Colors.white70, fontSize: 10, fontWeight: isOn ? FontWeight.bold : FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
