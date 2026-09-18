import 'package:flutter/material.dart';
import '../data/davinci_resolve_model.dart';

class DavinciTimeline extends StatelessWidget {
  final List<TimelineTrack> tracks;
  final String activeTimecode;
  final bool isPlaying;
  final VoidCallback onTogglePlay;

  const DavinciTimeline({
    super.key,
    required this.tracks,
    required this.activeTimecode,
    required this.isPlaying,
    required this.onTogglePlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF141416),
      child: Column(
        children: [
          // 1. Timeline Toolbar & Transport
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: const Color(0xFF1B1B1E),
            child: Row(
              children: [
                _toolIcon(Icons.near_me, '선택 도구 (A)', isSelected: true),
                _toolIcon(Icons.content_cut, '면도날 도구 (B)'),
                _toolIcon(Icons.compare_arrows, '트림 편집 (T)'),
                _toolIcon(Icons.vertical_align_center, '스냅 자석 (N)', isSelected: true),
                const SizedBox(width: 8),
                Container(width: 1, height: 16, color: Colors.white12),
                const SizedBox(width: 8),

                // Timecode Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    activeTimecode,
                    style: const TextStyle(
                      color: Color(0xFF00E676),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Consolas',
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const Spacer(),

                // Playback Transport
                IconButton(
                  icon: const Icon(Icons.fast_rewind, size: 16, color: Colors.white70),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 18, color: const Color(0xFFE53935)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                  onPressed: onTogglePlay,
                ),
                IconButton(
                  icon: const Icon(Icons.fast_forward, size: 16, color: Colors.white70),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                  onPressed: () {},
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.loop, size: 14, color: Colors.white38),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // 2. Timeline Tracks Body
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: tracks.length,
                  itemBuilder: (context, idx) {
                    final track = tracks[idx];
                    return _buildTrackRow(track);
                  },
                ),

                // Red Playhead Needle (CTI)
                Positioned(
                  left: 280,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE53935),
                  ),
                ),
                Positioned(
                  left: 274,
                  top: 0,
                  child: CustomPaint(
                    size: const Size(14, 10),
                    painter: _PlayheadMarkerPainter(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackRow(TimelineTrack track) {
    return Container(
      height: 38,
      decoration: const BoxDecoration(
        color: Color(0xFF141416),
        border: Border(bottom: BorderSide(color: Color(0xFF222226), width: 1)),
      ),
      child: Row(
        children: [
          // Track Header (Width: 100)
          Container(
            width: 100,
            color: const Color(0xFF1B1B1E),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  track.isVideo ? Icons.videocam_outlined : Icons.volume_up_outlined,
                  size: 13,
                  color: Colors.white70,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    track.name,
                    style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.lock_outline, size: 11, color: Colors.white24),
              ],
            ),
          ),

          // Clips Area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                return Stack(
                  children: track.clips.map((clip) {
                    final left = clip.start * totalWidth;
                    final width = clip.duration * totalWidth;

                    return Positioned(
                      left: left,
                      width: width,
                      top: 3,
                      bottom: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: clip.color.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                clip.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolIcon(IconData icon, String tooltip, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE53935).withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(3),
        border: isSelected ? Border.all(color: const Color(0xFFE53935)) : null,
      ),
      child: Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.white60),
    );
  }
}

class _PlayheadMarkerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height * 0.5)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
