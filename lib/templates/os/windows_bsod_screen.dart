import 'package:flutter/material.dart';
import '../../models/windows_bsod_model.dart';

class WindowsBsodScreen extends StatelessWidget {
  final WindowsBsodConfig config;
  final int currentPercentage;

  const WindowsBsodScreen({
    super.key,
    required this.config,
    this.currentPercentage = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0078D7),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 슬픈 얼굴 이모지
          const Text(
            ':(',
            style: TextStyle(
              color: Colors.white,
              fontSize: 84,
              fontFamily: 'Segoe UI',
              fontWeight: FontWeight.w100,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 24),

          // 2. 오류 메시지
          const Text(
            'PC에 문제가 발생하여 다시 시작해야 합니다. 일부 오류 정보를\n수집하고 있습니다. 그런 다음 자동으로 다시 시작합니다.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
              fontFamily: 'Segoe UI',
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 24),

          // 3. 퍼센트 진행률
          Text(
            '$currentPercentage% 완료',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Segoe UI',
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),

          // 4. QR 코드 및 중지 코드 섹션
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mock QR Code Box
              Container(
                width: 80,
                height: 80,
                color: Colors.white,
                padding: const EdgeInsets.all(6),
                child: CustomPaint(
                  painter: _MockQrPainter(),
                ),
              ),
              const SizedBox(width: 18),

              // 상세 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '자세한 내용과 가능한 해결 방법은 다음을 참조하세요.\n${config.supportUrl}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.35,
                        fontFamily: 'Segoe UI',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '지원 담당자에게 문의하는 경우 다음 정보를 제공하세요.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFamily: 'Segoe UI',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '중지 코드: ${config.stopCode}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Segoe UI',
                      ),
                    ),
                    if (config.whatFailed.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '실패한 내용: ${config.whatFailed}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Segoe UI',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MockQrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;

    // Corner Finder Patterns
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width * 0.3, size.height * 0.3), paint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.7, 0, size.width * 0.3, size.height * 0.3), paint);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.7, size.width * 0.3, size.height * 0.3), paint);

    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.08, size.height * 0.08, size.width * 0.14, size.height * 0.14), whitePaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.78, size.height * 0.08, size.width * 0.14, size.height * 0.14), whitePaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.08, size.height * 0.78, size.width * 0.14, size.height * 0.14), whitePaint);

    // Random Pattern Dots
    canvas.drawRect(Rect.fromLTWH(size.width * 0.4, size.height * 0.2, size.width * 0.15, size.height * 0.15), paint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.35, size.height * 0.45, size.width * 0.3, size.height * 0.15), paint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.45, size.height * 0.7, size.width * 0.2, size.height * 0.2), paint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.75, size.height * 0.4, size.width * 0.15, size.height * 0.25), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
