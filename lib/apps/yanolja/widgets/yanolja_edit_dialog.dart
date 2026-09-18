import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/yanolja_model.dart';

class YanoljaEditDialog extends StatefulWidget {
  final YanoljaConfig config;
  final ValueChanged<YanoljaConfig> onSave;

  const YanoljaEditDialog({
    super.key,
    required this.config,
    required this.onSave,
  });

  static Future<void> show(BuildContext context, YanoljaConfig config, ValueChanged<YanoljaConfig> onSave) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => YanoljaEditDialog(config: config, onSave: onSave),
    );
  }

  @override
  State<YanoljaEditDialog> createState() => _YanoljaEditDialogState();
}

class _YanoljaEditDialogState extends State<YanoljaEditDialog> {
  late TextEditingController _regionCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _lodgingNameCtrl;
  late TextEditingController _rentPriceCtrl;
  late TextEditingController _stayPriceCtrl;
  late TextEditingController _guestNameCtrl;

  @override
  void initState() {
    super.initState();
    _regionCtrl = TextEditingController(text: widget.config.selectedRegion);
    _dateCtrl = TextEditingController(text: widget.config.dateRangeText);
    _lodgingNameCtrl = TextEditingController(text: widget.config.lodgings.first.name);
    _rentPriceCtrl = TextEditingController(text: widget.config.lodgings.first.minRentPrice.toString());
    _stayPriceCtrl = TextEditingController(text: widget.config.lodgings.first.minStayPrice.toString());
    _guestNameCtrl = TextEditingController(text: widget.config.latestReservation?.guestName ?? '김민준');
  }

  @override
  void dispose() {
    _regionCtrl.dispose();
    _dateCtrl.dispose();
    _lodgingNameCtrl.dispose();
    _rentPriceCtrl.dispose();
    _stayPriceCtrl.dispose();
    _guestNameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.config.selectedRegion = _regionCtrl.text.trim();
    widget.config.dateRangeText = _dateCtrl.text.trim();
    if (widget.config.lodgings.isNotEmpty) {
      widget.config.lodgings.first.name = _lodgingNameCtrl.text.trim();
      widget.config.lodgings.first.minRentPrice = int.tryParse(_rentPriceCtrl.text.replaceAll(',', '').trim()) ?? widget.config.lodgings.first.minRentPrice;
      widget.config.lodgings.first.minStayPrice = int.tryParse(_stayPriceCtrl.text.replaceAll(',', '').trim()) ?? widget.config.lodgings.first.minStayPrice;
    }
    if (widget.config.latestReservation != null) {
      widget.config.latestReservation!.guestName = _guestNameCtrl.text.trim();
    }
    widget.onSave(widget.config);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E24),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(CupertinoIcons.bed_double_fill, color: Color(0xFFFF3478), size: 22),
                const SizedBox(width: 8),
                const Text('야놀자 설정 및 데이터 수정', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, color: Colors.white54, size: 18),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField('검색 지역 / 위치', _regionCtrl)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField('숙박 일정 (일자)', _dateCtrl)),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField('대표 숙소명', _lodgingNameCtrl),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildTextField('대실 가격 (원)', _rentPriceCtrl, isNumber: true)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField('숙박 가격 (원)', _stayPriceCtrl, isNumber: true)),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField('예약자 이름 (스토리 연출용)', _guestNameCtrl),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3478),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _save,
              child: const Text('수정 완료', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2C2C34),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
