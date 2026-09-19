import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../apps/screen_template.dart';
import '../../../services/app_theme_service.dart';
import '../../../services/project_service.dart';
import 'dialogs/create_project_dialog.dart';
import 'models/project_model.dart';
import 'views/app_gallery_view.dart';
import 'views/dashboard_home_view.dart';
import 'views/os_gallery_view.dart';
import 'views/profile_view.dart';
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
  // Navigation State: 'home' | 'gallery' | 'os' | or a projectId
  String _activeMenuId = 'home';
  bool _isSidebarCollapsed = false;

  // Real Projects stream from Firebase Firestore
  List<ProjectModel> _projects = [];
  StreamSubscription<List<ProjectModel>>? _projectsSub;

  ProjectModel? _currentEditingProject;
  String _currentEditorTemplateId = 'kakaotalk';

  bool get _isDarkMode => AppThemeService.instance.isDarkMode(context);

  @override
  void initState() {
    super.initState();
    _projectsSub = ProjectService.streamProjects().listen((list) {
      if (mounted) {
        setState(() {
          _projects = list;
        });
      }
    });
  }

  @override
  void dispose() {
    _projectsSub?.cancel();
    super.dispose();
  }

  void _openProject(ProjectModel proj) {
    setState(() {
      _currentEditingProject = proj;
      _currentEditorTemplateId = proj.appTemplateId;
    });
    context.go('/editor/${proj.appTemplateId}/${proj.id}');
  }

  void _openAppInEditor(String templateId) async {
    final t = ScreenTemplate.allTemplates.firstWhere(
      (item) => item.id == templateId,
      orElse: () => ScreenTemplate.allTemplates.first,
    );
    final count = _projects.where((p) => p.appTemplateId == templateId).length + 1;
    final newProj = ProjectModel(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      title: '${t.title} 작업 #$count',
      appTemplateId: templateId,
      updatedAt: DateTime.now(),
    );
    await ProjectService.createProject(newProj);
    if (!mounted) return;
    context.go('/editor/$templateId/${newProj.id}');
  }

  void _createNewProject() async {
    final newProj = await CreateProjectDialog.show(context, isDarkMode: _isDarkMode);
    if (newProj != null) {
      await ProjectService.createProject(newProj);
      if (!mounted) return;
      context.go('/editor/${newProj.appTemplateId}/${newProj.id}');
    }
  }

  void _toggleStarProject(ProjectModel proj) {
    ProjectService.toggleStar(proj.id, !proj.isStarred);
  }

  void _deleteProject(ProjectModel proj) {
    ProjectService.deleteProject(proj.id);
    if (_currentEditingProject?.id == proj.id) {
      setState(() {
        _currentEditingProject = null;
        _activeMenuId = 'home';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    // 1. Full-Screen Figma Editor Mode
    final isProjectEditing = _currentEditingProject != null && _activeMenuId == _currentEditingProject!.id;
    if (isProjectEditing) {
      return AppEditorPage(
        templateId: _currentEditorTemplateId,
        projectId: _currentEditingProject!.id,
        onBackToGallery: () {
          setState(() {
            _currentEditingProject = null;
            _activeMenuId = 'home';
          });
        },
        onOpenInOs: widget.onOpenInOs,
      );
    }

    // 2. Console Workspace Shell (Left Sidebar + Center Views)
    final dummyTemplate = ScreenTemplate.allTemplates.firstWhere(
      (t) => t.id == _currentEditorTemplateId,
      orElse: () => ScreenTemplate.allTemplates.first,
    );

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF090B10) : const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // Workspace Body: Left Sidebar (Project-centric) + Center View (extends under top bar)
          Row(
            children: [
              // Left Navigation Sidebar (CapCut style, Hamburger icon, Real Firebase projects, user profile)
              WorkspaceSidebar(
                projects: _projects,
                activeMenuId: _activeMenuId,
                onSelectMenu: (menuId) {
                  setState(() {
                    _currentEditingProject = null;
                    _activeMenuId = menuId;
                  });
                },
                onSelectProject: _openProject,
                onNewProject: _createNewProject,
                onDeleteProject: _deleteProject,
                onToggleStarProject: _toggleStarProject,
                isCollapsed: _isSidebarCollapsed,
                onToggleCollapse: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                isDarkMode: isDarkMode,
                onSignOut: widget.onSignOut,
                onOpenProfile: () => setState(() => _activeMenuId = 'profile'),
                topPadding: 56.0,
              ),

              // Center Content Area (Smooth Animated Switcher)
              Expanded(
                child: Container(
                  color: isDarkMode ? const Color(0xFF06080D) : const Color(0xFFF8FAFC),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
                          child: child,
                        ),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(_activeMenuId),
                      child: _buildCenterContent(isDarkMode),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Pinned Top Header Bar (Translucent Blur, Floating Edge-to-Edge)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WorkspaceTopBar(
              template: dummyTemplate,
              isDarkMode: isDarkMode,
              isSidebarCollapsed: _isSidebarCollapsed,
              isExporting: false,
              onToggleTheme: () => AppThemeService.instance.toggleTheme(context),
              onToggleSidebar: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
              onExport: () {},
              onOpenInOs: () => widget.onOpenInOs('kakaotalk'),
              onSelectOs: widget.onSelectOs,
              onSignOut: widget.onSignOut,
              onOpenProfile: () => setState(() => _activeMenuId = 'profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterContent(bool isDark) {
    switch (_activeMenuId) {
      case 'profile':
        return ProfileView(
          isDarkMode: isDark,
          onSignOut: widget.onSignOut,
          onBackToDashboard: () => setState(() => _activeMenuId = 'home'),
        );
      case 'os':
        // OS Selection Page View (Req: "OS 탭도 누르면 페이지 나와서 선택한 OS로 접속되게 해야지")
        return OsGalleryView(
          isDarkMode: isDark,
          onSelectOs: widget.onSelectOs,
        );
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
