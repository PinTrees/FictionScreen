import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SteamosQuickAccessMenu extends StatefulWidget {
  final VoidCallback onClose;

  const SteamosQuickAccessMenu({
    super.key,
    required this.onClose,
  });

  @override
  State<SteamosQuickAccessMenu> createState() => _SteamosQuickAccessMenuState();
}

class _SteamosQuickAccessMenuState extends State<SteamosQuickAccessMenu> {
  int _activeTab = 0; // 0: Notifications, 1: Quick Settings, 2: Performance
  double _brightness = 0.85;
  double _volume = 0.70;
  int _fpsLimit = 60;
  bool _wifiEnabled = true;
  bool _bluetoothEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      width: 330,
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F141C).withValues(alpha: 0.94),
                border: Border(
                  left: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header with QAM Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildTabButton(0, CupertinoIcons.bell_fill, '알림'),
                              const SizedBox(width: 8),
                              _buildTabButton(1, CupertinoIcons.slider_horizontal_3, '빠른 설정'),
                              const SizedBox(width: 8),
                              _buildTabButton(2, CupertinoIcons.speedometer, '성능'),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(CupertinoIcons.xmark, color: Colors.white70, size: 18),
                            onPressed: widget.onClose,
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white12, height: 1),

                    // Content
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (_activeTab == 0) ..._buildNotificationsTab(),
                          if (_activeTab == 1) ..._buildQuickSettingsTab(),
                          if (_activeTab == 2) ..._buildPerformanceTab(),
                        ],
                      ),
                    ),

                    // Quick Deck Status Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0A0D14),
                        border: Border(top: BorderSide(color: Colors.white10)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(CupertinoIcons.battery_100, color: Color(0xFF22C55E), size: 16),
                              SizedBox(width: 6),
                              Text(
                                '98% (충전 중)',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Text(
                            '예상 시간: 3시간 50분',
                            style: TextStyle(color: Colors.white54, fontSize: 11),
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
      ),
    );
  }

  Widget _buildTabButton(int index, IconData icon, String tooltip) {
    final isSelected = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A9FFF).withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: const Color(0xFF1A9FFF).withValues(alpha: 0.5)) : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF1A9FFF) : Colors.white60,
          size: 18,
        ),
      ),
    );
  }

  List<Widget> _buildNotificationsTab() {
    return [
      const Text(
        '최근 알림',
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      _buildNotificationItem(
        title: '도전 과제 달성!',
        desc: '사이버펑크 2077 - [나이트 시티의 전설]',
        time: '방금 전',
        icon: CupertinoIcons.sparkles,
        color: const Color(0xFFF59E0B),
      ),
      const SizedBox(height: 10),
      _buildNotificationItem(
        title: '클라우드 동기화 완료',
        desc: '모든 세이브 파일이 최신 상태입니다.',
        time: '12분 전',
        icon: CupertinoIcons.cloud_fill,
        color: const Color(0xFF1A9FFF),
      ),
      const SizedBox(height: 10),
      _buildNotificationItem(
        title: 'SteamOS 업데이트 다운로드 완료',
        desc: 'SteamOS 3.6.14 준비됨',
        time: '1시간 전',
        icon: CupertinoIcons.arrow_down_circle_fill,
        color: const Color(0xFF22C55E),
      ),
    ];
  }

  Widget _buildNotificationItem({
    required String title,
    required String desc,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold),
                    ),
                    Text(time, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.white70, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuickSettingsTab() {
    return [
      const Text(
        '빠른 설정 (Quick Settings)',
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      // Brightness Slider
      Row(
        children: [
          const Icon(CupertinoIcons.sun_max_fill, color: Colors.white70, size: 18),
          const SizedBox(width: 10),
          const Text('화면 밝기', style: TextStyle(color: Colors.white, fontSize: 12.5)),
          const Spacer(),
          Text('${(_brightness * 100).toInt()}%', style: const TextStyle(color: Color(0xFF1A9FFF), fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
      Slider(
        value: _brightness,
        activeColor: const Color(0xFF1A9FFF),
        inactiveColor: Colors.white24,
        onChanged: (v) => setState(() => _brightness = v),
      ),

      const SizedBox(height: 12),
      // Volume Slider
      Row(
        children: [
          const Icon(CupertinoIcons.speaker_2_fill, color: Colors.white70, size: 18),
          const SizedBox(width: 10),
          const Text('스피커 볼륨', style: TextStyle(color: Colors.white, fontSize: 12.5)),
          const Spacer(),
          Text('${(_volume * 100).toInt()}%', style: const TextStyle(color: Color(0xFF1A9FFF), fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
      Slider(
        value: _volume,
        activeColor: const Color(0xFF1A9FFF),
        inactiveColor: Colors.white24,
        onChanged: (v) => setState(() => _volume = v),
      ),

      const SizedBox(height: 16),
      // Toggles
      SwitchListTile(
        title: const Text('Wi-Fi', style: TextStyle(color: Colors.white, fontSize: 13)),
        subtitle: const Text('Valve_5G_Fast 연결됨', style: TextStyle(color: Colors.white54, fontSize: 11)),
        value: _wifiEnabled,
        activeThumbColor: const Color(0xFF1A9FFF),
        contentPadding: EdgeInsets.zero,
        onChanged: (v) => setState(() => _wifiEnabled = v),
      ),
      SwitchListTile(
        title: const Text('Bluetooth', style: TextStyle(color: Colors.white, fontSize: 13)),
        subtitle: const Text('Xbox Wireless Controller', style: TextStyle(color: Colors.white54, fontSize: 11)),
        value: _bluetoothEnabled,
        activeThumbColor: const Color(0xFF1A9FFF),
        contentPadding: EdgeInsets.zero,
        onChanged: (v) => setState(() => _bluetoothEnabled = v),
      ),
    ];
  }

  List<Widget> _buildPerformanceTab() {
    return [
      const Text(
        '성능 오버레이 (Performance)',
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 14),

      // FPS Limit Selector
      const Text('최대 프레임 제한 (FPS Limit)', style: TextStyle(color: Colors.white70, fontSize: 12)),
      const SizedBox(height: 8),
      Row(
        children: [30, 45, 60, 90].map((fps) {
          final isSelected = _fpsLimit == fps;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: InkWell(
                onTap: () => setState(() => _fpsLimit = fps),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1A9FFF) : Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$fps FPS',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),

      const SizedBox(height: 20),
      // Live Metrics
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: const Column(
          children: [
            _MetricRow(label: 'APU TDP 전력', value: '15.0 W (최대)'),
            SizedBox(height: 8),
            _MetricRow(label: 'GPU 클럭', value: '1600 MHz'),
            SizedBox(height: 8),
            _MetricRow(label: 'CPU 온도', value: '62°C'),
            SizedBox(height: 8),
            _MetricRow(label: '팬 속도', value: '3100 RPM'),
            SizedBox(height: 8),
            _MetricRow(label: '화면 재생률', value: '90Hz (OLED)'),
          ],
        ),
      ),
    ];
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        Text(value, style: const TextStyle(color: Color(0xFF67C1F5), fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
