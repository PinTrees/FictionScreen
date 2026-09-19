import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/excel_model.dart';

class ExcelEditDialog extends StatefulWidget {
  final ExcelConfig config;
  final ValueChanged<ExcelConfig> onApply;

  const ExcelEditDialog({
    super.key,
    required this.config,
    required this.onApply,
  });

  @override
  State<ExcelEditDialog> createState() => _ExcelEditDialogState();
}

class _ExcelEditDialogState extends State<ExcelEditDialog> {
  late TextEditingController _fileNameCtrl;
  late TextEditingController _authorCtrl;
  late TextEditingController _formulaCtrl;
  late TextEditingController _sumCtrl;
  late TextEditingController _selectedCellCtrl;
  late ExcelConfig _currentConfig;

  @override
  void initState() {
    super.initState();
    _currentConfig = widget.config;
    _fileNameCtrl = TextEditingController(text: _currentConfig.fileName);
    _authorCtrl = TextEditingController(text: _currentConfig.author);
    _formulaCtrl = TextEditingController(text: _currentConfig.formulaText);
    _sumCtrl = TextEditingController(text: _currentConfig.sumText);
    _selectedCellCtrl = TextEditingController(text: _currentConfig.selectedCellKey);
  }

  @override
  void dispose() {
    _fileNameCtrl.dispose();
    _authorCtrl.dispose();
    _formulaCtrl.dispose();
    _sumCtrl.dispose();
    _selectedCellCtrl.dispose();
    super.dispose();
  }

  void _applyPreset(ExcelConfig preset) {
    setState(() {
      _currentConfig = preset;
      _fileNameCtrl.text = preset.fileName;
      _authorCtrl.text = preset.author;
      _formulaCtrl.text = preset.formulaText;
      _sumCtrl.text = preset.sumText;
      _selectedCellCtrl.text = preset.selectedCellKey;
    });
  }

  void _save() {
    final updated = _currentConfig.copyWith(
      fileName: _fileNameCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      formulaText: _formulaCtrl.text.trim(),
      sumText: _sumCtrl.text.trim(),
      selectedCellKey: _selectedCellCtrl.text.trim(),
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
        height: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Image.asset('assets/images/excel_icon.webp', width: 28, height: 28),
                const SizedBox(width: 10),
                const Text(
                  'Microsoft Excel 시나리오 설정',
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
              style: TextStyle(color: Color(0xFF107C41), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetChip('🕵️ 재벌 비자금 장부', () => _applyPreset(ExcelConfig.slushFundPreset())),
                  _buildPresetChip('⚔️ 헌터 레이드 정산', () => _applyPreset(ExcelConfig.hunterRaidPreset())),
                  _buildPresetChip('📉 코인 선물 청산', () => _applyPreset(ExcelConfig.coinPreset())),
                  _buildPresetChip('🚀 스타트업 캡테이블', () => _applyPreset(ExcelConfig.startupPreset())),
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
                  _buildTextField('통합 문서 파일명 (File Name)', _fileNameCtrl),
                  const SizedBox(height: 12),
                  _buildTextField('작성 부서 / 작성자 (Author)', _authorCtrl),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('선택 셀 주소 (Active Cell)', _selectedCellCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('하단 집계 합계액 (Sum)', _sumCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField('수식 입력줄 내용 (Formula fx)', _formulaCtrl),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF272727),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF107C41).withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.info_circle_fill, color: Color(0xFF107C41), size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '스프레드시트 셀을 직접 클릭하면 선택 셀 및 수식 바가 실시간 연동됩니다.',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    backgroundColor: const Color(0xFF107C41),
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

  Widget _buildTextField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: const Color(0xFF272727),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF107C41))),
          ),
        ),
      ],
    );
  }
}
