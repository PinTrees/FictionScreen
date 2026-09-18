import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 7 플래그십 시그니처 Now Bar (실시간 라이브 알림 캡슐)
class OneUi7NowBar extends StatefulWidget {
  final VoidCallback? onTap;

  const OneUi7NowBar({super.key, this.onTap});

  @override
  State<OneUi7NowBar> createState() => _OneUi7NowBarState();
}

class _OneUi7NowBarState extends State<OneUi7NowBar> {
  bool _isPlaying = true;
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) return const SizedBox.shrink();

    return GestureDetector(
      onTap: widget.onTap ?? () => setState(() => _isPlaying = !_isPlaying),
      child: Container(
        height: 42,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(CupertinoIcons.music_note_2, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Seven (feat. Latto)', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(_isPlaying ? '재생 중 · Jung Kook' : '일시정지됨 · Jung Kook', style: const TextStyle(color: Colors.white60, fontSize: 10)),
                ],
              ),
            ),
            InkWell(
              onTap: () => setState(() => _isPlaying = !_isPlaying),
              child: Icon(_isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
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
