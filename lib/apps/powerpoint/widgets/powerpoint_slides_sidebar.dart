import 'package:flutter/material.dart';
import '../data/powerpoint_model.dart';

class PowerPointSlidesSidebar extends StatelessWidget {
  final List<PowerPointSlide> slides;
  final int activeSlideIndex;
  final ValueChanged<int> onSelectSlide;

  const PowerPointSlidesSidebar({
    super.key,
    required this.slides,
    required this.activeSlideIndex,
    required this.onSelectSlide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      color: const Color(0xFFF3F2F1),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        itemCount: slides.length,
        itemBuilder: (context, index) {
          final slide = slides[index];
          final isActive = activeSlideIndex == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Slide Number
                SizedBox(
                  width: 18,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive ? const Color(0xFFC43E1C) : const Color(0xFF605E5C),
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 4),

                // Slide Mini Thumbnail
                Expanded(
                  child: InkWell(
                    onTap: () => onSelectSlide(index),
                    child: Container(
                      height: 85,
                      decoration: BoxDecoration(
                        color: slide.slideBgColor ?? Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isActive ? const Color(0xFFC43E1C) : const Color(0xFFD2D0CE),
                          width: isActive ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isActive ? 0.15 : 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (slide.confidentialBadge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                              margin: const EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                slide.confidentialBadge!,
                                style: const TextStyle(fontSize: 5, color: Colors.red, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Text(
                            slide.title,
                            style: TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                              color: slide.slideBgColor != null ? Colors.white : Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          // Tiny bullet indicator lines
                          Row(
                            children: [
                              Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFC43E1C), shape: BoxShape.circle)),
                              const SizedBox(width: 3),
                              Expanded(child: Container(height: 2, color: Colors.grey.withValues(alpha: 0.3))),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFC43E1C), shape: BoxShape.circle)),
                              const SizedBox(width: 3),
                              Expanded(child: Container(height: 2, color: Colors.grey.withValues(alpha: 0.3))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
