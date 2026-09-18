import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MorePage extends StatelessWidget {
  final int payBalance;
  final VoidCallback? onTapPay;

  const MorePage({
    super.key,
    required this.payBalance,
    this.onTapPay,
  });

  String _formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text('더보기', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
              const Spacer(),
              const Icon(CupertinoIcons.qrcode_viewfinder, size: 20, color: Colors.black87),
              const SizedBox(width: 16),
              const Icon(CupertinoIcons.gear, size: 20, color: Colors.black87),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 카카오페이 카드 (터치 시 금액 커스텀)
              GestureDetector(
                onTap: onTapPay,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEB00),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('pay', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black)),
                          const Spacer(),
                          Text('${_formatNumber(payBalance)} 원', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: onTapPay,
                              child: const Text('송금', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black.withValues(alpha: 0.08),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: onTapPay,
                              child: const Text('자산', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 아이콘 서비스 그리드
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildServiceIcon(CupertinoIcons.gift_fill, '선물하기', Colors.pinkAccent),
                  _buildServiceIcon(CupertinoIcons.smiley_fill, '이모티콘', Colors.amber),
                  _buildServiceIcon(CupertinoIcons.shopping_cart, '쇼핑하기', Colors.blue),
                  _buildServiceIcon(CupertinoIcons.mail_solid, '메일', Colors.green),
                  _buildServiceIcon(CupertinoIcons.folder_fill, '톡서랍', Colors.purple),
                  _buildServiceIcon(CupertinoIcons.calendar, '캘린더', Colors.orange),
                  _buildServiceIcon(CupertinoIcons.tv_fill, 'TV/동영상', Colors.red),
                  _buildServiceIcon(CupertinoIcons.ellipsis_circle_fill, '전체서비스', Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceIcon(IconData icon, String label, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
