import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 9 플래그십 시그니처 Now Bar (실시간 라이브 알림 캡슐)
class OneUi9NowBar extends StatefulWidget {
  final VoidCallback? onTap;

  const OneUi9NowBar({super.key, this.onTap});

  @override
  State<OneUi9NowBar> createState() => _OneUi9NowBarState();
}

class _OneUi9NowBarState extends State<OneUi9NowBar> {
  bool _isPlaying = true;
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) return const SizedBox.shrink();

    return GestureDetector(
      onTap: widget.onTap ?? () => setState(() => _isPlaying = !_isPlaying),
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.52),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)]),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(CupertinoIcons.music_note_2, size: 15, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Golden Hour · JVKE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(_isPlaying ? 'Galaxy AI 오디오 향상 재생 중' : '일시정지됨', style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 10)),
                ],
              ),
            ),
            InkWell(
              onTap: () => setState(() => _isPlaying = !_isPlaying),
              child: Icon(_isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill, color: Colors.white, size: 19),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => setState(() => _isDismissed = true),
              child: const Icon(CupertinoIcons.xmark, color: Colors.white38, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}
