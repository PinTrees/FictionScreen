import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/lottery_ball_widget.dart';
import '../../data/lottery_model.dart';

/// 로또 6/45 당첨 결과 포털 페이지
class LottoResultPage extends StatelessWidget {
  final LotteryConfig config;
  final ValueChanged<LotteryConfig> onConfigChanged;

  const LottoResultPage({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. 회차 및 추첨 헤더 카드
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 회차 배너
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '제 ${config.round}회',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0066B3),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '당첨결과',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(${config.drawDate})',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 당첨 볼 6개 + 보너스 1개
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 10,
                      children: [
                        ...config.winningNumbers.map((ballNum) => LotteryBallWidget(number: ballNum, size: 48)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(CupertinoIcons.add, size: 22, color: Color(0xFF94A3B8)),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LotteryBallWidget(number: config.bonusNumber, size: 48, isBonus: true),
                            const SizedBox(height: 4),
                            const Text(
                              '보너스',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFF1F5F9), height: 1),
                    const SizedBox(height: 20),

                    // 1등 당첨금 요약 배너
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.rosette, color: Color(0xFF2563EB), size: 24),
                          const SizedBox(width: 10),
                          const Text(
                            '1등 1게임당 당첨금액',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E40AF)),
                          ),
                          const Spacer(),
                          Text(
                            config.firstPrizePerGame,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. 등위별 상세 당첨 결과 테이블
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(flex: 2, child: Text('순위', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
                          Expanded(flex: 3, child: Text('당첨기준', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
                          Expanded(flex: 3, child: Text('1인당 당첨금액', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
                          Expanded(flex: 2, child: Text('당첨게임수', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
                        ],
                      ),
                    ),
                    _buildPrizeRow('1등', '당첨번호 6개 일치', config.firstPrizePerGame, '${config.firstPrizeWinners}명', isHighlight: true),
                    _buildPrizeRow('2등', '당첨번호 5개 + 보너스 일치', '56,841,200원', '90명'),
                    _buildPrizeRow('3등', '당첨번호 5개 일치', '1,489,200원', '3,450명'),
                    _buildPrizeRow('4등', '당첨번호 4개 일치', '50,000원', '168,290명'),
                    _buildPrizeRow('5등', '당첨번호 3개 일치', '5,000원', '2,751,900명'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. 1등 배출점 (로또 명당) 리스트
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(CupertinoIcons.location_solid, color: Color(0xFF0066B3), size: 18),
                        SizedBox(width: 6),
                        Text(
                          '제 1140회 1등 배출점 (전국 로또 명당)',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStoreTile(1, '잠실매표소', '서울 송파구 올림픽로 269', '자동'),
                    _buildStoreTile(2, '스파', '서울 노원구 동일로 1493 상계주공10단지종합상가', '자동'),
                    _buildStoreTile(3, '부일카서비스', '부산 동구 자성로133번길 35', '자동'),
                    _buildStoreTile(4, '일등복권편의점', '대구 달서구 대명로 20', '수동'),
                    _buildStoreTile(5, '행운복권방', '인천 미추홀구 주안로 108', '자동'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrizeRow(String rank, String criteria, String prize, String winners, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              rank,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: isHighlight ? const Color(0xFFDC2626) : const Color(0xFF1E293B),
              ),
            ),
          ),
          Expanded(flex: 3, child: Text(criteria, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))),
          Expanded(
            flex: 3,
            child: Text(
              prize,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
                color: isHighlight ? const Color(0xFFDC2626) : const Color(0xFF1E293B),
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(winners, textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
        ],
      ),
    );
  }

  Widget _buildStoreTile(int num, String name, String address, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '$num',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                Text(address, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: type == '자동' ? const Color(0xFFEFF6FF) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: type == '자동' ? const Color(0xFFBFDBFE) : const Color(0xFFFECACA)),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: type == '자동' ? const Color(0xFF2563EB) : const Color(0xFFDC2626),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
