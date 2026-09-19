import 'package:flutter/material.dart';
import '../data/powerpoint_model.dart';

class PowerPointSlideCanvas extends StatelessWidget {
  final PowerPointSlide slide;
  final int slideIndex;
  final int totalSlides;
  final VoidCallback onStartSlideShow;

  const PowerPointSlideCanvas({
    super.key,
    required this.slide,
    required this.slideIndex,
    required this.totalSlides,
    required this.onStartSlideShow,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkSlide = slide.slideBgColor != null;
    final primaryTextColor = isDarkSlide ? Colors.white : const Color(0xFF201F1E);
    final secondaryTextColor = isDarkSlide ? Colors.white70 : const Color(0xFF605E5C);

    return Container(
      color: const Color(0xFFE1DFDD), // PowerPoint grey canvas background
      child: Column(
        children: [
          // 1. Center Presentation Slide Canvas (16:9)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: slide.slideBgColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Slide Watermark if confidential
                        if (slide.confidentialBadge != null)
                          Positioned.fill(
                            child: Center(
                              child: Transform.rotate(
                                angle: -0.28,
                                child: Text(
                                  'TOP SECRET',
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w900,
                                    color: (isDarkSlide ? Colors.white : Colors.red).withValues(alpha: 0.05),
                                    letterSpacing: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Main Slide Content
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Confidential / Header Badge
                              if (slide.confidentialBadge != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC43E1C).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFFC43E1C).withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    slide.confidentialBadge!,
                                    style: const TextStyle(
                                      color: Color(0xFFC43E1C),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),

                              // Slide Title
                              Text(
                                slide.title,
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              if (slide.subtitle.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  slide.subtitle,
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 12),
                              // Accent Line
                              Container(
                                width: 50,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC43E1C),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Bullets List
                              if (slide.bullets.isNotEmpty)
                                Expanded(
                                  child: ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: slide.bullets.length,
                                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                                    itemBuilder: (context, bIdx) {
                                      final bullet = slide.bullets[bIdx];
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(top: 6),
                                            width: 7,
                                            height: 7,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFC43E1C),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              bullet,
                                              style: TextStyle(
                                                color: primaryTextColor,
                                                fontSize: 14,
                                                height: 1.35,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                              // KPI Metric Cards
                              if (slide.kpis.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: slide.kpis.map((kpi) {
                                    return Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 12),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isDarkSlide
                                              ? const Color(0xFF2A2A2A)
                                              : const Color(0xFFF3F2F1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: (kpi.color ?? const Color(0xFFC43E1C)).withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              kpi.label,
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              kpi.value,
                                              style: TextStyle(
                                                color: kpi.color ?? const Color(0xFFC43E1C),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (kpi.subtext != null) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                kpi.subtext!,
                                                style: TextStyle(
                                                  color: secondaryTextColor,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Bottom PowerPoint Status Bar
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: const Color(0xFFF3F2F1),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFD2D0CE))),
            ),
            child: Row(
              children: [
                Text(
                  '슬라이드 ${slideIndex + 1} / $totalSlides',
                  style: const TextStyle(color: Color(0xFF605E5C), fontSize: 11),
                ),
                const SizedBox(width: 14),
                const Text('한국어', style: TextStyle(color: Color(0xFF605E5C), fontSize: 11)),
                const SizedBox(width: 14),
                const Text('메모', style: TextStyle(color: Color(0xFF605E5C), fontSize: 11)),
                const Spacer(),

                // Slide Show Quick Button
                InkWell(
                  onTap: onStartSlideShow,
                  child: Row(
                    children: const [
                      Icon(Icons.slideshow, size: 14, color: Color(0xFFC43E1C)),
                      SizedBox(width: 4),
                      Text('슬라이드 쇼', style: TextStyle(color: Color(0xFFC43E1C), fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Zoom Slider
                const Icon(Icons.remove, size: 12, color: Color(0xFF605E5C)),
                const SizedBox(width: 4),
                Container(
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC8C6C4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFC43E1C), shape: BoxShape.circle)),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.add, size: 12, color: Color(0xFF605E5C)),
                const SizedBox(width: 6),
                const Text('68%', style: TextStyle(color: Color(0xFF605E5C), fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
