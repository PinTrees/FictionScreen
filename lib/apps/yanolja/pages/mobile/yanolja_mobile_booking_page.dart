import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/yanolja_model.dart';

class YanoljaMobileBookingPage extends StatelessWidget {
  final YanoljaReservation reservation;
  final VoidCallback onHome;

  const YanoljaMobileBookingPage({
    super.key,
    required this.reservation,
    required this.onHome,
  });

  String _formatPrice(int price) {
    return '${NumberFormat('#,###').format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 완료 바
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child: const Row(
                children: [
                  Text('예약 완료 내역', style: TextStyle(color: Color(0xFF191919), fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // 상단 완료 축하 헤더
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF3478),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.check_mark, color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 16),
                        const Text('예약이 완료되었습니다!', style: TextStyle(color: Color(0xFF191919), fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('예약번호: ${reservation.reservationNo}', style: const TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 예약 상세 영수증 카드
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: reservation.isRent ? const Color(0xFF3B82F6).withValues(alpha: 0.12) : const Color(0xFFFF3478).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                reservation.isRent ? '대실 예약' : '숙박 예약',
                                style: TextStyle(
                                  color: reservation.isRent ? const Color(0xFF3B82F6) : const Color(0xFFFF3478),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(reservation.lodgingName, style: const TextStyle(color: Color(0xFF191919), fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(reservation.roomName, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                        const Divider(height: 28, color: Color(0xFFEEEEEE)),

                        _buildInfoRow('이용 일시', '${reservation.checkInInfo} ~'),
                        const SizedBox(height: 12),
                        _buildInfoRow('퇴실 일시', reservation.checkOutInfo),
                        const SizedBox(height: 12),
                        _buildInfoRow('예약자 이름', reservation.guestName),
                        const SizedBox(height: 12),
                        _buildInfoRow('휴대폰 번호', reservation.guestPhone),
                        const SizedBox(height: 12),
                        _buildInfoRow('결제 수단', reservation.paymentMethod),
                        const Divider(height: 28, color: Color(0xFFEEEEEE)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('총 결제 금액', style: TextStyle(color: Color(0xFF191919), fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(_formatPrice(reservation.totalAmount), style: const TextStyle(color: Color(0xFFFF3478), fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 바코드 카드 시뮬레이션
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text('프런트 체크인 바코드', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFF191919),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Text(
                              '||| || |||| | ||| ||||| || |||',
                              style: TextStyle(color: Colors.white, letterSpacing: 8, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 확인 및 홈으로 버튼
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3478),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onHome,
                child: const Text('확인 (홈으로 돌아가기)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black45, fontSize: 13)),
        Text(value, style: const TextStyle(color: Color(0xFF191919), fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
