import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/daangn_model.dart';

class DaangnEditDialog extends StatefulWidget {
  final DaangnConfig config;
  final ValueChanged<DaangnConfig> onSave;

  const DaangnEditDialog({
    super.key,
    required this.config,
    required this.onSave,
  });

  static Future<void> show(BuildContext context, DaangnConfig config, ValueChanged<DaangnConfig> onSave) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DaangnEditDialog(config: config, onSave: onSave),
    );
  }

  @override
  State<DaangnEditDialog> createState() => _DaangnEditDialogState();
}

class _DaangnEditDialogState extends State<DaangnEditDialog> {
  late TextEditingController _titleCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _sellerCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _tempCtrl;
  late String _tradeStatus;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.config.productTitle);
    _priceCtrl = TextEditingController(text: widget.config.productPrice.toString());
    _sellerCtrl = TextEditingController(text: widget.config.sellerName);
    _locationCtrl = TextEditingController(text: widget.config.sellerLocation);
    _tempCtrl = TextEditingController(text: widget.config.mannerTemp.toString());
    _tradeStatus = widget.config.tradeStatus;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _sellerCtrl.dispose();
    _locationCtrl.dispose();
    _tempCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.config.productTitle = _titleCtrl.text.trim();
    widget.config.productPrice = int.tryParse(_priceCtrl.text.replaceAll(',', '').trim()) ?? widget.config.productPrice;
    widget.config.sellerName = _sellerCtrl.text.trim();
    widget.config.sellerLocation = _locationCtrl.text.trim();
    widget.config.mannerTemp = double.tryParse(_tempCtrl.text.trim()) ?? widget.config.mannerTemp;
    widget.config.tradeStatus = _tradeStatus;
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
                const Icon(CupertinoIcons.pencil_ellipsis_rectangle, color: Color(0xFFFF6F0F), size: 22),
                const SizedBox(width: 8),
                const Text('당근마켓 정보 수정', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, color: Colors.white54, size: 18),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('거래 상태', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: ['판매중', '예약중', '거래완료'].map((st) {
                final isSel = _tradeStatus == st;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(st, style: TextStyle(color: isSel ? Colors.white : Colors.white70, fontSize: 12)),
                    selected: isSel,
                    selectedColor: const Color(0xFFFF6F0F),
                    backgroundColor: const Color(0xFF2C2C34),
                    onSelected: (val) => setState(() => _tradeStatus = st),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            _buildTextField('상품명', _titleCtrl),
            const SizedBox(height: 10),
            _buildTextField('판매 가격 (원)', _priceCtrl, isNumber: true),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildTextField('판매자 닉네임', _sellerCtrl)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField('동네 (예: 역삼동)', _locationCtrl)),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField('매너온도 (°C)', _tempCtrl, isNumber: true),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6F0F),
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
