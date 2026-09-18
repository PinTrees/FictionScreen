import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KakaoBankSafeboxSliderModal extends StatefulWidget {
  final int initialBalance;
  final int maxTarget;
  final ValueChanged<int> onSave;

  const KakaoBankSafeboxSliderModal({
    super.key,
    required this.initialBalance,
    this.maxTarget = 50000000,
    required this.onSave,
  });

  static Future<void> show(BuildContext context, int balance, int maxTarget, ValueChanged<int> onSave) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => KakaoBankSafeboxSliderModal(
        initialBalance: balance,
        maxTarget: maxTarget,
        onSave: onSave,
      ),
    );
  }

  @override
  State<KakaoBankSafeboxSliderModal> createState() => _KakaoBankSafeboxSliderModalState();
}

class _KakaoBankSafeboxSliderModalState extends State<KakaoBankSafeboxSliderModal> {
  late double _currentAmount;

  @override
  void initState() {
    super.initState();
    _currentAmount = widget.initialBalance.toDouble().clamp(0.0, widget.maxTarget.toDouble());
  }

  String _formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    final intAmount = (_currentAmount / 10000).round() * 10000;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E212B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFF3B82F6),
                    child: Icon(CupertinoIcons.lock_fill, color: Colors.white, size: 14),
                  ),
                  SizedBox(width: 8),
                  Text('세이프박스 보관 금액 설정', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.xmark, color: Colors.white54, size: 18),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('현재 보관 금액', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 8),
          Text(
            _formatPrice(intAmount),
            style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 28),

          // 슬라이더 바
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF3B82F6),
              inactiveTrackColor: Colors.white12,
              thumbColor: Colors.white,
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            ),
            child: Slider(
              value: _currentAmount,
              min: 0,
              max: widget.maxTarget.toDouble(),
              divisions: 100,
              onChanged: (v) => setState(() => _currentAmount = v),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('0원', style: TextStyle(color: Colors.white38, fontSize: 11)),
              Text('최대 ${_formatPrice(widget.maxTarget)}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),

          const SizedBox(height: 28),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              widget.onSave(intAmount);
              Navigator.of(context).pop();
            },
            child: const Text('보관 금액 변경 완료', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
