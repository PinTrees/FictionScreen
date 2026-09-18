import 'package:flutter/foundation.dart';
import 'package:screenshot/screenshot.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

class ExportManager {
  static final ScreenshotController screenshotController = ScreenshotController();

  /// 캡처 후 이미지 다운로드 실행
  static Future<bool> captureAndDownload({
    required ScreenshotController controller,
    String filename = 'fiction_screen.png',
    double pixelRatio = 2.5, // 고화질 렌더링
  }) async {
    try {
      final Uint8List? imageBytes = await controller.capture(
        pixelRatio: pixelRatio,
      );

      if (imageBytes == null || imageBytes.isEmpty) {
        return false;
      }

      if (kIsWeb) {
        _downloadWeb(imageBytes, filename);
      }
      return true;
    } catch (e) {
      debugPrint('[ExportManager] Error capturing image: $e');
      return false;
    }
  }

  static void _downloadWeb(Uint8List bytes, String filename) {
    try {
      final jsArray = bytes.toJS;
      final blob = web.Blob([jsArray].toJS, web.BlobPropertyBag(type: 'image/png'));
      final url = web.URL.createObjectURL(blob);
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = filename;
      anchor.click();
      web.URL.revokeObjectURL(url);
    } catch (e) {
      debugPrint('[ExportManager] Web download error: $e');
    }
  }
}
