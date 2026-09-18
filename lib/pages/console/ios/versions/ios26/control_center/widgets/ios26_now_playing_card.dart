import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';

/// iOS 26 리퀴드 글래스 지금 재생 중 (Now Playing) 2x2 카드
class Ios26NowPlayingCard extends StatefulWidget {
  const Ios26NowPlayingCard({super.key});

  @override
  State<Ios26NowPlayingCard> createState() => _Ios26NowPlayingCardState();
}

class _Ios26NowPlayingCardState extends State<Ios26NowPlayingCard> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Ios26LiquidGlass(
      height: 154,
      borderRadius: 28,
      blurSigma: 36,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 상단: 앨범 아트 플레이스홀더 및 AirPlay 아이콘
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 0.8,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.music_note_2,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.14),
                ),
                child: const Icon(
                  CupertinoIcons.radiowaves_right,
                  color: Colors.white70,
                  size: 15,
                ),
              ),
            ],
          ),

          // 중앙: 상태 문구 (재생 중이 아님)
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '재생 중이 아님',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),

          // 하단: 재생 컨트롤 (이전, 재생/정지, 다음)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(CupertinoIcons.backward_fill, color: Colors.white, size: 19),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () => setState(() => _isPlaying = !_isPlaying),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.forward_fill, color: Colors.white, size: 19),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
