import 'package:flutter/material.dart';
import '../../common/netflix_icons.dart';
import '../../data/netflix_model.dart';

/// 넷플릭스 모바일 오늘 대한민국 TOP 10 시리즈
class MobileTop10Section extends StatelessWidget {
  final List<NetflixMediaItem> items;
  final ValueChanged<NetflixMediaItem> onSelectMedia;

  const MobileTop10Section({
    super.key,
    required this.items,
    required this.onSelectMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '오늘 대한민국 TOP 10 시리즈',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final media = items[index];
              final rank = index + 1;
              return GestureDetector(
                onTap: () => onSelectMedia(media),
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 10),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: NetflixTop10Number(rank: rank, height: 130),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        top: 10,
                        child: Container(
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              media.posterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(color: const Color(0xFF333333)),
                            ),
                          ),
                        ),
                      ),
                    ],
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
