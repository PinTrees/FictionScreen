import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/lottery_model.dart';
import 'lotto_winning_dialog.dart';

/// 실제 로또 6/45 종이 영수증 슬립지 생성기 및 뷰
class LottoSlipPage extends StatefulWidget {
  final LotteryConfig config;
  final ValueChanged<LotteryConfig> onConfigChanged;

  const LottoSlipPage({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<LottoSlipPage> createState() => _LottoSlipPageState();
}

class _LottoSlipPageState extends State<LottoSlipPage> {
  bool _isShowingWinningDialog = false;

  void _openWinningDialog() {
    setState(() => _isShowingWinningDialog = true);
  }

  void _regenerateRandomNumbers() {
    final random = Random();
    final newGames = <LottoGameItem>[];
    const labels = ['A', 'B', 'C', 'D', 'E'];

    for (var label in labels) {
      final numbersSet = <int>{};
      while (numbersSet.length < 6) {
        numbersSet.add(random.nextInt(45) + 1);
      }
      final sortedNumbers = numbersSet.toList()..sort();
      newGames.add(LottoGameItem(label: label, type: '자 동', numbers: sortedNumbers));
    }

    widget.onConfigChanged(
      widget.config.copyWith(
        slipGames: newGames,
        myWinningGameLabel: 'A',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  // 상단 크리에이터 퀵 액션 버튼들
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 2,
                          ),
                          icon: const Icon(CupertinoIcons.qrcode_viewfinder, size: 18),
                          label: const Text(
                            '📱 QR 당첨 확인 연출',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                          onPressed: _openWinningDialog,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF334155),
                          elevation: 1,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                        ),
                        icon: const Icon(CupertinoIcons.arrow_clockwise, size: 16),
                        label: const Text(
                          '자동 생성',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        onPressed: _regenerateRandomNumbers,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 실제 로또 종이 영수증 슬립지 본체
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAF7), // 실물 영수증 용지 미색
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(color: const Color(0xFFE5E5E0), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 영수증 상단 로고
                        const Center(
                          child: Text(
                            '동 행 복 권',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              color: Color(0xFF1E293B),
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            '제 ${widget.config.round} 회  로 또 6/45',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: Color(0xFF0F172A),
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '--------------------------------------------',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF94A3B8), fontFamily: 'monospace', fontSize: 13),
                        ),
                        const SizedBox(height: 8),

                        // 발행 정보
                        _buildReceiptText('발 행 일 : ${widget.config.issueDate}'),
                        _buildReceiptText('추 첨 일 : ${widget.config.drawDate}'),
                        _buildReceiptText('지급기한 : ${widget.config.payDueDate} 까지'),
                        _buildReceiptText(widget.config.trCode),
                        const SizedBox(height: 8),
                        const Text(
                          '============================================',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF64748B), fontFamily: 'monospace', fontSize: 13),
                        ),
                        const SizedBox(height: 12),

                        // A ~ E 5게임 출력
                        ...widget.config.slipGames.map((game) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text(
                                  '${game.label} ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'monospace',
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  '${game.type}  ',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'monospace',
                                    color: Color(0xFF475569),
                                  ),
                                ),
                                const Spacer(),
                                ...game.numbers.map((n) {
                                  final numStr = n.toString().padLeft(2, '0');
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      numStr,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'monospace',
                                        letterSpacing: 1,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 12),
                        const Text(
                          '--------------------------------------------',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF94A3B8), fontFamily: 'monospace', fontSize: 13),
                        ),
                        const SizedBox(height: 8),

                        // 금액 표시
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '금  액',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                            ),
                            Text(
                              '₩ 5,000원',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // 바코드 및 QR코드
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // QR코드 그래픽
                            GestureDetector(
                              onTap: _openWinningDialog,
                              child: Container(
                                width: 74,
                                height: 74,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black, width: 1.5),
                                ),
                                child: Image.network(
                                  'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://m.dhlottery.co.kr/qr.do?method=winQr%26v=1140',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code_2, size: 60),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // 실감 나는 바코드 그래픽
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSimulatedBarcode(),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.config.barcode,
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'monospace',
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          '--------------------------------------------',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF94A3B8), fontFamily: 'monospace', fontSize: 13),
                        ),
                        const SizedBox(height: 6),

                        // 하단 매장 정보
                        Center(
                          child: Text(
                            widget.config.storeName,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF64748B),
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // QR 당첨 확인 모달
        if (_isShowingWinningDialog)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
              child: LottoWinningDialog(
                config: widget.config,
                onConfigChanged: widget.onConfigChanged,
                onClose: () => setState(() => _isShowingWinningDialog = false),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReceiptText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF334155),
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _buildSimulatedBarcode() {
    return Container(
      height: 38,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(42, (index) {
          final isThick = index % 3 == 0;
          final isSpace = index % 7 == 0;
          return Container(
            width: isSpace ? 0.5 : (isThick ? 2.5 : 1.2),
            color: isSpace ? Colors.transparent : Colors.black87,
          );
        }),
      ),
    );
  }
}
