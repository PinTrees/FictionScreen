import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/kakaobank_model.dart';

class KakaoBankAccountDetailPage extends StatefulWidget {
  final KakaoBankConfig config;
  final VoidCallback onBack;
  final VoidCallback onTransfer;
  final VoidCallback? onEdit;

  const KakaoBankAccountDetailPage({
    super.key,
    required this.config,
    required this.onBack,
    required this.onTransfer,
    this.onEdit,
  });

  @override
  State<KakaoBankAccountDetailPage> createState() => _KakaoBankAccountDetailPageState();
}

class _KakaoBankAccountDetailPageState extends State<KakaoBankAccountDetailPage> {
  String _activeFilter = '전체'; // '전체', '입금', '출금'

  String _formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    final transactions = widget.config.transactions.where((t) {
      if (_activeFilter == '입금') return t.isIncome;
      if (_activeFilter == '출금') return !t.isIncome;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 앱바
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: const Color(0xFF16161A),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.left_chevron, color: Colors.white, size: 20),
                    onPressed: widget.onBack,
                  ),
                  const SizedBox(width: 8),
                  Text(widget.config.accountName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white70, size: 18),
                    onPressed: widget.onEdit,
                  ),
                ],
              ),
            ),

            // 계좌 요약 카드 (상단 고정)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              color: const Color(0xFF16161A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.config.accountNumber, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatPrice(widget.config.balance), style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEE500),
                          foregroundColor: const Color(0xFF111111),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: widget.onTransfer,
                        child: const Text('이체', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 필터 탭 바 (전체 / 입금 / 출금)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF131317),
              child: Row(
                children: ['전체', '입금', '출금'].map((f) {
                  final isSel = _activeFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f, style: TextStyle(color: isSel ? Colors.white : Colors.white60, fontSize: 12)),
                      selected: isSel,
                      selectedColor: const Color(0xFF33333E),
                      backgroundColor: Colors.transparent,
                      onSelected: (_) => setState(() => _activeFilter = f),
                    ),
                  );
                }).toList(),
              ),
            ),

            // 거래내역 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C22),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: tx.isIncome ? const Color(0xFF3B82F6).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.08),
                          child: Icon(
                            tx.isIncome ? CupertinoIcons.arrow_down : CupertinoIcons.arrow_up,
                            color: tx.isIncome ? const Color(0xFF60A5FA) : Colors.white70,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tx.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 2),
                              Text('${tx.date} · ${tx.category}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${tx.isIncome ? "+" : "-"}${_formatPrice(tx.amount)}',
                              style: TextStyle(
                                color: tx.isIncome ? const Color(0xFF60A5FA) : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text('잔액 ${_formatPrice(tx.balanceAfter)}', style: const TextStyle(color: Colors.white38, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
