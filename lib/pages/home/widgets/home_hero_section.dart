import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeHeroSection extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onExploreTemplates;
  final Function(String) onQuickLaunch;

  const HomeHeroSection({
    super.key,
    required this.isMobile,
    required this.onExploreTemplates,
    required this.onQuickLaunch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 32 : 56,
      ),
      child: Column(
        children: [
          // 1. Eyebrow Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1F30).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.35)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
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
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF10B981),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '웹툰 • 웹소설 • 영상 창작자를 위한 올인원 Mock UI 스튜디오',
                  style: TextStyle(
                    color: Color(0xFFC7D2FE),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Main High-Impact Heading
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Colors.white, Color(0xFFC7D2FE)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: Text(
              '상상 속의 그 화면,\n클릭 한 번으로 완벽 재현.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 34 : 54,
                fontWeight: FontWeight.w900,
                height: 1.15,
                letterSpacing: -1.5,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 3. Subtitle
          Container(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              '카톡 단톡방 폭파, 디시 개념글, 엑셀 비자금 장부, TV 긴급 속보부터 CCTV까지.\n창작물에 꼭 필요한 가짜 화면을 100% 픽셀 정밀도로 제작하고 고화질로 캡처하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.68),
                fontSize: isMobile ? 14 : 17,
                height: 1.6,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(height: 36),

          // 4. Action Buttons
          Wrap(
            spacing: 14,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.45),
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
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.04),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: onExploreTemplates,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.square_grid_2x2, size: 17),
                    SizedBox(width: 8),
                    Text('템플릿 둘러보기', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 5. Quick-Launch Pills (Hot Tags)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildQuickPill('🔥 뉴스 속보', 'news', const Color(0xFFD32F2F)),
              _buildQuickPill('💬 카톡 단톡방', 'kakaotalk', const Color(0xFFFEE500), textColor: Colors.black),
              _buildQuickPill('📊 엑셀 비자금', 'excel', const Color(0xFF107C41)),
              _buildQuickPill('⚡ 디시 개념글', 'dcinside', const Color(0xFF3B4890)),
              _buildQuickPill('📹 CCTV 감시', 'cctv', const Color(0xFFE53935)),
              _buildQuickPill('🎮 스팀 도전과제', 'steam', const Color(0xFF1B2838)),
            ],
          ),
          const SizedBox(height: 40),

          // 6. Modern Trust Metric Cards
          Container(
            constraints: const BoxConstraints(maxWidth: 860),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF111420).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem('100%', '픽셀 정밀 재현', '폰트·곡률·아이콘'),
                _buildMetricDivider(),
                _buildMetricItem('PNG / GIF', '무손실 고화질', '워터마크 완전 무료'),
                if (!isMobile) ...[
                  _buildMetricDivider(),
                  _buildMetricItem('24+ 앱', '장르별 킬러 템플릿', '지속 업데이트'),
                  _buildMetricDivider(),
                  _buildMetricItem('가상 OS', 'MDI 멀티 윈도우', '폴더·바탕화면 지원'),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF161824),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor ?? Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(String value, String label, String sublabel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFC7D2FE),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          sublabel,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
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
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}
