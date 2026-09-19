import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../apps/screen_template.dart';
import '../models/project_model.dart';

class CreateProjectDialog extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<ProjectModel> onProjectCreated;

  const CreateProjectDialog({
    super.key,
    required this.isDarkMode,
    required this.onProjectCreated,
  });

  static Future<ProjectModel?> show(BuildContext context, {required bool isDarkMode}) {
    return showDialog<ProjectModel>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => CreateProjectDialog(
        isDarkMode: isDarkMode,
        onProjectCreated: (proj) => Navigator.of(ctx).pop(proj),
      ),
    );
  }

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final TextEditingController _titleCtrl = TextEditingController(text: '새 시나리오 프로젝트');
  final TextEditingController _descCtrl = TextEditingController();
  String _selectedTemplateId = 'kakaotalk';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleCtrl.text.trim().isEmpty ? '새 시나리오 프로젝트' : _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();

    final newProj = ProjectModel(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      appTemplateId: _selectedTemplateId,
      description: desc,
      updatedAt: DateTime.now(),
      isStarred: false,
    );

    widget.onProjectCreated(newProj);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final dialogBg = isDark ? const Color(0xFF141822) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final fieldBg = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: dialogBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
              blurRadius: 32,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(CupertinoIcons.plus_circle_fill, size: 20, color: Color(0xFF6366F1)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '새 시나리오 프로젝트 생성',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        '시작할 어플 템플릿과 프로젝트 이름을 설정하세요.',
                        style: TextStyle(color: textSubColor, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.xmark, size: 16, color: textSubColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Project Title Input
            Text(
              '프로젝트 이름',
              style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _titleCtrl,
                style: TextStyle(color: textColor, fontSize: 13.5),
                decoration: InputDecoration(
                  hintText: '예: 웹소설 15화 반전 단톡방',
                  hintStyle: TextStyle(color: textSubColor.withValues(alpha: 0.5), fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Project Description Input
            Text(
              '간단 설명 (선택)',
              style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _descCtrl,
                maxLines: 2,
                style: TextStyle(color: textColor, fontSize: 13),
                decoration: InputDecoration(
                  hintText: '어떤 장면인지 메모를 남겨보세요.',
                  hintStyle: TextStyle(color: textSubColor.withValues(alpha: 0.5), fontSize: 12.5),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // App Template Selection
            Text(
              '기본 어플 템플릿 선택',
              style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 86,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(scrollbars: false),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ScreenTemplate.allTemplates.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final t = ScreenTemplate.allTemplates[index];
                    final isSelected = t.id == _selectedTemplateId;

                    return InkWell(
                      onTap: () => setState(() => _selectedTemplateId = t.id),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 78,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6366F1).withValues(alpha: 0.16)
                              : (isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: t.themeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: t.imageAsset != null
                                    ? Image.asset(t.imageAsset!, fit: BoxFit.contain)
                                    : Icon(t.icon, size: 16, color: t.themeColor),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              t.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF6366F1)
                                    : (isDark ? Colors.white70 : const Color(0xFF334155)),
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: textSubColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('취소', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('프로젝트 생성 & 에디터 열기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
