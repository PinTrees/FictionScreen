import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 18 최신 스타일 Control Center (제어 센터)
class IosControlCenter extends StatefulWidget {
  final String timeString;
  final VoidCallback onClose;
  final VoidCallback? onOpenSettings;

  const IosControlCenter({
    super.key,
    required this.timeString,
    required this.onClose,
    this.onOpenSettings,
  });

  @override
  State<IosControlCenter> createState() => _IosControlCenterState();
}

class _IosControlCenterState extends State<IosControlCenter> {
  bool _isAirplaneMode = false;
  bool _isCellularOn = true;
  bool _isWifiOn = true;
  bool _isBluetoothOn = true;
  bool _isFocusModeOn = false;

  double _brightness = 0.8;
  double _volume = 0.65;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! < -10) {
          widget.onClose(); // 위로 드래그 시 제어센터 닫기
        }
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
            child: SafeArea(
              child: Column(
                children: [
                  // 상단 다이내믹 아일랜드 / 상태바 영역
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        // 상단 인디케이터 바
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.timeString,
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: widget.onClose,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(CupertinoIcons.xmark, size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // iOS 18 제어 센터 그리드 모듈들
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // 1. 네트워크 통신 모듈 & 미디어 플레이어 모듈 (2개 카드)
                          Row(
                            children: [
                              // 좌측: 네트워크 2x2 카드 모듈
                              Expanded(
                                child: Container(
                                  height: 160,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          _buildNetworkBtn(CupertinoIcons.airplane, _isAirplaneMode, () => setState(() => _isAirplaneMode = !_isAirplaneMode)),
                                          _buildNetworkBtn(CupertinoIcons.antenna_radiowaves_left_right, _isCellularOn, () => setState(() => _isCellularOn = !_isCellularOn), activeColor: const Color(0xFF10B981)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          _buildNetworkBtn(CupertinoIcons.wifi, _isWifiOn, () => setState(() => _isWifiOn = !_isWifiOn), activeColor: const Color(0xFF007AFF)),
                                          _buildNetworkBtn(CupertinoIcons.bluetooth, _isBluetoothOn, () => setState(() => _isBluetoothOn = !_isBluetoothOn), activeColor: const Color(0xFF007AFF)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // 우측: Apple Music 미디어 제어 모듈
                              Expanded(
                                child: Container(
                                  height: 160,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(CupertinoIcons.music_note, color: Color(0xFFF43F5E), size: 16),
                                          SizedBox(width: 6),
                                          Text('Apple Music', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Sequoia Sunset', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                          Text('Fiction Lofi Lab', style: TextStyle(color: Colors.white54, fontSize: 11)),
                                        ],
                                      ),
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(CupertinoIcons.backward_fill, color: Colors.white70, size: 18),
                                          Icon(CupertinoIcons.play_fill, color: Colors.white, size: 24),
                                          Icon(CupertinoIcons.forward_fill, color: Colors.white70, size: 18),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 2. 화면 방향 잠금, 집중 모드, 밝기/음량 슬라이더
                          Row(
                            children: [
                              // 화면 방향 회전 잠금 & 집중 모드 카드
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 73,
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(CupertinoIcons.lock_shield_fill, color: Colors.white, size: 20),
                                          SizedBox(width: 10),
                                          Text('회전 잠금', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    InkWell(
                                      onTap: () => setState(() => _isFocusModeOn = !_isFocusModeOn),
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        height: 73,
                                        padding: const EdgeInsets.symmetric(horizontal: 14),
                                        decoration: BoxDecoration(
                                          color: _isFocusModeOn ? const Color(0xFF6366F1) : Colors.white.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.moon_fill, color: _isFocusModeOn ? Colors.white : Colors.indigoAccent, size: 20),
                                            const SizedBox(width: 10),
                                            const Text('집중 모드', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),

                              // 수직 밝기 & 음량 슬라이더 바
                              _buildVerticalSlider(
                                icon: CupertinoIcons.sun_max_fill,
                                value: _brightness,
                                onChanged: (val) => setState(() => _brightness = val),
                              ),
                              const SizedBox(width: 14),
                              _buildVerticalSlider(
                                icon: CupertinoIcons.speaker_2_fill,
                                value: _volume,
                                onChanged: (val) => setState(() => _volume = val),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 3. 하단 손전등, 계산기, 카메라, 저전력 모드 Quick 그리드
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildCircleQuickBtn(CupertinoIcons.lightbulb_fill, Colors.amber),
                              _buildCircleQuickBtn(CupertinoIcons.number, Colors.white),
                              _buildCircleQuickBtn(CupertinoIcons.camera_fill, Colors.white),
                              _buildCircleQuickBtn(CupertinoIcons.battery_25, Colors.amber),
                            ],
                          ),
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

  Widget _buildNetworkBtn(IconData icon, bool isOn, VoidCallback onTap, {Color activeColor = const Color(0xFF007AFF)}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isOn ? activeColor : Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildVerticalSlider({
    required IconData icon,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      width: 73,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 160 * value,
                color: Colors.white,
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: value > 0.3 ? Colors.black87 : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleQuickBtn(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
