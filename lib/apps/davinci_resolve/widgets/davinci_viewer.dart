import 'package:flutter/material.dart';
import '../data/davinci_resolve_model.dart';

class DavinciViewer extends StatelessWidget {
  final DavinciConfig config;
  final VoidCallback onTogglePlay;

  const DavinciViewer({
    super.key,
    required this.config,
    required this.onTogglePlay,
  });

  @override
  Widget build(BuildContext context) {
    final values = config.colorValues;
    // Calculate grading tint from Lift (shadows teal) & Gain (highlights orange)
    final tintColor = Color.fromARGB(
      25,
      (128 + values.gain.dx * 120).clamp(0, 255).toInt(),
      (128 - values.lift.dy * 80).clamp(0, 255).toInt(),
      (128 - values.gain.dy * 120 + values.lift.dx * 80).clamp(0, 255).toInt(),
    );

    return Container(
      color: const Color(0xFF0E0E10),
      child: Column(
        children: [
          // 1. Viewer Top Header
          Container(
            height: 26,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: const Color(0xFF1B1B1E),
            child: Row(
              children: [
                const Icon(Icons.videocam, size: 12, color: Color(0xFFE53935)),
                const SizedBox(width: 6),
                const Text(
                  'Timeline Viewer - 4K DCI (Scope)',
                  style: TextStyle(color: Colors.white70, fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(2)),
                  child: const Text('Fit (100%)', style: TextStyle(color: Colors.white60, fontSize: 10)),
                ),
              ],
            ),
          ),

          // 2. Center Video Canvas
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1B1E),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 16),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Simulated Cinematic Video Scene
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF0B192C), // Deep cinematic navy
                              Color(0xFF1E3E62),
                              Color(0xFF000000),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                config.isPlaying ? Icons.movie : Icons.play_circle_outline,
                                size: 48,
                                color: Colors.white24,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'A001_C001_RAW_6K.braw',
                                style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                config.activeLutPreset,
                                style: const TextStyle(color: Color(0xFFFF8A80), fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Live Color Grading Overlay Tint
                      Container(
                        color: tintColor,
                      ),

                      // Timecode Stamp on viewer
                      Positioned(
                        left: 12,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            config.activeTimecode,
                            style: const TextStyle(
                              color: Color(0xFF00E676),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Consolas',
                            ),
                          ),
                        ),
                      ),

                      // Blackmagic RAW badge
                      Positioned(
                        right: 12,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935).withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'BRAW 12-BIT',
                            style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
