import 'dart:ui_web' as ui_web;
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

final Set<String> _registeredViews = <String>{};

Widget buildIframeView(String viewId, String videoId) {
  final viewType = 'youtube-iframe-$videoId';

  if (!_registeredViews.contains(viewType)) {
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int id) {
      final iframe = web.HTMLIFrameElement()
        ..src = 'https://www.youtube-nocookie.com/embed/$videoId?autoplay=1&playsinline=1&rel=0&modestbranding=1'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
        ..allowFullscreen = true;
      return iframe;
    });
    _registeredViews.add(viewType);
  }

  return HtmlElementView(viewType: viewType);
}
