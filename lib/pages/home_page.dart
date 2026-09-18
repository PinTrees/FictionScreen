import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/screen_template.dart';
import '../style/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TemplateCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final templates = _selectedCategory == null
        ? ScreenTemplate.allTemplates
        : ScreenTemplate.allTemplates.where((t) => t.category == _selectedCategory).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 앱바 및 헤더
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.background.withValues(alpha: 0.9),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.movie_filter_rounded, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Text(
                  'FictionScreen',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('STUDIO', style: TextStyle(color: AppColors.primaryLight, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // 히어로 배너 섹션
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: AppColors.kakaoYellow, size: 14),
                          SizedBox(width: 6),
                          Text('크리에이터 & 숏폼 창작자를 위한 가짜 화면 스튜디오', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '필요한 모든 가짜 화면,\n1초 만에 커스텀하고 캡처하세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '카카오톡 대화, 유튜브 댓글, 인스타그램 피드, 배달 앱, Windows 블루스크린까지\n실제와 100% 동일한 비주얼과 애니메이션을 지원합니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 카테고리 필터 탭
          SliverToBoxAdapter(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildCategoryChip(null, '전체 템플릿'),
                    ...TemplateCategory.values.map((cat) => _buildCategoryChip(cat, cat.label)),
                  ],
                ),
              ),
            ),
          ),

          // 템플릿 카드 그리드
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 60),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1040),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 700 ? 2 : 1;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          mainAxisExtent: 160,
                        ),
                        itemCount: templates.length,
                        itemBuilder: (context, index) {
                          final template = templates[index];
                          return _buildTemplateCard(template);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(TemplateCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
        side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (_) => setState(() => _selectedCategory = category),
      ),
    );
  }

  Widget _buildTemplateCard(ScreenTemplate template) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/studio/${template.id}'),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: template.themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: template.themeColor.withValues(alpha: 0.3)),
                ),
                child: Icon(template.icon, color: template.themeColor, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            template.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (template.badge.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              template.badge,
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        template.description,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.35),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '제작 스튜디오 열기',
                          style: TextStyle(
                            color: template.themeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 14, color: template.themeColor),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
