import 'package:flutter/material.dart';
import '../../common/netflix_icons.dart';
import '../../data/netflix_model.dart';

/// 넷플릭스 모바일 가로 카드 캐러셀
class MobileCarousel extends StatelessWidget {
  final String title;
  final List<NetflixMediaItem> items;
  final bool isOriginal;
  final ValueChanged<NetflixMediaItem> onSelectMedia;

  const MobileCarousel({
    super.key,
    required this.title,
    required this.items,
    this.isOriginal = false,
    required this.onSelectMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final media = items[index];
              return GestureDetector(
                onTap: () => onSelectMedia(media),
                child: Container(
                  width: isOriginal ? 95 : 180,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            isOriginal ? media.posterUrl : media.backdropUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(color: const Color(0xFF333333)),
                          ),
                        ),
                        if (media.isOriginal)
                          const Positioned(
                            top: 4,
                            left: 4,
                            child: NetflixWordmark(fontSize: 10, isNOnly: true),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
