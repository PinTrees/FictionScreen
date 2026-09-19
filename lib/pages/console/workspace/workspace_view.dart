import 'package:flutter/material.dart';
import '../../../apps/screen_template.dart';
import 'dialogs/create_project_dialog.dart';
import 'models/project_model.dart';
import 'views/app_gallery_view.dart';
import 'views/dashboard_home_view.dart';
import 'widgets/workspace_sidebar.dart';
import 'widgets/workspace_top_bar.dart';
import '../../editor/app_editor_page.dart';

class WorkspaceView extends StatefulWidget {
  final ValueChanged<String> onOpenInOs;
  final ValueChanged<String> onSelectOs;
  final VoidCallback onSignOut;

  const WorkspaceView({
    super.key,
    required this.onOpenInOs,
    required this.onSelectOs,
    required this.onSignOut,
  });

  @override
  State<WorkspaceView> createState() => _WorkspaceViewState();
}

class _WorkspaceViewState extends State<WorkspaceView> {
  // Navigation State
  // 'home' | 'gallery' | 'os' | or a projectId
  String _activeMenuId = 'home';
  bool _isSidebarCollapsed = false;
  bool? _userThemeOverride;

  // Active Projects
  final List<ProjectModel> _projects = List.from(ProjectModel.initialSampleProjects);
  ProjectModel? _currentEditingProject;
  String _currentEditorTemplateId = 'kakaotalk';

  bool get _isDarkMode {
    if (_userThemeOverride != null) return _userThemeOverride!;
    return true; // Default dark studio theme
  }

  void _openProject(ProjectModel proj) {
    setState(() {
      _currentEditingProject = proj;
      _currentEditorTemplateId = proj.appTemplateId;
      _activeMenuId = proj.id;
    });
  }

  void _openAppInEditor(String templateId) {
    // Check if an existing project matches or create temporary session
    final existing = _projects.where((p) => p.appTemplateId == templateId).firstOrNull;
    setState(() {
      if (existing != null) {
        _currentEditingProject = existing;
        _activeMenuId = existing.id;
      } else {
        final t = ScreenTemplate.allTemplates.firstWhere((item) => item.id == templateId);
        final newProj = ProjectModel(
          id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
          title: '${t.title} 작업 프로젝트',
          appTemplateId: templateId,
          updatedAt: DateTime.now(),
        );
        _projects.insert(0, newProj);
        _currentEditingProject = newProj;
        _activeMenuId = newProj.id;
      }
      _currentEditorTemplateId = templateId;
    });
  }

  void _createNewProject() async {
    final newProj = await CreateProjectDialog.show(context, isDarkMode: _isDarkMode);
    if (newProj != null) {
      setState(() {
        _projects.insert(0, newProj);
        _openProject(newProj);
      });
    }
  }

  void _toggleStarProject(ProjectModel proj) {
    setState(() {
      proj.isStarred = !proj.isStarred;
    });
  }

  void _deleteProject(ProjectModel proj) {
    setState(() {
      _projects.removeWhere((p) => p.id == proj.id);
      if (_currentEditingProject?.id == proj.id) {
        _currentEditingProject = null;
        _activeMenuId = 'home';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    // 1. If currently editing a project in Full-Screen Figma Editor Mode
    final isProjectEditing = _currentEditingProject != null && _activeMenuId == _currentEditingProject!.id;
    if (isProjectEditing) {
      return AppEditorPage(
        templateId: _currentEditorTemplateId,
        onBackToGallery: () {
          setState(() {
            _currentEditingProject = null;
            _activeMenuId = 'home';
          });
        },
        onOpenInOs: widget.onOpenInOs,
      );
    }

    // 2. Otherwise, display the Console Workspace Shell (Left Sidebar + Center Views)
    final dummyTemplate = ScreenTemplate.allTemplates.firstWhere(
      (t) => t.id == _currentEditorTemplateId,
      orElse: () => ScreenTemplate.allTemplates.first,
    );

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF090B10) : const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Top Header Bar
          WorkspaceTopBar(
            template: dummyTemplate,
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

          // Workspace Body: Left Sidebar (Project-centric) + Center View
          Expanded(
            child: Row(
              children: [
                // Left Navigation Sidebar (Zero outline, project list)
                WorkspaceSidebar(
                  projects: _projects,
                  activeMenuId: _activeMenuId,
                  onSelectMenu: (menuId) {
                    if (menuId == 'os') {
                      widget.onSelectOs('windows_11');
                    } else {
                      setState(() {
                        _currentEditingProject = null;
                        _activeMenuId = menuId;
                      });
                    }
                  },
                  onSelectProject: _openProject,
                  onNewProject: _createNewProject,
                  onDeleteProject: _deleteProject,
                  onToggleStarProject: _toggleStarProject,
                  isCollapsed: _isSidebarCollapsed,
                  onToggleCollapse: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                  isDarkMode: isDarkMode,
                ),

                // Center Content Area
                Expanded(
                  child: Container(
                    color: isDarkMode ? const Color(0xFF06080D) : const Color(0xFFF8FAFC),
                    child: _buildCenterContent(isDarkMode),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterContent(bool isDark) {
    switch (_activeMenuId) {
      case 'gallery':
        return AppGalleryView(
          templates: ScreenTemplate.allTemplates,
          isDarkMode: isDark,
          onSelectApp: (appId) => _openAppInEditor(appId),
        );
      case 'home':
      default:
        return DashboardHomeView(
          projects: _projects,
          isDarkMode: isDark,
          onOpenProject: _openProject,
          onNewProject: _createNewProject,
          onOpenGallery: () => setState(() => _activeMenuId = 'gallery'),
          onOpenOs: widget.onSelectOs,
        );
    }
  }
}
