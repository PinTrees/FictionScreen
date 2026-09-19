import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../apps/screen_template.dart';
import '../../editor/modules/generic_editor_page.dart';
import '../../editor/modules/kakaotalk_editor_page.dart';
import 'views/app_gallery_view.dart';
import 'widgets/workspace_sidebar.dart';
import 'widgets/workspace_top_bar.dart';

class WorkspaceView extends StatefulWidget {
  final String? initialTemplateId;
  final Function(String osKey) onSelectOs;
  final Function(String templateId) onOpenInOs;
  final VoidCallback onSignOut;

  const WorkspaceView({
    super.key,
    this.initialTemplateId,
    required this.onSelectOs,
    required this.onOpenInOs,
    required this.onSignOut,
  });

  @override
  State<WorkspaceView> createState() => _WorkspaceViewState();
}

class _WorkspaceViewState extends State<WorkspaceView> {
  late String _currentTemplateId;
  bool? _userThemeOverride;
  bool _isSidebarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _currentTemplateId = widget.initialTemplateId ?? 'gallery';
  }

  static const _galleryTemplate = ScreenTemplate(
    id: 'gallery',
    title: '어플 탐색 갤러리',
    description: '33개 픽셀 정밀 가상 어플 스튜디오 탐색',
    category: TemplateCategory.messenger,
    icon: CupertinoIcons.square_grid_2x2_fill,
    themeColor: Color(0xFF6366F1),
  );

  ScreenTemplate get _currentTemplate {
    if (_currentTemplateId == 'gallery') return _galleryTemplate;
    return ScreenTemplate.allTemplates.firstWhere(
      (t) => t.id == _currentTemplateId,
      orElse: () => _galleryTemplate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final systemIsDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final isDarkMode = _userThemeOverride ?? systemIsDark;

    // 1. If user selected a specific application, display the Full-Screen Figma-style Editor!
    if (_currentTemplateId != 'gallery') {
      void handleBackToGallery() {
        setState(() {
          _currentTemplateId = 'gallery';
        });
      }

      if (_currentTemplateId == 'kakaotalk') {
        return KakaoTalkEditorPage(
          onBackToGallery: handleBackToGallery,
          onOpenInOs: widget.onSelectOs,
        );
      }

      return GenericEditorPage(
        templateId: _currentTemplateId,
        onBackToGallery: handleBackToGallery,
        onOpenInOs: widget.onSelectOs,
      );
    }

    // 2. Otherwise, display the Console Main Page (Left Sidebar + App Gallery View)
    final template = _currentTemplate;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF090B10) : const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Top Header Bar
          WorkspaceTopBar(
            template: template,
            isDarkMode: isDarkMode,
            isSidebarCollapsed: _isSidebarCollapsed,
            isExporting: false,
            onToggleTheme: () => setState(() => _userThemeOverride = !isDarkMode),
            onToggleSidebar: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
            onExport: () {},
            onOpenInOs: () => widget.onOpenInOs('kakaotalk'),
            onSelectOs: widget.onSelectOs,
            onSignOut: widget.onSignOut,
          ),

          // Workspace Body: Left Sidebar + Center App Gallery Grid
          Expanded(
            child: Row(
              children: [
                // Left Navigation Sidebar (Rescene-inspired Collapsible & Border-free)
                WorkspaceSidebar(
                  templates: ScreenTemplate.allTemplates,
                  selectedTemplateId: _currentTemplateId,
                  onSelectTemplate: (id) => setState(() => _currentTemplateId = id),
                  isCollapsed: _isSidebarCollapsed,
                  onToggleCollapse: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                  isDarkMode: isDarkMode,
                ),

                // Center App Selection Gallery View
                Expanded(
                  child: Container(
                    color: isDarkMode ? const Color(0xFF06080D) : const Color(0xFFF8FAFC),
                    child: AppGalleryView(
                      templates: ScreenTemplate.allTemplates,
                      isDarkMode: isDarkMode,
                      onSelectApp: (id) {
                        setState(() {
                          _currentTemplateId = id;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
