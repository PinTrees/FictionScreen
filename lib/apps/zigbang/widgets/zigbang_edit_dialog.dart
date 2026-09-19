import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/zigbang_model.dart';

/// 직방 매물 정보 및 시나리오 실시간 편집 모달
class ZigbangEditDialog extends StatefulWidget {
  final ZigbangConfig config;
  final ValueChanged<ZigbangConfig> onConfigChanged;

  const ZigbangEditDialog({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<ZigbangEditDialog> createState() => _ZigbangEditDialogState();
}

class _ZigbangEditDialogState extends State<ZigbangEditDialog> {
  late String _selectedPropertyId;
  late TextEditingController _titleController;
  late TextEditingController _depositController;
  late TextEditingController _rentController;
  late TextEditingController _areaController;
  late TextEditingController _floorController;
  late TextEditingController _locationController;
  late TextEditingController _agentController;
  late TextEditingController _descController;
  late TextEditingController _tagsController;
  String _priceType = '월세';
  String _roomType = '원·투룸';

  @override
  void initState() {
    super.initState();
    _selectedPropertyId = widget.config.selectedPropertyId;
    _initControllersFor(widget.config.selectedProperty);
  }

  void _initControllersFor(ZigbangProperty prop) {
    _titleController = TextEditingController(text: prop.title);
    _depositController = TextEditingController(text: prop.deposit);
    _rentController = TextEditingController(text: prop.rent);
    _areaController = TextEditingController(text: prop.area);
    _floorController = TextEditingController(text: prop.floor);
    _locationController = TextEditingController(text: prop.location);
    _agentController = TextEditingController(text: prop.agentName);
    _descController = TextEditingController(text: prop.description);
    _tagsController = TextEditingController(text: prop.tags.join(', '));
    _priceType = prop.priceType;
    _roomType = prop.roomType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _depositController.dispose();
    _rentController.dispose();
    _areaController.dispose();
    _floorController.dispose();
    _locationController.dispose();
    _agentController.dispose();
    _descController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _saveCurrentProperty() {
    final updatedList = widget.config.properties.map((p) {
      if (p.id == _selectedPropertyId) {
        final parsedTags = _tagsController.text
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();

        return p.copyWith(
          title: _titleController.text.trim(),
          priceType: _priceType,
          roomType: _roomType,
          deposit: _depositController.text.trim(),
          rent: _rentController.text.trim(),
          area: _areaController.text.trim(),
          floor: _floorController.text.trim(),
          location: _locationController.text.trim(),
          agentName: _agentController.text.trim(),
          description: _descController.text.trim(),
          tags: parsedTags,
        );
      }
      return p;
    }).toList();

    widget.onConfigChanged(
      widget.config.copyWith(
        properties: updatedList,
        selectedPropertyId: _selectedPropertyId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E212B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 580,
        height: 640,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset('assets/images/zigbang_icon.webp', width: 28, height: 28),
                ),
                const SizedBox(width: 12),
                const Text(
                  '직방 매물 & 시나리오 편집',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, color: Colors.white70, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 매물 선택 탭
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.config.properties.map((p) {
                  final isSelected = p.id == _selectedPropertyId;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFFFF7800),
                      backgroundColor: const Color(0xFF2E3444),
                      onSelected: (val) {
                        if (val) {
                          _saveCurrentProperty();
                          setState(() {
                            _selectedPropertyId = p.id;
                            _initControllersFor(p);
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // 입력 폼
            Expanded(
              child: ListView(
                children: [
                  _buildTextField('매물명 (헤드라인)', _titleController),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          '거래 종류',
                          _priceType,
                          ['월세', '전세', '매매'],
                          (val) => setState(() => _priceType = val ?? '월세'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          '매물 형태',
                          _roomType,
                          ['원·투룸', '오피스텔', '아파트', '빌라'],
                          (val) => setState(() => _roomType = val ?? '원·투룸'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('보증금 / 매매가', _depositController)),
                      if (_priceType == '월세') ...[
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('월세', _rentController)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('전용 면적 (평형)', _areaController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('층수 정보', _floorController)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField('위치 / 지하철역', _locationController),
                  const SizedBox(height: 12),
                  _buildTextField('중개사무소 정보', _agentController),
                  const SizedBox(height: 12),
                  _buildTextField('특징 태그 (쉼표로 구분)', _tagsController),
                  const SizedBox(height: 12),
                  _buildTextField('상세 설명', _descController, maxLines: 3),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 하단 저장 버튼
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    widget.onConfigChanged(ZigbangConfig.defaultPreset());
                    Navigator.pop(context);
                  },
                  icon: const Icon(CupertinoIcons.arrow_counterclockwise, size: 14, color: Colors.white60),
                  label: const Text('기본값 초기화', style: TextStyle(color: Colors.white60, fontSize: 13)),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7800),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    _saveCurrentProperty();
                    Navigator.pop(context);
                  },
                  child: const Text('저장 완료', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF141720),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String current, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF141720),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: current,
              isExpanded: true,
              dropdownColor: const Color(0xFF141720),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
