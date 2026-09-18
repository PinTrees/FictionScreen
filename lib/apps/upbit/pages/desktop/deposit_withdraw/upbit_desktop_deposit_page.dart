import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/upbit_model.dart';

class UpbitDesktopDepositPage extends StatefulWidget {
  final UpbitConfig config;
  final VoidCallback onEdit;

  const UpbitDesktopDepositPage({
    super.key,
    required this.config,
    required this.onEdit,
  });

  @override
  State<UpbitDesktopDepositPage> createState() => _UpbitDesktopDepositPageState();
}

class _UpbitDesktopDepositPageState extends State<UpbitDesktopDepositPage> {
  int _selectedAssetIndex = 0; // 0: KRW
  int _actionTab = 0; // 0: 입금신청, 1: 출금신청, 2: 입출금내역
  final TextEditingController _amountCtrl = TextEditingController(text: '10000000');

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  String _format(num val) => NumberFormat('#,###').format(val);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9ECF1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. 좌측 자산 목록 (KRW + 보유 코인)
          SizedBox(
            width: 260,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFFF9FAFB),
                    child: const Row(
                      children: [
                        Text('입출금 지원 자산', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildAssetTile(0, '원화', 'KRW', widget.config.krwBalance, isKrw: true),
                        ...widget.config.coins.asMap().entries.map((e) {
                          final idx = e.key + 1;
                          final c = e.value;
                          return _buildAssetTile(idx, c.koreanName, c.symbol, c.currentPrice);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 2. 우측 입출금 신청 본문
          Expanded(
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 연동 계좌 상태 배너
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4FC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF093687).withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(color: const Color(0xFF093687), borderRadius: BorderRadius.circular(8)),
                            child: const Icon(CupertinoIcons.building_2_fill, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('케이뱅크(Kbank) 실명확인 입출금 계좌', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF093687))),
                                    SizedBox(width: 6),
                                    Text('인증완료', style: TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Text('100-128-******492 (예금주: 김*준)', style: TextStyle(fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: widget.onEdit,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF093687)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: const Text('잔액/한도 설정', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF093687))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 입금신청 / 출금신청 / 입출금내역 탭
                    Row(
                      children: ['입금신청', '출금신청', '입출금내역'].asMap().entries.map((entry) {
                        final isActive = _actionTab == entry.key;
                        return InkWell(
                          onTap: () => setState(() => _actionTab = entry.key),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: isActive ? const Color(0xFF093687) : Colors.transparent, width: 2.5)),
                            ),
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                color: isActive ? const Color(0xFF093687) : Colors.black54,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    // 입출금 폼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('출금가능 / 보유 잔액', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        Text('${_format(widget.config.krwBalance)} KRW', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2024))),
                      ],
                    ),
                    const SizedBox(height: 14),

                    TextField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _actionTab == 1 ? '출금 신청 금액 (KRW)' : '입금 신청 금액 (KRW)',
                        suffixText: 'KRW',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 퀵 금액 버튼
                    Row(
                      children: ['+10만', '+50만', '+100만', '+1000만', '최대'].map((label) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            onPressed: () {},
                            child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                          ),
                        );
                      }).toList(),
                    ),
                    const Spacer(),

                    // 안내사항
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• 1회 입금 한도: 100,000,000원 / 1일 입금 한도: 500,000,000원', style: TextStyle(fontSize: 11, color: Colors.black54)),
                          const SizedBox(height: 4),
                          const Text('• 원화 입출금은 본인 명의 케이뱅크 실명인증 계좌를 통해서만 가능합니다.', style: TextStyle(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF093687),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: widget.onEdit,
                      child: Text(_actionTab == 1 ? '출금 신청하기 (케이뱅크 2채널 인증)' : '입금 신청하기 (케이뱅크 연동)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetTile(int index, String name, String symbol, double amount, {bool isKrw = false}) {
    final isSelected = _selectedAssetIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedAssetIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F4FC) : Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text(symbol, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            Text(
              isKrw ? '${_format(amount)}원' : '${_format(amount)} KRW',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E2024)),
            ),
          ],
        ),
      ),
    );
  }
}
