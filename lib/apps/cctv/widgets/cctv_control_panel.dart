import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/cctv_model.dart';

class CctvControlPanel extends StatelessWidget {
  final CctvConfig config;
  final ValueChanged<CctvGridMode> onGridModeChanged;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onToggleScanlines;
  final VoidCallback onToggleNoise;
  final VoidCallback onOpenEditDialog;
  final ValueChanged<int> onSelectChannel;

  const CctvControlPanel({
    super.key,
    required this.config,
    required this.onGridModeChanged,
    required this.onTogglePlay,
    required this.onSpeedChanged,
    required this.onToggleScanlines,
    required this.onToggleNoise,
    required this.onOpenEditDialog,
    required this.onSelectChannel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF10141B),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 관제 상단 툴바
          Row(
            children: [
              // NVR 상태 인디케이터
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF66).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF00FF66).withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF00FF66),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'SECURE-NVR ONLINE',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Color(0xFF00FF66),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // 분할 모드 전환 버튼들
              _buildModeButton('4분할', CctvGridMode.split4, CupertinoIcons.square_grid_2x2_fill),
              const SizedBox(width: 4),
              _buildModeButton('9분할', CctvGridMode.split9, CupertinoIcons.circle_grid_3x3_fill),
              const SizedBox(width: 4),
              _buildModeButton('1채널', CctvGridMode.single, CupertinoIcons.viewfinder),

              const Spacer(),

              // CRT 스캔라인 & 노이즈 토글
              _buildToggleButton('SCANLINES', config.showScanlines, onToggleScanlines),
              const SizedBox(width: 6),
              _buildToggleButton('NOISE', config.showNoise, onToggleNoise),
              const SizedBox(width: 10),

              // 시나리오 편집 버튼
              ElevatedButton.icon(
                onPressed: onOpenEditDialog,
                icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 14),
                label: const Text('시나리오 설정', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 2. 하단 NVR 타임라인 재생 및 스크러버 바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF181D26),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                // 재생 / 일시정지
                IconButton(
                  onPressed: onTogglePlay,
                  icon: Icon(
                    config.isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                    color: config.isPlaying ? const Color(0xFF00FF66) : Colors.white70,
                    size: 18,
                  ),
                  tooltip: config.isPlaying ? '일시정지' : '재생',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),

                // 배속 스위처 (1x, 2x, 4x, 8x)
                InkWell(
                  onTap: () {
                    final nextSpeed = config.playbackSpeed == 1.0
                        ? 2.0
                        : config.playbackSpeed == 2.0
                            ? 4.0
                            : config.playbackSpeed == 4.0
                                ? 8.0
                                : 1.0;
                    onSpeedChanged(nextSpeed);
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      '${config.playbackSpeed.toInt()}X',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 가상 타임라인 트랙 (이벤트 마커 시각화)
                Expanded(
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1218),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Stack(
                      children: [
                        // 녹화 정상 구간 (초록색 바)
                        Positioned.fill(
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.95,
                            child: Container(color: const Color(0xFF1B4332).withValues(alpha: 0.7)),
                          ),
                        ),
                        // 모션 감지 이벤트 구간 (빨간색 마커)
                        Positioned(
                          left: 60,
                          width: 25,
                          top: 0,
                          bottom: 0,
                          child: Container(color: const Color(0xFFFF2222).withValues(alpha: 0.8)),
                        ),
                        Positioned(
                          left: 180,
                          width: 35,
                          top: 0,
                          bottom: 0,
                          child: Container(color: const Color(0xFFFF2222).withValues(alpha: 0.8)),
                        ),
                        Positioned(
                          left: 280,
                          width: 18,
                          top: 0,
                          bottom: 0,
                          child: Container(color: const Color(0xFFFF2222).withValues(alpha: 0.8)),
                        ),
                        // 현재 재생 헤드 플레이바
                        Positioned(
                          left: 200,
                          top: 0,
                          bottom: 0,
                          child: Container(width: 2, color: const Color(0xFF00FF66)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 스토리지 상태 인디케이터
                const Text(
                  'HDD: 14.2TB/16TB [REC]',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, CctvGridMode mode, IconData icon) {
    final isSelected = config.gridMode == mode;
    return InkWell(
      onTap: () => onGridModeChanged(mode),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00FF66).withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? const Color(0xFF00FF66) : Colors.white24,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: isSelected ? const Color(0xFF00FF66) : Colors.white70),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                color: isSelected ? const Color(0xFF00FF66) : Colors.white70,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isOn, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isOn ? const Color(0xFF2563EB).withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isOn ? const Color(0xFF3B82F6) : Colors.white12,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            color: isOn ? const Color(0xFF60A5FA) : Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
