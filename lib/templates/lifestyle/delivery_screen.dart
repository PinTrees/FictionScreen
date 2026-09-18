import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/delivery_model.dart';
import '../../style/app_colors.dart';

class DeliveryScreen extends StatelessWidget {
  final DeliveryConfig config;

  const DeliveryScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F7F9),
      child: Column(
        children: [
          // 1. 배민 민트색 헤더
          Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
            decoration: const BoxDecoration(
              color: AppColors.baeminMint,
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.back, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    config.storeName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  config.orderNumber,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 2. 배달 상태 카드
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.baeminMint.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                config.status.title,
                                style: const TextStyle(
                                  color: AppColors.baeminMint,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(CupertinoIcons.time, size: 16, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              config.estimatedTime,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          config.status.description,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 단계 프로그레스 바
                        Row(
                          children: [
                            _buildStep(label: '접수', isActive: true),
                            _buildStepLine(isActive: config.status.index >= 1),
                            _buildStep(label: '조리', isActive: config.status.index >= 1),
                            _buildStepLine(isActive: config.status.index >= 2),
                            _buildStep(label: '배달', isActive: config.status.index >= 2),
                            _buildStepLine(isActive: config.status.index >= 3),
                            _buildStep(label: '완료', isActive: config.status.index >= 3),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 3. 주문 내역 요약 카드
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '주문 정보',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                        ),
                        const Divider(height: 20),
                        Text(
                          config.menuSummary,
                          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('총 결제금액', style: TextStyle(color: Colors.black54, fontSize: 13)),
                            Text(
                              '${config.totalPrice}원',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.info, size: 16, color: Colors.black45),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '요청사항: ${config.riderMessage}',
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({required String label, required bool isActive}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? AppColors.baeminMint : const Color(0xFFE5E7EB),
          child: Icon(
            CupertinoIcons.check_mark,
            size: 14,
            color: isActive ? Colors.white : Colors.black26,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? Colors.black87 : Colors.black38,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 3,
        color: isActive ? AppColors.baeminMint : const Color(0xFFE5E7EB),
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );
  }
}
