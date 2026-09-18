import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/instagram_model.dart';
import 'instagram_comments_sheet.dart';

class InstagramPostCard extends StatefulWidget {
  final InstagramFeedPost post;
  final VoidCallback? onProfileTap;

  const InstagramPostCard({
    super.key,
    required this.post,
    this.onProfileTap,
  });

  @override
  State<InstagramPostCard> createState() => _InstagramPostCardState();
}

class _InstagramPostCardState extends State<InstagramPostCard> with SingleTickerProviderStateMixin {
  late AnimationController _heartAnimController;
  late Animation<double> _heartScaleAnim;
  late Animation<double> _heartOpacityAnim;
  bool _showBurstHeart = false;

  @override
  void initState() {
    super.initState();
    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _heartScaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2).chain(CurveTween(curve: Curves.easeOutBack)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.8).chain(CurveTween(curve: Curves.easeIn)), weight: 30),
    ]).animate(_heartAnimController);

    _heartOpacityAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_heartAnimController);

    _heartAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showBurstHeart = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    setState(() {
      _showBurstHeart = true;
      if (!widget.post.isLiked) {
        widget.post.isLiked = true;
        widget.post.likesCount++;
        widget.post.likesText = _formatLikes(widget.post.likesCount);
      }
    });
    _heartAnimController.forward(from: 0.0);
  }

  void _toggleLike() {
    setState(() {
      widget.post.isLiked = !widget.post.isLiked;
      if (widget.post.isLiked) {
        widget.post.likesCount++;
      } else {
        widget.post.likesCount = (widget.post.likesCount - 1).clamp(0, 9999999);
      }
      widget.post.likesText = _formatLikes(widget.post.likesCount);
    });
  }

  String _formatLikes(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}만';
    }
    return count.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  void _openCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return InstagramCommentsSheet(
          comments: widget.post.comments,
          onAddComment: (text) {
            setState(() {
              widget.post.comments.add(
                InstagramCommentItem(
                  id: 'c_${DateTime.now().millisecondsSinceEpoch}',
                  username: 'sunset_traveler',
                  text: text,
                  timeAgo: '방금 전',
                ),
              );
              widget.post.commentCount = widget.post.comments.length;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: User Profile
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onProfileTap,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: widget.post.userAvatarBg,
                      child: Text(
                        widget.post.userAvatarLetter,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: widget.onProfileTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.username,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                      if (widget.post.location.isNotEmpty)
                        Text(
                          widget.post.location,
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('게시물 링크가 복사되었습니다.'), duration: Duration(seconds: 1)),
                  );
                },
                icon: const Icon(CupertinoIcons.ellipsis, size: 18, color: Colors.black87),
              ),
            ],
          ),
        ),

        // Image / Media area with double-tap heart burst
        GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 380,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.post.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: widget.post.imageAsset != null
                    ? Image.asset(
                        widget.post.imageAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),

              // Animated double-tap heart burst
              if (_showBurstHeart)
                AnimatedBuilder(
                  animation: _heartAnimController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _heartOpacityAnim.value,
                      child: Transform.scale(
                        scale: _heartScaleAnim.value,
                        child: const Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.white,
                          size: 100,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 20,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),

        // Actions Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Icon(
                  widget.post.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  color: widget.post.isLiked ? Colors.red : Colors.black87,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _openCommentsSheet(context),
                child: const Icon(CupertinoIcons.chat_bubble, size: 24, color: Colors.black87),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('게시물을 공유합니다 ✈️'), duration: Duration(seconds: 1)),
                  );
                },
                child: const Icon(CupertinoIcons.paperplane, size: 24, color: Colors.black87),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.post.isSaved = !widget.post.isSaved;
                  });
                },
                child: Icon(
                  widget.post.isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                  color: Colors.black87,
                  size: 25,
                ),
              ),
            ],
          ),
        ),

        // Likes, Caption, Comments Preview
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '좋아요 ${widget.post.likesText}개',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.3),
                  children: [
                    TextSpan(
                      text: '${widget.post.username} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: widget.post.caption),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _openCommentsSheet(context),
                child: Text(
                  '댓글 ${widget.post.commentCount}개 모두 보기',
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.post.timeAgo,
                style: const TextStyle(color: Colors.black38, fontSize: 10),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(CupertinoIcons.photo, size: 64, color: Colors.white70),
          SizedBox(height: 8),
          Text(
            '인스타그램 감성 피드',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
