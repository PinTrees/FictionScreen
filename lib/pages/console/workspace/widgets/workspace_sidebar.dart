import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/project_model.dart';
import 'package:go_router/go_router.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;
    final sidebarWidth = isCollapsed ? 74.0 : 270.0;

    final bgColor = isDark ? const Color(0xFF0D1017) : const Color(0xFFF8FAFC);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final activeItemBg = isDark ? const Color(0xFF1E2433) : const Color(0xFFEEF2FF);
    final activeItemText = isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 230),
      curve: Curves.easeOutCubic,
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Top Section: New Project Button or Expand Icon
          Padding(
            padding: EdgeInsets.fromLTRB(isCollapsed ? 8 : 12, 14, isCollapsed ? 8 : 12, 10),
            child: isCollapsed
                ? Center(
                    child: IconButton(
                      tooltip: '새 프로젝트 생성',
                      icon: const Icon(CupertinoIcons.plus_circle_fill, size: 22, color: Color(0xFF6366F1)),
                      onPressed: onNewProject,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: onNewProject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(double.infinity, 42),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(CupertinoIcons.plus_circle_fill, size: 16),
                    label: const Text(
                      '새 프로젝트 생성',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
          ),

          // 2. Global Core Navigation (Home, Gallery, Virtual OS)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 10),
            child: Column(
              children: [
                _buildNavItem(
                  id: 'home',
                  icon: CupertinoIcons.home,
                  title: '대시보드 / 홈',
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
                  icon: CupertinoIcons.compass,
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
                  icon: CupertinoIcons.macwindow,
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

          const SizedBox(height: 12),

          // 3. Projects Section Header (Only when expanded)
          if (!isCollapsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Row(
                children: [
                  Icon(CupertinoIcons.folder_fill, size: 13, color: textSubColor),
                  const SizedBox(width: 6),
                  Text(
                    '내 프로젝트 (${projects.length})',
                    style: TextStyle(
                      color: textSubColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                width: 28,
                height: 1,
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
              ),
            ),

          // 4. Projects List (Scrollable, NO SCROLLBAR)
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(scrollbars: false),
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: isCollapsed ? 8 : 10,
                ),
                children: [
                  if (projects.isEmpty)
                    if (!isCollapsed)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
                        child: Center(
                          child: Text(
                            '생성된 프로젝트가 없습니다\n상단의 새 프로젝트를 눌러보세요',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textSubColor, fontSize: 11.5, height: 1.4),
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink()
                  else
                    ...projects.map((proj) {
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
                                      color: (template?.themeColor ?? const Color(0xFF6366F1)).withValues(alpha: 0.16),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: template?.imageAsset != null
                                        ? Image.asset(template!.imageAsset!, fit: BoxFit.contain)
                                        : Icon(template?.icon ?? CupertinoIcons.doc,
                                            size: 14, color: template?.themeColor ?? const Color(0xFF6366F1)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      // Expanded Project Card Item (BORDER-FREE)
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: InkWell(
                          onTap: () => onSelectProject(proj),
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                            decoration: BoxDecoration(
                              color: isActive ? activeItemBg : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                // App Icon
                                Container(
                                  width: 28,
                                  height: 28,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: (template?.themeColor ?? const Color(0xFF6366F1)).withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: template?.imageAsset != null
                                        ? Image.asset(template!.imageAsset!, fit: BoxFit.contain)
                                        : Icon(template?.icon ?? CupertinoIcons.doc,
                                            size: 14, color: template?.themeColor ?? const Color(0xFF6366F1)),
                                  ),
                                ),
                                const SizedBox(width: 9),
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
                                          fontSize: 12.5,
                                          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            template?.title ?? proj.appTemplateId,
                                            style: TextStyle(
                                              color: textSubColor,
                                              fontSize: 10.5,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '• ${proj.timeAgo}',
                                            style: TextStyle(
                                              color: textSubColor.withValues(alpha: 0.7),
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Star button
                                InkWell(
                                  onTap: () => onToggleStarProject(proj),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      proj.isStarred ? CupertinoIcons.star_fill : CupertinoIcons.star,
                                      size: 13,
                                      color: proj.isStarred ? const Color(0xFFF59E0B) : textSubColor.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),

          // 5. Bottom Navigation & Collapse Control (Zero Outline)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 6 : 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF090B10) : const Color(0xFFEFF2F6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isCollapsed) ...[
                  Row(
                    children: [
                      InkWell(
                        onTap: () => context.push('/terms'),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            '이용약관',
                            style: TextStyle(color: textSubColor, fontSize: 11),
                          ),
                        ),
                      ),
                      Text('•', style: TextStyle(color: textSubColor.withValues(alpha: 0.4), fontSize: 10)),
                      InkWell(
                        onTap: () => context.push('/privacy'),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            '개인정보방침',
                            style: TextStyle(color: textSubColor, fontSize: 11),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onToggleCollapse,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(CupertinoIcons.chevron_left, size: 14, color: textSubColor),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  IconButton(
                    tooltip: '사이드바 펼치기',
                    icon: const Icon(CupertinoIcons.chevron_right, size: 14),
                    color: textSubColor,
                    onPressed: onToggleCollapse,
                  ),
                ],
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
                size: 18,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? activeText : textSubColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isActive ? activeText : textColor,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
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
