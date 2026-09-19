import 'package:flutter/material.dart';
import '../data/word_model.dart';

class WordDocumentCanvas extends StatelessWidget {
  final WordConfig config;

  const WordDocumentCanvas({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE1DFDD), // Word grey workspace
      child: Column(
        children: [
          // 1. Center A4 Paper Scrollable Canvas
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: Container(
                  width: 720,
                  constraints: const BoxConstraints(minHeight: 960),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Document Header (Code & Confidential Stamp)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '문서관리번호: ${config.documentCode}',
                                style: const TextStyle(
                                  color: Color(0xFF605E5C),
                                  fontSize: 11,
                                  fontFamily: 'Consolas',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '소관부서: ${config.department}',
                                style: const TextStyle(color: Color(0xFF605E5C), fontSize: 11),
                              ),
                            ],
                          ),
                          const Spacer(),

                          // 🔴 붉은색 기밀 고무 도장 (TOP SECRET Stamp)
                          if (config.confidentialStamp != null)
                            Transform.rotate(
                              angle: -0.15,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFD32F2F), width: 2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  config.confidentialStamp!,
                                  style: const TextStyle(
                                    color: Color(0xFFD32F2F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      // Document Title
                      Center(
                        child: Text(
                          config.documentTitle,
                          style: const TextStyle(
                            color: Color(0xFF201F1E),
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(color: Color(0xFF323130), thickness: 1.5),
                      const SizedBox(height: 16),

                      // Metadata Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('시행 일자: ${config.issueDate}', style: const TextStyle(color: Color(0xFF605E5C), fontSize: 12)),
                          Text('기안자: ${config.author}', style: const TextStyle(color: Color(0xFF605E5C), fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Paragraphs List
                      ...config.paragraphs.map((p) => _buildParagraph(p)),

                      const SizedBox(height: 48),

                      // Signature Block & Official Red Seal
                      _buildSignatureSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Bottom Word Status Bar
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: const Color(0xFFF3F2F1),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFD2D0CE))),
            ),
            child: Row(
              children: [
                Text('페이지: 1 / ${config.pageCount}', style: const TextStyle(color: Color(0xFF605E5C), fontSize: 11)),
                const SizedBox(width: 14),
                Text('단어 수: ${config.wordCount}개', style: const TextStyle(color: Color(0xFF605E5C), fontSize: 11)),
                const SizedBox(width: 14),
                const Text('한국어', style: TextStyle(color: Color(0xFF605E5C), fontSize: 11)),
                const Spacer(),

                const Icon(Icons.chrome_reader_mode, size: 12, color: Color(0xFF605E5C)),
                const SizedBox(width: 8),
                const Icon(Icons.print, size: 12, color: Color(0xFF185ABD)),
                const SizedBox(width: 8),
                const Icon(Icons.web, size: 12, color: Color(0xFF605E5C)),
                const SizedBox(width: 14),

                // Zoom Slider
                const Icon(Icons.remove, size: 12, color: Color(0xFF605E5C)),
                const SizedBox(width: 4),
                Container(
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC8C6C4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF185ABD), shape: BoxShape.circle)),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.add, size: 12, color: Color(0xFF605E5C)),
                const SizedBox(width: 6),
                const Text('100%', style: TextStyle(color: Color(0xFF605E5C), fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraph(WordParagraph p) {
    if (p.isRedacted) {
      // ⬛ 블랙 마스킹 바 (REDACTED) 연출
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            p.text,
            style: const TextStyle(
              color: Colors.black, // Masked black text
              fontSize: 13,
              height: 1.5,
              fontFamily: 'Consolas',
            ),
          ),
        ),
      );
    }

    if (p.type == WordParagraphType.heading) {
      return Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 8),
        child: Text(
          p.text,
          style: const TextStyle(
            color: Color(0xFF185ABD),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (p.type == WordParagraphType.clause) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Color(0xFF201F1E), fontSize: 13, height: 1.6),
            children: [
              if (p.clauseNumber != null)
                TextSpan(
                  text: '${p.clauseNumber}  ',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF185ABD)),
                ),
              TextSpan(
                text: p.text,
                style: TextStyle(fontWeight: p.isBold ? FontWeight.bold : FontWeight.normal),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        p.text,
        style: TextStyle(
          color: const Color(0xFF201F1E),
          fontSize: 13.5,
          height: 1.65,
          fontWeight: p.isBold ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: p.align,
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                config.issueDate,
                style: const TextStyle(color: Color(0xFF323130), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                config.department,
                style: const TextStyle(color: Color(0xFF201F1E), fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // 🔴 붉은색 관인/직인 (Red Official Seal)
          if (config.officialSealName != null)
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD32F2F), width: 2.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    config.officialSealName!,
                    style: const TextStyle(
                      color: Color(0xFFD32F2F),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
