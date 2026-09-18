import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/lottery_model.dart';

/// 즉석식 복권 스피또 2000 인터랙티브 스크래치 페이지
class SpitoScratchPage extends StatefulWidget {
  final LotteryConfig config;
  final ValueChanged<LotteryConfig> onConfigChanged;

  const SpitoScratchPage({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<SpitoScratchPage> createState() => _SpitoScratchPageState();
}

class _SpitoScratchPageState extends State<SpitoScratchPage> {
  // 스크래치 은박 벗겨짐 상태 관리 (행운번호 2개, 나의번호 6개)
  final Set<int> _scratchedItems = {};

  void _scratchItem(int index) {
    setState(() {
      _scratchedItems.add(index);
    });
  }

  void _scratchAll() {
    setState(() {
      for (int i = 0; i < 8; i++) {
        _scratchedItems.add(i);
      }
    });
  }

  void _resetTicket() {
    setState(() {
      _scratchedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 0, 1: 행운번호 2개 / 2~7: 나의 번호 6개
    final isLuckyScratched = _scratchedItems.contains(0) && _scratchedItems.contains(1);
    final isJackpotRevealed = _scratchedItems.contains(2); // 2번 슬롯에 20억 일치!

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              // 컨트롤 바
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE11D48),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(CupertinoIcons.sparkles, size: 16),
                      label: const Text('✨ 한 번에 모두 긁기', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      onPressed: _scratchAll,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF334155),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                    ),
                    icon: const Icon(CupertinoIcons.arrow_clockwise, size: 16),
                    label: const Text('새 복권', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    onPressed: _resetTicket,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 스피또 2000 티켓 본체
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF881337), Color(0xFF4C0519)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFF43F5E), width: 1.5),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 티켓 헤더
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBBF24),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '제 ${widget.config.spitoRound}회',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF78350F)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '스피또 2000',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          '1등 20억원',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFFDE047)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '행운 번호와 나의 번호가 일치하면 당첨금 지급!',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFFFECDD3)),
                    ),
                    const SizedBox(height: 16),

                    // 1. 행운번호 영역 (2개)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBE123C)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '★ 행운의 번호 ★',
                            style: TextStyle(color: Color(0xFFFACC15), fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildScratchBall(0, widget.config.spitoLuckyNumber1),
                              const SizedBox(width: 24),
                              _buildScratchBall(1, widget.config.spitoLuckyNumber2),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. 나의 번호 6개 & 당첨금 그리드
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBE123C)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '나의 번호 및 당첨금',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          // 2행 3열 나의 번호들
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.2,
                            children: [
                              _buildMyNumberSlot(2, widget.config.spitoLuckyNumber1, '2,000,000,000원', isMatch: true),
                              _buildMyNumberSlot(3, 7, '2,000원'),
                              _buildMyNumberSlot(4, 31, '10,000원'),
                              _buildMyNumberSlot(5, 19, '100,000,000원'),
                              _buildMyNumberSlot(6, 42, '4,000원'),
                              _buildMyNumberSlot(7, 3, '500,000원'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 1등 대박 당첨 알림 배너
                    if (isLuckyScratched && isJackpotRevealed) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFACC15), Color(0xFFEAB308)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEAB308).withValues(alpha: 0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🎊', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '축하합니다! 1등 20억원 당첨!',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF78350F)),
                                ),
                                Text(
                                  '일금 이십억원정 (₩2,000,000,000)',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 행운번호 스크래치 슬롯
  Widget _buildScratchBall(int index, int number) {
    final isScratched = _scratchedItems.contains(index);

    return GestureDetector(
      onTap: () => _scratchItem(index),
      onPanUpdate: (_) => _scratchItem(index),
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isScratched ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2),
        ),
        child: Center(
          child: isScratched
              ? Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.hand_draw_fill, color: Colors.white70, size: 16),
                    SizedBox(height: 2),
                    Text('긁기', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ],
                ),
        ),
      ),
    );
  }

  /// 나의 번호 슬롯 (번호 + 당첨금액)
  Widget _buildMyNumberSlot(int index, int number, String prize, {bool isMatch = false}) {
    final isScratched = _scratchedItems.contains(index);

    return GestureDetector(
      onTap: () => _scratchItem(index),
      onPanUpdate: (_) => _scratchItem(index),
      child: Container(
        decoration: BoxDecoration(
          color: isScratched
              ? (isMatch ? const Color(0xFFFEF08A) : Colors.white)
              : const Color(0xFF94A3B8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isScratched && isMatch ? const Color(0xFFEAB308) : Colors.white.withValues(alpha: 0.6),
            width: isMatch ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: isScratched
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$number',
                      style: TextStyle(
                        color: isMatch ? const Color(0xFFDC2626) : const Color(0xFF0F172A),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      prize,
                      style: TextStyle(
                        color: isMatch ? const Color(0xFFDC2626) : const Color(0xFF475569),
                        fontWeight: isMatch ? FontWeight.w900 : FontWeight.w700,
                        fontSize: isMatch ? 11 : 9.5,
                      ),
                    ),
                  ],
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.circle_grid_hex, color: Colors.white70, size: 16),
                    SizedBox(height: 2),
                    Text('긁기', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ],
                ),
        ),
      ),
    );
  }
}
