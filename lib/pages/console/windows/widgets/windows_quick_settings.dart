import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows 11 빠른 설정 & 알림 센터 (Quick Settings & Notification Center)
class WindowsQuickSettings extends StatefulWidget {
  final String dateString;
  final String timeString;
  final VoidCallback onClose;
  final VoidCallback? onOpenSettings;

  const WindowsQuickSettings({
    super.key,
    required this.dateString,
    required this.timeString,
    required this.onClose,
    this.onOpenSettings,
  });

  @override
  State<WindowsQuickSettings> createState() => _WindowsQuickSettingsState();
}

class _WindowsQuickSettingsState extends State<WindowsQuickSettings> {
  bool _isWifiOn = true;
  bool _isBluetoothOn = true;
  bool _isAirplaneOn = false;
  bool _isNightLightOn = false;
  bool _isFocusAssistOn = false;
  bool _isAccessibilityOn = false;

  double _brightness = 0.8;
  double _volume = 0.7;

  final List<Map<String, String>> _notifications = [
    {'app': 'Windows 보안', 'title': '보안 검사 완료', 'body': '위협 요소가 감지되지 않았습니다.', 'time': '방금 전'},
    {'app': 'Microsoft Edge', 'title': '다운로드 완료', 'body': 'FictionScreen_2K_Wallpaper.png', 'time': '10분 전'},
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.only(right: 12, bottom: 54),
            width: 360,
            decoration: BoxDecoration(
              color: const Color(0xFF20222A).withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. 빠른 설정 퀵 버튼 그리드 (3x2)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQuickCard('Wi-Fi', 'Fiction_5G', CupertinoIcons.wifi, _isWifiOn, () => setState(() => _isWifiOn = !_isWifiOn)),
                          _buildQuickCard('Bluetooth', '연결됨', CupertinoIcons.bluetooth, _isBluetoothOn, () => setState(() => _isBluetoothOn = !_isBluetoothOn)),
                          _buildQuickCard('비행기 모드', '끄기', CupertinoIcons.airplane, _isAirplaneOn, () => setState(() => _isAirplaneOn = !_isAirplaneOn)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQuickCard('야간 모드', '끄기', CupertinoIcons.moon_fill, _isNightLightOn, () => setState(() => _isNightLightOn = !_isNightLightOn)),
                          _buildQuickCard('집중 지원', '끄기', CupertinoIcons.minus_circle_fill, _isFocusAssistOn, () => setState(() => _isFocusAssistOn = !_isFocusAssistOn)),
                          _buildQuickCard('접근성', '켬', CupertinoIcons.person_fill, _isAccessibilityOn, () => setState(() => _isAccessibilityOn = !_isAccessibilityOn)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 2. 밝기 & 음량 슬라이더
                      Row(
                        children: [
                          const Icon(CupertinoIcons.sun_max_fill, color: Colors.white70, size: 16),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: const Color(0xFF0078D7),
                                inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
                                thumbColor: Colors.white,
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              ),
                              child: Slider(
                                value: _brightness,
                                onChanged: (val) => setState(() => _brightness = val),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.speaker_2_fill, color: Colors.white70, size: 16),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: const Color(0xFF0078D7),
                                inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
                                thumbColor: Colors.white,
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              ),
                              child: Slider(
                                value: _volume,
                                onChanged: (val) => setState(() => _volume = val),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white12, height: 20),

                      // 3. 알림 센터 영역
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('알림 센터', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          InkWell(
                            onTap: () => setState(() => _notifications.clear()),
                            child: const Text('모두 지우기', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 11)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      if (_notifications.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('새 알림 없음', style: TextStyle(color: Colors.white38, fontSize: 12)),
                        )
                      else
                        ..._notifications.map((notif) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(notif['app']!, style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 10, fontWeight: FontWeight.bold)),
                                    Text(notif['time']!, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(notif['title']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                Text(notif['body']!, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                          );
                        }),

                      const Divider(color: Colors.white12, height: 20),

                      // 하단 배터리 & 설정 버튼
                      Row(
                        children: [
                          const Icon(CupertinoIcons.battery_100, color: Color(0xFF10B981), size: 18),
                          const SizedBox(width: 8),
                          const Text('100%', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              widget.onClose();
                              widget.onOpenSettings?.call();
                            },
                            child: const Icon(CupertinoIcons.gear_alt_fill, color: Colors.white70, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickCard(String title, String status, IconData icon, bool isOn, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 104,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isOn ? const Color(0xFF0078D7) : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isOn ? const Color(0xFF0078D7) : Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(status, style: TextStyle(color: isOn ? Colors.white70 : Colors.white38, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
