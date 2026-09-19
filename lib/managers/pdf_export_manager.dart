import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

/// PDF 파일 생성 및 브라우저 다운로드 관리자
class PdfExportManager {
  /// 위젯을 A4 정규격 고해상도 PDF 바이너리로 변환 후 .pdf 파일 다운로드
  static Future<bool> exportToPdf({
    required ScreenshotController controller,
    required String filename,
    double pixelRatio = 2.8,
  }) async {
    try {
      final Uint8List? imageBytes = await controller.capture(
        pixelRatio: pixelRatio,
      );

      if (imageBytes == null || imageBytes.isEmpty) {
        return false;
      }

      // 1. PDF 문서 생성 (A4 정규격)
      final pdf = pw.Document();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();

      // 2. 웹 브라우저에서 다운로드
      if (kIsWeb) {
        final sanitizedName = filename.endsWith('.pdf') ? filename : '$filename.pdf';
        _downloadWeb(pdfBytes, sanitizedName, 'application/pdf');
      }
      return true;
    } catch (e) {
      debugPrint('[PdfExportManager] PDF export error: $e');
      return false;
    }
  }

  /// 고화질 PNG 이미지로 내보내기
  static Future<bool> exportToPng({
    required ScreenshotController controller,
    required String filename,
    double pixelRatio = 3.0,
  }) async {
    try {
      final Uint8List? imageBytes = await controller.capture(
        pixelRatio: pixelRatio,
      );

      if (imageBytes == null || imageBytes.isEmpty) {
        return false;
      }

      if (kIsWeb) {
        final sanitizedName = filename.endsWith('.png') ? filename : '$filename.png';
        _downloadWeb(imageBytes, sanitizedName, 'image/png');
      }
      return true;
    } catch (e) {
      debugPrint('[PdfExportManager] PNG export error: $e');
      return false;
    }
  }

  /// 브라우저 시스템 인쇄 다이얼로그 호출
  static void printCurrentWindow() {
    if (kIsWeb) {
      try {
        web.window.print();
      } catch (e) {
        debugPrint('[PdfExportManager] Print error: $e');
      }
    }
  }

  static void _downloadWeb(Uint8List bytes, String filename, String mimeType) {
    try {
      final jsArray = bytes.toJS;
      final blob = web.Blob([jsArray].toJS, web.BlobPropertyBag(type: mimeType));
      final url = web.URL.createObjectURL(blob);
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = filename;
      anchor.click();
      web.URL.revokeObjectURL(url);
    } catch (e) {
      debugPrint('[PdfExportManager] Web download error: $e');
    }
  }
}
