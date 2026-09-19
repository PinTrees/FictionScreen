import 'package:flutter/material.dart';
import '../models/pdf_document_model.dart';

/// 실제 공문서/인감도장 스타일의 붉은 직인 날인 위젯
class SealStampWidget extends StatelessWidget {
  final String text;
  final StampShape shape;
  final double size;
  final double angle;

  const SealStampWidget({
    super.key,
    required this.text,
    this.shape = StampShape.circle,
    this.size = 64,
    this.angle = -0.08, // 살짝 기운 자연스러운 도장 각도
  });

  @override
  Widget build(BuildContext context) {
    const Color inkColor = Color(0xFFCC1F1A);

    Widget shapeContainer;

    if (shape == StampShape.square) {
      shapeContainer = Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: inkColor, width: 2.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: inkColor.withValues(alpha: 0.5), width: 0.8),
            borderRadius: BorderRadius.circular(2),
          ),
          alignment: Alignment.center,
          child: _buildText(inkColor),
        ),
      );
    } else if (shape == StampShape.oval) {
      shapeContainer = Container(
        width: size * 1.25,
        height: size * 0.85,
        padding: const EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          border: Border.all(color: inkColor, width: 2.2),
          borderRadius: BorderRadius.circular(size),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: inkColor.withValues(alpha: 0.5), width: 0.8),
            borderRadius: BorderRadius.circular(size),
          ),
          alignment: Alignment.center,
          child: _buildText(inkColor),
        ),
      );
    } else {
      // Circle
      shapeContainer = Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: inkColor, width: 2.2),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: inkColor.withValues(alpha: 0.5), width: 0.8),
          ),
          alignment: Alignment.center,
          child: _buildText(inkColor),
        ),
      );
    }

    return Transform.rotate(
      angle: angle,
      child: shapeContainer,
    );
  }

  Widget _buildText(Color inkColor) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'serif',
        color: inkColor,
        fontSize: size * 0.22,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
        height: 1.1,
      ),
    );
  }
}
