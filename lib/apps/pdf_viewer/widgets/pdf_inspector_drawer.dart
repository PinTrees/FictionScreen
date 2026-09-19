import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/pdf_document_model.dart';
import '../data/pdf_templates_data.dart';

/// PDF 서식 선택 및 실시간 폼 필드 편집 인스펙터 서랍
class PdfInspectorDrawer extends StatefulWidget {
  final PdfDocumentData documentData;
  final Function(PdfDocumentData) onDocumentChanged;
  final VoidCallback onClose;

  const PdfInspectorDrawer({
    super.key,
    required this.documentData,
    required this.onDocumentChanged,
    required this.onClose,
  });

  @override
  State<PdfInspectorDrawer> createState() => _PdfInspectorDrawerState();
}

class _PdfInspectorDrawerState extends State<PdfInspectorDrawer> {
  late PdfDocumentData _doc;
  final List<PdfDocumentData> _allTemplates = PdfTemplatesData.getAllTemplates();

  late TextEditingController _titleCtrl;
  late TextEditingController _subtitleCtrl;
  late TextEditingController _docNumberCtrl;
  late TextEditingController _partyANameCtrl;
  late TextEditingController _partyAIdCtrl;
  late TextEditingController _partyAAddressCtrl;
  late TextEditingController _partyBNameCtrl;
  late TextEditingController _partyBIdCtrl;
  late TextEditingController _partyBAddressCtrl;
  late TextEditingController _amountCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _institutionCtrl;
  late TextEditingController _specialTermsCtrl;
  late TextEditingController _stampTextCtrl;
  late TextEditingController _watermarkTextCtrl;

  @override
  void initState() {
    super.initState();
    _doc = widget.documentData.copyWith();
    _initControllers();
  }

  void _initControllers() {
    _titleCtrl = TextEditingController(text: _doc.title);
    _subtitleCtrl = TextEditingController(text: _doc.subtitle);
    _docNumberCtrl = TextEditingController(text: _doc.docNumber);
    _partyANameCtrl = TextEditingController(text: _doc.partyAName);
    _partyAIdCtrl = TextEditingController(text: _doc.partyAId);
    _partyAAddressCtrl = TextEditingController(text: _doc.partyAAddress);
    _partyBNameCtrl = TextEditingController(text: _doc.partyBName);
    _partyBIdCtrl = TextEditingController(text: _doc.partyBId);
    _partyBAddressCtrl = TextEditingController(text: _doc.partyBAddress);
    _amountCtrl = TextEditingController(text: _doc.amountText);
    _dateCtrl = TextEditingController(text: _doc.dateText);
    _institutionCtrl = TextEditingController(text: _doc.institutionName);
    _specialTermsCtrl = TextEditingController(text: _doc.specialTerms);
    _stampTextCtrl = TextEditingController(text: _doc.stampText);
    _watermarkTextCtrl = TextEditingController(text: _doc.watermarkText);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _docNumberCtrl.dispose();
    _partyANameCtrl.dispose();
    _partyAIdCtrl.dispose();
    _partyAAddressCtrl.dispose();
    _partyBNameCtrl.dispose();
    _partyBIdCtrl.dispose();
    _partyBAddressCtrl.dispose();
    _amountCtrl.dispose();
    _dateCtrl.dispose();
    _institutionCtrl.dispose();
    _specialTermsCtrl.dispose();
    _stampTextCtrl.dispose();
    _watermarkTextCtrl.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onDocumentChanged(_doc);
  }

  void _selectTemplate(PdfDocumentData template) {
    setState(() {
      _doc = template.copyWith();
      _initControllers();
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      decoration: const BoxDecoration(
        color: Color(0xFF1E222D),
        border: Border(
          left: BorderSide(color: Color(0xFF333A4C), width: 1),
        ),
      ),
      child: Column(
        children: [
          // 인스펙터 헤더
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF282D3C),
              border: Border(bottom: BorderSide(color: Color(0xFF333A4C))),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.slider_horizontal_3, size: 16, color: Color(0xFF60A5FA)),
                const SizedBox(width: 8),
                const Text(
                  '문서 서식 & 필드 설정',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, size: 16, color: Colors.white70),
                  onPressed: widget.onClose,
                  tooltip: '설정 닫기',
                ),
              ],
            ),
          ),

          // 스크롤 가능한 폼 컨트롤
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                // 1. 가상 서식 템플릿 선택기
                _buildSectionTitle('가상 서식 템플릿 라이브러리'),
                const SizedBox(height: 6),
                _buildTemplateSelector(),
                const SizedBox(height: 18),

                // 2. 문서 기본 정보
                _buildSectionTitle('문서 기본 정보'),
                const SizedBox(height: 8),
                _buildTextField('문서 제목', _titleCtrl, (val) {
                  _doc.title = val;
                  _notifyChange();
                }),
                _buildTextField('부제목 / 법률 근거', _subtitleCtrl, (val) {
                  _doc.subtitle = val;
                  _notifyChange();
                }),
                _buildTextField('문서 등록 번호', _docNumberCtrl, (val) {
                  _doc.docNumber = val;
                  _notifyChange();
                }),
                _buildTextField('작성 일자', _dateCtrl, (val) {
                  _doc.dateText = val;
                  _notifyChange();
                }),
                _buildTextField('기관 / 법원 / 회사명', _institutionCtrl, (val) {
                  _doc.institutionName = val;
                  _notifyChange();
                }),
                const SizedBox(height: 16),

                // 3. 당사자 (갑) 정보
                _buildSectionTitle('당사자 정보 (${_doc.partyATitle})'),
                const SizedBox(height: 8),
                _buildTextField('성명 / 상호', _partyANameCtrl, (val) {
                  _doc.partyAName = val;
                  _notifyChange();
                }),
                _buildTextField('주민번호 / 사업자번호', _partyAIdCtrl, (val) {
                  _doc.partyAId = val;
                  _notifyChange();
                }),
                _buildTextField('주소지', _partyAAddressCtrl, (val) {
                  _doc.partyAAddress = val;
                  _notifyChange();
                }),
                const SizedBox(height: 16),

                // 4. 당사자 (을) 정보
                _buildSectionTitle('상대방 정보 (${_doc.partyBTitle})'),
                const SizedBox(height: 8),
                _buildTextField('성명 / 상호', _partyBNameCtrl, (val) {
                  _doc.partyBName = val;
                  _notifyChange();
                }),
                _buildTextField('주민번호 / 사업자번호', _partyBIdCtrl, (val) {
                  _doc.partyBId = val;
                  _notifyChange();
                }),
                _buildTextField('주소지', _partyBAddressCtrl, (val) {
                  _doc.partyBAddress = val;
                  _notifyChange();
                }),
                const SizedBox(height: 16),

                // 5. 주요 금액 및 특약
                _buildSectionTitle('금액 & 특약 사항'),
                const SizedBox(height: 8),
                _buildTextField('합의금 / 보증금 / 연봉 등', _amountCtrl, (val) {
                  _doc.amountText = val;
                  _notifyChange();
                }),
                _buildTextField('특약사항 / 비고', _specialTermsCtrl, (val) {
                  _doc.specialTerms = val;
                  _notifyChange();
                }, maxLines: 2),
                const SizedBox(height: 16),

                // 6. 직인 및 도장 설정
                _buildSectionTitle('도장 / 직인 설정'),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('인감도장 날인 표시', style: TextStyle(color: Colors.white, fontSize: 12)),
                  value: _doc.isStampVisible,
                  activeThumbColor: const Color(0xFFEF4444),
                  onChanged: (val) {
                    setState(() => _doc.isStampVisible = val);
                    _notifyChange();
                  },
                ),
                if (_doc.isStampVisible) ...[
                  _buildTextField('도장 문구 (줄바꿈 지원)', _stampTextCtrl, (val) {
                    _doc.stampText = val;
                    _notifyChange();
                  }),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('도장 형태: ', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(width: 8),
                      _buildStampShapeBtn('원형', StampShape.circle),
                      const SizedBox(width: 6),
                      _buildStampShapeBtn('타원', StampShape.oval),
                      const SizedBox(width: 6),
                      _buildStampShapeBtn('사각', StampShape.square),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                // 7. 워터마크 및 바코드
                _buildSectionTitle('보안 워터마크 & 바코드'),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('대각선 워터마크 표시', style: TextStyle(color: Colors.white, fontSize: 12)),
                  value: _doc.isWatermarkVisible,
                  activeThumbColor: const Color(0xFF3B82F6),
                  onChanged: (val) {
                    setState(() => _doc.isWatermarkVisible = val);
                    _notifyChange();
                  },
                ),
                if (_doc.isWatermarkVisible)
                  _buildTextField('워터마크 텍스트', _watermarkTextCtrl, (val) {
                    _doc.watermarkText = val;
                    _notifyChange();
                  }),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('상단 보안 바코드 표시', style: TextStyle(color: Colors.white, fontSize: 12)),
                  value: _doc.isBarcodeVisible,
                  activeThumbColor: const Color(0xFF10B981),
                  onChanged: (val) {
                    setState(() => _doc.isBarcodeVisible = val);
                    _notifyChange();
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 3, height: 12, color: const Color(0xFF60A5FA)),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151821),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF333A4C)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PdfTemplateType>(
          isExpanded: true,
          value: _doc.templateType,
          dropdownColor: const Color(0xFF1E222D),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          icon: const Icon(CupertinoIcons.chevron_down, size: 14, color: Colors.white70),
          items: _allTemplates.map((tpl) {
            return DropdownMenuItem<PdfTemplateType>(
              value: tpl.templateType,
              child: Text(
                tpl.title,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              final found = _allTemplates.firstWhere((e) => e.templateType == val);
              _selectTemplate(found);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, Function(String) onChanged, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10.5)),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white, fontSize: 11.5),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              filled: true,
              fillColor: const Color(0xFF151821),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF333A4C)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF333A4C)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF60A5FA)),
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildStampShapeBtn(String label, StampShape shape) {
    final isSelected = _doc.stampShape == shape;

    return InkWell(
      onTap: () {
        setState(() => _doc.stampShape = shape);
        _notifyChange();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEF4444) : const Color(0xFF282D3C),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFF333A4C),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
