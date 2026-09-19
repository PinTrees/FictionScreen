import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/home_i18n.dart';

class HomeFooter extends StatelessWidget {
  final bool isMobile;
  final bool isDarkMode;
  final bool isEnglish;

  const HomeFooter({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Final CTA Full-Width Section (Edge-to-Edge, NO CARD BOX, Seamless Ambient Gradient)
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08),
                width: 1.0,
              ),
            ),
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      const Color(0xFF0C0E1B),
                      const Color(0xFF080913),
                      const Color(0xFF040508),
                    ]
                  : [
                      const Color(0xFFF1F5F9),
                      const Color(0xFFF8FAFC),
                      const Color(0xFFFFFFFF),
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 48,
            vertical: isMobile ? 70 : 110,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.sparkles, color: Color(0xFF6366F1), size: 30),
                  ),
                  const SizedBox(height: 24),
                Text(
                  HomeI18n.t('footerTitle', isEnglish: isEnglish),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  HomeI18n.t('footerSubtitle', isEnglish: isEnglish),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white.withValues(alpha: 0.65) : const Color(0xFF475569),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 16,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: [
                    // Primary Brand Gradient Button (NO OUTLINE)
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
                            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                            blurRadius: 16,
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
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => context.go('/console'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.device_desktop, size: 17),
                            const SizedBox(width: 8),
                            Text(
                              HomeI18n.t('footerPrimaryBtn', isEnglish: isEnglish),
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Secondary Button (NO OUTLINE)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                        backgroundColor: isDarkMode ? Colors.white.withValues(alpha: 0.08) : Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => context.go('/studio/kakaotalk'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset('assets/images/kakaotalk_icon.webp', width: 18, height: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isEnglish ? 'Open KakaoTalk Studio' : '카카오톡 스튜디오 열기',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

        // Clean Minimal Footer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF08090E) : const Color(0xFFF1F5F9),
            border: Border(
              top: BorderSide(
                color: isDarkMode ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.06),
                width: 1.0,
              ),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Center(
                        child: Icon(CupertinoIcons.square_stack_3d_up_fill, color: Colors.white, size: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'FictionScreen',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isEnglish
                      ? 'All-in-one virtual screen studio for novelists, webtoon artists & video creators'
                      : '소설가, 웹툰 작가, 시나리오 라이터, 영상 크리에이터를 위한 올인원 가상 화면 스튜디오',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white.withValues(alpha: 0.5) : const Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '© 2026 FictionScreen. All rights reserved.',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white.withValues(alpha: 0.25) : const Color(0xFF94A3B8),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
