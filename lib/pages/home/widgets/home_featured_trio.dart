import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../apps/blind/blind_screen.dart';
import '../../../apps/blind/data/blind_model.dart';
import '../../../apps/daangn/daangn_screen.dart';
import '../../../apps/daangn/data/daangn_model.dart';
import '../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../apps/kakaotalk/kakaotalk_screen.dart';

import '../../../constants/home_i18n.dart';

class HomeFeaturedTrio extends StatelessWidget {
  final bool isMobile;
  final bool isDarkMode;
  final bool isEnglish;

  const HomeFeaturedTrio({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.68)
        : const Color(0xFF475569);

    // Standard smartphone screen aspect ratio: ~370px width by ~700px height (~9:17)
    final previewWidth = isMobile ? double.infinity : 370.0;
    final previewHeight = isMobile ? 640.0 : 700.0;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1140),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 48,
          vertical: isMobile ? 64 : 110,
        ),
        child: Column(
          children: [
            // Section Title
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF1E1F30)
                          : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      HomeI18n.t('trioBadge', isEnglish: isEnglish),
                      style: TextStyle(
                        color: isDarkMode ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    HomeI18n.t('trioTitle', isEnglish: isEnglish),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: isMobile ? 28 : 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    HomeI18n.t('trioSubtitle', isEnglish: isEnglish),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: isMobile ? 14.5 : 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),

            // 1. 카카오톡 (KakaoTalk) Section (Pure UI, standard smartphone ratio)
            _buildFeatureSection(
              context: context,
              badge: HomeI18n.t('kakaoBadge', isEnglish: isEnglish),
              iconAsset: 'assets/images/kakaotalk_icon.webp',
              title: HomeI18n.t('kakaoTitle', isEnglish: isEnglish),
              description: HomeI18n.t('kakaoDesc', isEnglish: isEnglish),
              bullets: [
                HomeI18n.t('kakaoBullet1', isEnglish: isEnglish),
                HomeI18n.t('kakaoBullet2', isEnglish: isEnglish),
                HomeI18n.t('kakaoBullet3', isEnglish: isEnglish),
              ],
              uiWidget: KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset()),
              previewWidth: previewWidth,
              previewHeight: previewHeight,
              templateId: 'kakaotalk',
              actionLabel: HomeI18n.t('kakaoAction', isEnglish: isEnglish),
              isReversed: false,
            ),

            const SizedBox(height: 120),

            // 2. 당근마켓 (Daangn) Section (Pure UI, standard smartphone ratio)
            _buildFeatureSection(
              context: context,
              badge: HomeI18n.t('daangnBadge', isEnglish: isEnglish),
              iconAsset: 'assets/images/daangn_icon.webp',
              title: HomeI18n.t('daangnTitle', isEnglish: isEnglish),
              description: HomeI18n.t('daangnDesc', isEnglish: isEnglish),
              bullets: [
                HomeI18n.t('daangnBullet1', isEnglish: isEnglish),
                HomeI18n.t('daangnBullet2', isEnglish: isEnglish),
                HomeI18n.t('daangnBullet3', isEnglish: isEnglish),
              ],
              uiWidget: DaangnScreen(config: DaangnConfig.defaultPreset()),
              previewWidth: previewWidth,
              previewHeight: previewHeight,
              templateId: 'daangn',
              actionLabel: HomeI18n.t('daangnAction', isEnglish: isEnglish),
              isReversed: !isMobile,
            ),

            const SizedBox(height: 120),

            // 3. 블라인드 (Blind) Section (Pure UI, standard smartphone ratio)
            _buildFeatureSection(
              context: context,
              badge: HomeI18n.t('blindBadge', isEnglish: isEnglish),
              iconAsset: 'assets/images/blind_icon.webp',
              title: HomeI18n.t('blindTitle', isEnglish: isEnglish),
              description: HomeI18n.t('blindDesc', isEnglish: isEnglish),
              bullets: [
                HomeI18n.t('blindBullet1', isEnglish: isEnglish),
                HomeI18n.t('blindBullet2', isEnglish: isEnglish),
                HomeI18n.t('blindBullet3', isEnglish: isEnglish),
              ],
              uiWidget: BlindScreen(config: BlindConfig.defaultPreset()),
              previewWidth: previewWidth,
              previewHeight: previewHeight,
              templateId: 'blind',
              actionLabel: HomeI18n.t('blindAction', isEnglish: isEnglish),
              isReversed: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection({
    required BuildContext context,
    required String badge,
    required String iconAsset,
    required String title,
    required String description,
    required List<String> bullets,
    required Widget uiWidget,
    required double previewWidth,
    required double previewHeight,
    required String templateId,
    required String actionLabel,
    required bool isReversed,
  }) {
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final descColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.72)
        : const Color(0xFF475569);

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Badge with Real App Icon (No outline)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E2133) : const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(iconAsset, width: 20, height: 20, fit: BoxFit.cover),
              ),
              const SizedBox(width: 8),
              Text(
                badge,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF334155),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Title
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.w900,
            height: 1.25,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 16),

        // Description
        Text(
          description,
          style: TextStyle(
            color: descColor,
            fontSize: isMobile ? 14 : 15.5,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 24),

        // Bullets
        ...bullets.map(
          (bullet) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Color(0xFF6366F1), size: 17),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    bullet,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF334155),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Brand Gradient Action Button (NO OUTLINE)
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => context.go('/studio/$templateId'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(width: 6),
                const Icon(CupertinoIcons.arrow_right, size: 14),
              ],
            ),
          ),
        ),
      ],
    );

    // PURE UI ONLY Container - Accurate Smartphone Aspect Ratio (~9:17 to 9:19)
    final pureUiBox = Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        width: previewWidth,
        height: previewHeight,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF0F111A) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black.withValues(alpha: 0.5) : const Color(0x1C000000),
              blurRadius: 36,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: uiWidget,
        ),
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          textColumn,
          const SizedBox(height: 32),
          pureUiBox,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: isReversed
          ? [
              Expanded(flex: 5, child: pureUiBox),
              const SizedBox(width: 60),
              Expanded(flex: 5, child: textColumn),
            ]
          : [
              Expanded(flex: 5, child: textColumn),
              const SizedBox(width: 60),
              Expanded(flex: 5, child: pureUiBox),
            ],
    );
  }
}
