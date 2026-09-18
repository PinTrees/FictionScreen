import 'package:flutter/widgets.dart';

/// 인스타그램 앱 창 내에서만 바텀시트/모달이 뜨도록 범위(Scope)를 제공하는 InheritedWidget
class InstagramModalScope extends InheritedWidget {
  final void Function(Widget modal) showModal;
  final VoidCallback hideModal;

  const InstagramModalScope({
    super.key,
    required this.showModal,
    required this.hideModal,
    required super.child,
  });

  static InstagramModalScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InstagramModalScope>();
  }

  static InstagramModalScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No InstagramModalScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(InstagramModalScope oldWidget) => false;
}
