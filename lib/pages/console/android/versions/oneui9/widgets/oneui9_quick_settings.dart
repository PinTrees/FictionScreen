import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung Galaxy One UI 9 플래그십 스플릿 빠른 설정 (Quick Settings) 패널
class OneUi9QuickSettings extends StatefulWidget {
  final String timeString;
  final String dateString;
  final VoidCallback onClose;
  final VoidCallback? onSwitchToNotifications;
  final VoidCallback? onOpenSettings;

  const OneUi9QuickSettings({
    super.key,
    required this.timeString,
    required this.dateString,
    required this.onClose,
    this.onSwitchToNotifications,
    this.onOpenSettings,
  });

  @override
  State<OneUi9QuickSettings> createState() => _OneUi9QuickSettingsState();
}

class _OneUi9QuickSettingsState extends State<OneUi9QuickSettings> {
  bool _isWifiOn = true;
  bool _isBluetoothOn = true;
  bool _isSoundOn = true;
  bool _isRotationOn = true;
  bool _isFlashlightOn = false;
  bool _isAirplaneOn = false;
  bool _isHotspotOn = false;
  bool _isPowerSavingOn = false;
  bool _isEyeComfortOn = false;
  bool _isDarkModeOn = true;

  double _brightness = 0.85;
  double _volume = 0.70;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 12) {
          widget.onSwitchToNotifications?.call();
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! < -8) {
          widget.onClose();
        }
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: SafeArea(
              child: Column(
                children: [
                  // 상단 시스템 제어 바 & 탭 전환 인디케이터
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
                              onTap: widget.onSwitchToNotifications,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                                child: const Row(
                                  children: [
                                    Icon(CupertinoIcons.bell_fill, size: 12, color: Colors.white70),
                                    SizedBox(width: 4),
                                    Text('알림 보기', style: TextStyle(color: Colors.white70, fontSize: 11)),
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

                  // 패널 스크롤 영역
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // 1. One UI 9 대형 캡슐 (Wi-Fi & Bluetooth)
                          Row(
                            children: [
                              Expanded(
                                child: _buildLargePill(
                                  title: 'Wi-Fi',
                                  subtitle: _isWifiOn ? 'Fiction_Galaxy_6E' : '사용 안 함',
                                  icon: CupertinoIcons.wifi,
                                  isOn: _isWifiOn,
                                  onToggle: () => setState(() => _isWifiOn = !_isWifiOn),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildLargePill(
                                  title: 'Bluetooth',
                                  subtitle: _isBluetoothOn ? 'Galaxy Buds3 Pro' : '사용 안 함',
                                  icon: CupertinoIcons.bluetooth,
                                  isOn: _isBluetoothOn,
                                  onToggle: () => setState(() => _isBluetoothOn = !_isBluetoothOn),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 2. 4x2 원형 토글 카드
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 4,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.88,
                              children: [
                                _buildQuickCircleToggle('소리', CupertinoIcons.speaker_2_fill, _isSoundOn, () => setState(() => _isSoundOn = !_isSoundOn)),
                                _buildQuickCircleToggle('자동 회전', CupertinoIcons.device_phone_portrait, _isRotationOn, () => setState(() => _isRotationOn = !_isRotationOn)),
                                _buildQuickCircleToggle('손전등', CupertinoIcons.lightbulb_fill, _isFlashlightOn, () => setState(() => _isFlashlightOn = !_isFlashlightOn)),
                                _buildQuickCircleToggle('비행기 모드', CupertinoIcons.airplane, _isAirplaneOn, () => setState(() => _isAirplaneOn = !_isAirplaneOn)),
                                _buildQuickCircleToggle('핫스팟', CupertinoIcons.antenna_radiowaves_left_right, _isHotspotOn, () => setState(() => _isHotspotOn = !_isHotspotOn)),
                                _buildQuickCircleToggle('절전 모드', CupertinoIcons.battery_25, _isPowerSavingOn, () => setState(() => _isPowerSavingOn = !_isPowerSavingOn)),
                                _buildQuickCircleToggle('편안한 화면', CupertinoIcons.eye_fill, _isEyeComfortOn, () => setState(() => _isEyeComfortOn = !_isEyeComfortOn)),
                                _buildQuickCircleToggle('다크 모드', CupertinoIcons.moon_fill, _isDarkModeOn, () => setState(() => _isDarkModeOn = !_isDarkModeOn)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 3. 듀얼 수직 슬라이더 캡슐
                          Row(
                            children: [
                              Expanded(
                                child: _buildSliderCapsule(
                                  title: '화면 밝기',
                                  percent: '${(_brightness * 100).round()}%',
                                  icon: CupertinoIcons.sun_max_fill,
                                  value: _brightness,
                                  accentColor: const Color(0xFF3B82F6),
                                  onChanged: (val) => setState(() => _brightness = val),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildSliderCapsule(
                                  title: '미디어 음량',
                                  percent: '${(_volume * 100).round()}%',
                                  icon: CupertinoIcons.volume_up,
                                  value: _volume,
                                  accentColor: const Color(0xFF60A5FA),
                                  onChanged: (val) => setState(() => _volume = val),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 4. 하단 기기 제어 & 스마트 뷰
                          Row(
                            children: [
                              Expanded(child: _buildUtilityButton(title: '스마트 뷰', subtitle: '화면 공유', icon: CupertinoIcons.tv, onTap: () {})),
                              const SizedBox(width: 10),
                              Expanded(child: _buildUtilityButton(title: '기기 제어', subtitle: 'SmartThings', icon: CupertinoIcons.house_alt_fill, onTap: () {})),
                            ],
                          ),
                          const SizedBox(height: 24),
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

  Widget _buildLargePill({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isOn,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isOn ? const Color(0xFF2563EB) : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: isOn ? const Color(0xFF3B82F6) : Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          CupertinoSwitch(
            value: isOn,
            activeTrackColor: Colors.white,
            thumbColor: isOn ? const Color(0xFF2563EB) : Colors.white70,
            onChanged: (val) => onToggle(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCircleToggle(String title, IconData icon, bool isOn, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isOn ? const Color(0xFF2563EB) : Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              boxShadow: isOn ? [BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.45), blurRadius: 10, spreadRadius: 1)] : null,
            ),
            child: Icon(icon, size: 21, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(color: isOn ? Colors.white : Colors.white70, fontSize: 10, fontWeight: isOn ? FontWeight.bold : FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildSliderCapsule({
    required String title,
    required String percent,
    required IconData icon,
    required double value,
    required Color accentColor,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 15, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
              Text(percent, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: accentColor,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
              thumbColor: Colors.white,
              trackHeight: 12,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.white70),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
