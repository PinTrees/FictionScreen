import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeHeroSection extends StatelessWidget {
  final bool isMobile;
  final bool isDarkMode;
  final VoidCallback onExploreShowcase;
  final Function(String) onQuickLaunch;

  const HomeHeroSection({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
    required this.onExploreShowcase,
    required this.onQuickLaunch,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.68)
        : const Color(0xFF475569);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 32 : 56,
      ),
      child: Column(
        children: [
          // 1. Eyebrow Badge (No outline)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Main Heading (High Impact, focused on virtual screens for fiction)
          Text(
            '작품 속 가상 화면 연출,\n클릭 한 번으로 1초 만에 완성.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
              fontSize: isMobile ? 32 : 52,
              fontWeight: FontWeight.w900,
              height: 1.16,
              letterSpacing: -1.4,
            ),
          ),
          const SizedBox(height: 18),

          // 3. Subtitle (Explicitly mentioning OS, apps, sites for easy fiction production)
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              '웹툰, 웹소설, 영상 연출을 위한 가상 OS(Windows·Mac), 필수 어플(카카오톡·당근마켓·토스), 인기 사이트(블라인드·디시·유튜브) 화면을 실제와 똑같이 연출하고 고화질로 캡처하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subtitleColor,
                fontSize: isMobile ? 14 : 16.5,
                height: 1.6,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(height: 36),

          // 4. Action Buttons (Brand Gradient Primary, Soft Filled Secondary - NO OUTLINES)
          Wrap(
            spacing: 14,
            runSpacing: 12,
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
                      blurRadius: 18,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => context.go('/console'),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.device_desktop, size: 18),
                      SizedBox(width: 8),
                      Text('가상 OS 콘솔 즉시 체험', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: onExploreShowcase,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.play_circle_fill, size: 17),
                    SizedBox(width: 8),
                    Text('실시간 화면 둘러보기', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 5. Quick-Launch Pills (Clean Soft Fill, NO OUTLINES, CCTV removed)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildQuickPill('💬 카카오톡', 'kakaotalk', const Color(0xFFFEE500), textColor: Colors.black),
              _buildQuickPill('🥕 당근마켓', 'daangn', const Color(0xFFFF6F0F)),
              _buildQuickPill('🏢 블라인드', 'blind', const Color(0xFFDA3238)),
              _buildQuickPill('📺 뉴스 속보', 'news', const Color(0xFFD32F2F)),
              _buildQuickPill('📊 엑셀 장부', 'excel', const Color(0xFF107C41)),
              _buildQuickPill('⚡ 디시인사이드', 'dcinside', const Color(0xFF3B4890)),
              _buildQuickPill('📈 코인 차트', 'upbit', const Color(0xFF0050FF)),
            ],
          ),
          const SizedBox(height: 38),

          // 6. Modern Trust Metric Strip (Clean shadow, NO OUTLINE)
          Container(
            constraints: const BoxConstraints(maxWidth: 860),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF111420).withValues(alpha: 0.7)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? Colors.black.withValues(alpha: 0.3) : const Color(0x12000000),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
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
    );
  }

  Widget _buildQuickPill(String label, String templateId, Color color, {Color? textColor}) {
    return InkWell(
      onTap: () => onQuickLaunch(templateId),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF161824)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isDarkMode ? 0.2 : 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor ?? (isDarkMode ? Colors.white : const Color(0xFF1E293B)),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
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
            fontSize: 16,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6366F1),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          sublabel,
          style: TextStyle(
            color: titleColor.withValues(alpha: 0.45),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider() {
    return Container(
      height: 32,
      width: 1,
      color: isDarkMode ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
    );
  }
}
