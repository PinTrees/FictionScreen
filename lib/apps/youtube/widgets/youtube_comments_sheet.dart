import 'package:flutter/cupertino.dart';
import '../data/youtube_model.dart';

class YouTubeCommentsSheet extends StatefulWidget {
  final YoutubeConfig config;
  final VoidCallback onClose;
  final ValueChanged<String>? onAddComment;

  const YouTubeCommentsSheet({
    super.key,
    required this.config,
    required this.onClose,
    this.onAddComment,
  });

  @override
  State<YouTubeCommentsSheet> createState() => _YouTubeCommentsSheetState();
}

class _YouTubeCommentsSheetState extends State<YouTubeCommentsSheet> {
  final TextEditingController _textController = TextEditingController();
  late List<YoutubeComment> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.config.comments);
    if (_comments.isEmpty) {
      _comments = [
        YoutubeComment(
          author: 'FictionMaster',
          avatarUrl: 'https://picsum.photos/id/64/100/100',
          text: '이 영상 진짜 역대급 퀄리티네요! 다음 영상도 너무 기대됩니다 🔥',
          timeAgo: '2시간 전',
          likes: 342,
          isLiked: false,
        ),
        YoutubeComment(
          author: 'screen_lover',
          avatarUrl: 'https://picsum.photos/id/102/100/100',
          text: '진짜 실시간 유튜브 플레이어가 이렇게 매끄럽게 돌아가다니 신기하다',
          timeAgo: '5시간 전',
          likes: 89,
          isLiked: false,
        ),
        YoutubeComment(
          author: 'DevK',
          avatarUrl: 'https://picsum.photos/id/338/100/100',
          text: '구독 누르고 갑니다! 좋은 콘텐츠 감사합니다.',
          timeAgo: '1일 전',
          likes: 12,
          isLiked: false,
        ),
      ];
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final newComment = YoutubeComment(
      author: '나 (You)',
      avatarUrl: '',
      text: text,
      timeAgo: '방금 전',
      likes: 0,
      isLiked: false,
    );
    setState(() {
      _comments.insert(0, newComment);
      _textController.clear();
    });
    widget.onAddComment?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle indicator
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF555555),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      '댓글',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_comments.length}',
                      style: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: Color(0xFFFFFFFF),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(height: 1, color: const Color(0xFF2E2E2E)),

          // Comments list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _comments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return _buildCommentRow(comment, index);
              },
            ),
          ),

          // Bottom comment input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF282828),
              border: Border(top: BorderSide(color: Color(0xFF383838), width: 0.8)),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2BA640),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'F',
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CupertinoTextField(
                    controller: _textController,
                    placeholder: '댓글 추가...',
                    placeholderStyle: const TextStyle(color: Color(0xFF888888), fontSize: 13),
                    style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 13),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    onSubmitted: (value) => _submitComment(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _submitComment,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3EA6FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.arrow_up,
                        color: Color(0xFF000000),
                        size: 18,
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

  Widget _buildCommentRow(YoutubeComment comment, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF333333),
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: comment.avatarUrl.isNotEmpty
              ? Image.network(
                  comment.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      comment.author.isNotEmpty ? comment.author[0] : '?',
                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    comment.author.isNotEmpty ? comment.author[0] : '?',
                    style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12),
                  ),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '@${comment.author}',
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    comment.timeAgo,
                    style: const TextStyle(
                      color: Color(0xFF717171),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment.text,
                style: const TextStyle(
                  color: Color(0xFFF1F1F1),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        final cur = _comments[index];
                        final newLiked = !cur.isLiked;
                        _comments[index] = YoutubeComment(
                          author: cur.author,
                          avatarUrl: cur.avatarUrl,
                          text: cur.text,
                          timeAgo: cur.timeAgo,
                          likes: newLiked ? cur.likes + 1 : (cur.likes > 0 ? cur.likes - 1 : 0),
                          isLiked: newLiked,
                        );
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          comment.isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                          color: comment.isLiked ? const Color(0xFF3EA6FF) : const Color(0xFFAAAAAA),
                          size: 14,
                        ),
                        if (comment.likes > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            '${comment.likes}',
                            style: TextStyle(
                              color: comment.isLiked ? const Color(0xFF3EA6FF) : const Color(0xFFAAAAAA),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    CupertinoIcons.hand_thumbsdown,
                    color: Color(0xFFAAAAAA),
                    size: 14,
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    '답글',
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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
