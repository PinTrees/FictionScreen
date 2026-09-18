import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/kakaobank_model.dart';

class KakaoBankEditDialog extends StatefulWidget {
  final KakaoBankConfig config;
  final ValueChanged<KakaoBankConfig> onSave;

  const KakaoBankEditDialog({
    super.key,
    required this.config,
    required this.onSave,
  });

  static Future<void> show(BuildContext context, KakaoBankConfig config, ValueChanged<KakaoBankConfig> onSave) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => KakaoBankEditDialog(config: config, onSave: onSave),
    );
  }

  @override
  State<KakaoBankEditDialog> createState() => _KakaoBankEditDialogState();
}

class _KakaoBankEditDialogState extends State<KakaoBankEditDialog> {
  late TextEditingController _userNameCtrl;
  late TextEditingController _accountNameCtrl;
  late TextEditingController _accountNumCtrl;
  late TextEditingController _balanceCtrl;
  late TextEditingController _safeBoxCtrl;
  late TextEditingController _savingsCtrl;

  @override
  void initState() {
    super.initState();
    _userNameCtrl = TextEditingController(text: widget.config.userName);
    _accountNameCtrl = TextEditingController(text: widget.config.accountName);
    _accountNumCtrl = TextEditingController(text: widget.config.accountNumber);
    _balanceCtrl = TextEditingController(text: widget.config.balance.toString());
    _safeBoxCtrl = TextEditingController(text: widget.config.safeBoxBalance.toString());
    _savingsCtrl = TextEditingController(text: widget.config.savingsBalance.toString());
  }

  @override
  void dispose() {
    _userNameCtrl.dispose();
    _accountNameCtrl.dispose();
    _accountNumCtrl.dispose();
    _balanceCtrl.dispose();
    _safeBoxCtrl.dispose();
    _savingsCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.config.userName = _userNameCtrl.text.trim();
    widget.config.accountName = _accountNameCtrl.text.trim();
    widget.config.accountNumber = _accountNumCtrl.text.trim();
    widget.config.balance = int.tryParse(_balanceCtrl.text.replaceAll(',', '').trim()) ?? widget.config.balance;
    widget.config.safeBoxBalance = int.tryParse(_safeBoxCtrl.text.replaceAll(',', '').trim()) ?? widget.config.safeBoxBalance;
    widget.config.savingsBalance = int.tryParse(_savingsCtrl.text.replaceAll(',', '').trim()) ?? widget.config.savingsBalance;
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
                const Icon(CupertinoIcons.creditcard_fill, color: Color(0xFFFEE500), size: 22),
                const SizedBox(width: 8),
                const Text('카카오뱅크 통장 설정', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
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
                Expanded(child: _buildTextField('사용자 이름', _userNameCtrl)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField('통장 이름', _accountNameCtrl)),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField('계좌 번호', _accountNumCtrl),
            const SizedBox(height: 10),
            _buildTextField('메인 통장 잔액 (원)', _balanceCtrl, isNumber: true),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildTextField('세이프박스 잔액 (원)', _safeBoxCtrl, isNumber: true)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField('26주 적금 잔액 (원)', _savingsCtrl, isNumber: true)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEE500),
                foregroundColor: Colors.black87,
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
