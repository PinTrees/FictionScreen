import 'package:flutter/material.dart';
import '../data/photoshop_model.dart';

class PhotoshopEditDialog extends StatefulWidget {
  final PhotoshopConfig config;
  final ValueChanged<PhotoshopConfig> onSave;

  const PhotoshopEditDialog({
    super.key,
    required this.config,
    required this.onSave,
  });

  @override
  State<PhotoshopEditDialog> createState() => _PhotoshopEditDialogState();
}

class _PhotoshopEditDialogState extends State<PhotoshopEditDialog> {
  late TextEditingController _titleCtrl;
  late TextEditingController _widthCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _zoomCtrl;
  late TextEditingController _colorModeCtrl;

  late TextEditingController _layerNameCtrl;
  late TextEditingController _layerTextCtrl;
  late double _layerOpacity;
  late String _layerBlendMode;
  Color _selectedColor = const Color(0xFF31A8FF);

  final List<String> _blendModes = ['표준', '곱하기', '스크린', '오버레이', '소프트 라이트', '색상 닷지'];
  final List<Color> _swatches = [
    const Color(0xFF31A8FF), // Adobe Cyan
    const Color(0xFF5865F2), // Blurple
    const Color(0xFFE91E63), // Pink
    const Color(0xFFFFD54F), // Gold
    const Color(0xFF00D26A), // Green
    const Color(0xFF212121), // Dark Shadow
    const Color(0xFFFFFFFF), // White
  ];

  @override
  void initState() {
    super.initState();
    final cfg = widget.config;
    _titleCtrl = TextEditingController(text: cfg.documentTitle);
    _widthCtrl = TextEditingController(text: '${cfg.widthPx}');
    _heightCtrl = TextEditingController(text: '${cfg.heightPx}');
    _zoomCtrl = TextEditingController(text: '${cfg.zoomPercent}');
    _colorModeCtrl = TextEditingController(text: cfg.colorMode);

    final activeLayer = cfg.layers.firstWhere(
      (l) => l.id == cfg.selectedLayerId,
      orElse: () => cfg.layers.first,
    );

    _layerNameCtrl = TextEditingController(text: activeLayer.name);
    _layerTextCtrl = TextEditingController(text: activeLayer.textContent ?? '');
    _layerOpacity = activeLayer.opacity;
    _layerBlendMode = activeLayer.blendMode;
    _selectedColor = activeLayer.color;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    _zoomCtrl.dispose();
    _colorModeCtrl.dispose();
    _layerNameCtrl.dispose();
    _layerTextCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final cfg = widget.config;

    // Update active layer
    final updatedLayers = cfg.layers.map((l) {
      if (l.id == cfg.selectedLayerId) {
        return l.copyWith(
          name: _layerNameCtrl.text.trim(),
          textContent: _layerTextCtrl.text.trim().isNotEmpty ? _layerTextCtrl.text.trim() : null,
          opacity: _layerOpacity,
          blendMode: _layerBlendMode,
          color: _selectedColor,
        );
      }
      return l;
    }).toList();

    final updated = cfg.copyWith(
      documentTitle: _titleCtrl.text.trim(),
      widthPx: int.tryParse(_widthCtrl.text.trim()) ?? cfg.widthPx,
      heightPx: int.tryParse(_heightCtrl.text.trim()) ?? cfg.heightPx,
      zoomPercent: int.tryParse(_zoomCtrl.text.trim()) ?? cfg.zoomPercent,
      colorMode: _colorModeCtrl.text.trim(),
      layers: updatedLayers,
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  void _addNewLayer() {
    final cfg = widget.config;
    final newId = 'layer-${DateTime.now().millisecondsSinceEpoch}';
    final newLayer = PhotoshopLayer(
      id: newId,
      name: '새 레이어 ${cfg.layers.length + 1}',
      type: 'pixel',
      color: _selectedColor,
    );

    final updatedLayers = [newLayer, ...cfg.layers];
    setState(() {
      _layerNameCtrl.text = newLayer.name;
      _layerTextCtrl.clear();
      _layerOpacity = 1.0;
      _layerBlendMode = '표준';
    });

    final updated = cfg.copyWith(
      layers: updatedLayers,
      selectedLayerId: newId,
    );
    widget.onSave(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF282828),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 520,
        constraints: const BoxConstraints(maxHeight: 680),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF001E36),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF31A8FF), width: 1),
                  ),
                  child: const Text(
                    'Ps',
                    style: TextStyle(color: Color(0xFF31A8FF), fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '포토샵 문서 및 레이어 설정',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Color(0xFF9E9E9E)),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Form
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('문서 정보'),
                    _buildTextField(controller: _titleCtrl, label: '문서 제목 (PSD 파일명)', hint: '진짜최종_시안_final_v4.psd'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(controller: _widthCtrl, label: '가로 해상도 (px)', hint: '1920', keyboardType: TextInputType.number),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(controller: _heightCtrl, label: '세로 해상도 (px)', hint: '1080', keyboardType: TextInputType.number),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(controller: _colorModeCtrl, label: '색상 모드', hint: 'RGB/8#'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('선택된 레이어 속성'),
                        ElevatedButton.icon(
                          onPressed: _addNewLayer,
                          icon: const Icon(Icons.add, size: 12),
                          label: const Text('새 레이어 추가', style: TextStyle(fontSize: 11)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF383838),
                            foregroundColor: const Color(0xFF31A8FF),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(controller: _layerNameCtrl, label: '레이어 이름', hint: '텍스트: 메인 비주얼'),
                    const SizedBox(height: 10),
                    _buildTextField(controller: _layerTextCtrl, label: '텍스트 내용 (텍스트 레이어일 경우)', hint: 'FICTION SCREEN'),
                    const SizedBox(height: 12),

                    // Opacity Slider
                    Row(
                      children: [
                        Text('불투명도: ${(_layerOpacity * 100).round()}%', style: const TextStyle(color: Color(0xFFB5B5B5), fontSize: 11.5)),
                        Expanded(
                          child: Slider(
                            value: _layerOpacity,
                            activeColor: const Color(0xFF31A8FF),
                            inactiveColor: const Color(0xFF3E3E3E),
                            onChanged: (v) => setState(() => _layerOpacity = v),
                          ),
                        ),
                      ],
                    ),

                    // Blend mode dropdown
                    Row(
                      children: [
                        const Text('블렌딩 모드: ', style: TextStyle(color: Color(0xFFB5B5B5), fontSize: 11.5)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF333333),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF454545)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _layerBlendMode,
                              dropdownColor: const Color(0xFF333333),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              items: _blendModes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                              onChanged: (v) => setState(() => _layerBlendMode = v ?? '표준'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Color swatch
                    const Text('레이어 대표 색상', style: TextStyle(color: Color(0xFFB5B5B5), fontSize: 11.5)),
                    const SizedBox(height: 6),
                    Row(
                      children: _swatches.map((c) {
                        final isSelected = _selectedColor == c;
                        return InkWell(
                          onTap: () => setState(() => _selectedColor = c),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: c,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF31A8FF) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(color: Color(0xFF9E9E9E))),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF31A8FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  ),
                  child: const Text('적용하기', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF31A8FF)),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 12.5, color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF6E6E6E)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            isDense: true,
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF3E3E3E)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF31A8FF)),
            ),
          ),
        ),
      ],
    );
  }
}
