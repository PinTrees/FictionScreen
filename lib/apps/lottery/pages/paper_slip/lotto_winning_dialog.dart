import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/lottery_ball_widget.dart';
import '../../data/lottery_model.dart';

/// 실제 동행복권 QR코드 스캔 시 나타나는 당첨 확인 결과 화면
class LottoWinningDialog extends StatefulWidget {
  final LotteryConfig config;
  final ValueChanged<LotteryConfig> onConfigChanged;
  final VoidCallback onClose;

  const LottoWinningDialog({
    super.key,
    required this.config,
    required this.onConfigChanged,
    required this.onClose,
  });

  @override
  State<LottoWinningDialog> createState() => _LottoWinningDialogState();
}

class _LottoWinningDialogState extends State<LottoWinningDialog> {
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.config.myWinningAmount);
  }

  @override
  void didUpdateWidget(covariant LottoWinningDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.myWinningAmount != oldWidget.config.myWinningAmount) {
      _amountController.text = widget.config.myWinningAmount;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _applyRank(int rank, String defaultAmount) {
    widget.onConfigChanged(
      widget.config.copyWith(
        myWinningRank: rank,
        myWinningAmount: defaultAmount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rank = widget.config.myWinningRank;
    final isWinner = rank > 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 480,
        constraints: const BoxConstraints(maxHeight: 740),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              // 1. 모바일 앱 상단 GNB 바
              Container(
                color: const Color(0xFF0066B3),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Image.asset('assets/images/lottery_icon.webp', width: 22, height: 22),
                    const SizedBox(width: 8),
                    const Text(
                      '동행복권 복권 당첨결과',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(CupertinoIcons.xmark, color: Colors.white, size: 18),
                      onPressed: widget.onClose,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // 2. 메인 스크롤 콘텐츠
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 빠른 등수 변경 툴바 (쇼츠/영상 제작 편의성)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildQuickButton('1등 (대박)', 1, '2,586,381,123원', const Color(0xFFDC2626)),
                            _buildQuickButton('2등 (5천만)', 2, '56,841,200원', const Color(0xFF2563EB)),
                            _buildQuickButton('3등 (140만)', 3, '1,489,200원', const Color(0xFF059669)),
                            _buildQuickButton('4등 (5만)', 4, '50,000원', const Color(0xFFD97706)),
                            _buildQuickButton('5등 (5천)', 5, '5,000원', const Color(0xFF475569)),
                            _buildQuickButton('낙첨', 0, '0원', const Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 회차 안내
                      Center(
                        child: Text(
                          '제 ${widget.config.round}회 (${widget.config.drawDate.split(' ')[0]})',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 당첨 축하 히어로 카드
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: isWinner
                              ? const LinearGradient(
                                  colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                              : const LinearGradient(
                                  colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isWinner ? const Color(0xFFFCD34D) : const Color(0xFFE2E8F0),
                            width: isWinner ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            if (isWinner) ...[
                              const Text('🎉', style: TextStyle(fontSize: 36)),
                              const SizedBox(height: 6),
                              Text(
                                '축하합니다! $rank등에 당첨되셨습니다!',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFB45309),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '총 당첨금액',
                                style: TextStyle(fontSize: 12, color: Color(0xFF92400E), fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.config.myWinningAmount,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFDC2626),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ] else ...[
                              const Text('😢', style: TextStyle(fontSize: 36)),
                              const SizedBox(height: 6),
                              const Text(
                                '아쉽게도 낙첨되었습니다.',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF334155)),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '다음 회차의 행운을 빕니다!',
                                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 당첨 번호 안내
                      const Text(
                        '당첨번호 안내',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...widget.config.winningNumbers.map(
                            (ballNum) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.5),
                              child: LotteryBallWidget(number: ballNum, size: 34),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(CupertinoIcons.add, size: 16, color: Color(0xFF94A3B8)),
                          ),
                          LotteryBallWidget(number: widget.config.bonusNumber, size: 34, isBonus: true),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 내 복권 5게임 대조 결과
                      const Text(
                        '나의 복권 결과 (5게임)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: widget.config.slipGames.map((game) {
                            final isTargetGame = game.label == widget.config.myWinningGameLabel && isWinner;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
                              ),
                              child: Row(
                                children: [
                                  // 줄 레이블
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: isTargetGame ? const Color(0xFFDC2626) : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        game.label,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 11,
                                          color: isTargetGame ? Colors.white : const Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    game.type,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                  const Spacer(),
                                  // 6개 번호 (일치 시 빨간 도장 링 표시)
                                  ...game.numbers.map((n) {
                                    final bool matched = widget.config.winningNumbers.contains(n) ||
                                        (rank == 2 && n == widget.config.bonusNumber);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: LotteryBallWidget(
                                        number: n,
                                        size: 26,
                                        isMatched: matched && isTargetGame,
                                      ),
                                    );
                                  }),
                                  const SizedBox(width: 8),
                                  // 당첨 여부 뱃지
                                  Container(
                                    width: 48,
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isTargetGame ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isTargetGame ? const Color(0xFFF87171) : const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        isTargetGame ? '$rank등 당첨' : '낙첨',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: isTargetGame ? const Color(0xFFDC2626) : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. 닫기 버튼
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066B3),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: widget.onClose,
                  child: const Text('확인 완료', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickButton(String title, int rank, String amount, Color color) {
    final isSelected = widget.config.myWinningRank == rank;
    return InkWell(
      onTap: () => _applyRank(rank, amount),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? color : const Color(0xFFCBD5E1)),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF334155),
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
