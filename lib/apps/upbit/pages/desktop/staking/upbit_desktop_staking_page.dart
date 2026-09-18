import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/upbit_model.dart';

class UpbitDesktopStakingPage extends StatelessWidget {
  final UpbitConfig config;
  final VoidCallback onEdit;

  const UpbitDesktopStakingPage({
    super.key,
    required this.config,
    required this.onEdit,
  });

  String _format(num val) => NumberFormat('#,###.##').format(val);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 스테이킹 히어로 배너
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF093687), Color(0xFF0C2461)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                            child: const Text('UPbit Staking Service', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '보유한 디지털 자산으로 매일 보상을 받아보세요',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          const Text('업비트 검증인이 직접 운영하는 안전하고 투명한 온체인 검증 보상 시스템', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(CupertinoIcons.sparkles, size: 16),
                        label: const Text('스테이킹 신청', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF093687),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: onEdit,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. 지원 스테이킹 가상자산 카드 그리드
                const Text('스테이킹 지원 상품', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2024))),
                const SizedBox(height: 14),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: config.stakings.length,
                  itemBuilder: (context, index) {
                    final item = config.stakings[index];
                    return _buildStakingCard(item);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStakingCard(UpbitStakingItem item) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: const Color(0xFF093687).withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Center(child: Text(item.symbol.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF093687)))),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.coinName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(item.symbol, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('예상 연 보상률', style: TextStyle(color: Colors.black54, fontSize: 11)),
                  Text('${item.estimatedApr.toStringAsFixed(2)}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFC84A31))),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('내 스테이킹 수량', style: TextStyle(color: Colors.black54, fontSize: 12)),
              Text('${_format(item.stakedAmount)} ${item.symbol}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('누적 획득 보상', style: TextStyle(color: Colors.black54, fontSize: 12)),
              Text('+${_format(item.totalReward)} ${item.symbol}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFC84A31))),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF093687)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onPressed: onEdit,
              child: const Text('위임 / 언스테이킹', style: TextStyle(color: Color(0xFF093687), fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
