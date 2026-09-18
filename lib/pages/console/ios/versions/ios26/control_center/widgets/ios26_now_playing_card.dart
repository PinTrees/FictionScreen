import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';
import 'ios26_cc_icons.dart';

/// Apple iOS 26 리퀴드 글래스 지금 재생 중 (Now Playing) 2x2 카드
class Ios26NowPlayingCard extends StatefulWidget {
  final double cardSize;
  const Ios26NowPlayingCard({super.key, required this.cardSize});

  @override
  State<Ios26NowPlayingCard> createState() => _Ios26NowPlayingCardState();
}

class _Ios26NowPlayingCardState extends State<Ios26NowPlayingCard> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final size = widget.cardSize;
    final pad = size * (14.0 / 180.0);
    final artSize = size * 0.28;
    final airPlaySize = size * 0.22;

    return Ios26LiquidGlass(
      width: size,
      height: size,
      borderRadius: size * 0.20,
      blurSigma: 36,
      tintColor: const Color(0xFF0F2644),
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 상단: 앨범 커버 플레이스홀더 + AirPlay 오디오 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: artSize,
                height: artSize,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(artSize * 0.22),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.22), width: 0.8),
                ),
              ),
              Container(
                width: airPlaySize,
                height: airPlaySize,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.16)),
                child: Center(child: Ios26AirPlayIcon(size: airPlaySize * 0.50)),
              ),
            ],
          ),

          // 중앙: 상태 타이틀
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Text('재생 중이 아님', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
          ),

          // 하단: 이전, 재생/일시정지, 다음 컨트롤
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {},
                child: const Icon(CupertinoIcons.backward_fill, color: Colors.white70, size: 20),
              ),
              GestureDetector(
                onTap: () => setState(() => _isPlaying = !_isPlaying),
                child: Icon(_isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill, color: Colors.white, size: 28),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(CupertinoIcons.forward_fill, color: Colors.white70, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
