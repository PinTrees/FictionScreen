import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/dcinside_model.dart';

class DcinsidePostList extends StatelessWidget {
  final DcinsideConfig config;
  final ValueChanged<String> onSelectPost;

  const DcinsidePostList({
    super.key,
    required this.config,
    required this.onSelectPost,
  });

  @override
  Widget build(BuildContext context) {
    // 탭에 따라 필터링
    final filteredPosts = config.posts.where((p) {
      if (config.activeTab == '개념글') return p.isConcept;
      if (config.activeTab == '공지') return p.category == '[공지]';
      return true;
    }).toList();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 1. 테이블 헤더
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: const Row(
              children: [
                SizedBox(width: 50, child: Text('말머리', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(child: Text('제목', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.bold))),
                SizedBox(width: 100, child: Text('글쓴이', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.bold))),
                SizedBox(width: 60, child: Text('작성일', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.bold))),
                SizedBox(width: 50, child: Text('조회', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.bold))),
                SizedBox(width: 50, child: Text('추천', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          // 2. 게시글 목록 리스트
          Expanded(
            child: filteredPosts.isEmpty
                ? const Center(
                    child: Text('등록된 게시글이 없습니다.', style: TextStyle(color: Colors.black45, fontSize: 13)),
                  )
                : ListView.separated(
                    itemCount: filteredPosts.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];
                      final isSelected = post.id == config.selectedPostId;

                      return InkWell(
                        onTap: () => onSelectPost(post.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          color: isSelected
                              ? const Color(0xFFEFF6FF)
                              : post.isConcept
                                  ? const Color(0xFFFFFBEB).withValues(alpha: 0.6)
                                  : Colors.white,
                          child: Row(
                            children: [
                              // 말머리
                              SizedBox(
                                width: 50,
                                child: Text(
                                  post.category,
                                  style: TextStyle(
                                    color: post.category == '[공지]'
                                        ? const Color(0xFFDC2626)
                                        : const Color(0xFF6B7280),
                                    fontSize: 11,
                                    fontWeight: post.category == '[공지]' ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),

                              // 제목 + 댓글 수
                              Expanded(
                                child: Row(
                                  children: [
                                    if (post.isConcept)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 4),
                                        child: Icon(CupertinoIcons.star_fill, color: Color(0xFFF59E0B), size: 11),
                                      ),
                                    Flexible(
                                      child: Text(
                                        post.title,
                                        style: TextStyle(
                                          color: post.isConcept ? const Color(0xFF1E3A8A) : const Color(0xFF1F2937),
                                          fontSize: 13,
                                          fontWeight: post.isConcept ? FontWeight.bold : FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (post.comments.isNotEmpty) ...[
                                      const SizedBox(width: 6),
                                      Text(
                                        '[${post.comments.length}]',
                                        style: const TextStyle(
                                          color: Color(0xFFDC2626),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // 글쓴이
                              SizedBox(
                                width: 100,
                                child: _buildAuthorBadge(post),
                              ),

                              // 작성일 (오늘이면 시간 표기)
                              SizedBox(
                                width: 60,
                                child: Text(
                                  _formatDate(post.createdAt),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                                ),
                              ),

                              // 조회수
                              SizedBox(
                                width: 50,
                                child: Text(
                                  post.viewCount.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                                ),
                              ),

                              // 추천수
                              SizedBox(
                                width: 50,
                                child: Text(
                                  post.recommendCount.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: post.recommendCount >= 100
                                        ? const Color(0xFFDC2626)
                                        : const Color(0xFF6B7280),
                                    fontSize: 11,
                                    fontWeight: post.recommendCount >= 100 ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorBadge(DcPost post) {
    switch (post.authorType) {
      case DcAuthorType.anonymous:
        return Text(
          '${post.authorName} ${post.ipOrBadge}',
          style: const TextStyle(color: Color(0xFF4B5563), fontSize: 11),
          overflow: TextOverflow.ellipsis,
        );
      case DcAuthorType.fixed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                post.authorName,
                style: const TextStyle(color: Color(0xFF2563EB), fontSize: 11, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 3),
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(CupertinoIcons.checkmark, color: Colors.white, size: 8),
            ),
          ],
        );
      case DcAuthorType.subManager:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                post.authorName,
                style: const TextStyle(color: Color(0xFF0284C7), fontSize: 11, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text('부', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      case DcAuthorType.manager:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                post.authorName,
                style: const TextStyle(color: Color(0xFFEA580C), fontSize: 11, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFFEA580C),
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text('주', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
            ),
          ],
        );
    }
  }

  String _formatDate(String fullDate) {
    if (fullDate.contains(' ')) {
      final parts = fullDate.split(' ');
      if (parts.length > 1) {
        final time = parts[1];
        final timeParts = time.split(':');
        if (timeParts.length >= 2) {
          return '${timeParts[0]}:${timeParts[1]}';
        }
      }
    }
    return fullDate;
  }
}
