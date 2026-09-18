import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/upbit_model.dart';

class UpbitEditDialog extends StatefulWidget {
  final UpbitConfig config;
  final ValueChanged<UpbitConfig> onSave;

  const UpbitEditDialog({
    super.key,
    required this.config,
    required this.onSave,
  });

  @override
  State<UpbitEditDialog> createState() => _UpbitEditDialogState();
}

class _UpbitEditDialogState extends State<UpbitEditDialog> {
  late TextEditingController _totalAssetsCtrl;
  late TextEditingController _krwBalanceCtrl;
  late TextEditingController _btcPriceCtrl;
  late TextEditingController _btcChangeRateCtrl;
  late TextEditingController _btcQtyCtrl;
  late TextEditingController _btcBuyPriceCtrl;

  @override
  void initState() {
    super.initState();
    _totalAssetsCtrl = TextEditingController(text: widget.config.totalAssets.toInt().toString());
    _krwBalanceCtrl = TextEditingController(text: widget.config.krwBalance.toInt().toString());

    final btc = widget.config.coins.firstWhere((c) => c.symbol == 'BTC');
    _btcPriceCtrl = TextEditingController(text: btc.currentPrice.toInt().toString());
    _btcChangeRateCtrl = TextEditingController(text: btc.changeRate.toString());

    final btcHolding = widget.config.holdings.firstWhere((h) => h.symbol == 'BTC');
    _btcQtyCtrl = TextEditingController(text: btcHolding.holdingQuantity.toString());
    _btcBuyPriceCtrl = TextEditingController(text: btcHolding.avgBuyPrice.toInt().toString());
  }

  @override
  void dispose() {
    _totalAssetsCtrl.dispose();
    _krwBalanceCtrl.dispose();
    _btcPriceCtrl.dispose();
    _btcChangeRateCtrl.dispose();
    _btcQtyCtrl.dispose();
    _btcBuyPriceCtrl.dispose();
    super.dispose();
  }

  void _applyJackpotPreset() {
    setState(() {
      _totalAssetsCtrl.text = '5240000000';
      _krwBalanceCtrl.text = '140000000';
      _btcPriceCtrl.text = '145000000';
      _btcChangeRateCtrl.text = '8.75';
      _btcQtyCtrl.text = '35.0';
      _btcBuyPriceCtrl.text = '42000000';
    });
  }

  void _applyLossPreset() {
    setState(() {
      _totalAssetsCtrl.text = '8400000';
      _krwBalanceCtrl.text = '240000';
      _btcPriceCtrl.text = '92000000';
      _btcChangeRateCtrl.text = '-12.80';
      _btcQtyCtrl.text = '0.088';
      _btcBuyPriceCtrl.text = '135000000';
    });
  }

  void _handleSave() {
    final updated = widget.config;
    updated.totalAssets = double.tryParse(_totalAssetsCtrl.text) ?? updated.totalAssets;
    updated.krwBalance = double.tryParse(_krwBalanceCtrl.text) ?? updated.krwBalance;

    final btc = updated.coins.firstWhere((c) => c.symbol == 'BTC');
    btc.currentPrice = double.tryParse(_btcPriceCtrl.text) ?? btc.currentPrice;
    btc.changeRate = double.tryParse(_btcChangeRateCtrl.text) ?? btc.changeRate;
    btc.changeAmount = btc.currentPrice * (btc.changeRate / 100);

    final btcHolding = updated.holdings.firstWhere((h) => h.symbol == 'BTC');
    btcHolding.holdingQuantity = double.tryParse(_btcQtyCtrl.text) ?? btcHolding.holdingQuantity;
    btcHolding.avgBuyPrice = double.tryParse(_btcBuyPriceCtrl.text) ?? btcHolding.avgBuyPrice;
    btcHolding.currentPrice = btc.currentPrice;

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 핸들 바 및 타이틀
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(CupertinoIcons.slider_horizontal_3, color: Color(0xFF093687), size: 20),
                  SizedBox(width: 8),
                  Text('업비트 시세 & 자산 연출 설정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E2024))),
                ],
              ),
              IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.of(context).pop()),
            ],
          ),
          const Divider(height: 16),

          // 프리셋 버튼
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _applyJackpotPreset,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFC84A31)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('🔥 인생역전 52억 (+245%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFC84A31))),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _applyLossPreset,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1261C4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('❄️ 눈물의 고점물림 (-68%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1261C4))),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 스크롤 입력 폼
          Expanded(
            child: ListView(
              children: [
                _buildSectionHeader('1. 전체 자산 연출'),
                _buildNumberField('총 보유자산 (원)', _totalAssetsCtrl, '예: 3450230000'),
                const SizedBox(height: 10),
                _buildNumberField('보유 원화 KRW (원)', _krwBalanceCtrl, '예: 50230000'),
                const SizedBox(height: 18),

                _buildSectionHeader('2. 비트코인(BTC) 시세 조작'),
                _buildNumberField('BTC 현재가 (원)', _btcPriceCtrl, '예: 138500000'),
                const SizedBox(height: 10),
                _buildNumberField('BTC 전일대비 변동률 (%)', _btcChangeRateCtrl, '예: 2.85 또는 -8.5'),
                const SizedBox(height: 18),

                _buildSectionHeader('3. 비트코인(BTC) 보유 포트폴리오'),
                _buildNumberField('BTC 보유 수량 (개)', _btcQtyCtrl, '예: 20.5'),
                const SizedBox(height: 10),
                _buildNumberField('BTC 매수 평균가 (원)', _btcBuyPriceCtrl, '예: 58000000'),
              ],
            ),
          ),

          // 저장하기 버튼
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF093687),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _handleSave,
            child: const Text('변경사항 실시간 적용하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF093687))),
    );
  }

  Widget _buildNumberField(String label, TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Colors.black54),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF093687), width: 1.5)),
      ),
    );
  }
}
