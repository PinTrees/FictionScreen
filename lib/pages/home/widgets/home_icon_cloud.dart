import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_platform_icons.dart';
import '../../../constants/home_i18n.dart';

class HomeIconCloud extends StatelessWidget {
  final bool isMobile;
  final bool isDarkMode;
  final bool isEnglish;

  const HomeIconCloud({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF475569);

    final osList = AppPlatformIcons.osList;
    final appList = AppPlatformIcons.appList;
    final siteList = AppPlatformIcons.siteList;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1140),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 48,
          vertical: isMobile ? 64 : 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E1F30) : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      HomeI18n.t('ecosystemBadge', isEnglish: isEnglish),
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
                    HomeI18n.t('ecosystemTitle', isEnglish: isEnglish),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: isMobile ? 28 : 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    HomeI18n.t('ecosystemSubtitle', isEnglish: isEnglish),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: isMobile ? 14.5 : 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),

            // Category 1: 가상 OS
            _buildCategoryHeader(
              isEnglish ? '🖥️ Virtual Desktop OS' : '🖥️ 가상 데스크톱 OS',
              '${osList.length}${isEnglish ? ' types' : '종'}',
              titleColor,
            ),
            const SizedBox(height: 18),
            _buildIconGrid(context, osList),

            const SizedBox(height: 52),

            // Category 2: 모바일 어플리케이션
            _buildCategoryHeader(
              isEnglish ? '📱 Mobile Applications' : '📱 모바일 어플리케이션',
              '${appList.length}${isEnglish ? ' types' : '종'}',
              titleColor,
            ),
            const SizedBox(height: 18),
            _buildIconGrid(context, appList),

            const SizedBox(height: 52),

            // Category 3: 웹사이트 & 전문 툴 (No news, No CCTV)
            _buildCategoryHeader(
              isEnglish ? '🌐 Web & Business Tools' : '🌐 웹사이트 & 비즈니스 툴',
              '${siteList.length}${isEnglish ? ' types' : '종'}',
              titleColor,
            ),
            const SizedBox(height: 18),
            _buildIconGrid(context, siteList),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title, String countBadge, Color titleColor) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: isDarkMode ? 0.2 : 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            countBadge,
            style: const TextStyle(
              color: Color(0xFF6366F1),
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconGrid(BuildContext context, List<AppPlatformInfo> items) {
    final tileBg = isDarkMode ? const Color(0xFF111422) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: items.map((item) {
        return InkWell(
          onTap: () {
            if (item.isConsole) {
              context.go('/console');
            } else {
              context.go('/studio/${item.id}');
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: tileBg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? Colors.black.withValues(alpha: 0.3) : const Color(0x0C000000),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Real Official App/OS Logo
                Container(
                  width: 32,
                  height: 32,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        item.assetPath,
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(CupertinoIcons.app, size: 22),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  item.name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 11,
                  color: isDarkMode ? Colors.white38 : Colors.black26,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
