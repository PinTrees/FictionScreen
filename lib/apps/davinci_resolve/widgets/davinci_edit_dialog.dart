import 'package:flutter/material.dart';
import '../data/davinci_resolve_model.dart';

class DavinciResolveEditDialog extends StatefulWidget {
  final DavinciConfig initialConfig;
  final ValueChanged<DavinciConfig> onSave;

  const DavinciResolveEditDialog({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  @override
  State<DavinciResolveEditDialog> createState() => _DavinciResolveEditDialogState();
}

class _DavinciResolveEditDialogState extends State<DavinciResolveEditDialog> {
  late TextEditingController _projectController;
  late TextEditingController _timelineController;
  late TextEditingController _timecodeController;
  late TextEditingController _renderStatusController;
  late String _resolution;
  late String _lutPreset;
  late double _temp;
  late double _tint;
  late double _contrast;
  late double _saturation;

  final List<String> _resolutions = [
    '3840 x 2160 Ultra HD 24.00fps',
    '4096 x 2160 DCI 4K 23.98fps',
    '1920 x 1080 Full HD 60.00fps',
    '1080 x 1920 9:16 Shorts/Reels',
  ];

  final List<String> _lutPresets = [
    'Teal & Orange (헐리우드 블록버스터)',
    'Vintage 35mm Kodak Film (빈티지 필름)',
    'Cyberpunk Neon Night (사이버펑크 네온)',
    'Clean Commercial Warm (화사한 광고 톤)',
  ];

  @override
  void initState() {
    super.initState();
    final cfg = widget.initialConfig;
    _projectController = TextEditingController(text: cfg.projectName);
    _timelineController = TextEditingController(text: cfg.timelineName);
    _timecodeController = TextEditingController(text: cfg.activeTimecode);
    _renderStatusController = TextEditingController(text: cfg.renderStatus);
    _resolution = cfg.resolution;
    _lutPreset = cfg.activeLutPreset;
    _temp = cfg.colorValues.temp;
    _tint = cfg.colorValues.tint;
    _contrast = cfg.colorValues.contrast;
    _saturation = cfg.colorValues.saturation;
  }

  @override
  void dispose() {
    _projectController.dispose();
    _timelineController.dispose();
    _timecodeController.dispose();
    _renderStatusController.dispose();
    super.dispose();
  }

  void _save() {
    final updatedColorValues = widget.initialConfig.colorValues.copyWith(
      temp: _temp,
      tint: _tint,
      contrast: _contrast,
      saturation: _saturation,
    );

    final updated = widget.initialConfig.copyWith(
      projectName: _projectController.text.trim(),
      timelineName: _timelineController.text.trim(),
      activeTimecode: _timecodeController.text.trim(),
      renderStatus: _renderStatusController.text.trim(),
      resolution: _resolution,
      activeLutPreset: _lutPreset,
      colorValues: updatedColorValues,
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  void _restoreDefaults() {
    final def = DavinciConfig.defaultPreset();
    setState(() {
      _projectController.text = def.projectName;
      _timelineController.text = def.timelineName;
      _timecodeController.text = def.activeTimecode;
      _renderStatusController.text = def.renderStatus;
      _resolution = def.resolution;
      _lutPreset = def.activeLutPreset;
      _temp = def.colorValues.temp;
      _tint = def.colorValues.tint;
      _contrast = def.colorValues.contrast;
      _saturation = def.colorValues.saturation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1B1B1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 580,
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.palette, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DaVinci Resolve Studio 환경 설정', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('프로젝트, 타임코드, 색보정 LUT 및 비디오 규격을 편집합니다.', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(color: Color(0xFF28282C), height: 24),

            // Form inputs
            Row(
              children: [
                Expanded(child: _buildTextField('프로젝트명', _projectController)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('타임라인명', _timelineController)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField('타임코드 (Timecode)', _timecodeController)),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown('해상도 / 프레임레이트', _resolution, _resolutions, (val) {
                    if (val != null) setState(() => _resolution = val);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDropdown('색보정 LUT 프리셋', _lutPreset, _lutPresets, (val) {
              if (val != null) setState(() => _lutPreset = val);
            }),
            const SizedBox(height: 14),

            // Sliders
            const Text('색보정 파라미터 (Color Adjustments)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildSlider('Temperature', _temp, -50, 50, (v) => setState(() => _temp = v)),
            _buildSlider('Tint', _tint, -50, 50, (v) => setState(() => _tint = v)),
            _buildSlider('Contrast', _contrast, 0.5, 1.8, (v) => setState(() => _contrast = v)),
            _buildSlider('Saturation', _saturation, 0, 100, (v) => setState(() => _saturation = v)),

            const Divider(color: Color(0xFF28282C), height: 24),
            Row(
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16, color: Colors.white70),
                  label: const Text('기본값 복원', style: TextStyle(color: Colors.white70)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF3F3F46))),
                  onPressed: _restoreDefaults,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(color: Colors.white60)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: _save,
                  child: const Text('적용하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 4),
        Container(
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF141416),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF28282C)),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white, fontSize: 12.5),
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 4),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF141416),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF28282C)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              dropdownColor: const Color(0xFF1B1B1E),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11))),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              activeTrackColor: const Color(0xFFE53935),
              thumbColor: Colors.white,
              inactiveTrackColor: Colors.white12,
            ),
            child: Slider(value: value, min: min, max: max, onChanged: onChanged),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(value.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Consolas'), textAlign: TextAlign.right),
        ),
      ],
    );
  }
}
