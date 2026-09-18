import 'package:flutter/material.dart';
import '../../common/netflix_icons.dart';
import '../../data/netflix_model.dart';

/// 넷플릭스 데스크탑 가로 카드 캐러셀
class DesktopCarousel extends StatefulWidget {
  final String title;
  final List<NetflixMediaItem> items;
  final bool isOriginal;
  final ValueChanged<NetflixMediaItem> onSelectMedia;

  const DesktopCarousel({
    super.key,
    required this.title,
    required this.items,
    this.isOriginal = false,
    required this.onSelectMedia,
  });

  @override
  State<DesktopCarousel> createState() => _DesktopCarouselState();
}

class _DesktopCarouselState extends State<DesktopCarousel> {
  String? _hoveredId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 36),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final media = widget.items[index];
              final isHovered = _hoveredId == media.id;

              return MouseRegion(
                onEnter: (_) => setState(() => _hoveredId = media.id),
                onExit: (_) => setState(() => _hoveredId = null),
                child: GestureDetector(
                  onTap: () => widget.onSelectMedia(media),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: widget.isOriginal ? 110 : 210,
                    margin: const EdgeInsets.only(right: 10),
                    transform: isHovered
                        ? Matrix4.diagonal3Values(1.05, 1.05, 1.0)
                        : Matrix4.identity(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              widget.isOriginal ? media.posterUrl : media.backdropUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(color: const Color(0xFF333333)),
                            ),
                          ),
                          // 하단 텍스트 오버레이
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                                ),
                              ),
                              child: Text(
                                media.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          if (media.isOriginal)
                            const Positioned(
                              top: 6,
                              left: 6,
                              child: NetflixWordmark(fontSize: 12, isNOnly: true),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
