import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'modules/generic_editor_page.dart';
import 'modules/kakaotalk_editor_page.dart';

class AppEditorPage extends StatelessWidget {
  final String templateId;
  final VoidCallback? onBackToGallery;
  final ValueChanged<String>? onOpenInOs;

  const AppEditorPage({
    super.key,
    required this.templateId,
    this.onBackToGallery,
    this.onOpenInOs,
  });

  @override
  Widget build(BuildContext context) {
    void handleBackToGallery() {
      if (onBackToGallery != null) {
        onBackToGallery!();
        return;
      }
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/console');
      }
    }

    void handleOpenInOs(String osKey) {
      if (onOpenInOs != null) {
        onOpenInOs!(osKey);
        return;
      }
      context.go('/console?os=$osKey');
    }

    if (templateId == 'kakaotalk') {
      return KakaoTalkEditorPage(
        onBackToGallery: handleBackToGallery,
        onOpenInOs: handleOpenInOs,
      );
    }

    return GenericEditorPage(
      templateId: templateId,
      onBackToGallery: handleBackToGallery,
      onOpenInOs: handleOpenInOs,
    );
  }
}
