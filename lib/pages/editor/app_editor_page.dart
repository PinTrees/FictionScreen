import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../apps/screen_template.dart';
import '../../../services/project_service.dart';
import '../console/workspace/models/project_model.dart';
import 'modules/generic_editor_page.dart';
import 'modules/kakaotalk_editor_page.dart';

/// 각 작업마다 별도의 고유 문서 ID(Document)를 부여하고
/// /editor/:templateId/:projectId 전용 경로로 라우팅/페이징하는 래퍼 페이지
class AppEditorPage extends StatefulWidget {
  final String templateId;
  final String? projectId;
  final VoidCallback? onBackToGallery;
  final ValueChanged<String>? onOpenInOs;

  const AppEditorPage({
    super.key,
    required this.templateId,
    this.projectId,
    this.onBackToGallery,
    this.onOpenInOs,
  });

  @override
  State<AppEditorPage> createState() => _AppEditorPageState();
}

class _AppEditorPageState extends State<AppEditorPage> {
  String? _effectiveProjectId;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _effectiveProjectId = widget.projectId;
    if (_effectiveProjectId == null || _effectiveProjectId!.isEmpty) {
      _initializeNewDocument();
    }
  }

  @override
  void didUpdateWidget(covariant AppEditorPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.projectId != oldWidget.projectId && widget.projectId != null) {
      setState(() {
        _effectiveProjectId = widget.projectId;
      });
    }
  }

  Future<void> _initializeNewDocument() async {
    setState(() => _isInitializing = true);
    final docId = 'proj_${DateTime.now().millisecondsSinceEpoch}';
    final t = ScreenTemplate.allTemplates.firstWhere(
      (item) => item.id == widget.templateId,
      orElse: () => ScreenTemplate.allTemplates.first,
    );
    final newProj = ProjectModel(
      id: docId,
      title: '${t.title} 작업',
      appTemplateId: widget.templateId,
      updatedAt: DateTime.now(),
    );
    await ProjectService.createProject(newProj);

    if (!mounted) return;
    setState(() {
      _effectiveProjectId = docId;
      _isInitializing = false;
    });

    // 고유 문서 경로(/editor/:templateId/:projectId)로 브라우저 URL 갱신하여 페이징 가능하게 처리
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go('/editor/${widget.templateId}/$docId');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing || _effectiveProjectId == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F1219),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        ),
      );
    }

    void handleBackToGallery() {
      if (widget.onBackToGallery != null) {
        widget.onBackToGallery!();
        return;
      }
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/console');
      }
    }

    void handleOpenInOs(String osKey) {
      if (widget.onOpenInOs != null) {
        widget.onOpenInOs!(osKey);
        return;
      }
      context.go('/console?os=$osKey');
    }

    if (widget.templateId == 'kakaotalk') {
      return KakaoTalkEditorPage(
        projectId: _effectiveProjectId,
        onBackToGallery: handleBackToGallery,
        onOpenInOs: handleOpenInOs,
      );
    }

    return GenericEditorPage(
      templateId: widget.templateId,
      projectId: _effectiveProjectId,
      onBackToGallery: handleBackToGallery,
      onOpenInOs: handleOpenInOs,
    );
  }
}
