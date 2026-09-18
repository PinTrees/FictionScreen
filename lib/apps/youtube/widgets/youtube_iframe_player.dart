import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../data/youtube_model.dart';
import 'iframe_stub.dart' if (dart.library.js_interop) 'iframe_web.dart';

/// YouTube Player widget supporting both Web IFrame playback and realistic simulated playback
class YouTubeIframePlayer extends StatefulWidget {
  final YoutubeConfig config;
  final ValueChanged<YoutubeConfig>? onConfigChanged;
  final bool isShorts;

  const YouTubeIframePlayer({
    super.key,
    required this.config,
    this.onConfigChanged,
    this.isShorts = false,
  });

  @override
  State<YouTubeIframePlayer> createState() => _YouTubeIframePlayerState();
}

class _YouTubeIframePlayerState extends State<YouTubeIframePlayer> {
  bool _useIframe = true;
  bool _isPlaying = true;
  double _progress = 0.42;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    // Default to iframe on Web, mock on other platforms
    _useIframe = kIsWeb && widget.config.videoId.isNotEmpty;
  }

  String get _thumbnailUrl {
    if (widget.config.thumbnailUrl.isNotEmpty) {
      return widget.config.thumbnailUrl;
    }
    if (widget.config.videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/${widget.config.videoId}/hqdefault.jpg';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.isShorts ? (9 / 16) : (16 / 9),
      child: Container(
        color: const Color(0xFF000000),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video / IFrame / Thumbnail display
            if (_useIframe && kIsWeb && widget.config.videoId.isNotEmpty)
              buildIframeView('yt-${widget.config.videoId}', widget.config.videoId)
            else
              _buildMockPlayer(),

            // Top control bar (Iframe toggle & mode badge)
            Positioned(
              top: 8,
              right: 8,
              child: _buildModeToggle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockPlayer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail
          if (_thumbnailUrl.isNotEmpty)
            Image.network(
              _thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF1F1F1F),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.play_rectangle_fill,
                    color: Color(0xFFFF0000),
                    size: 48,
                  ),
                ),
              ),
            )
          else
            Container(
              color: const Color(0xFF1F1F1F),
              child: const Center(
                child: Icon(
                  CupertinoIcons.play_rectangle_fill,
                  color: Color(0xFFFF0000),
                  size: 48,
                ),
              ),
            ),

          // Dark overlay when controls are visible
          if (_showControls)
            Container(
              color: const Color(0x66000000),
            ),

          // Center Play/Pause button
          if (_showControls)
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xAA000000),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                    color: const Color(0xFFFFFFFF),
                    size: 28,
                  ),
                ),
              ),
            ),

          // Bottom scrub bar and duration
          if (_showControls)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.config.currentTime,
                          style: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.config.totalTime,
                              style: const TextStyle(
                                color: Color(0xFFCCCCCC),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              CupertinoIcons.fullscreen,
                              color: Color(0xFFFFFFFF),
                              size: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Red scrubber line
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        final delta = details.primaryDelta ?? 0;
                        _progress = (_progress + delta / 250).clamp(0.0, 1.0);
                      });
                    },
                    child: Container(
                      height: 12,
                      color: const Color(0x00000000),
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 3,
                        child: Stack(
                          children: [
                            Container(color: const Color(0x44FFFFFF)),
                            FractionallySizedBox(
                              widthFactor: _progress,
                              child: Container(color: const Color(0xFFFF0000)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    if (!kIsWeb) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        setState(() {
          _useIframe = !_useIframe;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xCC000000),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _useIframe ? const Color(0xFFFF0000) : const Color(0x66FFFFFF),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _useIframe ? CupertinoIcons.play_circle_fill : CupertinoIcons.photo,
              color: _useIframe ? const Color(0xFFFF0000) : const Color(0xFFFFFFFF),
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              _useIframe ? 'IFrame ON' : '캡처 모드',
              style: TextStyle(
                color: _useIframe ? const Color(0xFFFF0000) : const Color(0xFFFFFFFF),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
