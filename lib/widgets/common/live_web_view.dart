import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

/// iOS Safari / Windows Edge 등 가상 브라우저용 실시간 웹뷰 렌더러 (iframe 기반)
class LiveWebView extends StatefulWidget {
  final String url;

  const LiveWebView({
    super.key,
    required this.url,
  });

  @override
  State<LiveWebView> createState() => _LiveWebViewState();
}

class _LiveWebViewState extends State<LiveWebView> {
  late String _viewId;

  @override
  void initState() {
    super.initState();
    _updateView();
  }

  @override
  void didUpdateWidget(covariant LiveWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _updateView();
    }
  }

  void _updateView() {
    _viewId = 'iframe_${widget.url.hashCode}_${DateTime.now().millisecondsSinceEpoch}';

    if (kIsWeb) {
      ui_web.platformViewRegistry.registerViewFactory(
        _viewId,
        (int viewId) {
          final iframe = web.HTMLIFrameElement()
            ..src = widget.url
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%';
          return iframe;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return HtmlElementView(viewType: _viewId);
    } else {
      // Non-web fallback
      return Container(
        color: const Color(0xFF141720),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.globe, color: Color(0xFF007AFF), size: 48),
              const SizedBox(height: 12),
              Text(
                widget.url,
                style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text('웹 디바이스 전용 실시간 웹뷰', style: TextStyle(color: Color(0x8AFFFFFF), fontSize: 12)),
            ],
          ),
        ),
      );
    }
  }
}
