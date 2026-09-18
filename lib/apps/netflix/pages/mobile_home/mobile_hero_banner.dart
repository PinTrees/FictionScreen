import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/netflix_model.dart';

/// 넷플릭스 모바일 세로형 히어로 포스터 & 3버튼
class MobileHeroBanner extends StatelessWidget {
  final NetflixMediaItem hero;
  final ValueChanged<NetflixMediaItem> onSelectMedia;

  const MobileHeroBanner({
    super.key,
    required this.hero,
    required this.onSelectMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // 세로형 포스터
        SizedBox(
          height: 400,
          width: double.infinity,
          child: Image.network(
            hero.posterUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: const Color(0xFF222222)),
          ),
        ),
        // 하단 페이드 그라데이션
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0xFF141414).withValues(alpha: 0.8),
                const Color(0xFF141414),
              ],
            ),
          ),
        ),
        // 메인 정보 & 3버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 장르 태그
              Text(
                hero.genres.join(' • '),
                style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              // 액션 3버튼 (내가 찜한 리스트 / 재생 / 정보)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(CupertinoIcons.add, color: Colors.white, size: 22),
                      SizedBox(height: 2),
                      Text('내가 찜한 리스트', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => onSelectMedia(hero),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    icon: const Icon(CupertinoIcons.play_arrow_solid, size: 18),
                    label: const Text('재생', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  GestureDetector(
                    onTap: () => onSelectMedia(hero),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(CupertinoIcons.info_circle, color: Colors.white, size: 22),
                        SizedBox(height: 2),
                        Text('정보', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
