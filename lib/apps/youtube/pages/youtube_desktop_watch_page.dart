import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/youtube_model.dart';
import '../widgets/youtube_iframe_player.dart';

class YouTubeDesktopWatchPage extends StatefulWidget {
  final YoutubeConfig config;
  final ValueChanged<YoutubeConfig>? onConfigChanged;
  final ValueChanged<YoutubeVideoItem>? onSelectVideo;

  const YouTubeDesktopWatchPage({
    super.key,
    required this.config,
    this.onConfigChanged,
    this.onSelectVideo,
  });

  @override
  State<YouTubeDesktopWatchPage> createState() => _YouTubeDesktopWatchPageState();
}

class _YouTubeDesktopWatchPageState extends State<YouTubeDesktopWatchPage> {
  bool _isDescriptionExpanded = false;
  String _selectedCategoryChip = '모두';
  final TextEditingController _commentController = TextEditingController();
  bool _isCommentFocused = false;

  final List<String> _categoryChips = [
    '모두',
    '관련 동영상',
    '이 채널의 동영상',
    '최근에 업로드된 동영상',
    '감상한 동영상',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleAddComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final newComment = YoutubeComment(
      author: 'FictionScreen_User',
      timeAgo: '방금 전',
      text: text,
      likes: 1,
    );

    final updated = List<YoutubeComment>.from(widget.config.comments)..insert(0, newComment);
    widget.onConfigChanged?.call(widget.config.copyWith(comments: updated));
    _commentController.clear();
    setState(() {
      _isCommentFocused = false;
    });
  }

  void _toggleLikeComment(int index) {
    final list = List<YoutubeComment>.from(widget.config.comments);
    final c = list[index];
    list[index] = YoutubeComment(
      id: c.id,
      author: c.author,
      avatarUrl: c.avatarUrl,
      timeAgo: c.timeAgo,
      text: c.text,
      likes: c.isLiked ? (c.likes > 0 ? c.likes - 1 : 0) : c.likes + 1,
      isLiked: !c.isLiked,
      isHearted: c.isHearted,
      isPinned: c.isPinned,
    );
    widget.onConfigChanged?.call(widget.config.copyWith(comments: list));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 24 : 12,
            vertical: 16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left primary watch column (70%)
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildVideoPlayer(),
                              const SizedBox(height: 12),
                              _buildVideoTitle(),
                              const SizedBox(height: 12),
                              _buildChannelAndActionToolbar(),
                              const SizedBox(height: 14),
                              _buildDescriptionBox(),
                              const SizedBox(height: 24),
                              _buildCommentsSection(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Right secondary recommendations sidebar (30%)
                        SizedBox(
                          width: 380,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryChips(),
                              const SizedBox(height: 14),
                              _buildRecommendationList(),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildVideoPlayer(),
                        const SizedBox(height: 10),
                        _buildVideoTitle(),
                        const SizedBox(height: 10),
                        _buildChannelAndActionToolbar(),
                        const SizedBox(height: 12),
                        _buildDescriptionBox(),
                        const SizedBox(height: 20),
                        _buildCategoryChips(),
                        const SizedBox(height: 14),
                        _buildRecommendationList(),
                        const SizedBox(height: 24),
                        _buildCommentsSection(),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoPlayer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.black,
        child: YouTubeIframePlayer(
          config: widget.config,
          onConfigChanged: widget.onConfigChanged,
        ),
      ),
    );
  }

  Widget _buildVideoTitle() {
    return Text(
      widget.config.videoTitle,
      style: const TextStyle(
        color: Color(0xFFF1F1F1),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildChannelAndActionToolbar() {
    final isSubscribed = widget.config.isSubscribed;
    final isLiked = widget.config.isLiked;

    return Row(
      children: [
        // Channel Avatar
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFF333333),
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: widget.config.channelAvatarUrl.isNotEmpty
              ? Image.network(
                  widget.config.channelAvatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildChannelInitial(),
                )
              : _buildChannelInitial(),
        ),
        const SizedBox(width: 12),

        // Channel Name & Subscribers
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      widget.config.channelName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.check_circle, color: Color(0xFFAAAAAA), size: 14),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '구독자 ${widget.config.subscriberCount}',
                style: const TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Subscribe button
        InkWell(
          onTap: () {
            widget.onConfigChanged?.call(
              widget.config.copyWith(isSubscribed: !isSubscribed),
            );
          },
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSubscribed ? const Color(0xFF272727) : Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSubscribed) ...[
                  const Icon(CupertinoIcons.bell_fill, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                ],
                Text(
                  isSubscribed ? '구독중' : '구독',
                  style: TextStyle(
                    color: isSubscribed ? Colors.white : const Color(0xFF0F0F0F),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isSubscribed) ...[
                  const SizedBox(width: 4),
                  const Icon(CupertinoIcons.chevron_down, color: Colors.white, size: 12),
                ],
              ],
            ),
          ),
        ),

        const Spacer(),

        // Action Toolbar (Like/Dislike, Share, Download, Clip, More)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Like / Dislike pill group
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF272727),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.onConfigChanged?.call(
                          widget.config.copyWith(isLiked: !isLiked),
                        );
                      },
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                              color: isLiked ? const Color(0xFF3EA6FF) : Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.config.likeCount,
                              style: TextStyle(
                                color: isLiked ? const Color(0xFF3EA6FF) : Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1, height: 18, color: const Color(0xFF3F3F3F)),
                    InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(18)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Share pill
              _buildActionPill(CupertinoIcons.arrowshape_turn_up_right, '공유'),

              const SizedBox(width: 8),

              // Download pill
              _buildActionPill(CupertinoIcons.arrow_down_to_line, '오프라인 저장'),

              const SizedBox(width: 8),

              // Clip pill
              _buildActionPill(CupertinoIcons.scissors, '클립'),

              const SizedBox(width: 8),

              // More pill
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF272727),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(CupertinoIcons.ellipsis, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChannelInitial() {
    return Center(
      child: Text(
        widget.config.channelName.isNotEmpty ? widget.config.channelName[0] : 'Y',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildActionPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF272727),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDescriptionExpanded = !_isDescriptionExpanded;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF272727),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats & Date Header
            Wrap(
              spacing: 8,
              children: [
                Text(
                  '조회수 ${widget.config.viewCount}회',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.config.uploadTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description text
            Text(
              widget.config.description,
              style: const TextStyle(
                color: Color(0xFFF1F1F1),
                fontSize: 13,
                height: 1.45,
              ),
              maxLines: _isDescriptionExpanded ? null : 3,
              overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Show more / Show less toggle
            Text(
              _isDescriptionExpanded ? '간략히' : '...더보기',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categoryChips.map((chip) {
          final isSelected = _selectedCategoryChip == chip;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(chip),
              selected: isSelected,
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              backgroundColor: const Color(0xFF272727),
              selectedColor: Colors.white,
              showCheckmark: false,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              onSelected: (val) {
                if (val) setState(() => _selectedCategoryChip = chip);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendationList() {
    final list = widget.config.recommendedVideos;

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];
        return InkWell(
          onTap: () => widget.onSelectVideo?.call(item),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 16:9 Thumbnail
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 168,
                      height: 94,
                      color: const Color(0xFF272727),
                      child: Image.network(
                        item.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: item.gradientColors,
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 32),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xDD000000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              // Meta info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Color(0xFFF1F1F1),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.channelTitle,
                            style: const TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle, color: Color(0xFFAAAAAA), size: 11),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '조회수 ${item.viewCount} · ${item.publishedTime}',
                      style: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Color(0xFFAAAAAA), size: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentsSection() {
    final comments = widget.config.comments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comments Header with Sort By
        Row(
          children: [
            Text(
              '댓글 ${comments.length}개',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.sort, color: Colors.white, size: 20),
                SizedBox(width: 6),
                Text(
                  '정렬 기준',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Add Comment Input Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('F', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _commentController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    onTap: () => setState(() => _isCommentFocused = true),
                    decoration: InputDecoration(
                      hintText: '댓글 추가...',
                      hintStyle: const TextStyle(color: Color(0xFF888888), fontSize: 13),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF444444)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                  ),
                  if (_isCommentFocused) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _commentController.clear();
                            setState(() => _isCommentFocused = false);
                          },
                          child: const Text('취소', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3EA6FF),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          onPressed: _handleAddComment,
                          child: const Text('댓글', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Comment List
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: comments.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final comment = comments[index];
            return _buildCommentItem(comment, index);
          },
        ),
      ],
    );
  }

  Widget _buildCommentItem(YoutubeComment comment, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            shape: BoxShape.circle,
            gradient: comment.isPinned
                ? const LinearGradient(colors: [Color(0xFFFF0000), Color(0xFFCC0000)])
                : null,
          ),
          child: Center(
            child: Text(
              comment.author.isNotEmpty ? comment.author[0] : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pinned badge if pinned
              if (comment.isPinned)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.push_pin, color: Color(0xFFAAAAAA), size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.config.channelName} 님이 고정함',
                        style: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              // Author & Time
              Row(
                children: [
                  Text(
                    '@${comment.author}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    comment.timeAgo,
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Comment text
              Text(
                comment.text,
                style: const TextStyle(
                  color: Color(0xFFF1F1F1),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),

              // Reaction Bar
              Row(
                children: [
                  InkWell(
                    onTap: () => _toggleLikeComment(index),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          comment.isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                          color: comment.isLiked ? const Color(0xFF3EA6FF) : const Color(0xFFAAAAAA),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${comment.likes}',
                          style: TextStyle(
                            color: comment.isLiked ? const Color(0xFF3EA6FF) : const Color(0xFFAAAAAA),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(CupertinoIcons.hand_thumbsdown, color: Color(0xFFAAAAAA), size: 14),
                  if (comment.isHearted) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF272727),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(CupertinoIcons.heart_fill, color: Color(0xFFFF0000), size: 12),
                          SizedBox(width: 3),
                          Text('하트', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(width: 14),
                  const Text(
                    '답글',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
