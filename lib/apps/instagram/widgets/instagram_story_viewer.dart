import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/instagram_model.dart';

class InstagramStoryViewer extends StatefulWidget {
  final InstagramStoryItem story;
  final VoidCallback onClose;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;

  const InstagramStoryViewer({
    super.key,
    required this.story,
    required this.onClose,
    this.onNext,
    this.onPrev,
  });

  @override
  State<InstagramStoryViewer> createState() => _InstagramStoryViewerState();
}

class _InstagramStoryViewerState extends State<InstagramStoryViewer> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  final TextEditingController _replyController = TextEditingController();
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward().then((_) {
        if (mounted) {
          if (widget.onNext != null) {
            widget.onNext!();
          } else {
            widget.onClose();
          }
        }
      });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Center Story Content
            Positioned.fill(
              child: GestureDetector(
                onTapUp: (details) {
                  final width = MediaQuery.of(context).size.width;
                  if (details.localPosition.dx < width * 0.35) {
                    widget.onPrev?.call();
                  } else {
                    widget.onNext != null ? widget.onNext!() : widget.onClose();
                  }
                },
                child: Container(
                  color: Colors.black,
                  child: widget.story.imageAsset != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              widget.story.imageAsset!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildFallbackContent(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withValues(alpha: 0.55),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.65),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.0, 0.45, 1.0],
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  widget.story.storyText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : _buildFallbackContent(),
                ),
              ),
            ),

            // Top Header: Progress Bar & User Info
            Positioned(
              top: 8,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: _progressController.value,
                          minHeight: 2.5,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: widget.story.avatarBg,
                        child: Text(
                          widget.story.avatarLetter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.story.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.story.storyTime,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(CupertinoIcons.xmark, color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Actions: Reply Bar & Like
            Positioned(
              left: 12,
              right: 12,
              bottom: 16,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _replyController,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: '${widget.story.username}님에게 메시지 보내기...',
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_replyController.text.trim().isNotEmpty) {
                                _replyController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('답장을 보냈습니다 💌'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            child: const Icon(
                              CupertinoIcons.paperplane_fill,
                              color: Colors.white70,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLiked = !_isLiked;
                      });
                    },
                    child: Icon(
                      _isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: _isLiked ? Colors.redAccent : Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    CupertinoIcons.paperplane,
                    color: Colors.white,
                    size: 26,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.story.avatarBg.withValues(alpha: 0.85),
            const Color(0xFF1E1B4B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                child: const Icon(
                  CupertinoIcons.sparkles,
                  color: Colors.amberAccent,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.story.storyText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
