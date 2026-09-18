import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/blind_model.dart';
import 'blind_company_badge.dart';

class BlindPostCard extends StatelessWidget {
  final BlindPostItem post;
  final VoidCallback? onTap;

  const BlindPostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFF1F3F5), width: 1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6F8),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      post.channel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BlindCompanyBadge(
                    company: post.authorCompany,
                    maskedId: post.authorMaskedId,
                    timeAgo: post.createdAt,
                    fontSize: 11.5,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E2024),
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                post.content,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (post.poll != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDA3238).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Row(
                        children: [
                          Icon(CupertinoIcons.chart_bar_fill, size: 10, color: Color(0xFFDA3238)),
                          SizedBox(width: 3),
                          Text(
                            '투표',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFDA3238),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Spacer(),
                  _buildStatItem(CupertinoIcons.eye, _formatCount(post.viewCount)),
                  const SizedBox(width: 10),
                  _buildStatItem(
                    post.isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                    '${post.likeCount}',
                    color: post.isLiked ? const Color(0xFFDA3238) : null,
                  ),
                  const SizedBox(width: 10),
                  _buildStatItem(
                    CupertinoIcons.bubble_left,
                    '${post.commentCount}',
                    color: post.commentCount > 0 ? const Color(0xFFDA3238) : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, {Color? color}) {
    final effectiveColor = color ?? const Color(0xFF9EA3AA);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.5, color: effectiveColor),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: effectiveColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}만';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}천';
    }
    return '$count';
  }
}
