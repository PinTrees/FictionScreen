import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/netflix_icons.dart';
import '../../data/netflix_model.dart';
import 'media_episode_tile.dart';

/// 넷플릭스 영화/시리즈 상세 정보 창 내부 팝업 다이얼로그
class MediaDetailDialog extends StatelessWidget {
  final NetflixMediaItem media;
  final VoidCallback onClose;
  final VoidCallback onPlay;

  const MediaDetailDialog({
    super.key,
    required this.media,
    required this.onClose,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      alignment: Alignment.center,
      child: Container(
        width: 720,
        height: 580,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              // 스크롤 가능한 상세 내용
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 상단 백드롭 히어로
                  _buildBackdropHero(),

                  // 메인 메타 정보 & 시놉시스
                  _buildMetaAndSynopsis(),

                  // 회차 목록 (시리즈인 경우)
                  if (media.episodes.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      child: Divider(color: Colors.white12),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '회차',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            media.durationOrSeasons,
                            style: const TextStyle(color: Colors.white60, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...media.episodes.map((ep) => MediaEpisodeTile(episode: ep)),
                  ],
                  const SizedBox(height: 30),
                ],
              ),

              // 우측 상단 닫기 (X) 버튼
              Positioned(
                top: 14,
                right: 14,
                child: InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF181818),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.xmark, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackdropHero() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: Image.network(
            media.backdropUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: const Color(0xFF2B2B2B),
              child: const Center(
                child: Icon(CupertinoIcons.film, color: Colors.white24, size: 60),
              ),
            ),
          ),
        ),
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0xFF181818).withValues(alpha: 0.8),
                const Color(0xFF181818),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (media.isOriginal) ...[
                Row(
                  children: [
                    const NetflixWordmark(fontSize: 16, isNOnly: true),
                    const SizedBox(width: 6),
                    Text(
                      '시 리 즈',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              Text(
                media.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: onPlay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    icon: const Icon(CupertinoIcons.play_arrow_solid, size: 18),
                    label: const Text('재생', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const SizedBox(width: 10),
                  _buildCircleButton(CupertinoIcons.add),
                  const SizedBox(width: 8),
                  _buildCircleButton(CupertinoIcons.hand_thumbsup),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetaAndSynopsis() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${media.matchPercentage}% 일치',
                      style: const TextStyle(
                        color: Color(0xFF46D369),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${media.releaseYear}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(width: 10),
                    NetflixAgeBadge(rating: media.ageRating),
                    const SizedBox(width: 10),
                    Text(
                      media.durationOrSeasons,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white38),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text('HD', style: TextStyle(color: Colors.white70, fontSize: 9)),
                    ),
                  ],
                ),
                if (media.tagline.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    media.tagline,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Text(
                  media.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetaRow('출연', media.cast.join(', ')),
                const SizedBox(height: 8),
                _buildMetaRow('장르', media.genres.join(', ')),
                const SizedBox(height: 8),
                _buildMetaRow('감독/각본', media.director),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white38),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, height: 1.4),
        children: [
          TextSpan(text: '$label: ', style: const TextStyle(color: Colors.white54)),
          TextSpan(text: value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
