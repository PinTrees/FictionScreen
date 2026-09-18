import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';

/// Apple iOS 26 공식 리퀴드 글래스 지금 재생 중 (Now Playing) 2x2 카드
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
      height: 160,
      borderRadius: 28,
      blurSigma: 36,
      tintColor: const Color(0xFF0F2644),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 상단: 앨범 아트 플레이스홀더 및 AirPlay 원형 아이콘
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 0.8),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.16)),
                child: const Center(child: Icon(CupertinoIcons.radiowaves_right, color: Colors.white70, size: 16)),
              ),
            ],
          ),

          // 중앙: 상태 문구 (재생 중이 아님)
          const Text(
            '재생 중이 아님',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: -0.2),
          ),

          // 하단: 재생 컨트롤 (이전, 재생/정지, 다음)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(CupertinoIcons.backward_fill, color: Colors.white, size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: Icon(_isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill, color: Colors.white, size: 26),
                onPressed: () => setState(() => _isPlaying = !_isPlaying),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.forward_fill, color: Colors.white, size: 20),
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
