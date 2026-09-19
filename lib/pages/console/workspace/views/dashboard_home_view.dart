import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/project_model.dart';

class DashboardHomeView extends StatelessWidget {
  final List<ProjectModel> projects;
  final bool isDarkMode;
  final ValueChanged<ProjectModel> onOpenProject;
  final VoidCallback onNewProject;
  final VoidCallback onOpenGallery;
  final ValueChanged<String> onOpenOs;

  const DashboardHomeView({
    super.key,
    required this.projects,
    required this.isDarkMode,
    required this.onOpenProject,
    required this.onNewProject,
    required this.onOpenGallery,
    required this.onOpenOs,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDarkMode ? Colors.white54 : const Color(0xFF64748B);
    final cardBgColor = isDarkMode ? const Color(0xFF141822) : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner / Welcome Area
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                    : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'FICTION SCREEN STUDIO',
                              style: TextStyle(
                                color: Color(0xFF818CF8),
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '총 ${projects.length}개의 활성 프로젝트',
                            style: TextStyle(color: textSubColor, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '시나리오 & 가상 화면 프로젝트',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '어플을 선택하여 대화 및 스크린샷을 작성하고, 피그마 캔버스에서 실시간으로 편집하거나 PNG로 내보내세요.',
                        style: TextStyle(color: textSubColor, fontSize: 13.5, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Action Buttons (BORDER-FREE)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(CupertinoIcons.plus_circle_fill, size: 16),
                      label: const Text('새 프로젝트 만들기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      onPressed: onNewProject,
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(CupertinoIcons.compass, size: 14),
                      label: const Text('어플 템플릿 갤러리 탐색', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      onPressed: onOpenGallery,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Section Title: 최근 작업 프로젝트
          Row(
            children: [
              Icon(CupertinoIcons.clock, size: 18, color: textColor),
              const SizedBox(width: 8),
              Text(
                '최근 작업 프로젝트',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              Text(
                '총 ${projects.length}개',
                style: TextStyle(color: textSubColor, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Projects Grid
          Expanded(
            child: projects.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.folder_badge_plus, size: 48, color: textSubColor.withValues(alpha: 0.4)),
                        const SizedBox(height: 12),
                        Text('아직 생성된 프로젝트가 없습니다', style: TextStyle(color: textSubColor, fontSize: 14)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: onNewProject,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('첫 번째 프로젝트 만들기'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 340,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.55,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final proj = projects[index];
                      final template = proj.template;

                      return InkWell(
                        onTap: () => onOpenProject(proj),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBgColor,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDarkMode ? 0.25 : 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // App Icon
                                  Container(
                                    width: 32,
                                    height: 32,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: (template?.themeColor ?? const Color(0xFF6366F1)).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: template?.imageAsset != null
                                          ? Image.asset(template!.imageAsset!, fit: BoxFit.contain)
                                          : Icon(template?.icon ?? CupertinoIcons.app,
                                              size: 16, color: template?.themeColor ?? const Color(0xFF6366F1)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          template?.title ?? proj.appTemplateId,
                                          style: TextStyle(
                                            color: textSubColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          proj.timeAgo,
                                          style: TextStyle(
                                            color: textSubColor.withValues(alpha: 0.7),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (proj.isStarred)
                                    const Icon(CupertinoIcons.star_fill, size: 14, color: Color(0xFFF59E0B)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                proj.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  proj.description.isNotEmpty
                                      ? proj.description
                                      : '피그마 캔버스에서 자유롭게 화면을 편집하세요.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: textSubColor,
                                    fontSize: 12,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '피그마 에디터 열기',
                                    style: TextStyle(
                                      color: isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    CupertinoIcons.arrow_right,
                                    size: 11,
                                    color: isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
