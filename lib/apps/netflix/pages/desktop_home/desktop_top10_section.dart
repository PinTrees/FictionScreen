import 'package:flutter/material.dart';
import '../../common/netflix_icons.dart';
import '../../data/netflix_model.dart';

/// 넷플릭스 오늘 대한민국의 TOP 10 시리즈 (시그니처 거대 넘버링)
class DesktopTop10Section extends StatefulWidget {
  final List<NetflixMediaItem> items;
  final ValueChanged<NetflixMediaItem> onSelectMedia;

  const DesktopTop10Section({
    super.key,
    required this.items,
    required this.onSelectMedia,
  });

  @override
  State<DesktopTop10Section> createState() => _DesktopTop10SectionState();
}

class _DesktopTop10SectionState extends State<DesktopTop10Section> {
  String? _hoveredId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 36, vertical: 10),
          child: Text(
            '오늘 대한민국의 TOP 10 시리즈',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 36),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final media = widget.items[index];
              final rank = index + 1;
              final isHovered = _hoveredId == media.id;

              return MouseRegion(
                onEnter: (_) => setState(() => _hoveredId = media.id),
                onExit: (_) => setState(() => _hoveredId = null),
                child: GestureDetector(
                  onTap: () => widget.onSelectMedia(media),
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 14),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        // 거대 3D 랭킹 숫자
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: NetflixTop10Number(rank: rank, height: 160),
                        ),
                        // 포스터 카드 (우측 살짝 겹침)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          top: 8,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 120,
                            transform: isHovered
                                ? Matrix4.diagonal3Values(1.04, 1.04, 1.0)
                                : Matrix4.identity(),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.network(
                                      media.posterUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(color: const Color(0xFF333333)),
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
                      ],
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
