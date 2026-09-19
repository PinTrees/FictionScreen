import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/scale_button.dart';
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
      padding: const EdgeInsets.fromLTRB(40, 76, 40, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner / Welcome Area with generous padding (ZERO OUTLINE)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [const Color(0xFF131B2E), const Color(0xFF090D17)]
                    : [const Color(0xFFE0F7FA), const Color(0xFFE8EAF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
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
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00E5FF).withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '스튜디오 대시보드',
                              style: TextStyle(
                                color: Color(0xFF00B0FF),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '총 ${projects.length}개의 프로젝트',
                            style: TextStyle(color: textSubColor, fontSize: 12.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '시나리오 & 가상 화면 프로젝트',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '어플을 선택하여 대화 및 스크린샷을 작성하고, 피그마 캔버스에서 실시간으로 편집하거나 PNG로 내보내세요.',
                        style: TextStyle(color: textSubColor, fontSize: 14, height: 1.45),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Brand Button (CapCut style)
                ScaleButton(
                  onTap: onNewProject,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.add, size: 18, color: Color(0xFF003852)),
                        SizedBox(width: 8),
                        Text(
                          '새 프로젝트 만들기',
                          style: TextStyle(
                            color: Color(0xFF003852),
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // Section Title: 최근 작업 프로젝트
          Row(
            children: [
              Icon(CupertinoIcons.clock, size: 19, color: textColor),
              const SizedBox(width: 10),
              Text(
                '최근 작업 프로젝트',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const Spacer(),
              Text(
                '총 ${projects.length}개',
                style: TextStyle(color: textSubColor, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Projects Grid or Empty State
          Expanded(
            child: projects.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(CupertinoIcons.folder_badge_plus, size: 36, color: textSubColor.withValues(alpha: 0.5)),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '저장된 프로젝트가 없습니다',
                          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '새 프로젝트를 생성하여 피그마 캔버스에서 첫 번째 화면을 디자인해보세요.',
                          style: TextStyle(color: textSubColor, fontSize: 13),
                        ),
                        const SizedBox(height: 18),
                        ScaleButton(
                          onTap: onNewProject,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '새 프로젝트 시작하기',
                              style: TextStyle(color: Color(0xFF003852), fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 380,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final proj = projects[index];
                      final template = proj.template;

                      return ScaleButton(
                        onTap: () => onOpenProject(proj),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardBgColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.04),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
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
                                    width: 36,
                                    height: 36,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: (template?.themeColor ?? const Color(0xFF00B0FF)).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: template?.imageAsset != null
                                          ? Image.asset(template!.imageAsset!, fit: BoxFit.contain)
                                          : Icon(template?.icon ?? CupertinoIcons.app,
                                              size: 18, color: template?.themeColor ?? const Color(0xFF00B0FF)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          template?.title ?? proj.appTemplateId,
                                          style: TextStyle(
                                            color: textSubColor,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          proj.timeAgo,
                                          style: TextStyle(
                                            color: textSubColor.withValues(alpha: 0.7),
                                            fontSize: 10.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (proj.isStarred)
                                    const Icon(CupertinoIcons.star_fill, size: 15, color: Color(0xFFF59E0B)),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Text(
                                proj.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 15,
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
                                    fontSize: 12.5,
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
                                      color: isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    CupertinoIcons.arrow_right,
                                    size: 12,
                                    color: isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
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
