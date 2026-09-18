import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 9 최신 퀵 세팅 패널 (media_1789750829725.png 1:1 완벽 구현)
class OneUi9QuickSettings extends StatefulWidget {
  final String timeString;
  final String dateString;
  final VoidCallback onClose;
  final VoidCallback? onOpenSettings;
  final Function(DragUpdateDetails details)? onDragUpdate;
  final Function(DragEndDetails details)? onDragEnd;

  const OneUi9QuickSettings({
    super.key,
    required this.timeString,
    required this.dateString,
    required this.onClose,
    this.onOpenSettings,
    this.onDragUpdate,
    this.onDragEnd,
  });

  @override
  State<OneUi9QuickSettings> createState() => _OneUi9QuickSettingsState();
}

class _OneUi9QuickSettingsState extends State<OneUi9QuickSettings> {
  bool _isWifiOn = true;
  bool _isBluetoothOn = true;
  bool _isAutoRotateLocked = true;
  bool _isFlightModeOn = false;
  bool _isFlashlightOn = false;
  bool _isMobileDataOn = false;
  bool _isHotspotOn = false;
  bool _isBatterySaverOn = false;
  bool _isLocationOn = true; // active state (화이트 원형 + 블랙 핀)
  bool _isSmartSwitchOn = false;
  bool _isDarkModeOn = false;
  bool _isMuted = false;

  double _brightness = 0.35;
  double _volume = 0.40;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: widget.onDragUpdate ?? (details) {
        if (details.primaryDelta != null && details.primaryDelta! < -8) widget.onClose();
      },
      onVerticalDragEnd: widget.onDragEnd,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9F83DB), Color(0xFF9070D2), Color(0xFF8666C8), Color(0xFF7C5EBD)],
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 1. 상단 스테이터스 바 (No SIM • No service | BT, NFC, Signal, Wi-Fi, (74) 배터리)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('No SIM • No service', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.bluetooth, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            // NFC (N) 아이콘
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 0.5),
                              decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 0.8), borderRadius: BorderRadius.circular(2)),
                              child: const Text('N', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, height: 1.1)),
                            ),
                            const SizedBox(width: 4),
                            // VoLTE 신호
                            const Icon(CupertinoIcons.antenna_radiowaves_left_right, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            const Icon(CupertinoIcons.wifi, color: Colors.white, size: 13),
                            const SizedBox(width: 5),
                            // 74% 알약형 배터리
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(9)),
                              child: const Text('74', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 2. 상단 헤더: 시각 + 날짜 & 액션 아이콘들 (연필, 전원, 설정)
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 20, top: 6, bottom: 12),
                    child: Row(
                      children: [
                        Text(
                          widget.timeString.isNotEmpty ? widget.timeString : '10:28',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.dateString.isNotEmpty ? widget.dateString : 'Mon, Mar 16',
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        InkWell(onTap: () {}, child: const Icon(CupertinoIcons.pencil, size: 20, color: Colors.white)),
                        const SizedBox(width: 18),
                        InkWell(onTap: widget.onClose, child: const Icon(CupertinoIcons.power, size: 20, color: Colors.white)),
                        const SizedBox(width: 18),
                        InkWell(
                          onTap: () {
                            widget.onClose();
                            widget.onOpenSettings?.call();
                          },
                          child: const Icon(CupertinoIcons.gear_alt_fill, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // 3. 메인 패널 스크롤 영역
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Wi-Fi & Bluetooth 대형 캡슐
                          Row(
                            children: [
                              Expanded(
                                child: _buildConnectivityPill(
                                  title: 'Wi-Fi',
                                  subtitle: 'FRITZ!Box 7490',
                                  icon: CupertinoIcons.wifi,
                                  isOn: _isWifiOn,
                                  onTap: () => setState(() => _isWifiOn = !_isWifiOn),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildConnectivityPill(
                                  title: 'Bluetooth',
                                  subtitle: null,
                                  icon: CupertinoIcons.bluetooth,
                                  isOn: _isBluetoothOn,
                                  onTap: () => setState(() => _isBluetoothOn = !_isBluetoothOn),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 4x2 퀵 토글 통합 반투명 카드
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildCircleToggle(CupertinoIcons.lock_fill, _isAutoRotateLocked, () => setState(() => _isAutoRotateLocked = !_isAutoRotateLocked)),
                                    _buildCircleToggle(CupertinoIcons.airplane, _isFlightModeOn, () => setState(() => _isFlightModeOn = !_isFlightModeOn)),
                                    _buildCircleToggle(CupertinoIcons.lightbulb_fill, _isFlashlightOn, () => setState(() => _isFlashlightOn = !_isFlashlightOn)),
                                    _buildCircleToggle(CupertinoIcons.arrow_up_arrow_down, _isMobileDataOn, () => setState(() => _isMobileDataOn = !_isMobileDataOn)),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildCircleToggle(CupertinoIcons.antenna_radiowaves_left_right, _isHotspotOn, () => setState(() => _isHotspotOn = !_isHotspotOn)),
                                    _buildCircleToggle(CupertinoIcons.battery_25, _isBatterySaverOn, () => setState(() => _isBatterySaverOn = !_isBatterySaverOn)),
                                    // 활성화된 위치 토글: 화이트 원형 + 블랙 핀
                                    _buildCircleToggle(CupertinoIcons.location_solid, _isLocationOn, () => setState(() => _isLocationOn = !_isLocationOn), isHighlighted: _isLocationOn),
                                    _buildCircleToggle(CupertinoIcons.device_phone_portrait, _isSmartSwitchOn, () => setState(() => _isSmartSwitchOn = !_isSmartSwitchOn)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // 카드 하단 미니 드래그 핸들
                                Container(width: 32, height: 3, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(2))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 밝기 슬라이더 카드 + 우측 초승달 다크모드 버튼
                          _buildSliderWithSideButton(
                            value: _brightness,
                            thumbIcon: CupertinoIcons.sun_max,
                            sideIcon: CupertinoIcons.moon_fill,
                            isSideActive: _isDarkModeOn,
                            onSliderChanged: (val) => setState(() => _brightness = val),
                            onSideTap: () => setState(() => _isDarkModeOn = !_isDarkModeOn),
                          ),
                          const SizedBox(height: 12),

                          // 음량 슬라이더 카드 + 우측 스피커 버튼
                          _buildSliderWithSideButton(
                            value: _volume,
                            thumbIcon: CupertinoIcons.music_note,
                            sideIcon: _isMuted ? CupertinoIcons.volume_off : CupertinoIcons.volume_up,
                            isSideActive: !_isMuted,
                            onSliderChanged: (val) => setState(() => _volume = val),
                            onSideTap: () => setState(() => _isMuted = !_isMuted),
                          ),
                          const SizedBox(height: 12),

                          // 미디어 재생 바 (♪ Play music | Media output)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.music_note_2, size: 16, color: Colors.white),
                                const SizedBox(width: 8),
                                const Text('Play music', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('Media output', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 하단 2x2 유틸리티 캡슐들
                          Row(
                            children: [
                              Expanded(child: _buildBottomCapsule(icon: CupertinoIcons.shield_fill, title: 'Privacy display', subtitle: null)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildBottomCapsule(icon: CupertinoIcons.arrow_2_circlepath, title: 'Smart View', subtitle: 'Mirror screen')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildBottomCapsule(icon: CupertinoIcons.device_phone_portrait, title: 'Nearby devices', subtitle: null)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildBottomCapsule(icon: CupertinoIcons.circle_grid_hex_fill, title: 'SmartThings', subtitle: 'Device control')),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // 4. 하단 삼성 3버튼 내비게이션 바 (|||  O  <)
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 최근 앱 (|||)
                        InkWell(
                          onTap: widget.onClose,
                          child: const Row(
                            children: [
                              Text('|', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                              SizedBox(width: 2),
                              Text('|', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                              SizedBox(width: 2),
                              Text('|', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        // 홈 (O 스쿼클)
                        InkWell(
                          onTap: widget.onClose,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.5),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                        // 뒤로가기 (<)
                        InkWell(
                          onTap: widget.onClose,
                          child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 20),
                        ),
                      ],
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

  Widget _buildConnectivityPill({
    required String title,
    required String? subtitle,
    required IconData icon,
    required bool isOn,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          // 좌측 화이트 원형 버튼 (dark 아이콘)
          InkWell(
            onTap: onTap,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.black87, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleToggle(IconData icon, bool isOn, VoidCallback onTap, {bool isHighlighted = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.white : Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isHighlighted ? Colors.black87 : Colors.white, size: 22),
      ),
    );
  }

  Widget _buildSliderWithSideButton({
    required double value,
    required IconData thumbIcon,
    required IconData sideIcon,
    required bool isSideActive,
    required ValueChanged<double> onSliderChanged,
    required VoidCallback onSideTap,
  }) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          // 좌측 슬라이더 바
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    final newVal = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
                    onSliderChanged(newVal);
                  },
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // 슬라이더 채움
                      FractionallySizedBox(
                        widthFactor: value.clamp(0.12, 1.0),
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                      ),
                      // 화이트 썸 (아이콘)
                      Positioned(
                        left: (constraints.maxWidth - 46) * value,
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: Icon(thumbIcon, color: Colors.black87, size: 20),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          // 우측 원형 토글 버튼
          InkWell(
            onTap: onSideTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSideActive ? Colors.white : Colors.black.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(sideIcon, color: isSideActive ? Colors.black87 : Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCapsule({required IconData icon, required String title, required String? subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 9.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
