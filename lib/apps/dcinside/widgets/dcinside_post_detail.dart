import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/dcinside_model.dart';

class DcinsidePostDetail extends StatefulWidget {
  final DcPost post;
  final ValueChanged<DcPost> onPostUpdated;
  final VoidCallback onBackToList;

  const DcinsidePostDetail({
    super.key,
    required this.post,
    required this.onPostUpdated,
    required this.onBackToList,
  });

  @override
  State<DcinsidePostDetail> createState() => _DcinsidePostDetailState();
}

class _DcinsidePostDetailState extends State<DcinsidePostDetail> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(text: 'ㅇㅇ');
  bool _hasVotedRecommend = false;
  bool _hasVotedDislike = false;

  @override
  void dispose() {
    _commentController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleVoteRecommend() {
    if (_hasVotedRecommend) return;
    setState(() => _hasVotedRecommend = true);
    final updated = widget.post.copyWith(
      recommendCount: widget.post.recommendCount + 1,
      isConcept: true,
    );
    widget.onPostUpdated(updated);
  }

  void _handleVoteDislike() {
    if (_hasVotedDislike) return;
    setState(() => _hasVotedDislike = true);
    final updated = widget.post.copyWith(
      dislikeCount: widget.post.dislikeCount + 1,
    );
    widget.onPostUpdated(updated);
  }

  void _handleAddComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final newComment = DcComment(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      authorName: _nameController.text.trim().isEmpty ? 'ㅇㅇ' : _nameController.text.trim(),
      ipOrBadge: '(223.38)',
      authorType: DcAuthorType.anonymous,
      content: text,
      createdAt: '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    );

    final updatedComments = List<DcComment>.from(widget.post.comments)..add(newComment);
    final updated = widget.post.copyWith(comments: updatedComments);
    widget.onPostUpdated(updated);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 게시글 헤더
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리 + 제목
                  Text(
                    '${widget.post.category} ${widget.post.title}',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 작성자 정보 & 작성일시 & 통계
                  Row(
                    children: [
                      _buildAuthorBadge(widget.post),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 10, color: const Color(0xFFD1D5DB)),
                      const SizedBox(width: 8),
                      Text(
                        widget.post.createdAt,
                        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        '조회 ${widget.post.viewCount}  |  추천 ${widget.post.recommendCount}  |  댓글 ${widget.post.comments.length}',
                        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. 게시글 본문 내용
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: SelectableText(
                widget.post.content,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 14.5,
                  height: 1.7,
                  letterSpacing: -0.2,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. 개념 추천 / 비추천 투표 바
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 개념 추천 버튼
                  GestureDetector(
                    onTap: _handleVoteRecommend,
                    child: Container(
                      width: 130,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _hasVotedRecommend ? const Color(0xFFDC2626) : const Color(0xFF3B4890),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B4890).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.hand_thumbsup_fill, color: Colors.white, size: 16),
                              SizedBox(width: 5),
                              Text('개념', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.post.recommendCount.toString(),
                            style: const TextStyle(color: Color(0xFFFFD54F), fontSize: 15, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // 비추천 버튼
                  GestureDetector(
                    onTap: _handleVoteDislike,
                    child: Container(
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B7280),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.hand_thumbsdown_fill, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text('비추', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.post.dislikeCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // 4. 댓글 섹션
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB)),
                  bottom: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text('전체 댓글', style: TextStyle(color: Color(0xFF111827), fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
                  Text('${widget.post.comments.length}개', style: const TextStyle(color: Color(0xFFDC2626), fontSize: 14, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Text('등록순  |  최신순', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                ],
              ),
            ),

            // 댓글 목록
            if (widget.post.comments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('첫 번째 댓글을 남겨보세요.', style: TextStyle(color: Colors.black38, fontSize: 13)),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.post.comments.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
                itemBuilder: (context, index) {
                  final comment = widget.post.comments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildCommentAuthorBadge(comment),
                            const Spacer(),
                            Text(comment.createdAt, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          comment.content,
                          style: const TextStyle(color: Color(0xFF374151), fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              ),

            // 댓글 작성 폼
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFF3F4F6),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 110,
                        height: 32,
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: '닉네임',
                            isDense: true,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD1D5DB))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 100,
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        child: const Text('••••••', style: TextStyle(color: Colors.black26, fontSize: 12)),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B4890),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onPressed: _handleAddComment,
                        child: const Text('등록', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: '타인의 권리를 침해하거나 명예를 훼손하는 댓글은 관련 법률에 의해 제재를 받을 수 있습니다.',
                      isDense: true,
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD1D5DB))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorBadge(DcPost post) {
    switch (post.authorType) {
      case DcAuthorType.anonymous:
        return Text(
          '${post.authorName} ${post.ipOrBadge}',
          style: const TextStyle(color: Color(0xFF374151), fontSize: 13, fontWeight: FontWeight.w600),
        );
      case DcAuthorType.fixed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              post.authorName,
              style: const TextStyle(color: Color(0xFF2563EB), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(3)),
              child: const Text('갤로그', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      case DcAuthorType.subManager:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              post.authorName,
              style: const TextStyle(color: Color(0xFF0284C7), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(color: const Color(0xFF0284C7), borderRadius: BorderRadius.circular(3)),
              child: const Text('부매니저', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      case DcAuthorType.manager:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              post.authorName,
              style: const TextStyle(color: Color(0xFFEA580C), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(color: const Color(0xFFEA580C), borderRadius: BorderRadius.circular(3)),
              child: const Text('매니저', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ],
        );
    }
  }

  Widget _buildCommentAuthorBadge(DcComment comment) {
    switch (comment.authorType) {
      case DcAuthorType.anonymous:
        return Text(
          '${comment.authorName} ${comment.ipOrBadge}',
          style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12, fontWeight: FontWeight.bold),
        );
      case DcAuthorType.fixed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(comment.authorName, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(width: 3),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
              child: const Icon(CupertinoIcons.checkmark, color: Colors.white, size: 7),
            ),
          ],
        );
      case DcAuthorType.subManager:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(comment.authorName, style: const TextStyle(color: Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(width: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(color: const Color(0xFF0284C7), borderRadius: BorderRadius.circular(2)),
              child: const Text('부', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      case DcAuthorType.manager:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(comment.authorName, style: const TextStyle(color: Color(0xFFEA580C), fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(width: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(color: const Color(0xFFEA580C), borderRadius: BorderRadius.circular(2)),
              child: const Text('주', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
            ),
          ],
        );
    }
  }
}
