import 'package:flutter/material.dart';
import '../models/pdf_document_model.dart';
import 'seal_stamp_widget.dart';

/// 실제 규격의 A4 공문서 / 법적 서식 렌더러 위젯
class PdfA4PageView extends StatelessWidget {
  final PdfDocumentData doc;
  final double scale;

  const PdfA4PageView({
    super.key,
    required this.doc,
    this.scale = 1.0,
  });

  // A4 표준 비율 (폭 640 x 높이 905)
  static const double baseWidth = 640.0;
  static const double baseHeight = 905.0;

  @override
  Widget build(BuildContext context) {
    final bool isAward = doc.templateType == PdfTemplateType.awardCertificate;

    return Center(
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.topCenter,
        child: Container(
          width: baseWidth,
          height: baseHeight,
          margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 1. 문서 메인 본문
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isAward ? 40 : 48,
                  vertical: isAward ? 40 : 44,
                ),
                child: isAward ? _buildAwardLayout() : _buildStandardLegalLayout(),
              ),

              // 2. 대각선 보안 워터마크 (선택 시)
              if (doc.isWatermarkVisible) _buildWatermark(),

              // 3. 상장 전용 골드 테두리 장식
              if (isAward) _buildAwardBorder(),
            ],
          ),
        ),
      ),
    );
  }

  /// 표준 법적 공문서 / 계약서 레이아웃
  Widget _buildStandardLegalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 상단 문서번호 및 가상 보안 바코드
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doc.docNumber,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontFamily: 'serif',
              ),
            ),
            if (doc.isBarcodeVisible) _buildBarcode(),
          ],
        ),
        const SizedBox(height: 12),

        // 문서 대제목
        Center(
          child: Text(
            doc.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 3.5,
              color: Colors.black,
              fontFamily: 'serif',
            ),
          ),
        ),
        if (doc.subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Center(
            child: Text(
              doc.subtitle,
              style: const TextStyle(
                fontSize: 10.5,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        const SizedBox(height: 18),

        // 당사자 인적사항 표
        _buildPartiesTable(),
        const SizedBox(height: 14),

        // 주요 금액 또는 핵심 사항 박스 (존재 시)
        if (doc.amountText.isNotEmpty) _buildAmountBox(),
        const SizedBox(height: 14),

        // 조항 본문 목록
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doc.clauses.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return Text(
                doc.clauses[index],
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'serif',
                ),
              );
            },
          ),
        ),

        // 특약 사항
        if (doc.specialTerms.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 0.8),
            ),
            child: Text(
              doc.specialTerms,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF334155),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 하단 일자 및 발급 기관 / 직인
        _buildBottomSection(),
      ],
    );
  }

  /// 상장 / 표창장 전용 레이아웃
  Widget _buildAwardLayout() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          doc.subtitle, // 제 2026-1004호
          style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Text(
          doc.title, // 표 창 장
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 12,
            color: Color(0xFF0F172A),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 36),

        // 수상자 정보
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '소속: ${doc.partyAName}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(
                '성명: ${doc.partyBName}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // 표창 내용
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Text(
                doc.clauses.isNotEmpty ? doc.clauses.first : '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  height: 2.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'serif',
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ),

        // 수여일 및 기관장
        Text(
          doc.dateText,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'serif'),
        ),
        const SizedBox(height: 24),

        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Text(
              doc.institutionName,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                fontFamily: 'serif',
              ),
            ),
            if (doc.isStampVisible)
              Positioned(
                right: -24,
                child: SealStampWidget(
                  text: doc.stampText,
                  shape: doc.stampShape,
                  size: 68,
                ),
              ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  /// 당사자 정보 테이블
  Widget _buildPartiesTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 1.0),
      ),
      child: Column(
        children: [
          _buildTableRow(doc.partyATitle, doc.partyAName, doc.partyAId, doc.partyAAddress),
          Container(height: 1, color: Colors.black38),
          _buildTableRow(doc.partyBTitle, doc.partyBName, doc.partyBId, doc.partyBAddress),
        ],
      ),
    );
  }

  Widget _buildTableRow(String role, String name, String id, String address) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              role,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'serif',
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    if (id.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        '($id)',
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                    ],
                  ],
                ),
                if (address.isNotEmpty)
                  Text(
                    address,
                    style: const TextStyle(fontSize: 9.5, color: Colors.black87),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 주요 금액 박스
  Widget _buildAmountBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        border: Border.all(color: const Color(0xFF64748B), width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.attach_money, size: 14, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            doc.amountText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }

  /// 하단 날짜 및 발신처/직인
  Widget _buildBottomSection() {
    return Column(
      children: [
        Text(
          doc.dateText,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Text(
              doc.institutionName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                fontFamily: 'serif',
              ),
            ),
            if (doc.isStampVisible)
              Positioned(
                right: -24,
                child: SealStampWidget(
                  text: doc.stampText,
                  shape: doc.stampShape,
                  size: 58,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  /// 가상 보안 바코드
  Widget _buildBarcode() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 24; i++)
          Container(
            width: (i % 3 == 0) ? 2.2 : 1.1,
            height: 18,
            margin: const EdgeInsets.only(right: 1.5),
            color: Colors.black87,
          ),
      ],
    );
  }

  /// 대각선 워터마크
  Widget _buildWatermark() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Transform.rotate(
            angle: -0.45,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.22),
                  width: 3.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                doc.watermarkText,
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                  color: const Color(0xFFDC2626).withValues(alpha: 0.22),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 표창장 골드 테두리
  Widget _buildAwardBorder() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD4AF37), width: 4),
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.6), width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
