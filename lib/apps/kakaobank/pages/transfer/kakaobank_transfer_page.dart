import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/kakaobank_model.dart';

class KakaoBankTransferPage extends StatefulWidget {
  final KakaoBankConfig config;
  final VoidCallback onClose;
  final Function(String recipient, int amount) onTransferComplete;

  const KakaoBankTransferPage({
    super.key,
    required this.config,
    required this.onClose,
    required this.onTransferComplete,
  });

  @override
  State<KakaoBankTransferPage> createState() => _KakaoBankTransferPageState();
}

class _KakaoBankTransferPageState extends State<KakaoBankTransferPage> {
  final TextEditingController _amountCtrl = TextEditingController();
  String _recipient = '김철수';
  String _bankName = '카카오뱅크 3333-04-1234567';

  final List<Map<String, String>> _recentRecipients = [
    {'name': '김철수', 'bank': '카카오뱅크 3333-04-1234567'},
    {'name': '이영희', 'bank': '토스뱅크 1000-01-9876543'},
    {'name': '박지민', 'bank': '신한은행 110-345-678901'},
    {'name': '최유진', 'bank': '국민은행 456702-01-234567'},
  ];

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _addAmount(int add) {
    final current = int.tryParse(_amountCtrl.text.replaceAll(',', '').trim()) ?? 0;
    final next = current + add;
    setState(() {
      _amountCtrl.text = NumberFormat('#,###').format(next);
    });
  }

  void _setAllAmount() {
    setState(() {
      _amountCtrl.text = NumberFormat('#,###').format(widget.config.balance);
    });
  }

  void _submitTransfer() {
    final amount = int.tryParse(_amountCtrl.text.replaceAll(',', '').trim()) ?? 0;
    if (amount <= 0) return;
    widget.onTransferComplete(_recipient, amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 닫기 헤더
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: const Color(0xFF16161A),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.xmark, color: Colors.white, size: 20),
                    onPressed: widget.onClose,
                  ),
                  const SizedBox(width: 8),
                  const Text('이체하기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // 받는 사람 선택 카드
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C22),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('받는 사람', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: Color(0xFFFEE500),
                              child: Text('👤', style: TextStyle(fontSize: 14)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_recipient, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                Text(_bankName, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 최근 보낸 계좌 선택 가로 리스트
                  const Text('최근 보낸 계좌', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _recentRecipients.map((rec) {
                        final isSel = _recipient == rec['name'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => setState(() {
                              _recipient = rec['name']!;
                              _bankName = rec['bank']!;
                            }),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFFFEE500).withValues(alpha: 0.15) : const Color(0xFF1C1C22),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: isSel ? const Color(0xFFFEE500) : Colors.transparent),
                              ),
                              child: Text(rec['name']!, style: TextStyle(color: isSel ? const Color(0xFFFEE500) : Colors.white70, fontSize: 12)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 보낼 금액 입력 필드
                  const Text('보낼 금액', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '얼마를 보낼까요?',
                      hintStyle: const TextStyle(color: Colors.white24, fontSize: 20),
                      suffixText: '원',
                      suffixStyle: const TextStyle(color: Colors.white70, fontSize: 20),
                      filled: true,
                      fillColor: const Color(0xFF1C1C22),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 빠른 금액 추가 칩 (+1만, +5만, +10만, +100만, 전액)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildQuickChip('+1만', () => _addAmount(10000)),
                      _buildQuickChip('+5만', () => _addAmount(50000)),
                      _buildQuickChip('+10만', () => _addAmount(100000)),
                      _buildQuickChip('+100만', () => _addAmount(1000000)),
                      _buildQuickChip('전액', _setAllAmount),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '출금 가능 잔액: ${NumberFormat('#,###').format(widget.config.balance)}원',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),

            // 하단 보내기 버튼
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF16161A),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEE500),
                  foregroundColor: const Color(0xFF111111),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _submitTransfer,
                child: const Text('보내기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF25252E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
