import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/netflix_icons.dart';
import '../../data/netflix_model.dart';

/// 넷플릭스 데스크탑 대형 히어로 백드롭 배너
class DesktopHeroBanner extends StatefulWidget {
  final NetflixMediaItem hero;
  final ValueChanged<NetflixMediaItem> onSelectMedia;

  const DesktopHeroBanner({
    super.key,
    required this.hero,
    required this.onSelectMedia,
  });

  @override
  State<DesktopHeroBanner> createState() => _DesktopHeroBannerState();
}

class _DesktopHeroBannerState extends State<DesktopHeroBanner> {
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    final hero = widget.hero;
    return Stack(
      children: [
        // 백드롭 이미지
        SizedBox(
          height: 480,
          width: double.infinity,
          child: Image.network(
            hero.backdropUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: const Color(0xFF222222)),
          ),
        ),
        // 좌측 어두운 섀도우 & 하단 페이드 그라데이션
        Container(
          height: 480,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF141414).withValues(alpha: 0.95),
                const Color(0xFF141414).withValues(alpha: 0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Container(
          height: 480,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                const Color(0xFF141414).withValues(alpha: 0.7),
                const Color(0xFF141414),
              ],
            ),
          ),
        ),

        // 히어로 메인 타이틀 및 액션
        Positioned(
          left: 36,
          bottom: 60,
          width: 520,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hero.isOriginal) ...[
                Row(
                  children: [
                    const NetflixWordmark(fontSize: 16, isNOnly: true),
                    const SizedBox(width: 6),
                    Text(
                      '시 리 즈',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              Text(
                hero.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                  shadows: [
                    Shadow(color: Colors.black, blurRadius: 10),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hero.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
                ),
              ),
              const SizedBox(height: 20),

              // 버튼 액션
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => widget.onSelectMedia(hero),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    icon: const Icon(CupertinoIcons.play_arrow_solid, size: 20),
                    label: const Text('재생', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => widget.onSelectMedia(hero),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D6D6E).withValues(alpha: 0.7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    icon: const Icon(CupertinoIcons.info, size: 20),
                    label: const Text('상세 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 우측 하단 음소거 버튼 및 연령가
        Positioned(
          right: 0,
          bottom: 70,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _isMuted ? CupertinoIcons.volume_off : CupertinoIcons.volume_up,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => setState(() => _isMuted = !_isMuted),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  border: Border(left: BorderSide(color: Colors.white, width: 3)),
                ),
                child: Text(
                  '${hero.ageRating}+',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
