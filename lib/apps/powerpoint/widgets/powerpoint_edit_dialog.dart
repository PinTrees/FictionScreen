import 'package:flutter/material.dart';
import '../data/powerpoint_model.dart';

class PowerPointEditDialog extends StatefulWidget {
  final PowerPointConfig config;
  final ValueChanged<PowerPointConfig> onApply;

  const PowerPointEditDialog({
    super.key,
    required this.config,
    required this.onApply,
  });

  @override
  State<PowerPointEditDialog> createState() => _PowerPointEditDialogState();
}

class _PowerPointEditDialogState extends State<PowerPointEditDialog> {
  late TextEditingController _titleCtrl;
  late TextEditingController _authorCtrl;
  late TextEditingController _slideTitleCtrl;
  late TextEditingController _slideSubtitleCtrl;
  late TextEditingController _badgeCtrl;
  late TextEditingController _bulletsCtrl;
  late PowerPointConfig _currentConfig;

  @override
  void initState() {
    super.initState();
    _currentConfig = widget.config;
    final active = _currentConfig.activeSlide;
    _titleCtrl = TextEditingController(text: _currentConfig.presentationTitle);
    _authorCtrl = TextEditingController(text: _currentConfig.author);
    _slideTitleCtrl = TextEditingController(text: active.title);
    _slideSubtitleCtrl = TextEditingController(text: active.subtitle);
    _badgeCtrl = TextEditingController(text: active.confidentialBadge ?? '');
    _bulletsCtrl = TextEditingController(text: active.bullets.join('\n'));
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _slideTitleCtrl.dispose();
    _slideSubtitleCtrl.dispose();
    _badgeCtrl.dispose();
    _bulletsCtrl.dispose();
    super.dispose();
  }

  void _applyPreset(PowerPointConfig preset) {
    setState(() {
      _currentConfig = preset;
      final active = preset.activeSlide;
      _titleCtrl.text = preset.presentationTitle;
      _authorCtrl.text = preset.author;
      _slideTitleCtrl.text = active.title;
      _slideSubtitleCtrl.text = active.subtitle;
      _badgeCtrl.text = active.confidentialBadge ?? '';
      _bulletsCtrl.text = active.bullets.join('\n');
    });
  }

  void _save() {
    final activeIdx = _currentConfig.activeSlideIndex;
    final slides = List<PowerPointSlide>.from(_currentConfig.slides);

    final bullets = _bulletsCtrl.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    slides[activeIdx] = slides[activeIdx].copyWith(
      title: _slideTitleCtrl.text.trim(),
      subtitle: _slideSubtitleCtrl.text.trim(),
      confidentialBadge: _badgeCtrl.text.trim().isEmpty ? null : _badgeCtrl.text.trim(),
      bullets: bullets,
    );

    final updated = _currentConfig.copyWith(
      presentationTitle: _titleCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      slides: slides,
    );

    widget.onApply(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 640,
        height: 620,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Image.asset('assets/images/powerpoint_icon.webp', width: 28, height: 28),
                const SizedBox(width: 10),
                const Text(
                  'Microsoft PowerPoint 프레젠테이션 설정',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // 4대 장르 퀵 프리셋
            const Text(
              '🎯 웹툰 / 웹소설 장르별 원클릭 프리셋',
              style: TextStyle(color: Color(0xFFC43E1C), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetChip('🚀 극비 신기술 IR', () => _applyPreset(PowerPointConfig.techIrPreset())),
                  _buildPresetChip('🚨 국가 비상사태 브리핑', () => _applyPreset(PowerPointConfig.emergencyBriefingPreset())),
                  _buildPresetChip('🏛️ 재벌 적대적 M&A', () => _applyPreset(PowerPointConfig.conglomerateMaPreset())),
                  _buildPresetChip('⚔️ S급 레이드 작전', () => _applyPreset(PowerPointConfig.raidBriefingPreset())),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFF333333), height: 1),
            const SizedBox(height: 14),

            // Fields
            Expanded(
              child: ListView(
                children: [
                  _buildTextField('프레젠테이션 파일명', _titleCtrl),
                  const SizedBox(height: 12),
                  _buildTextField('발표자 / 소속 부서', _authorCtrl),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('기밀 / 보안 뱃지 문구 (옵션)', _badgeCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField('현재 슬라이드 제목 (Title)', _slideTitleCtrl, maxLines: 2),
                  const SizedBox(height: 12),
                  _buildTextField('부제목 (Subtitle)', _slideSubtitleCtrl),
                  const SizedBox(height: 12),
                  _buildTextField('핵심 불릿 포인트 (한 줄에 하나씩)', _bulletsCtrl, maxLines: 4),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC43E1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: _save,
                  child: const Text('적용하기', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        backgroundColor: const Color(0xFF2A2A2A),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
        side: const BorderSide(color: Color(0xFF444444)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: const Color(0xFF272727),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFC43E1C))),
          ),
        ),
      ],
    );
  }
}
