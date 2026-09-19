import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../services/auth_service.dart';
import '../models/project_model.dart';

class WorkspaceSidebar extends StatelessWidget {
  final List<ProjectModel> projects;
  final String activeMenuId; // 'home', 'gallery', 'os', or project id
  final ValueChanged<String> onSelectMenu;
  final ValueChanged<ProjectModel> onSelectProject;
  final VoidCallback onNewProject;
  final ValueChanged<ProjectModel> onDeleteProject;
  final ValueChanged<ProjectModel> onToggleStarProject;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;
  final bool isDarkMode;
  final VoidCallback onSignOut;

  const WorkspaceSidebar({
    super.key,
    required this.projects,
    required this.activeMenuId,
    required this.onSelectMenu,
    required this.onSelectProject,
    required this.onNewProject,
    required this.onDeleteProject,
    required this.onToggleStarProject,
    required this.isCollapsed,
    required this.onToggleCollapse,
    required this.isDarkMode,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;
    final sidebarWidth = isCollapsed ? 76.0 : 270.0;

    final bgColor = isDark ? const Color(0xFF090B10) : const Color(0xFFF8FAFC);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final activeItemBg = isDark ? const Color(0xFF19202E) : const Color(0xFFEEF2FF);
    final activeItemText = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);

    final User? user = AuthService.currentUser;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.04),
            blurRadius: 14,
            offset: const Offset(3, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. CapCut-style Brand Color "+ Create New" Button (Starts immediately without duplicate top bar)
          Padding(
            padding: EdgeInsets.fromLTRB(
              isCollapsed ? 10 : 16,
              18,
              isCollapsed ? 10 : 16,
              12,
            ),
            child: isCollapsed
                ? Center(
                    child: Tooltip(
                      message: '새 프로젝트 생성',
                      child: InkWell(
                        onTap: onNewProject,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(CupertinoIcons.add, size: 22, color: Color(0xFF003852)),
                          ),
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: onNewProject,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.add, size: 18, color: Color(0xFF003852)),
                          SizedBox(width: 8),
                          Text(
                            'Create new',
                            style: TextStyle(
                              color: Color(0xFF003852),
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 6),

          // 2. Navigation Items (Using 100% reliable Material Icons)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 10 : 14),
            child: Column(
              children: [
                _buildNavItem(
                  id: 'home',
                  icon: Icons.home_rounded,
                  title: 'Home (대시보드)',
                  badge: null,
                  isActive: activeMenuId == 'home',
                  isCollapsed: isCollapsed,
                  isDark: isDark,
                  textColor: textColor,
                  textSubColor: textSubColor,
                  activeBg: activeItemBg,
                  activeText: activeItemText,
                  onTap: () => onSelectMenu('home'),
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  id: 'gallery',
                  icon: Icons.explore_rounded,
                  title: '어플 템플릿 갤러리',
                  badge: '33종',
                  isActive: activeMenuId == 'gallery',
                  isCollapsed: isCollapsed,
                  isDark: isDark,
                  textColor: textColor,
                  textSubColor: textSubColor,
                  activeBg: activeItemBg,
                  activeText: activeItemText,
                  onTap: () => onSelectMenu('gallery'),
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  id: 'os',
                  icon: Icons.desktop_windows_rounded,
                  title: '가상 데스크톱 OS',
                  badge: 'SteamOS+',
                  isActive: activeMenuId == 'os',
                  isCollapsed: isCollapsed,
                  isDark: isDark,
                  textColor: textColor,
                  textSubColor: textSubColor,
                  activeBg: activeItemBg,
                  activeText: activeItemText,
                  onTap: () => onSelectMenu('os'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 3. Section Label: Projects (CapCut muted header)
          if (!isCollapsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
              child: Text(
                'TEMPLATES & PROJECTS',
                style: TextStyle(
                  color: textSubColor.withValues(alpha: 0.7),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            )
          else
            Center(
              child: Container(
                width: 26,
                height: 1,
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
              ),
            ),

          const SizedBox(height: 6),

          // 4. Real User Projects List (NO SCROLLBAR, Pure Firebase Data)
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(scrollbars: false),
              child: projects.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: isCollapsed
                            ? Icon(Icons.folder_open_rounded, size: 22, color: textSubColor.withValues(alpha: 0.4))
                            : Text(
                                '저장된 프로젝트가 없습니다\n상단의 새 프로젝트를 생성하세요',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: textSubColor, fontSize: 11.5, height: 1.4),
                              ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCollapsed ? 10 : 14,
                        vertical: 4,
                      ),
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final proj = projects[index];
                        final isActive = activeMenuId == proj.id;
                        final template = proj.template;

                        if (isCollapsed) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Tooltip(
                              message: '${proj.title} (${template?.title ?? proj.appTemplateId})',
                              child: InkWell(
                                onTap: () => onSelectProject(proj),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isActive ? activeItemBg : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: (template?.themeColor ?? const Color(0xFF00B0FF)).withValues(alpha: 0.16),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: template?.imageAsset != null
                                          ? Image.asset(template!.imageAsset!, fit: BoxFit.contain)
                                          : Icon(template?.icon ?? Icons.insert_drive_file_rounded,
                                              size: 14, color: template?.themeColor ?? const Color(0xFF00B0FF)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        // Expanded Project Item (BORDER-FREE)
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: InkWell(
                            onTap: () => onSelectProject(proj),
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isActive ? activeItemBg : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  // App Icon
                                  Container(
                                    width: 30,
                                    height: 30,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: (template?.themeColor ?? const Color(0xFF00B0FF)).withValues(alpha: 0.16),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: template?.imageAsset != null
                                          ? Image.asset(template!.imageAsset!, fit: BoxFit.contain)
                                          : Icon(template?.icon ?? Icons.insert_drive_file_rounded,
                                              size: 14, color: template?.themeColor ?? const Color(0xFF00B0FF)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Title & time
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          proj.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isActive ? activeItemText : textColor,
                                            fontSize: 13,
                                            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${template?.title ?? proj.appTemplateId} • ${proj.timeAgo}',
                                          style: TextStyle(
                                            color: textSubColor,
                                            fontSize: 10.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Star toggle
                                  InkWell(
                                    onTap: () => onToggleStarProject(proj),
                                    borderRadius: BorderRadius.circular(6),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        proj.isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                                        size: 16,
                                        color: proj.isStarred ? const Color(0xFFF59E0B) : textSubColor.withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // 5. Bottom User Profile Section
          Container(
            padding: EdgeInsets.all(isCollapsed ? 10 : 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF06070B) : const Color(0xFFF1F5F9),
            ),
            child: isCollapsed
                ? Center(
                    child: Tooltip(
                      message: user?.displayName ?? user?.email ?? '사용자 프로필',
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF00B0FF),
                        backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                        child: user?.photoURL == null
                            ? Text(
                                (user?.displayName?.isNotEmpty == true
                                        ? user!.displayName![0]
                                        : (user?.email?.isNotEmpty == true ? user!.email![0] : 'U'))
                                    .toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              )
                            : null,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF00B0FF),
                        backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                        child: user?.photoURL == null
                            ? Text(
                                (user?.displayName?.isNotEmpty == true
                                        ? user!.displayName![0]
                                        : (user?.email?.isNotEmpty == true ? user!.email![0] : 'U'))
                                    .toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user?.displayName ?? '사용자',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.email ?? 'Firebase 계정 연동됨',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textSubColor,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: '로그아웃',
                        icon: Icon(Icons.logout_rounded, size: 18, color: textSubColor),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: onSignOut,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String id,
    required IconData icon,
    required String title,
    required String? badge,
    required bool isActive,
    required bool isCollapsed,
    required bool isDark,
    required Color textColor,
    required Color textSubColor,
    required Color activeBg,
    required Color activeText,
    required VoidCallback onTap,
  }) {
    if (isCollapsed) {
      return Tooltip(
        message: title,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isActive ? activeBg : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: isActive ? activeText : textSubColor,
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? activeText : textSubColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isActive ? activeText : textColor,
                  fontSize: 13.5,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? activeText.withValues(alpha: 0.15)
                      : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: isActive ? activeText : textSubColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
