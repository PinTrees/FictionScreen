import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickPillData {
  final String label;
  final String templateId;
  final String imageAsset;

  const QuickPillData({
    required this.label,
    required this.templateId,
    required this.imageAsset,
  });
}

class HomeHeroSection extends StatelessWidget {
  final bool isMobile;
  final bool isDarkMode;
  final VoidCallback onExploreFeatured;

  const HomeHeroSection({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
    required this.onExploreFeatured,
  });

  static const List<QuickPillData> _pills = [
    QuickPillData(label: '카카오톡', templateId: 'kakaotalk', imageAsset: 'assets/images/kakaotalk_icon.webp'),
    QuickPillData(label: '당근마켓', templateId: 'daangn', imageAsset: 'assets/images/daangn_icon.webp'),
    QuickPillData(label: '블라인드', templateId: 'blind', imageAsset: 'assets/images/blind_icon.webp'),
    QuickPillData(label: '뉴스 속보', templateId: 'news', imageAsset: 'assets/images/windows/news.png'),
    QuickPillData(label: 'Microsoft 엑셀', templateId: 'excel', imageAsset: 'assets/images/excel_icon.webp'),
    QuickPillData(label: '디시인사이드', templateId: 'dcinside', imageAsset: 'assets/images/dcinside_icon.webp'),
    QuickPillData(label: '업비트 코인', templateId: 'upbit', imageAsset: 'assets/images/upbit_icon.webp'),
    QuickPillData(label: '유튜브', templateId: 'youtube', imageAsset: 'assets/images/youtube_icon.webp'),
  ];

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.72)
        : const Color(0xFF475569);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1140),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 48,
          vertical: isMobile ? 64 : 100,
        ),
        child: Column(
          children: [
            // 1. Eyebrow Badge (No outline)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF1E1F30).withValues(alpha: 0.8)
                    : const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '웹툰 • 웹소설 • 영상 창작자를 위한 가상 화면 스튜디오',
                    style: TextStyle(
                      color: isDarkMode ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 2. Main Heading (High Impact, focused on virtual screens for fiction)
            Text(
              '작품 속 가상 화면 연출,\n클릭 한 번으로 1초 만에 완성.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor,
                fontSize: isMobile ? 34 : 56,
                fontWeight: FontWeight.w900,
                height: 1.15,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 22),

            // 3. Subtitle
            Container(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                '웹툰, 웹소설, 영상 연출을 위한 가상 OS(Windows·Mac), 필수 어플(카카오톡·당근마켓·토스), 인기 사이트(블라인드·디시·유튜브) 화면을 실제와 똑같이 연출하고 고화질로 캡처하세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: isMobile ? 15 : 17.5,
                  height: 1.65,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 44),

            // 4. Action Buttons (Brand Gradient Primary, Soft Filled Secondary - NO OUTLINES)
            Wrap(
              spacing: 16,
              runSpacing: 14,
              alignment: WrapAlignment.center,
              children: [
                // Primary Brand Gradient Button
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => context.go('/console'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.device_desktop, size: 19),
                        SizedBox(width: 8),
                        Text('가상 OS 콘솔 즉시 체험', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        SizedBox(width: 6),
                        Icon(CupertinoIcons.arrow_right, size: 15),
                      ],
                    ),
                  ),
                ),

                // Secondary Clean Filled Button (NO OUTLINE)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? Colors.white.withValues(alpha: 0.08)
                        : const Color(0xFFE2E8F0),
                    foregroundColor: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: onExploreFeatured,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.play_circle_fill, size: 18),
                      SizedBox(width: 8),
                      Text('대표 화면 둘러보기', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 5. Quick-Launch Pills with REAL APP PNG ICONS & CRISP WHITE TEXT IN DARK MODE
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _pills.map((pill) => _buildQuickPill(context, pill)).toList(),
            ),
            const SizedBox(height: 52),

            // 6. Trust Metric Strip (Spacious padding, clean shadow, NO OUTLINE)
            Container(
              constraints: const BoxConstraints(maxWidth: 880),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 18 : 36,
                vertical: 22,
              ),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF111420).withValues(alpha: 0.7)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black.withValues(alpha: 0.35) : const Color(0x12000000),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricItem('100%', '픽셀 정밀 재현', '실제 폰트·곡률 일치', titleColor),
                  _buildMetricDivider(),
                  _buildMetricItem('PNG 캡처', '무손실 고화질', '워터마크 완전 무료', titleColor),
                  if (!isMobile) ...[
                    _buildMetricDivider(),
                    _buildMetricItem('가상 OS', 'Windows & Mac', '창 드래그·폴더 수납', titleColor),
                    _buildMetricDivider(),
                    _buildMetricItem('24+ 종류', '어플 & 사이트', '지속적인 템플릿 추가', titleColor),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPill(BuildContext context, QuickPillData pill) {
    // In Dark mode, pill text is ALWAYS crisp pure white! In Light mode, slate-900.
    final pillTextColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final pillBg = isDarkMode ? const Color(0xFF161928) : Colors.white;

    return InkWell(
      onTap: () => context.go('/studio/${pill.templateId}'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: pillBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black.withValues(alpha: 0.3) : const Color(0x10000000),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Real App PNG/WebP icon!
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                pill.imageAsset,
                width: 19,
                height: 19,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(width: 19, height: 19),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              pill.label,
              style: TextStyle(
                color: pillTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String value, String label, String sublabel, Color titleColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w800,
            fontSize: 17,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6366F1),
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          sublabel,
          style: TextStyle(
            color: titleColor.withValues(alpha: 0.45),
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider() {
    return Container(
      height: 36,
      width: 1,
      color: isDarkMode ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
    );
  }
}
