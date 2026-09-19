import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/cctv_model.dart';

class CctvEditDialog extends StatefulWidget {
  final CctvConfig config;
  final ValueChanged<CctvConfig> onSave;

  const CctvEditDialog({
    super.key,
    required this.config,
    required this.onSave,
  });

  @override
  State<CctvEditDialog> createState() => _CctvEditDialogState();
}

class _CctvEditDialogState extends State<CctvEditDialog> {
  late TextEditingController _titleController;
  late int _selectedChannelId;
  late List<CctvChannel> _channels;
  late TextEditingController _locationController;
  late TextEditingController _targetController;
  late int _year;
  late int _month;
  late int _day;
  late int _hour;
  late int _minute;
  late int _second;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.config.systemTitle);
    _selectedChannelId = widget.config.selectedChannelId;
    _channels = List.from(widget.config.channels);
    final ch = _currentChannel;
    _locationController = TextEditingController(text: ch.location);
    _targetController = TextEditingController(text: ch.motionTarget ?? '');

    final dt = widget.config.baseDateTime;
    _year = dt.year;
    _month = dt.month;
    _day = dt.day;
    _hour = dt.hour;
    _minute = dt.minute;
    _second = dt.second;
  }

  CctvChannel get _currentChannel => _channels.firstWhere(
        (c) => c.id == _selectedChannelId,
        orElse: () => _channels.first,
      );

  void _onSelectChannelTab(int id) {
    _saveCurrentChannelFields();
    setState(() {
      _selectedChannelId = id;
      final ch = _currentChannel;
      _locationController.text = ch.location;
      _targetController.text = ch.motionTarget ?? '';
    });
  }

  void _saveCurrentChannelFields() {
    final idx = _channels.indexWhere((c) => c.id == _selectedChannelId);
    if (idx != -1) {
      _channels[idx] = _channels[idx].copyWith(
        location: _locationController.text.trim(),
        motionTarget: _targetController.text.trim(),
      );
    }
  }

  void _applyPreset(int type) {
    setState(() {
      if (type == 1) {
        // 프리셋 1: 한밤중 의문의 침입자
        _channels = _channels.map((c) {
          if (c.id == 1) {
            return c.copyWith(
              isMotionDetected: true,
              motionTarget: 'TARGET: HOODED SUBJECT [98%]',
              isSignalLost: false,
            );
          } else if (c.id == 4) {
            return c.copyWith(
              isMotionDetected: true,
              motionTarget: 'ALERT: VAULT LOCK PICKED',
              isSignalLost: false,
            );
          }
          return c.copyWith(isMotionDetected: false);
        }).toList();
      } else if (type == 2) {
        // 프리셋 2: 옥상 & 서버실 신호 두절 (통신 단선)
        _channels = _channels.map((c) {
          if (c.id == 6 || c.id == 4) {
            return c.copyWith(isSignalLost: true, isMotionDetected: false);
          }
          return c.copyWith(isSignalLost: false);
        }).toList();
      } else if (type == 3) {
        // 프리셋 3: 전 채널 심야 야간 투시경 (그린 나이트비전)
        _channels = _channels.map((c) {
          return c.copyWith(filterMode: CctvFilterMode.nightVisionGreen);
        }).toList();
      }
      final ch = _currentChannel;
      _locationController.text = ch.location;
      _targetController.text = ch.motionTarget ?? '';
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ch = _currentChannel;

    return Dialog(
      backgroundColor: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF30363D)),
      ),
      child: Container(
        width: 600,
        height: 640,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 다이얼로그 헤더
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.videocam_fill, color: Color(0xFFE53935), size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'CCTV 관제 시나리오 & 카메라 편집',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, color: Colors.white70, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 스릴러 시나리오 퀵 프리셋
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text('퀵 연출: ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  _buildPresetChip('🚨 심야 침입자 감지', () => _applyPreset(1)),
                  const SizedBox(width: 6),
                  _buildPresetChip('⚡ 케이블 단선 (NO SIGNAL)', () => _applyPreset(2)),
                  const SizedBox(width: 6),
                  _buildPresetChip('🟢 전 채널 나이트비전', () => _applyPreset(3)),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 카메라 선택 탭 (CAM 01 ~ CAM 09)
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _channels.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (context, i) {
                  final c = _channels[i];
                  final isSelected = c.id == _selectedChannelId;
                  return InkWell(
                    onTap: () => _onSelectChannelTab(c.id),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE53935) : const Color(0xFF21262D),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: c.isSignalLost
                              ? Colors.redAccent
                              : c.isMotionDetected
                                  ? Colors.orangeAccent
                                  : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        c.code,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 세부 설정 폼
            Expanded(
              child: ListView(
                children: [
                  // 설치 구역명
                  _buildTextField('카메라 설치 위치 (OSD 표기)', _locationController),
                  const SizedBox(height: 12),

                  // 모션 감지 토글 & 타겟 문구
                  Row(
                    children: [
                      Expanded(
                        child: SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('침입자 모션 감지 경보', style: TextStyle(color: Colors.white, fontSize: 13)),
                          subtitle: const Text('화면에 붉은색 타겟 박스 및 점멸 경고', style: TextStyle(color: Colors.white54, fontSize: 11)),
                          value: ch.isMotionDetected,
                          activeThumbColor: const Color(0xFFE53935),
                          onChanged: (val) {
                            setState(() {
                              final idx = _channels.indexWhere((c) => c.id == _selectedChannelId);
                              _channels[idx] = _channels[idx].copyWith(isMotionDetected: val);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (ch.isMotionDetected) ...[
                    _buildTextField('감지 타겟 문구', _targetController),
                    const SizedBox(height: 12),
                  ],

                  // 신호 두절 (NO SIGNAL) 토글
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('신호 두절 (NO SIGNAL)', style: TextStyle(color: Colors.white, fontSize: 13)),
                    subtitle: const Text('카메라 파손 / 단선으로 인한 화면 암전 연출', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    value: ch.isSignalLost,
                    activeThumbColor: const Color(0xFFE53935),
                    onChanged: (val) {
                      setState(() {
                        final idx = _channels.indexWhere((c) => c.id == _selectedChannelId);
                        _channels[idx] = _channels[idx].copyWith(isSignalLost: val);
                      });
                    },
                  ),

                  // 필터 모드 선택
                  const Text('카메라 필터 모드', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: CctvFilterMode.values.map((mode) {
                      final isSel = ch.filterMode == mode;
                      return ChoiceChip(
                        label: Text(mode.label, style: TextStyle(color: isSel ? Colors.white : Colors.white70, fontSize: 11)),
                        selected: isSel,
                        selectedColor: const Color(0xFF238636),
                        backgroundColor: const Color(0xFF21262D),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              final idx = _channels.indexWhere((c) => c.id == _selectedChannelId);
                              _channels[idx] = _channels[idx].copyWith(filterMode: mode);
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 타임스탬프 사건 발생 시각
                  const Text('타임스탬프 기준 시각', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildNumberInput('년', _year, 2000, 2050, (v) => setState(() => _year = v)),
                      const SizedBox(width: 8),
                      _buildNumberInput('월', _month, 1, 12, (v) => setState(() => _month = v)),
                      const SizedBox(width: 8),
                      _buildNumberInput('일', _day, 1, 31, (v) => setState(() => _day = v)),
                      const SizedBox(width: 8),
                      _buildNumberInput('시', _hour, 0, 23, (v) => setState(() => _hour = v)),
                      const SizedBox(width: 8),
                      _buildNumberInput('분', _minute, 0, 59, (v) => setState(() => _minute = v)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 저장 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소', style: TextStyle(color: Colors.white54)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _saveCurrentChannelFields();
                    final newConfig = widget.config.copyWith(
                      systemTitle: _titleController.text.trim(),
                      selectedChannelId: _selectedChannelId,
                      channels: _channels,
                      baseDateTime: DateTime(_year, _month, _day, _hour, _minute, _second),
                    );
                    widget.onSave(newConfig);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF238636),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('설정 적용', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFF0D1117),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF30363D))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF58A6FF))),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberInput(String unit, int value, int min, int max, ValueChanged<int> onChanged) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF30363D)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$value $unit', style: const TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 11)),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    if (value < max) onChanged(value + 1);
                  },
                  child: const Icon(CupertinoIcons.chevron_up, size: 12, color: Colors.white70),
                ),
                InkWell(
                  onTap: () {
                    if (value > min) onChanged(value - 1);
                  },
                  child: const Icon(CupertinoIcons.chevron_down, size: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
