import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/blind_model.dart';
import '../../widgets/blind_comment_tile.dart';
import '../../widgets/blind_company_badge.dart';
import '../../widgets/blind_poll_widget.dart';

class BlindMobileDetailPage extends StatefulWidget {
  final BlindPostItem post;
  final VoidCallback onBack;
  final ValueChanged<BlindPostItem> onPostUpdated;
  final VoidCallback onEditStory;

  const BlindMobileDetailPage({
    super.key,
    required this.post,
    required this.onBack,
    required this.onPostUpdated,
    required this.onEditStory,
  });

  @override
  State<BlindMobileDetailPage> createState() => _BlindMobileDetailPageState();
}

class _BlindMobileDetailPageState extends State<BlindMobileDetailPage> {
  late BlindPostItem _post;
  final TextEditingController _commentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  void didUpdateWidget(covariant BlindMobileDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post != widget.post) {
      _post = widget.post;
    }
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _handleVote(String optionId) {
    final poll = _post.poll;
    if (poll == null) return;

    final updatedOptions = poll.options.map((opt) {
      if (opt.id == optionId) {
        return opt.copyWith(votes: opt.votes + 1, isVoted: true);
      } else if (poll.selectedOptionId == opt.id) {
        return opt.copyWith(votes: (opt.votes - 1).clamp(0, 9999999), isVoted: false);
      }
      return opt.copyWith(isVoted: false);
    }).toList();

    final updatedPoll = poll.copyWith(
      options: updatedOptions,
      hasVoted: true,
      selectedOptionId: optionId,
    );

    final updated = _post.copyWith(poll: updatedPoll);
    setState(() => _post = updated);
    widget.onPostUpdated(updated);
  }

  void _handleLike() {
    final newLiked = !_post.isLiked;
    final newCount = newLiked ? _post.likeCount + 1 : (_post.likeCount - 1).clamp(0, 9999999);
    final updated = _post.copyWith(isLiked: newLiked, likeCount: newCount);
    setState(() => _post = updated);
    widget.onPostUpdated(updated);
  }

  void _handleAddComment() {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;

    final newComment = BlindCommentItem(
      id: 'c-${DateTime.now().millisecondsSinceEpoch}',
      authorCompany: '토스',
      authorMaskedId: 't***',
      content: text,
      timeAgo: '방금 전',
    );

    final updated = _post.copyWith(
      comments: [newComment, ..._post.comments],
      commentCount: _post.commentCount + 1,
    );

    _commentCtrl.clear();
    setState(() => _post = updated);
    widget.onPostUpdated(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, size: 20, color: Color(0xFF1E2024)),
          onPressed: widget.onBack,
        ),
        title: Text(
          _post.channel,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E2024),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.pencil_circle, size: 21, color: Color(0xFFDA3238)),
            onPressed: widget.onEditStory,
            tooltip: '게시글 수정',
          ),
          IconButton(
            icon: Icon(
              _post.isBookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
              size: 20,
              color: _post.isBookmarked ? const Color(0xFFDA3238) : const Color(0xFF1E2024),
            ),
            onPressed: () {
              final updated = _post.copyWith(isBookmarked: !_post.isBookmarked);
              setState(() => _post = updated);
              widget.onPostUpdated(updated);
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.share, size: 20, color: Color(0xFF1E2024)),
            onPressed: () {},
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFFE9ECEF), height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlindCompanyBadge(
                    company: _post.authorCompany,
                    maskedId: _post.authorMaskedId,
                    timeAgo: _post.createdAt,
                    viewCount: _post.viewCount,
                    fontSize: 12.5,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _post.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E2024),
                      height: 1.35,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _post.content,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF2B2D31),
                      height: 1.65,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (_post.poll != null)
                    BlindPollWidget(
                      poll: _post.poll!,
                      onVote: _handleVote,
                    ),
                  const SizedBox(height: 20),

                  // Like button
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: _handleLike,
                      icon: Icon(
                        _post.isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                        size: 15,
                        color: _post.isLiked ? const Color(0xFFDA3238) : const Color(0xFF495057),
                      ),
                      label: Text(
                        '추천 ${_post.likeCount}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _post.isLiked ? const Color(0xFFDA3238) : const Color(0xFF495057),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: _post.isLiked ? const Color(0xFFDA3238) : const Color(0xFFDEE2E6),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                    ),
                  ),

                  const Divider(color: Color(0xFFF1F3F5), height: 32),

                  // Comments Header
                  Row(
                    children: [
                      const Text(
                        '댓글',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E2024)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_post.commentCount}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFFDA3238)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ..._post.comments.map(
                    (c) => BlindCommentTile(comment: c),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Comment Input
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE9ECEF), width: 1)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F5F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        controller: _commentCtrl,
                        cursorColor: const Color(0xFFDA3238),
                        style: const TextStyle(fontSize: 13, color: Color(0xFF1E2024)),
                        decoration: const InputDecoration(
                          hintText: '댓글을 남겨보세요.',
                          hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFFADB5BD)),
                          filled: false,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        onSubmitted: (_) => _handleAddComment(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _handleAddComment,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDA3238),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '등록',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
