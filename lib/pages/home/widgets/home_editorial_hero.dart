import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeEditorialHero extends StatelessWidget {
  final bool isMobile;
  final bool isDarkMode;
  final VoidCallback onExploreFeatured;
  final VoidCallback onToggleTheme;
  final double scrollProgress; // 0.0 to 1.0

  const HomeEditorialHero({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
    required this.onExploreFeatured,
    required this.onToggleTheme,
    this.scrollProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = isMobile ? 720.0 : screenHeight.clamp(740.0, 960.0);

    final bgCanvas = isDarkMode ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final textPrimary = isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A);
    final textSecondary = isDarkMode
        ? const Color(0xFFFFFFFF).withValues(alpha: 0.65)
        : const Color(0xFF000000).withValues(alpha: 0.60);
    final subLabelColor = isDarkMode
        ? const Color(0xFFFFFFFF).withValues(alpha: 0.40)
        : const Color(0xFF000000).withValues(alpha: 0.45);

    final bloomAsset = isDarkMode
        ? 'assets/images/win11_bloom_dark.jpg'
        : 'assets/images/win11_bloom_light.jpg';

    return Container(
      width: double.infinity,
      height: heroHeight,
      color: bgCanvas,
      child: Stack(
        children: [
          // 1. Right-side Windows 11 Official 4K Bloom Artwork Layer
          Positioned(
            top: 0,
            bottom: 0,
            right: isMobile ? -120 : 0,
            width: isMobile
                ? MediaQuery.of(context).size.width * 1.15
                : MediaQuery.of(context).size.width * 0.60,
            child: IgnorePointer(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    bloomAsset,
                    fit: BoxFit.cover,
                    alignment: isMobile ? const Alignment(0.4, 0.0) : const Alignment(0.15, 0.0),
                  ),
                  // Left-to-Right seamless fade gradient into canvas background
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            bgCanvas,
                            bgCanvas.withValues(alpha: 0.85),
                            bgCanvas.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.25, 0.72],
                        ),
                      ),
                    ),
                  ),
                  // Top fade for seamless appbar blend
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 90,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            bgCanvas.withValues(alpha: 0.9),
                            bgCanvas.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bottom fade for seamless transition to next section
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            bgCanvas,
                            bgCanvas.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Main Editorial Content (Left-aligned, massive typography inspired by Sofi)
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                left: isMobile ? 24 : 64,
                right: isMobile ? 24 : 64,
                top: 72, // Room for pinned top app bar
                bottom: 56,
              ),
              child: Align(
                alignment: isMobile ? Alignment.centerLeft : const Alignment(-1.0, -0.1),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sub-tag or editorial badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Windows 11 Studio & Real App Fiction',
                              style: TextStyle(
                                color: subLabelColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Giant Bold Lowercase Heading (Sofi reference style)
                      Text(
                        'make it\nreal.',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: isMobile ? 64 : 108,
                          fontWeight: FontWeight.w900,
                          height: 0.92,
                          letterSpacing: -4.0,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subheading
                      Text(
                        'every screen you imagine.',
                        style: TextStyle(
                          color: const Color(0xFF6366F1),
                          fontSize: isMobile ? 24 : 38,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          letterSpacing: -1.2,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Refined Editorial Description
                      Text(
                        '웹툰, 웹소설, 시나리오 작가를 위한 가장 정교한 가상 화면 스튜디오.\nWindows 11 공식 OS부터 카카오톡, 당근, 블라인드까지\n스토리 속 모든 인터페이스를 1초 만에 실시간으로 생성하세요.',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: isMobile ? 14 : 16.5,
                          height: 1.65,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Sofi Style Pill Button with Brand Gradient (no outline)
                      InkWell(
                        onTap: () => context.go('/console'),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.42),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '지금 무료로 시작하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                CupertinoIcons.arrow_right,
                                size: 15,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Bottom-Left & Bottom-Right Editorial Footer Bar (Sofi Reference Style)
          Positioned(
            bottom: 24,
            left: isMobile ? 24 : 44,
            right: isMobile ? 24 : 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Bottom-Left Values
                Text(
                  isMobile
                      ? 'virtual os • mobile apps'
                      : 'virtual os • mobile apps • web platforms',
                  style: TextStyle(
                    color: subLabelColor,
                    fontSize: isMobile ? 11 : 12.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),

                // Bottom-Right: "scroll down — 0%" Indicator
                InkWell(
                  onTap: onExploreFeatured,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'scroll down',
                        style: TextStyle(
                          color: subLabelColor,
                          fontSize: isMobile ? 11 : 12.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Fine progress line
                      Container(
                        width: isMobile ? 40 : 70,
                        height: 1.5,
                        color: subLabelColor.withValues(alpha: 0.3),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: (isMobile ? 40 : 70) * scrollProgress.clamp(0.05, 1.0),
                            height: 1.5,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(scrollProgress * 100).toInt()}%',
                        style: TextStyle(
                          color: subLabelColor,
                          fontSize: isMobile ? 11 : 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
