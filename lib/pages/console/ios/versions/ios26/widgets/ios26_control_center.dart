import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios26_liquid_glass.dart';

/// Apple iOS 26 순정 리퀴드 글래스 (Liquid Glass) 제어 센터 (Control Center)
/// - 상태바 드래그 다운 또는 탭으로 열림
/// - 연결성 (Wi-Fi, 에어드롭, 비행기, 셀룰러, 블루투스), 지금 재생 중 미디어 카드
/// - 화면 회전 잠금, 무음 벨소리, 집중 모드 캡슐
/// - 터치/드래그 인터랙티브 수직 화면 밝기 & 볼륨 슬라이더
/// - 손전등, 타이머, 계산기, 카메라 4개 하단 리퀴드 원형 퀵 토글
class Ios26ControlCenter extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String appId) onOpenApp;

  const Ios26ControlCenter({
    super.key,
    required this.onClose,
    required this.onOpenApp,
  });

  @override
  State<Ios26ControlCenter> createState() => _Ios26ControlCenterState();
}

class _Ios26ControlCenterState extends State<Ios26ControlCenter> {
  // 제어 센터 인터랙티브 상태값
  bool _isAirplaneOn = false;
  bool _isAirDropOn = true;
  bool _isWifiOn = true;
  bool _isCellularOn = true;
  bool _isBluetoothOn = true;
  bool _isPlaying = true;
  bool _isRotationLocked = false;
  bool _isSilentMode = true;
  bool _isFocusMode = false;
  bool _isFlashlightOn = false;

  double _brightness = 0.65;
  double _volume = 0.72;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: Colors.black.withValues(alpha: 0.35),
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              // 1. 상단 바 (+ 버튼, 다이내믹 아일랜드, 전원 ⏻ 버튼)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 좌측 '+' 추가 버튼
                    _buildCircleUtilityButton(
                      icon: CupertinoIcons.plus,
                      onTap: () {},
                    ),

                    // 중앙 다이내믹 아일랜드 자리
                    Container(
                      width: 124,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    // 우측 전원 ⏻ 버튼
                    _buildCircleUtilityButton(
                      icon: CupertinoIcons.power,
                      onTap: widget.onClose,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 2. 상단 상태 서브헤더 (안테나/Wi-Fi & 배터리 100%)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 통신사 신호 + Wi-Fi
                    const Row(
                      children: [
                        Icon(CupertinoIcons.antenna_radiowaves_left_right, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Icon(CupertinoIcons.wifi, color: Colors.white, size: 14),
                      ],
                    ),
                    // 배터리 100%
                    Row(
                      children: [
                        const Text(
                          '100%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 22,
                          height: 11,
                          padding: const EdgeInsets.all(1.2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.white, width: 1.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 3. 제어 센터 메인 모듈 그리드
              Expanded(
                child: GestureDetector(
                  onTap: () {}, // 내부 탭 시 닫힘 방지
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        // Row 1: 연결성 2x2 카드 + 지금 재생 중 미디어 2x2 카드
                        Row(
                          children: [
                            // 왼쪽 연결성 2x2 리퀴드 글래스 카드
                            Expanded(child: _buildConnectivityCard()),
                            const SizedBox(width: 14),
                            // 오른쪽 미디어 플레이어 2x2 리퀴드 글래스 카드
                            Expanded(child: _buildMediaCard()),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Row 2: 회전잠금, 무음, 집중모드 + 수직 밝기/볼륨 슬라이더
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 좌측 2열: 회전잠금 / 무음 버튼 + 하단 집중모드 캡슐
                            Expanded(
                              flex: 11,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // 회전 잠금 버튼
                                      Expanded(
                                        child: _buildSquareButton(
                                          icon: CupertinoIcons.lock_rotation,
                                          isActive: _isRotationLocked,
                                          activeColor: const Color(0xFF007AFF),
                                          onTap: () => setState(() => _isRotationLocked = !_isRotationLocked),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // 무음/벨소리 버튼
                                      Expanded(
                                        child: _buildSquareButton(
                                          icon: CupertinoIcons.bell_fill,
                                          isActive: _isSilentMode,
                                          activeColor: const Color(0xFFFF3B30),
                                          onTap: () => setState(() => _isSilentMode = !_isSilentMode),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  // 집중 모드 (Focus) 가로형 캡슐
                                  GestureDetector(
                                    onTap: () => setState(() => _isFocusMode = !_isFocusMode),
                                    child: Ios26LiquidGlass(
                                      height: 66,
                                      borderRadius: 33,
                                      blurSigma: 32,
                                      hasCornerGlow: false,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 38,
                                            height: 38,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _isFocusMode
                                                  ? const Color(0xFF5856D6)
                                                  : Colors.white.withValues(alpha: 0.15),
                                            ),
                                            child: const Icon(
                                              CupertinoIcons.moon_fill,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Expanded(
                                            child: Text(
                                              'Focus',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            CupertinoIcons.chevron_up_chevron_down,
                                            color: Colors.white70,
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // 우측: 화면 밝기 수직 슬라이더
                            Expanded(
                              flex: 5,
                              child: _buildVerticalSlider(
                                value: _brightness,
                                icon: CupertinoIcons.sun_max_fill,
                                iconColor: const Color(0xFFFF9500),
                                onChanged: (val) => setState(() => _brightness = val),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // 우측: 음량 볼륨 수직 슬라이더
                            Expanded(
                              flex: 5,
                              child: _buildVerticalSlider(
                                value: _volume,
                                icon: CupertinoIcons.speaker_2_fill,
                                iconColor: const Color(0xFF007AFF),
                                onChanged: (val) => setState(() => _volume = val),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Row 3: 하단 4개 원형 리퀴드 퀵 토글 (손전등, 타이머, 계산기, 카메라)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildSquareButton(
                                icon: Icons.flashlight_on_rounded,
                                isActive: _isFlashlightOn,
                                activeColor: const Color(0xFFFFD60A),
                                activeIconColor: Colors.black,
                                onTap: () => setState(() => _isFlashlightOn = !_isFlashlightOn),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSquareButton(
                                icon: CupertinoIcons.stopwatch_fill,
                                onTap: () => widget.onOpenApp('clock'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSquareButton(
                                icon: CupertinoIcons.number_square_fill,
                                onTap: () => widget.onOpenApp('calculator'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSquareButton(
                                icon: CupertinoIcons.camera_fill,
                                onTap: () => widget.onOpenApp('camera'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. 하단 닫기 핸들 바
              GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 120,
                  height: 20,
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  // 상단 유틸리티 원형 버튼 (+ 및 전원 버튼)
  Widget _buildCircleUtilityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 0.6),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  // 연결성 2x2 카드 (비행기, 에어드롭, Wi-Fi, 4단 통신 클러스터)
  Widget _buildConnectivityCard() {
    return Ios26LiquidGlass(
      height: 154,
      borderRadius: 28,
      blurSigma: 36,
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // 1. 비행기 모드
          _buildToggleCircle(
            icon: CupertinoIcons.airplane,
            isActive: _isAirplaneOn,
            activeColor: const Color(0xFFFF9500),
            onTap: () => setState(() => _isAirplaneOn = !_isAirplaneOn),
          ),
          // 2. AirDrop
          _buildToggleCircle(
            icon: CupertinoIcons.radiowaves_right,
            isActive: _isAirDropOn,
            activeColor: const Color(0xFF007AFF),
            onTap: () => setState(() => _isAirDropOn = !_isAirDropOn),
          ),
          // 3. Wi-Fi
          _buildToggleCircle(
            icon: CupertinoIcons.wifi,
            isActive: _isWifiOn,
            activeColor: const Color(0xFF007AFF),
            onTap: () => setState(() => _isWifiOn = !_isWifiOn),
          ),
          // 4. 셀룰러 / 블루투스 / 핫스팟 / VPN 4단 미니 클러스터
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMiniCircle(
                  icon: CupertinoIcons.antenna_radiowaves_left_right,
                  isActive: _isCellularOn,
                  activeColor: const Color(0xFF34C759),
                  onTap: () => setState(() => _isCellularOn = !_isCellularOn),
                ),
                _buildMiniCircle(
                  icon: CupertinoIcons.bluetooth,
                  isActive: _isBluetoothOn,
                  activeColor: const Color(0xFF007AFF),
                  onTap: () => setState(() => _isBluetoothOn = !_isBluetoothOn),
                ),
                _buildMiniCircle(
                  icon: CupertinoIcons.personalhotspot,
                  isActive: false,
                  activeColor: const Color(0xFF34C759),
                  onTap: () {},
                ),
                _buildMiniCircle(
                  icon: CupertinoIcons.shield_fill,
                  isActive: false,
                  activeColor: const Color(0xFF007AFF),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 지금 재생 중 2x2 미디어 카드
  Widget _buildMediaCard() {
    return Ios26LiquidGlass(
      height: 154,
      borderRadius: 28,
      blurSigma: 36,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 상단: 앨범 아트 및 AirPlay 아이콘
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(CupertinoIcons.music_note_2, color: Colors.white, size: 22),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                child: const Icon(CupertinoIcons.device_phone_portrait, color: Colors.white70, size: 14),
              ),
            ],
          ),

          // 중앙: 곡명 & 아티스트
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Backseat Driver',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Kane Brown',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          // 하단: 재생 컨트롤 (이전, 재생/정지, 다음)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(CupertinoIcons.backward_fill, color: Colors.white, size: 18),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () => setState(() => _isPlaying = !_isPlaying),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.forward_fill, color: Colors.white, size: 18),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 원형 토글 버튼 (비행기, 와이파이, 에어드롭 등)
  Widget _buildToggleCircle({
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? activeColor : Colors.white.withValues(alpha: 0.15),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.45),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  // 4단 클러스터 내부 미니 원형 버튼
  Widget _buildMiniCircle({
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? activeColor : Colors.white.withValues(alpha: 0.12),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 12),
        ),
      ),
    );
  }

  // 사각형/원형 리퀴드 글래스 버튼 (회전잠금, 무음, 손전등, 카메라 등)
  Widget _buildSquareButton({
    required IconData icon,
    bool isActive = false,
    Color activeColor = const Color(0xFF007AFF),
    Color activeIconColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Ios26LiquidGlass(
        height: 66,
        borderRadius: 33,
        blurSigma: 32,
        hasCornerGlow: false,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? activeColor : Colors.transparent,
            ),
            child: Icon(
              icon,
              color: isActive ? activeIconColor : Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  // 터치 & 드래그 인터랙티브 수직 리퀴드 슬라이더 (밝기, 음량)
  Widget _buildVerticalSlider({
    required double value,
    required IconData icon,
    required Color iconColor,
    required ValueChanged<double> onChanged,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = 146.0;

        return GestureDetector(
          onVerticalDragUpdate: (details) {
            final delta = -details.primaryDelta! / height;
            final newVal = (value + delta).clamp(0.0, 1.0);
            onChanged(newVal);
          },
          onTapDown: (details) {
            final localY = details.localPosition.dy;
            final newVal = (1.0 - (localY / height)).clamp(0.0, 1.0);
            onChanged(newVal);
          },
          child: Ios26LiquidGlass(
            height: height,
            borderRadius: 34,
            blurSigma: 32,
            hasCornerGlow: true,
            hasChromaticAberration: true,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // 1. 흰색 액체 게이지 채움 (Liquid Fill)
                FractionallySizedBox(
                  heightFactor: value,
                  widthFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(33),
                    ),
                  ),
                ),

                // 2. 하단 고정 아이콘 (해당 슬라이더의 상징 아이콘)
                Positioned(
                  bottom: 16,
                  child: Icon(
                    icon,
                    color: value > 0.35 ? iconColor : Colors.white70,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
