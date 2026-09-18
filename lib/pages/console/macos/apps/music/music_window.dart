import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// macOS Music (음악) 창
class MusicWindow extends StatefulWidget {
  final VoidCallback onClose;

  const MusicWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<MusicWindow> createState() => _MusicWindowState();
}

class _MusicWindowState extends State<MusicWindow> {
  bool _isPlaying = false;
  int _currentTrack = 0;

  final List<Map<String, String>> _tracks = [
    {'title': 'Golden Gate Sunset', 'artist': 'Fiction Lofi Lab', 'album': 'macOS Beats', 'duration': '2:45'},
    {'title': 'Sequoia Mist', 'artist': 'Apple Ambient', 'album': 'California Vibes', 'duration': '3:12'},
    {'title': 'Night Coding in Cupertino', 'artist': 'Developer Chill', 'album': 'Silicon Valley', 'duration': '4:05'},
    {'title': 'Neon Horizon Synth', 'artist': 'CyberFiction', 'album': 'Retro Wave 80s', 'duration': '3:30'},
    {'title': 'Harmony Blue Melody', 'artist': 'Windows Nostalgia', 'album': 'Classic Sounds', 'duration': '2:18'},
  ];

  @override
  Widget build(BuildContext context) {
    final track = _tracks[_currentTrack];

    return OsWindowFrame(
      title: '음악 - Apple Music',
      style: WindowStyle.macos,
      width: 780,
      height: 500,
      onClose: widget.onClose,
      child: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.backward_fill, size: 16, color: Colors.white70),
                      onPressed: () => setState(() => _currentTrack = (_currentTrack - 1 + _tracks.length) % _tracks.length),
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill, size: 22, color: Colors.white),
                      onPressed: () => setState(() => _isPlaying = !_isPlaying),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.forward_fill, size: 16, color: Colors.white70),
                      onPressed: () => setState(() => _currentTrack = (_currentTrack + 1) % _tracks.length),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFF43F5E), Color(0xFFBE123C)]),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(CupertinoIcons.music_note, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(track['title']!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text('${track['artist']!} — ${track['album']!}', style: const TextStyle(color: Colors.white54, fontSize: 10)),
                            ],
                          ),
                        ),
                        Text(_isPlaying ? '재생 중' : '일시 정지됨', style: TextStyle(color: _isPlaying ? const Color(0xFFF43F5E) : Colors.white38, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Row(
                  children: [
                    Icon(CupertinoIcons.volume_down, size: 14, color: Colors.white54),
                    SizedBox(width: 6),
                    SizedBox(
                      width: 70,
                      child: LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                        minHeight: 4,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(CupertinoIcons.volume_up, size: 14, color: Colors.white54),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 170,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      _buildSidebarItem(CupertinoIcons.play_circle_fill, '지금 듣기', isSelected: true),
                      _buildSidebarItem(CupertinoIcons.square_grid_2x2_fill, '둘러보기'),
                      _buildSidebarItem(CupertinoIcons.dot_radiowaves_left_right, '라디오'),
                      const SizedBox(height: 14),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text('보관함', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      _buildSidebarItem(CupertinoIcons.clock_fill, '최근 추가된 항목'),
                      _buildSidebarItem(CupertinoIcons.person_2_fill, '아티스트'),
                      _buildSidebarItem(CupertinoIcons.square_stack_3d_up_fill, '앨범'),
                      _buildSidebarItem(CupertinoIcons.music_note_list, '노래'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _tracks.length,
                    itemBuilder: (context, index) {
                      final item = _tracks[index];
                      final isCurrent = _currentTrack == index;

                      return InkWell(
                        onTap: () => setState(() {
                          _currentTrack = index;
                          _isPlaying = true;
                        }),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isCurrent ? const Color(0xFFF43F5E).withValues(alpha: 0.15) : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Text('${index + 1}', style: TextStyle(color: isCurrent ? const Color(0xFFF43F5E) : Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: Text(item['title']!, style: TextStyle(color: isCurrent ? const Color(0xFFF43F5E) : Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(item['artist']!, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(item['album']!, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                              ),
                              Text(item['duration']!, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF43F5E).withValues(alpha: 0.25) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isSelected ? const Color(0xFFF43F5E) : Colors.white60),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
