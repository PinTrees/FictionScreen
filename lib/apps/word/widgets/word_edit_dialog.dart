import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/word_model.dart';

class WordEditDialog extends StatefulWidget {
  final WordConfig config;
  final ValueChanged<WordConfig> onApply;

  const WordEditDialog({
    super.key,
    required this.config,
    required this.onApply,
  });

  @override
  State<WordEditDialog> createState() => _WordEditDialogState();
}

class _WordEditDialogState extends State<WordEditDialog> {
  late TextEditingController _titleCtrl;
  late TextEditingController _codeCtrl;
  late TextEditingController _deptCtrl;
  late TextEditingController _authorCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _stampCtrl;
  late TextEditingController _sealCtrl;
  late WordConfig _currentConfig;

  @override
  void initState() {
    super.initState();
    _currentConfig = widget.config;
    _titleCtrl = TextEditingController(text: _currentConfig.documentTitle);
    _codeCtrl = TextEditingController(text: _currentConfig.documentCode);
    _deptCtrl = TextEditingController(text: _currentConfig.department);
    _authorCtrl = TextEditingController(text: _currentConfig.author);
    _dateCtrl = TextEditingController(text: _currentConfig.issueDate);
    _stampCtrl = TextEditingController(text: _currentConfig.confidentialStamp ?? '');
    _sealCtrl = TextEditingController(text: _currentConfig.officialSealName ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _codeCtrl.dispose();
    _deptCtrl.dispose();
    _authorCtrl.dispose();
    _dateCtrl.dispose();
    _stampCtrl.dispose();
    _sealCtrl.dispose();
    super.dispose();
  }

  void _applyPreset(WordConfig preset) {
    setState(() {
      _currentConfig = preset;
      _titleCtrl.text = preset.documentTitle;
      _codeCtrl.text = preset.documentCode;
      _deptCtrl.text = preset.department;
      _authorCtrl.text = preset.author;
      _dateCtrl.text = preset.issueDate;
      _stampCtrl.text = preset.confidentialStamp ?? '';
      _sealCtrl.text = preset.officialSealName ?? '';
    });
  }

  void _save() {
    final updated = _currentConfig.copyWith(
      documentTitle: _titleCtrl.text.trim(),
      documentCode: _codeCtrl.text.trim(),
      department: _deptCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      issueDate: _dateCtrl.text.trim(),
      confidentialStamp: _stampCtrl.text.trim().isEmpty ? null : _stampCtrl.text.trim(),
      officialSealName: _sealCtrl.text.trim().isEmpty ? null : _sealCtrl.text.trim(),
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
                Image.asset('assets/images/word_icon.webp', width: 28, height: 28),
                const SizedBox(width: 10),
                const Text(
                  'Microsoft Word 공문서 및 기밀 서식 설정',
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
              style: TextStyle(color: Color(0xFF185ABD), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetChip('🔒 1급 기밀 보고서', () => _applyPreset(WordConfig.topSecretPreset())),
                  _buildPresetChip('📜 비밀유지 각서 (NDA)', () => _applyPreset(WordConfig.ndaPreset())),
                  _buildPresetChip('⚖️ 상속 유언 공증서', () => _applyPreset(WordConfig.willPreset())),
                  _buildPresetChip('⚔️ S급 각성 인증서', () => _applyPreset(WordConfig.hunterCertPreset())),
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
                  _buildTextField('문서 제목 (Document Title)', _titleCtrl, maxLines: 2),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('문서 관리 번호', _codeCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('소관 부서 / 발행처', _deptCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('기안자 / 담당 변호사', _authorCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('시행 일자', _dateCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('붉은색 기밀 도장 문구 (TOP SECRET)', _stampCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('인감도장 직인 명칭', _sealCtrl)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF272727),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF185ABD).withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.doc_text_fill, color: Color(0xFF185ABD), size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '첩보물 특화 블랙 마스킹 바(REDACTED) 및 붉은 관인 날인이 자동으로 렌더링됩니다.',
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
                    backgroundColor: const Color(0xFF185ABD),
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
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF185ABD))),
          ),
        ),
      ],
    );
  }
}
