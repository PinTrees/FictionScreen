import 'package:flutter/widgets.dart';

/// 유튜브 앱 창 내부에서만 바텀시트/모달이 뜨도록 범위를 제공하는 InheritedWidget
class YouTubeModalScope extends InheritedWidget {
  final void Function(Widget modal) showModal;
  final VoidCallback hideModal;

  const YouTubeModalScope({
    super.key,
    required this.showModal,
    required this.hideModal,
    required super.child,
  });

  static YouTubeModalScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<YouTubeModalScope>();
  }

  static YouTubeModalScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No YouTubeModalScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(YouTubeModalScope oldWidget) => false;
}
